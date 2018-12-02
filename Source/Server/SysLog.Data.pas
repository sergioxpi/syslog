Unit SysLog.Data;

Interface

Uses
  System.SysUtils, System.Classes,
  System.IniFiles,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  IdSysLogMessage, IdSocketHandle, IdBaseComponent, IdComponent, IdUDPBase,
  IdUDPServer, IdSysLogServer, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.Comp.ScriptCommands,
  FireDAC.Stan.Util, FireDAC.Comp.Script;

Type
  TDati = Class(TDataModule)
    Connection: TFDConnection;
    Transaction: TFDTransaction;
    SYEVN: TFDQuery;
    SyslogServer: TIdSyslogServer;
    GUIxWaitCursor: TFDGUIxWaitCursor;
    FDScript1: TFDScript;
    procedure SyslogServerSyslog(Sender: TObject;
      ASysLogMessage: TIdSysLogMessage; ABinding: TIdSocketHandle);
    procedure SyslogServerAfterBind(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ConnectionAfterConnect(Sender: TObject);
  Protected
    FConf : TMemIniFile;
  Private
    { Private declarations }
  Public
    { Public declarations }
    StTime : TDateTime;
    StEventi : Integer;
  End;

var
  Dati: TDati;

Implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

Uses System.IOUtils;

//==============================================================================
Procedure TDati.DataModuleCreate(Sender: TObject);
Var
  LAppName, LAppPath : String;
Begin
  LAppName := TPath.GetFileNameWithoutExtension(ParamStr(0));
  LAppPath := ExtractFilePath(ParamStr(0));

  FConf := TMemIniFile.Create( TPath.Combine(LAppPath, LAppName + '.conf') );

End;

//==============================================================================
Procedure TDati.DataModuleDestroy(Sender: TObject);
Begin
  FConf.Free;
End;

//==============================================================================
Procedure TDati.SyslogServerAfterBind(Sender: TObject);
Begin
  StTime := Now;
  StEventi := 0;

  Connection.DriverName := FConf.ReadString('DataBase', 'Driver', 'FB');
  Connection.Params.Values['Server']       := FConf.ReadString('DataBase', 'Server', '127.0.0.1');
  Connection.Params.Values['DataBase']     := FConf.ReadString('DataBase', 'DataBase', 'syslog');
  Connection.Params.Values['CharacterSet'] := FConf.ReadString('DataBase', 'CharacterSet', 'WIN1252');
  Connection.Params.Values['User_Name']    := FConf.ReadString('DataBase', 'UserName', 'sysdba');
  Connection.Params.Values['Password']     := FConf.ReadString('DataBase', 'Password', 'masterkey');
//  SaveConfig;

  Connection.Open;
End;

//==============================================================================
Procedure TDati.ConnectionAfterConnect(Sender: TObject);
Var
  Tabelle : TStrings;
Begin
  Tabelle := TStringList.Create;
  Try

    Connection.GetTableNames('', '', '', Tabelle, [osMy], [tkTable]);

    If Tabelle.IndexOf('SYEVN00F') < 0 Then
      FDScript1.ExecuteAll;

  Finally
    Tabelle.Free;
  End;
End;

//==============================================================================
Procedure TDati.SyslogServerSyslog(Sender: TObject;
  ASysLogMessage: TIdSysLogMessage; ABinding: TIdSocketHandle);
Begin
  If Not Connection.Connected Then
    Connection.Open;

  If Not SYEVN.Active Then
    SYEVN.Open;

  SYEVN.Append;
  SYEVN.FieldByName('DTOREV').AsDateTime := Now;
  SYEVN.FieldByName('HOSTEV').AsString := ASysLogMessage.Hostname;
  SYEVN.FieldByName('IPHREV').AsString := ABinding.PeerIP;
  SYEVN.FieldByName('NPGMEV').AsString := ASysLogMessage.Msg.Process;
  SYEVN.FieldByName('PIDPEV').AsString := ASysLogMessage.Msg.PID.ToString;

  SYEVN.FieldByName('SEVEEV').AsInteger := Ord( ASysLogMessage.Severity );

  SYEVN.FieldByName('MESSEV').AsString := ASysLogMessage.Msg.Text;

  SYEVN.Post;

  Inc(StEventi);
End;

//==============================================================================
End.
