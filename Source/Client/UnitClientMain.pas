unit UnitClientMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdUDPBase, IdUDPClient, IdSysLog, IdSysLogMessage;

type
  TForm2 = class(TForm)
    IdSysLog1: TIdSysLog;
    Button1: TButton;
    Button2: TButton;
    IdSysLogMessage1: TIdSysLogMessage;
    Edit1: TEdit;
    EdServer: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

Uses System.IOUtils;

procedure TForm2.Button1Click(Sender: TObject);
begin
  IdSysLog1.Host := EdServer.Text;

  IdSysLog1.Active := Not IdSysLog1.Active;
  If IdSysLog1.Active then
    Button1.Caption := 'Ferma'
  Else
    Button1.Caption := 'Avvia';

  IdSysLog1.Connect;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin

  IdSysLogMessage1.Msg.Process := ExtractFileName(Application.ExeName);
  IdSysLogMessage1.Msg.PID     := GetCurrentProcessId;
  IdSysLogMessage1.Msg.Content := Edit1.Text;

  IdSysLogMessage1.Severity   := TIdSyslogSeverity.slInformational;

//  TIdSyslogSeverity = (slEmergency, {0 - emergency - system unusable}
//              slAlert, {1 - action must be taken immediately }
//              slCritical, { 2 - critical conditions }
//              slError, {3 - error conditions }
//              slWarning, {4 - warning conditions }
//              slNotice, {5 - normal but signification condition }
//              slInformational, {6 - informational }
//              slDebug); {7 - debug-level messages }


  IdSysLog1.SendLogMessage( IdSysLogMessage1 );
end;

end.
