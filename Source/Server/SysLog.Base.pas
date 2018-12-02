Unit SysLog.Base;
//==============================================================================
//== SysLog Server Class                                     © XP Informatica ==
//==                         Realizzato da Cavicchioli Sergio - sergio@xpi.it ==
//==============================================================================
//== 31/05/2018 Cavicchioli Sergio                                            ==
//== + Realizzazione                                                          ==
//==                                                                          ==
//== 10/06/2018 Cavicchioli Sergio                                            ==
//== + Aggiunta modalità verbose (solo per modalità non Daemon)               ==
//==                                                                          ==
//==============================================================================

Interface

Uses
  System.SysUtils, System.Classes, System.IniFiles,

  IdSysLogMessage, IdSocketHandle, IdBaseComponent, IdComponent, IdUDPBase,
  IdUDPServer, IdSysLogServer,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.ConsoleUI.Wait;

Type

  TSysLogBase = Class(TObject)
  Protected
    FServer: TIdSyslogServer;
    FConnection : TFDConnection;
    FTransaction : TFDTransaction;
    FQuery: TFDQuery;
    FConf : TMemIniFile;
    FStartTime : TDateTime;
    FCountEvent : Integer;
    FVerbose : Boolean;
    Procedure SyslogWrite(Sender: TObject; ASysLogMessage: TIdSysLogMessage; ABinding: TIdSocketHandle);
    Function GetSrvActive : Boolean;
    procedure SaveConfig;
  Public
    Constructor Create;
    Destructor Destroy; override;
    Procedure Start;
    Procedure Stop;
    Property StartTime: TDateTime Read FStartTime;
    Property CountEvent: Integer Read FCountEvent;
    Property Active: Boolean Read GetSrvActive;
    Property Server: TIdSyslogServer Read FServer;
    Property DbServer: TFDConnection Read FConnection;
    Property Verbose: Boolean Read FVerbose write FVerbose;
  End;

Implementation

Uses Console.Base, System.IOUtils;

//==============================================================================
{ TSysLogBase }
//==============================================================================
Constructor TSysLogBase.Create;
Var
  LAppName, LAppPath : String;
Begin
  LAppName := TPath.GetFileNameWithoutExtension(ParamStr(0));
  LAppPath := ExtractFilePath(ParamStr(0));

  FConf := TMemIniFile.Create( TPath.Combine(LAppPath, LAppName + '.conf') );

  FServer := TIdSyslogServer.Create(Nil);
  FServer.ThreadedEvent := True;
  FServer.OnSyslog := SyslogWrite;

  FConnection := TFDConnection.Create(Nil);
  FConnection.LoginPrompt := False;
  FConnection.DriverName := FConf.ReadString('DataBase', 'Driver', 'FB');
  FConnection.Params.Values['Server']   := FConf.ReadString('DataBase', 'Server', '127.0.0.1');
  FConnection.Params.Values['DataBase'] := FConf.ReadString('DataBase', 'DataBase', 'syslog');
  FConnection.Params.Values['CharacterSet'] := FConf.ReadString('DataBase', 'CharacterSet', 'WIN1252');
  FConnection.Params.Values['User_Name']    := FConf.ReadString('DataBase', 'UserName', 'sysdba');
  FConnection.Params.Values['Password']     := FConf.ReadString('DataBase', 'Password', 'masterkey');
  SaveConfig;

  FTransaction := TFDTransaction.Create(Nil);
  FTransaction.Connection := FConnection;

  FQuery := TFDQuery.Create(Nil);
  FQuery.Connection := FConnection;
  FQuery.Transaction := FTransaction;
  FQuery.UpdateTransaction := FTransaction;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('Insert Into SYEVN00F');
  FQuery.SQL.Add('(DTOREV, SEVEEV, HOSTEV, IPHREV, NPGMEV, PIDPEV, MESSEV)');
  FQuery.SQL.Add('VALUES (:DTOREV, :SEVEEV, :HOSTEV, :IPHREV, :NPGMEV, :PIDPEV, :MESSEV)');

{$IFDEF DEBUG}
  FVerbose := True;
{$ELSE}
  FVerbose := False;
{$ENDIF}
End;

//==============================================================================
Destructor TSysLogBase.Destroy;
Begin
  FServer.Active := False;
  FServer.Free;

  FConnection.Close;
  FQuery.Free;
  FTransaction.Free;
  FConnection.Free;

  FConf.Free;

  inherited;
End;

//==============================================================================
Function TSysLogBase.GetSrvActive: Boolean;
Begin
  Result := FServer.Active;
End;

//==============================================================================
Procedure TSysLogBase.Start;
Begin
  Try
    FServer.Active := True;
    FStartTime := Now;
    FCountEvent := 0;
    TConsoleBase.WriteMsg('Servizio SysLog - Start.');
  Except
    On E: Exception Do Begin
      TConsoleBase.WriteMsg(E.ClassName + ': ' + E.Message);
    End;
  End;
End;

//==============================================================================
Procedure TSysLogBase.Stop;
Begin
  Try
    FServer.Active := False;
    FConnection.Close;
    TConsoleBase.WriteMsg('Servizio SysLog - Stop.');
  Except
    On E: Exception Do Begin
      TConsoleBase.WriteMsg(E.ClassName + ': ' + E.Message);
    End;
  End;
End;

//==============================================================================
Procedure TSysLogBase.SyslogWrite(Sender: TObject;
  ASysLogMessage: TIdSysLogMessage; ABinding: TIdSocketHandle);
Begin
  Try
    If Not FConnection.Connected Then
      FConnection.Open;

    If Not FTransaction.Active Then
      FTransaction.StartTransaction;

    FQuery.ParamByName('DTOREV').AsDateTime := Now;
    FQuery.ParamByName('HOSTEV').AsString   := ASysLogMessage.Hostname;
    FQuery.ParamByName('IPHREV').AsString   := ABinding.PeerIP;
    FQuery.ParamByName('NPGMEV').AsString   := ASysLogMessage.Msg.Process;
    FQuery.ParamByName('PIDPEV').AsString   := ASysLogMessage.Msg.PID.ToString;
    FQuery.ParamByName('SEVEEV').AsInteger  := Ord( ASysLogMessage.Severity );
    FQuery.ParamByName('MESSEV').AsString   := ASysLogMessage.Msg.Content;

    FQuery.ExecSQL;

    If FTransaction.Active Then
      FTransaction.Commit;

  Except
    On E: Exception Do Begin
      TConsoleBase.WriteMsg(E.ClassName + ': ' + E.Message);
    End;
  End;

  If FVerbose Then
    TConsoleBase.WriteMsg(ASysLogMessage.Msg.Content);

  Inc(FCountEvent);
End;

//==============================================================================
Procedure TSysLogBase.SaveConfig;
Begin
  Try
    FConf.WriteString('DataBase', 'Driver', FConnection.DriverName);
    FConf.WriteString('DataBase', 'Server', FConnection.Params.Values['Server']);
    FConf.WriteString('DataBase', 'DataBase', FConnection.Params.Values['DataBase']);
    FConf.WriteString('DataBase', 'CharacterSet', FConnection.Params.Values['CharacterSet']);
    FConf.WriteString('DataBase', 'UserName', FConnection.Params.Values['User_Name']);
    FConf.WriteString('DataBase', 'Password', FConnection.Params.Values['Password']);
    FConf.UpdateFile;
  Except
    On E: Exception Do Begin
      TConsoleBase.WriteMsg(E.ClassName + ': ' + E.Message);
    End;
  End;
End;

//==============================================================================
End.
