program SysLogClient;

uses
  Vcl.Forms,
  UnitClientMain in '..\Source\Client\UnitClientMain.pas' {FormMainClient},
  SysLog.Client in '..\Source\Client\SysLog.Client.pas' {DmSysLog: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDmSysLog, DmSysLog);
  Application.CreateForm(TFormMainClient, FormMainClient);
  Application.Run;
end.
