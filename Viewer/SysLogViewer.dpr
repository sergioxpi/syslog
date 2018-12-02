program SysLogViewer;

uses
  Vcl.Forms,
  UnitSysLogViewer in 'Source\UnitSysLogViewer.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
