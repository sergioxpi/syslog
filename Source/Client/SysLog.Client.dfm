object DmSysLog: TDmSysLog
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 205
  Width = 307
  object IdSysLog: TIdSysLog
    Host = '172.17.3.42'
    Left = 64
    Top = 64
  end
  object LogMessage: TIdSysLogMessage
    Pri = 109
    Left = 152
    Top = 64
  end
end
