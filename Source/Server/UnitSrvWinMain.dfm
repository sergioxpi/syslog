object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'SysLogServer'
  ClientHeight = 444
  ClientWidth = 803
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 312
    Width = 787
    Height = 81
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 103
    Width = 769
    Height = 106
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object StartButton: TButton
    Left = 16
    Top = 73
    Width = 75
    Height = 25
    Action = ActStart
    TabOrder = 2
  end
  object StopButton: TButton
    Left = 104
    Top = 73
    Width = 75
    Height = 25
    Action = ActStop
    TabOrder = 3
  end
  object DataSource1: TDataSource
    DataSet = Dati.SYEVN
    Left = 256
    Top = 136
  end
  object ActionList: TActionList
    Left = 128
    Top = 224
    object ActStop: TAction
      Caption = 'Stop'
      OnExecute = ActStopExecute
      OnUpdate = ActStopUpdate
    end
    object ActStart: TAction
      Caption = 'Start'
      OnExecute = ActStartExecute
      OnUpdate = ActStartUpdate
    end
  end
end
