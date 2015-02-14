unit logic_db;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  TDataModule_sjhf = class(TDataModule)
    ADOQuery_SjhfDb: TADOQuery;
    ADOQuery_LocalDb: TADOQuery;
    ADOStoredProc_SjhfDb: TADOStoredProc;
    ADOConnection_SjhfDb: TADOConnection;
    DataSource_FApprove: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule_sjhf: TDataModule_sjhf;

implementation

{$R *.dfm}

end.
