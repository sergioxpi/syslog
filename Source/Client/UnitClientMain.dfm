object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'SysLog Client Demo'
  ClientHeight = 300
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 79
    Top = 35
    Width = 69
    Height = 13
    Alignment = taRightJustify
    Caption = 'Server SysLog'
  end
  object Label2: TLabel
    Left = 106
    Top = 83
    Width = 42
    Height = 13
    Alignment = taRightJustify
    Caption = 'Message'
  end
  object Button1: TButton
    Left = 152
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 304
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 152
    Top = 80
    Width = 313
    Height = 21
    TabOrder = 2
    Text = 'Edit1'
  end
  object EdServer: TEdit
    Left = 152
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 3
    Text = '172.17.3.42'
  end
  object IdSysLog1: TIdSysLog
    Host = '172.17.3.42'
    Left = 48
    Top = 192
  end
  object IdSysLogMessage1: TIdSysLogMessage
    Msg.Text = 'pippo[1234]: sfsfs'
    Left = 48
    Top = 128
  end
end
