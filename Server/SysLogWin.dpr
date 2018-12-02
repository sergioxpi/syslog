program SysLogWin;

uses
  Vcl.Forms,
  UnitSrvWinMain in '..\Source\Server\UnitSrvWinMain.pas' {Form1},
  SysLog.Data in '..\Source\Server\SysLog.Data.pas' {Dati: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDati, Dati);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
