object DataModule_sjhf: TDataModule_sjhf
  OldCreateOrder = False
  Height = 191
  Width = 215
  object ADOQuery_SjhfDb: TADOQuery
    Connection = ADOConnection_SjhfDb
    Parameters = <>
    Left = 24
    Top = 16
  end
  object ADOQuery_LocalDb: TADOQuery
    Parameters = <>
    Left = 24
    Top = 72
  end
  object ADOStoredProc_SjhfDb: TADOStoredProc
    Connection = ADOConnection_SjhfDb
    Parameters = <>
    Left = 120
    Top = 16
  end
  object ADOConnection_SjhfDb: TADOConnection
    ConnectionString = 
      'Provider=OraOLEDB.Oracle.1;Password=bhgms;Persist Security Info=' +
      'True;User ID=bhgms;Data Source=xe'
    LoginPrompt = False
    Provider = 'OraOLEDB.Oracle.1'
    Left = 120
    Top = 72
  end
  object DataSource_FApprove: TDataSource
    DataSet = ADOQuery_SjhfDb
    Left = 24
    Top = 128
  end
end
