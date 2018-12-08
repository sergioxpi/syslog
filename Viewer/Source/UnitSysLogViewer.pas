Unit UnitSysLogViewer;
//==============================================================================
//== SysLog - Consultazione Logs                             © XP Informatica ==
//==                         Realizzato da Cavicchioli Sergio - sergio@xpi.it ==
//==============================================================================
//== 31/05/2018 Cavicchioli Sergio                                            ==
//== + Realizzazione                                                          ==
//==                                                                          ==
//== 26/06/2018 Cavicchioli Sergio                                            ==
//== + Aggiunto supporto file Ini per Configurazione Server                   ==
//==                                                                          ==
//== 06/12/2018 Cavicchioli Sergio                                            ==
//== + Aggiunto sulla griglia selezione multipla, menù per seleziona tutto e  ==
//==   selezione celle, copia incolla per esportazione excel                  ==
//==                                                                          ==
//==============================================================================

Interface

Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, System.IniFiles,
  EhLibFireDAC,  // Supporto Sort & Filter EhLib per FireDac
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, Vcl.ExtCtrls, EhLibVCL, GridsEh, DBAxisGridsEh,
  DBGridEh, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  Vcl.DBCtrls, Vcl.Mask, DBCtrlsEh, ExeInfo, FireDAC.Phys.IBBase,
  System.ImageList, Vcl.ImgList;

Type
  TFormMain = Class(TForm)
    Connection: TFDConnection;
    Transaction: TFDTransaction;
    Query: TFDQuery;
    DsQuery: TDataSource;
    DBGridEh1: TDBGridEh;
    Panel1: TPanel;
    Button1: TButton;
    Label1: TLabel;
    DataIn: TDBDateTimeEditEh;
    DataFi: TDBDateTimeEditEh;
    Label2: TLabel;
    ExeInfo: TExeInfo;
    FBDriverLink: TFDPhysFBDriverLink;
    DBEAlerter: TFDEventAlerter;
    CheckRefresh: TCheckBox;
    ImageList1: TImageList;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure QueryBeforeOpen(DataSet: TDataSet);
    procedure DBEAlerterAlert(ASender: TFDCustomEventAlerter;
      const AEventName: string; const AArgument: Variant);
    procedure CheckRefreshClick(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  FormMain: TFormMain;

Implementation

{$R *.dfm}

Uses System.StrUtils, System.IOUtils;

//==============================================================================
Function iif(Condition: Boolean; V1, V2: Variant): Variant;
Begin
  If (Condition) Then Result := V1 Else Result := V2;
End;

//==============================================================================
Function DataToSQL( CONST D : String ) : String ;
Var
  G, M, A, S : String;
  X : Integer;
Begin
  S := D;

  X := Pos('/', S);
  G := LeftStr(S, X - 1);

  S := RightStr(S, Length(S) - X);

  X := Pos('/', S);
  M := LeftStr(S, X - 1);

  A := RightStr(S, Length(S) - X);

  If (StrToInt(A) >= 0) And (StrToInt(A) < 40) Then A := IntToStr(StrToInt(A) + 2000);
  If (StrToInt(A) >= 40) And (StrToInt(A) < 100) Then A := IntToStr(StrToInt(A) + 1900);

  Result := '''' + M + '/' + G + '/' + A + '''';
End;

//==============================================================================
Procedure TFormMain.CheckRefreshClick(Sender: TObject);
Begin
  DBEAlerter.Names.Clear;
  If CheckRefresh.Checked Then
    DBEAlerter.Names.Add('SYEVN00F');
End;

//==============================================================================
Procedure TFormMain.DBEAlerterAlert(ASender: TFDCustomEventAlerter;
  const AEventName: string; const AArgument: Variant);
Begin
  Query.Refresh;
  Query.Last;
End;

//==============================================================================
Procedure TFormMain.FormCreate(Sender: TObject);
Var
  LIni : TMemIniFile;
Begin

  Caption := 'SysLog V' + ExeInfo.FileVersion;
{$IFDEF  WIN64}
  Caption := Caption + ' - Win64';
  FBDriverLink.VendorLib := 'fbclient64.dll';
{$ENDIF}
{$IFDEF  DEBUG}
  Caption := Caption + ' {DEBUG}';
{$ENDIF}

  LIni := TMemIniFile.Create( TPath.Combine(ExtractFilePath(Application.ExeName), 'DataBase.Conf') );
  Connection.Params.Values['Server'] := LIni.ReadString('SysLog', 'Server', '');
//  Connection.Params.Values['Server'] := '172.17.3.42';  // Lubiam
//  Connection.Params.Values['Server'] := '79.60.120.166';  // Arcosald
  LIni.Free;

  DataIn.Value := Date();

  DBEAlerter.Names.Clear;
  DBEAlerter.SubscriptionName := 'SysLog';
  DBEAlerter.Options.AutoRegister := True;

End;

//==============================================================================
Procedure TFormMain.Button1Click(Sender: TObject);
Begin
  Query.Close;
  Query.Open;
  Query.Last;

  DBEAlerter.Names.Clear;
  If CheckRefresh.Checked Then
    DBEAlerter.Names.Add('SYEVN00F');

End;

//==============================================================================
Procedure TFormMain.QueryBeforeOpen(DataSet: TDataSet);
Var
  Lwh : String;
Begin
  Lwh := '';

  If not DataIn.IsEmpty Then
    Lwh := 'Cast(DTOREV As Date) >= ' + DataToSql( DataIn.Value );

  If not DataFi.IsEmpty Then
    Lwh := Lwh + iif(Lwh='', '', ' And ') + 'Cast(DTOREV As Date) <= ' + DataToSql( DataFi.Value );

  With Query.SQL Do Begin
    Clear;
    Add('Select *');
    Add('From SYEVN00F');
    If Lwh <> '' then
      Add('Where ' + Lwh );
    Add('Order By IDREEV');
  End;
End;

//==============================================================================
End.
