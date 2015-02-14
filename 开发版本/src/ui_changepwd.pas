unit ui_changepwd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, logic_db, ui_session;

type
  TForm_ChangePassword = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit_PrevPasswd: TEdit;
    Edit_NewPasswd: TEdit;
    Edit_ConfNewPasswd: TEdit;
    Label5: TLabel;
    Button_Confirm: TButton;
    Button_Cancel: TButton;
    procedure Button_ConfirmClick(Sender: TObject);
    procedure Edit_PrevPasswdKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_NewPasswdKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_ConfNewPasswdKeyPress(Sender: TObject; var Key: Char);
    procedure Button_CancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_ChangePassword: TForm_ChangePassword;

implementation

{$R *.dfm}

procedure TForm_ChangePassword.Button_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_ChangePassword.Button_ConfirmClick(Sender: TObject);
begin
  if (Edit_PrevPasswd.Text = '') Or (Edit_NewPasswd.Text = '') Or (Edit_ConfNewPasswd.Text = '') then
    ShowMessage('密码不能为空！')
  else
    if Edit_NewPasswd.Text <> Edit_ConfNewPasswd.Text then
      ShowMessage('两次输入密码不一致！')
    else
      begin
        logic_db.DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
        logic_db.DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT PACKAGE_BHGMS_TRANSACTION.MATCH_PWD (''' + Form_Session.Edit_BtofId.Text + ''', ''' + Edit_PrevPasswd.Text + ''') AS MATCH_RESULT FROM DUAL';
        logic_db.DataModule_sjhf.ADOQuery_SjhfDb.Open;
        if logic_db.DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('MATCH_RESULT').AsInteger = 1 then
          ShowMessage('原密码错误！')
        else
          begin
            logic_db.DataModule_sjhf.ADOQuery_SjhfDb.Close;
            logic_db.DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
            logic_db.DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
            logic_db.DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'UPDATE BHGMS_U_LOGIN U SET U.PASSWORD=PACKAGE_BHGMS_TRANSACTION.GENERATE_PWD_CHAR (''' + Form_Session.Edit_BtofId.Text + ''',''' + Edit_NewPasswd.Text + '''),U.ALTER_TIME=SYSDATE WHERE U.BTOF_ID=''' + Form_Session.Edit_BtofId.Text + '''';
            logic_db.DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
            logic_db.DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
            ShowMessage('密码修改成功！');
          end
      end
end;

procedure TForm_ChangePassword.Edit_ConfNewPasswdKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    Button_Confirm.Click;
end;

procedure TForm_ChangePassword.Edit_NewPasswdKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    Edit_ConfNewPasswd.SetFocus;
end;

procedure TForm_ChangePassword.Edit_PrevPasswdKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    Edit_NewPasswd.SetFocus;
end;

end.
