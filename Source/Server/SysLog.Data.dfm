object Dati: TDati
  OldCreateOrder = False
  Height = 275
  Width = 502
  object Connection: TFDConnection
    Params.Strings = (
      'DriverID=FB'
      'Database=C:\Sviluppo\Delphi 10.2\SysLog\Win32\syslog.fdb'
      'CharacterSet=WIN1252'
      'Protocol=TCPIP'
      'Server=fb.local'
      'Password=masterkey'
      'User_Name=sysdba'
      'PageSize=8192')
    LoginPrompt = False
    Left = 48
    Top = 40
  end
  object Transaction: TFDTransaction
    Connection = Connection
    Left = 128
    Top = 40
  end
  object SYEVN: TFDQuery
    Connection = Connection
    Transaction = Transaction
    UpdateTransaction = Transaction
    UpdateOptions.AssignedValues = [uvGeneratorName]
    UpdateOptions.GeneratorName = 'GID_SYEVN00F'
    UpdateOptions.KeyFields = 'IDREEV'
    UpdateOptions.AutoIncFields = 'IDREEV'
    SQL.Strings = (
      'Select *'
      'From SYEVN00F')
    Left = 216
    Top = 40
  end
  object SyslogServer: TIdSyslogServer
    BroadcastEnabled = True
    Bindings = <>
    ThreadedEvent = True
    OnAfterBind = SyslogServerAfterBind
    OnSyslog = SyslogServerSyslog
    Left = 136
    Top = 144
  end
end
