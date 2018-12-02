object Dati: TDati
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 232
  Width = 347
  object Connection: TFDConnection
    Params.Strings = (
      'DriverID=FB'
      'Database=C:\Sviluppo\Delphi 10.2\SysLog\Win32\syslog.fdb'
      'CharacterSet=WIN1252'
      'Protocol=TCPIP'
      'Server=fb.local'
      'Password=masterkey'
      'User_Name=sysdba'
      'PageSize=8192'
      'OpenMode=OpenOrCreate')
    LoginPrompt = False
    AfterConnect = ConnectionAfterConnect
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
  object GUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Console'
    Left = 256
    Top = 112
  end
  object FDScript1: TFDScript
    SQLScripts = <
      item
        Name = 'SYEVN00F'
        SQL.Strings = (
          'SET CMDSEP #;'
          ''
          'CREATE TABLE SYEVN00F ('
          'IDREEV BIGINT NOT NULL,'
          'DTOREV TIMESTAMP NOT NULL,'
          'SEVEEV SMALLINT,'
          'HOSTEV VARCHAR(30),'
          'IPHREV VARCHAR(20),'
          'NPGMEV VARCHAR(50),'
          'PIDPEV INTEGER,'
          'MESSEV VARCHAR(1024));#'
          ''
          'COMMENT ON TABLE SYEVN00F Is '#39'Eventi'#39';#'
          ''
          'COMMENT ON COLUMN SYEVN00F.IDREEV Is '#39'ID Evento'#39';#'
          ''
          
            'COMMENT ON COLUMN SYEVN00F.DTOREV Is '#39'Data e Ora di Registrazion' +
            'e'#39';#'
          ''
          'COMMENT ON COLUMN SYEVN00F.SEVEEV Is '#39'Severity'#39';#'
          ''
          'COMMENT ON COLUMN SYEVN00F.HOSTEV Is '#39'Nome Host'#39';#'
          ''
          'COMMENT ON COLUMN SYEVN00F.IPHREV Is '#39'Indirizzo IP Host'#39';#'
          ''
          'COMMENT ON COLUMN SYEVN00F.NPGMEV Is '#39'Nome Programma'#39';#'
          ''
          'COMMENT ON COLUMN SYEVN00F.PIDPEV Is '#39'Process ID'#39';#'
          ''
          'COMMENT ON COLUMN SYEVN00F.MESSEV Is '#39'Message'#39';#'
          ''
          'CREATE GENERATOR GID_SYEVN00F;#'
          ''
          'ALTER TABLE SYEVN00F'
          'ADD CONSTRAINT SYEVN00P'
          'PRIMARY KEY ( IDREEV );#'
          ''
          
            'CREATE TRIGGER SYEVN00F_A_EVENT FOR SYEVN00F AFTER INSERT POSITI' +
            'ON 0 AS'
          'Begin'
          '  POST_EVENT '#39'SYEVN00F'#39';'
          'End             ;#'
          ''
          
            'CREATE TRIGGER SYEVN00F_GENID FOR SYEVN00F BEFORE INSERT Or UPDA' +
            'TE POSITION 0 AS'
          'Begin'
          '  If (New.IDREEV Is Null) Then'
          '    New.IDREEV = gen_id( GID_SYEVN00F, 1 );'
          'End;#'
          ''
          'SET CMDSEP ;#')
      end>
    Connection = Connection
    Params = <>
    Macros = <>
    Left = 48
    Top = 104
  end
end
