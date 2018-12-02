Unit UnitSrvWinMain;

Interface

Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdUDPBase, IdUDPServer, IdSysLogServer, IdSysLogMessage,
  IdSocketHandle, Data.DB, Vcl.Grids, Vcl.DBGrids, System.Actions, Vcl.ActnList;

Type
  TForm1 = Class(TForm)
    Memo1: TMemo;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ActionList: TActionList;
    ActStop: TAction;
    ActStart: TAction;
    StartButton: TButton;
    StopButton: TButton;
    procedure SyslogServerSyslog(Sender: TObject;
      ASysLogMessage: TIdSysLogMessage; ABinding: TIdSocketHandle);
    procedure ActStopExecute(Sender: TObject);
    procedure ActStopUpdate(Sender: TObject);
    procedure ActStartExecute(Sender: TObject);
    procedure ActStartUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  Form1: TForm1;

Implementation

{$R *.dfm}

Uses SysLog.Data;

//==============================================================================
Procedure TForm1.FormCreate(Sender: TObject);
Begin
  Dati.SyslogServer.OnSyslog := SyslogServerSyslog;
  Memo1.Clear;
  ActStart.Execute;
End;

//==============================================================================
Procedure TForm1.ActStartExecute(Sender: TObject);
Begin
  Dati.SyslogServer.Active := True;
End;

//==============================================================================
Procedure TForm1.ActStartUpdate(Sender: TObject);
Begin
  ActStart.Enabled := Dati.SyslogServer.Active = False;
End;

//==============================================================================
Procedure TForm1.ActStopExecute(Sender: TObject);
Begin
  Dati.SyslogServer.Active := False;
//  STM.WriteLog('Servizio terminato.');
End;

//==============================================================================
Procedure TForm1.ActStopUpdate(Sender: TObject);
Begin
  ActStop.Enabled := Dati.SyslogServer.Active = True;
End;

//==============================================================================
Procedure TForm1.SyslogServerSyslog(Sender: TObject;
  ASysLogMessage: TIdSysLogMessage; ABinding: TIdSocketHandle);
Begin
  Dati.SyslogServerSyslog(Sender, ASysLogMessage, ABinding);

  Memo1.Lines.Add( ASysLogMessage.Hostname + ' ' + ABinding.PeerIP + ' ' + ASysLogMessage.Msg.Text );
End;

//==============================================================================
End.
