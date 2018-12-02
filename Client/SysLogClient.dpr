program SysLogClient;

uses
  Vcl.Forms,
  UnitClientMain in '..\Source\Client\UnitClientMain.pas' {Form2},
  SysLog.Client in '..\Source\Client\SysLog.Client.pas' {DmSysLog: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TDmSysLog, DmSysLog);
  Application.Run;
end.
