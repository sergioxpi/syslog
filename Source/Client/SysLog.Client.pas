Unit SysLog.Client;
//==============================================================================
//== SysLog Client                                           © XP Informatica ==
//==                         Realizzato da Cavicchioli Sergio - sergio@xpi.it ==
//==============================================================================
//== Unit di Gestione Invio messaggi a SysLogServer UDP                       ==
//==============================================================================
//== 16/06/2018 Cavicchioli Sergio                                            ==
//== + Realizzazione                                                          ==
//==                                                                          ==
//== 30/08/2018 Cavicchioli Sergio                                            ==
//== * Modifiche per Supporto FMX                                             ==
//== + Aggiunta Pulizia Caratteri su Nome Processo                            ==
//== + Creata Funzione Publica SysLogMsg()                                    ==
//== + Aggiunto Caricamento Nome Host da File ini                             ==
//== + Aggiunto controllo LvReg (Livello di Registrazione eventi)             ==
//==                                                                          ==
//== 04/12/2018 Cavicchioli Sergio                                            ==
//== * Modifiche per Compatibilità con Delphi XE                              ==
//==                                                                          ==
//==============================================================================

Interface

Uses
  SysUtils, Classes, StrUtils, IniFiles,
{$IFDEF MSWINDOWS}
  Forms,
  {$IFDEF  VER220} // Delphi XE
  Windows,
  {$ELSE}
  Winapi.Windows,
  {$ENDIF}
{$ENDIF}
  IdSysLogMessage, IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient, IdSysLog;

Type
  TDmSysLog = class(TDataModule)
    IdSysLog: TIdSysLog;
    LogMessage: TIdSysLogMessage;
    Procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  Private
    LevelReg : SmallInt;
    IniSysLog : TMemIniFile;
  Public
    Procedure SendMsg(ASeverity : TIdSyslogSeverity; Const AText : String);
  End;

Var
  DmSysLog: TDmSysLog;

  Procedure SysLogMsg(const ASeverity: Integer; Const AText: String);

Implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

Uses IOUtils;

//==============================================================================
Procedure TDmSysLog.DataModuleCreate(Sender: TObject);
Var
  S : String;
Begin
  S := ExtractFileName( ExtractFileName(ParamStr(0)) );
  // Il nome Processo supporta solo lettere e numeri, pulisco il nome
  S := ReplaceStr(S, '_', '');
  S := ReplaceStr(S, '-', '');
  S := ReplaceStr(S, ':', '');
  S := ReplaceStr(S, ' ', '');
  LogMessage.Msg.Process := S;
{$IFDEF MSWINDOWS}
  LogMessage.Msg.PID     := GetCurrentProcessId;
{$ELSE}
  LogMessage.Msg.PID     := 0;
{$ENDIF}

  IniSysLog := TMemIniFile.Create( TPath.Combine(ExtractFilePath(ParamStr(0)), 'SysLog.Conf') );

  IdSysLog.Host := IniSysLog.ReadString('SysLog', 'Server', '');
  LevelReg      := IniSysLog.ReadInteger('SysLog', 'LevelReg', 7);
  If Not FileExists(IniSysLog.FileName) Then Begin
    IniSysLog.WriteString('SysLog', 'Server', IdSysLog.Host);
    IniSysLog.WriteInteger('SysLog', 'LevelReg', LevelReg);
    IniSysLog.UpdateFile;
  End;

  If IdSysLog.Host <> '' Then
  Try
    IdSysLog.Active := True;
    IdSysLog.Connect;
  Finally
  End;

  SysLogMsg( 7, 'EVENT=TDmSysLog.DataModuleCreate' );
{$IFDEF MSWINDOWS}
  SysLogMsg( 6, 'ACTION=RUN Application#PATH='+Application.ExeName );
{$ENDIF}
End;

//==============================================================================
Procedure TDmSysLog.DataModuleDestroy(Sender: TObject);
Begin
  SysLogMsg( 7, 'EVENT=TDmSysLog.DataModuleDestroy' );
End;

//==============================================================================
Procedure TDmSysLog.SendMsg(ASeverity: TIdSyslogSeverity; Const AText: String);
Var
  LGr : Integer;
Begin
  If Not IdSysLog.Connected Then Exit;

  Case ASeverity Of
    slEmergency:     LGr := 0;
    slAlert:         LGr := 1;
    slCritical:      LGr := 2;
    slError:         LGr := 3;
    slWarning:       LGr := 4;
    slNotice:        LGr := 5;
    slInformational: LGr := 6;
    slDebug:         LGr := 7;
  End;

  If LevelReg < LGr Then Exit;

  LogMessage.Msg.Content := AText;

  LogMessage.Severity := ASeverity;

//  TIdSyslogSeverity = (slEmergency, {0 - emergency - system unusable}
//              slAlert, {1 - action must be taken immediately }
//              slCritical, { 2 - critical conditions }
//              slError, {3 - error conditions }
//              slWarning, {4 - warning conditions }
//              slNotice, {5 - normal but signification condition }
//              slInformational, {6 - informational }
//              slDebug); {7 - debug-level messages }

  IdSysLog.SendLogMessage( LogMessage );
End;

//==============================================================================
Procedure SysLogMsg(const ASeverity: Integer; const AText: String);
Begin
  If Not Assigned(DmSysLog) Then
    Application.CreateForm(TDmSysLog, DmSysLog);

  If Not DmSysLog.IdSysLog.Connected Then Exit;

  If DmSysLog.LevelReg < ASeverity Then Exit;

  Case ASeverity Of
    0: DmSysLog.SendMsg(TIdSyslogSeverity.slEmergency, AText);
    1: DmSysLog.SendMsg(TIdSyslogSeverity.slAlert, AText);
    2: DmSysLog.SendMsg(TIdSyslogSeverity.slCritical, AText);
    3: DmSysLog.SendMsg(TIdSyslogSeverity.slError, AText);
    4: DmSysLog.SendMsg(TIdSyslogSeverity.slWarning, AText);
    5: DmSysLog.SendMsg(TIdSyslogSeverity.slNotice, AText);
    6: DmSysLog.SendMsg(TIdSyslogSeverity.slInformational, AText);
    7: DmSysLog.SendMsg(TIdSyslogSeverity.slDebug, AText);
  End;
End;

//==============================================================================
End.
