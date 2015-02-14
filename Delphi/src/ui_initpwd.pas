unit ui_initpwd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, logic_db;

type
  TForm_InitializePassword = class(TForm)
    Edit_UserId: TEdit;
    Edit_UserName: TEdit;
    Button_InitPwd: TButton;
    Button_Cancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure Edit_UserIdKeyPress(Sender: TObject; var Key: Char);
    procedure Button_CancelClick(Sender: TObject);
    procedure Button_InitPwdClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_InitializePassword: TForm_InitializePassword;

implementation

{$R *.dfm}

procedure TForm_InitializePassword.Button_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_InitializePassword.Button_InitPwdClick(Sender: TObject);
begin
  if Edit_UserName.Text = '' then
    ShowMessage('未选择初始化密码的操作员！')
  else
    begin
      DataModule_sjhf.ADOQuery_SjhfDb.Close;
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B.BTOF_ID FROM BHGMS_U_LOGIN B WHERE B.BTOF_ID=''' + Edit_UserId.Text + '''';
      DataModule_sjhf.ADOQuery_SjhfDb.Open;
      if DataModule_sjhf.ADOQuery_SjhfDb.RecordCount = 0 then
        begin
          try
            DataModule_sjhf.ADOQuery_SjhfDb.Close;
            DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
            DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
            DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'INSERT INTO BHGMS_U_LOGIN VALUES (''' + Edit_UserId.Text + ''',PACKAGE_BHGMS_TRANSACTION.GENERATE_PWD_CHAR(''' + Edit_UserId.Text + ''',''00000001''),''1'',SYSDATE,SYSDATE)';
            DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
            DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
            ShowMessage('初始化密码成功，初始密码为00000001！');
          except
            on e: Exception do
              begin
                ShowMessage('初始化密码失败！');
                DataModule_sjhf.ADOConnection_SjhfDb.RollbackTrans;
              end;
          end;
        end
      else
        begin
          try
            DataModule_sjhf.ADOQuery_SjhfDb.Close;
            DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
            DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
            DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'UPDATE BHGMS_U_LOGIN B SET B.PASSWORD=PACKAGE_BHGMS_TRANSACTION.GENERATE_PWD_CHAR(''' + Edit_UserId.Text + ''',''00000001''),B.ALTER_TIME=SYSDATE WHERE B.BTOF_ID=''' + Edit_UserId.Text + '''';
            DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
            DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
            ShowMessage('初始化密码成功，初始密码为00000001！');
          except
            on e: Exception do
              begin
                ShowMessage('初始化密码失败！');
                DataModule_sjhf.ADOConnection_SjhfDb.RollbackTrans;
              end;
          end;
        end;
    end;
end;

procedure TForm_InitializePassword.Edit_UserIdKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    begin
      if Length(Edit_UserId.Text) < 6 then
        begin
          ShowMessage('操作员不存在！');
          Edit_UserName.Text := '';
        end
      else
        begin
          DataModule_sjhf.ADOQuery_SjhfDb.Close;
          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT BTOF_NAME,BTOF_STATUS FROM BHGMS_U_OFFICER WHERE BTOF_ID=''' + Edit_UserId.Text + '''';
          DataModule_sjhf.ADOQuery_SjhfDb.Open;
          if DataModule_sjhf.ADOQuery_SjhfDb.RecordCount = 0 then
            begin
              ShowMessage('操作员不存在！');
              Edit_UserName.Text := '';
            end
          else
            if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTOF_STATUS').AsString = '0' then
              begin
                ShowMessage('操作员为无效状态！');
                Edit_UserName.Text := '';
              end
            else
              if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTOF_STATUS').AsString = '1' then
                Edit_UserName.Text := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTOF_NAME').AsString;
        end;
    end;
end;

end.
