Unit SysLog.Data;

Interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, IdSysLogMessage, IdSocketHandle, IdBaseComponent,
  IdComponent, IdUDPBase, IdUDPServer, IdSysLogServer, FireDAC.ConsoleUI.Wait;

type
  TDati = class(TDataModule)
    Connection: TFDConnection;
    Transaction: TFDTransaction;
    SYEVN: TFDQuery;
    SyslogServer: TIdSyslogServer;
    procedure SyslogServerSyslog(Sender: TObject;
      ASysLogMessage: TIdSysLogMessage; ABinding: TIdSocketHandle);
    procedure SyslogServerAfterBind(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    StTime : TDateTime;
    StEventi : Integer;
  end;

var
  Dati: TDati;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

//==============================================================================
Procedure TDati.SyslogServerAfterBind(Sender: TObject);
Begin
  StTime := Now;
  StEventi := 0;

//  Connection.Params.Values['Server']   := '127.0.0.1';
//  Connection.Params.Values['DataBase'] := 'syslog';
End;

//==============================================================================
Procedure TDati.SyslogServerSyslog(Sender: TObject;
  ASysLogMessage: TIdSysLogMessage; ABinding: TIdSocketHandle);
Begin
{
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
}
  Inc(StEventi);
End;

//==============================================================================
End.
