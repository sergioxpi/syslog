object FormMainClient: TFormMainClient
  Left = 0
  Top = 0
  Caption = 'SysLog Client Demo'
  ClientHeight = 212
  ClientWidth = 484
  Color = clBtnFace
  Constraints.MinHeight = 250
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 37
    Top = 35
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Server'
  end
  object Label2: TLabel
    Left = 27
    Top = 99
    Width = 42
    Height = 13
    Alignment = taRightJustify
    Caption = 'Message'
  end
  object Label3: TLabel
    Left = 45
    Top = 72
    Width = 24
    Height = 13
    Alignment = taRightJustify
    Caption = 'Type'
  end
  object BtnSend: TButton
    Left = 73
    Top = 138
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 0
    OnClick = BtnSendClick
  end
  object EdMessage: TEdit
    Left = 73
    Top = 96
    Width = 369
    Height = 21
    TabOrder = 1
    Text = 'Message'
  end
  object EdServer: TEdit
    Left = 73
    Top = 32
    Width = 145
    Height = 21
    TabOrder = 2
    Text = '127.0.0.1'
  end
  object ComboType: TComboBox
    Left = 73
    Top = 69
    Width = 145
    Height = 21
    ItemIndex = 6
    TabOrder = 3
    Text = 'Informational'
    Items.Strings = (
      'Emergency'
      'Alert'
      'Critical'
      'Error'
      'Warning'
      'Notice'
      'Informational'
      'Debug')
  end
end
