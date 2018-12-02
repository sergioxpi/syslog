Unit UnitClientMain;
//==============================================================================
//== SysLog Client                                           © XP Informatica ==
//==                         Realizzato da Cavicchioli Sergio - sergio@xpi.it ==
//==============================================================================
//== Unit Demo                                                                ==
//==============================================================================
//== 16/06/2018 Cavicchioli Sergio                                            ==
//== + Realizzazione                                                          ==
//==                                                                          ==
//==============================================================================

Interface

Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls;

Type
  TFormMainClient = Class(TForm)
    BtnSend: TButton;
    EdMessage: TEdit;
    EdServer: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ComboType: TComboBox;
    Label3: TLabel;
    procedure BtnSendClick(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  FormMainClient: TFormMainClient;

Implementation

{$R *.dfm}

Uses SysLog.Client;

//==============================================================================
Procedure TFormMainClient.BtnSendClick(Sender: TObject);
Begin

  If Not DmSysLog.IdSysLog.Connected Then Begin
    DmSysLog.IdSysLog.Host := EdServer.Text;
    DmSysLog.IdSysLog.Connect;
  End;

  If DmSysLog.IdSysLog.Host <> EdServer.Text Then Begin
    DmSysLog.IdSysLog.Disconnect;
    DmSysLog.IdSysLog.Host := EdServer.Text;
//    DmSysLog.IdSysLog.Active := True;
    DmSysLog.IdSysLog.Connect;
  End;

  SysLogMsg(ComboType.ItemIndex, EdMessage.Text );

End;

//==============================================================================
End.
