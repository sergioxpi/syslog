program SysLogWin;

uses
  Vcl.Forms,
  UnitSrvWinMain in '..\Source\Server\UnitSrvWinMain.pas' {Form1},
  DmDati in '..\Source\Server\DmDati.pas' {Dati: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDati, Dati);
  Application.Run;
end.
