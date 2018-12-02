unit UnitSrvWinMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdUDPBase, IdUDPServer, IdSysLogServer, IdSysLogMessage,
  IdSocketHandle, Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    procedure Button1Click(Sender: TObject);
    procedure SyslogServerSyslog(Sender: TObject;
      ASysLogMessage: TIdSysLogMessage; ABinding: TIdSocketHandle);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Uses DmDati;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo1.Clear;
  Dati.SyslogServer.Active := True;

  Dati.SyslogServer.OnSyslog := SyslogServerSyslog;
end;

procedure TForm1.SyslogServerSyslog(Sender: TObject;
  ASysLogMessage: TIdSysLogMessage; ABinding: TIdSocketHandle);
begin
  Dati.SyslogServerSyslog(Sender, ASysLogMessage, ABinding);

  Memo1.Lines.Add( ASysLogMessage.Hostname + ' ' + ABinding.PeerIP + ' ' + ASysLogMessage.Msg.Text );
end;

end.
