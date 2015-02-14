unit ui_login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdIPWatch, StrUtils, logic_db, ui_session, ui_frame, ComObj, Menus;

type
  TForm_Login = class(TForm)
    Edit_UserId: TEdit;
    Edit_Password: TEdit;
    Button_Login: TButton;
    Button_Clear: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Button_Exit: TButton;
    IdIPWatch_Local: TIdIPWatch;
    Label_Err: TLabel;
    procedure Button_ClearClick(Sender: TObject);
    procedure Button_LoginClick(Sender: TObject);
    procedure Edit_UserIdKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_PasswordKeyPress(Sender: TObject; var Key: Char);
    procedure Button_ExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Login: TForm_Login;

implementation

{$R *.dfm}

procedure TForm_Login.Button_ClearClick(Sender: TObject);
begin
  Edit_UserId.Text := '';
  Edit_Password.Text := '';
end;

procedure TForm_Login.Button_ExitClick(Sender: TObject);
begin
  Form_Session.Edit_BtofId.Text := '';
  Form_Session.Edit_BtoId.Text := '';
  Form_Session.Edit_BtofJobId.Text := '';
  Form_Session.Edit_IpAddress.Text := '';
  DataModule_sjhf.ADOConnection_SjhfDb.Close;
  Close;
end;

procedure TForm_Login.Button_LoginClick(Sender: TObject);
var
  ff: TForm_Frame;
  job_id: string;
begin
  if (Edit_UserId.Text = '') Or (Edit_Password.Text = '') then
    Label_Err.Caption := '用户名或密码不能为空，请重新输入！'
  else
    begin
      try
        logic_db.DataModule_sjhf.ADOQuery_SjhfDb.Close;
        logic_db.DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
        logic_db.DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT PACKAGE_BHGMS_TRANSACTION.MATCH_PWD (''' + Edit_UserId.Text + ''', ''' + Edit_Password.Text + ''') AS LOGIN FROM DUAL';
        logic_db.DataModule_sjhf.ADOQuery_SjhfDb.Open;
	      if (logic_db.DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('LOGIN').AsString = '0') then
          Label_Err.Caption := '用户尚未注册或无效！'
	      else
	        if (logic_db.DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('LOGIN').AsString = '1') then
		        Label_Err.Caption := '用户名或密码错误！'
	        else
	          if (logic_db.DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('LOGIN').AsString = '2') and (Edit_UserId.Text = 'admin') then
		          begin
                try
                  Label_Err.Caption := '';
                  Form_Session.Edit_BtofId.Text := Edit_UserId.Text;
                  Form_Session.Edit_BtofName.Text := '系统管理员';
                  ff := TForm_Frame.Create(Self);
                  ff.StatusBar_Frame.Panels[0].Text := '操作员：系统管理员';
                  ff.Label_Checkin.Caption := '登录成功。';
                  ff.MenuItem_CheckinMgmt.Visible := False;
                  ff.MenuItem_VacationMgmt.Visible := False;
                  ff.MenuItem_OvertimeMgmt.Visible := False;
                  if Edit_Password.Text = '00000001' then
                    begin
                      ff.MenuItem_ChangePassword.Visible := True;
                      ff.MenuItem_InitializePassword.Visible := False;
                      ff.MenuItem_DimensionMgmt.Visible := False;
                      ff.MenuItem_RightMgmt.Visible := False;
                    end
                  else
                    begin
                      ff.MenuItem_ChangePassword.Visible := True;
                      ff.MenuItem_InitializePassword.Visible := True;
                      ff.MenuItem_DimensionMgmt.Visible := True;
                      ff.MenuItem_RightMgmt.Visible := True;
                    end;
                  ff.ShowModal;
                finally
                  FreeAndNil(ff);
                end
		          end
		        else
              begin
                try
                  Label_Err.Caption := '';
                  ff := TForm_Frame.Create(Self);
                  DataModule_sjhf.ADOQuery_SjhfDb.Close;
                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT BTOF_ID,BTOF_NAME,BTO_ID,JOB_ID,BTOF_ISUNI FROM BHGMS_U_OFFICER WHERE BTOF_ID=''' + Edit_UserId.Text + '''';
                  DataModule_sjhf.ADOQuery_SjhfDb.Open;

                  if Length(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('JOB_ID').AsString) = 1 then
                    job_id := '0' + DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('JOB_ID').AsString + DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTOF_ISUNI').AsString
                  else
                    job_id := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('JOB_ID').AsString + DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTOF_ISUNI').AsString;

                  Form_Session.Edit_BtofId.Text := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTOF_ID').AsString;
                  Form_Session.Edit_BtofName.Text := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTOF_NAME').AsString;
                  Form_Session.Edit_BtoId.Text := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTO_ID').AsString;
                  Form_Session.Edit_BtofJobId.Text := job_id;
                  Form_Session.Edit_IpAddress.Text := '';
                  Form_Session.DateTimePicker_LoginTime.DateTime := Now;

                  ff.StatusBar_Frame.Panels[0].Text := '操作员：' + DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTOF_NAME').AsString + '(' +  DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTOF_ID').AsString + ')';
                  DataModule_sjhf.ADOQuery_SjhfDb.Close;
                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B.FC_ID,B.FC_CHECKTIME FROM BHGMS_F_CHECKIN B WHERE B.FC_CHECKER=''' + Edit_UserId.Text + ''' AND B.FC_DATE=TO_CHAR(SYSDATE,''YYYYMMDD'') AND B.FC_TYPE=''0''';
                  DataModule_sjhf.ADOQuery_SjhfDb.Open;
                  if DataModule_sjhf.ADOQuery_SjhfDb.RecordCount = 1 then
			              ff.Label_Checkin.Caption := '当日已签到，时间为' + LeftStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FC_CHECKTIME').AsString, 2) + '时' + RightStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FC_CHECKTIME').AsString, 2) + '分。'
                  else
                    begin
                      DataModule_sjhf.ADOQuery_SjhfDb.Close;
                      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT ISWORKDATE FROM C_HOLIDAY WHERE TO_CHAR(CH_DATE, ''YYYYMMDD'') = TO_CHAR(SYSDATE, ''YYYYMMDD'')';
                      DataModule_sjhf.ADOQuery_SjhfDb.Open;
                      if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('ISWORKDATE').AsString = '0' then
                        begin
                          DataModule_sjhf.ADOQuery_SjhfDb.Close;
                          DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'INSERT INTO BHGMS_F_CHECKIN (FC_ID,FC_DATE,FC_TYPE,FC_CHECKER,FC_CHECKTIME,FC_STATUS,INSERT_TIME,ALTER_TIME) VALUES (FC_ID.NEXTVAL, TO_CHAR (SYSDATE, ''YYYYMMDD''), ''0'', ''' + Edit_UserId.Text + ''', TO_CHAR (SYSDATE, ''HH24MI''), ''5'', SYSDATE, SYSDATE)';
                          DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                          DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
                        end
                      else
                        begin
                          DataModule_sjhf.ADOQuery_SjhfDb.Close;
                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT D.DIT_TIMESTAMP,TO_CHAR(SYSDATE,''HH24MI'') AS SYSTIME FROM BHGMS_D_INTIME D,BHGMS_U_OFFICER B2,BHGMS_U_ORGAN B1 WHERE B1.BTO_ID=B2.BTO_ID AND B1.BTO_CATEGORY=D.BTO_CATEGORY AND B2.BTOF_ID=''' + Edit_UserId.Text + '''';
                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(' AND TO_CHAR(SYSDATE-1,''D'')=D.DIT_DAYOFWEEK AND D.DIT_STATUS =''1'' AND D.DIT_TYPE=''1''');
                          DataModule_sjhf.ADOQuery_SjhfDb.Open;
                          if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('SYSTIME').AsString > DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DIT_TIMESTAMP').AsString then
                            begin
                              DataModule_sjhf.ADOQuery_SjhfDb.Close;
                              DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'INSERT INTO BHGMS_F_CHECKIN (FC_ID,FC_DATE,FC_TYPE,FC_CHECKER,FC_CHECKTIME,FC_STATUS,INSERT_TIME,ALTER_TIME) VALUES (FC_ID.NEXTVAL, TO_CHAR (SYSDATE, ''YYYYMMDD''), ''0'', ''' + Edit_UserId.Text + ''', TO_CHAR (SYSDATE, ''HH24MI''), ''2'', SYSDATE, SYSDATE)';
                              DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                              DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
                            end
                          else
                            begin
                              DataModule_sjhf.ADOQuery_SjhfDb.Close;
                              DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'INSERT INTO BHGMS_F_CHECKIN (FC_ID,FC_DATE,FC_TYPE,FC_CHECKER,FC_CHECKTIME,FC_STATUS,INSERT_TIME,ALTER_TIME) VALUES (FC_ID.NEXTVAL,TO_CHAR(SYSDATE,''YYYYMMDD''),''0'',''' + Edit_UserId.Text + ''',TO_CHAR(SYSDATE,''HH24MI''),''0'',SYSDATE,SYSDATE)';
                              DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                              DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
                            end;
                        end;
                      DataModule_sjhf.ADOQuery_SjhfDb.Close;
                      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B.FC_ID,B.FC_CHECKTIME FROM BHGMS_F_CHECKIN B WHERE B.FC_CHECKER=''' + Edit_UserId.Text + ''' AND B.FC_DATE=TO_CHAR(SYSDATE,''YYYYMMDD'') AND B.FC_TYPE=''0''';
                      DataModule_sjhf.ADOQuery_SjhfDb.Open;
                      ff.Label_Checkin.Caption := '签到成功，时间为' + LeftStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FC_CHECKTIME').AsString, 2) + '时' + RightStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FC_CHECKTIME').AsString, 2) + '分。';
                    end;

                  ff.MenuItem_ChangePassword.Visible := True;

                  if Edit_Password.Text = '00000001' then
                    begin
                      ff.MenuItem_CheckinMgmt.Visible := False;
                      ff.MenuItem_VacationMgmt.Visible := False;
                      ff.MenuItem_OvertimeMgmt.Visible := False;
                      ff.MenuItem_InitializePassword.Visible := False;
                      ff.MenuItem_DimensionMgmt.Visible := False;
                      ff.MenuItem_RightMgmt.Visible := False;
                    end
                  else
                    begin
                      ff.MenuItem_CheckinMgmt.Visible := True;
                      ff.MenuItem_VacationMgmt.Visible := True;
                      ff.MenuItem_OvertimeMgmt.Visible := True;
                      ff.MenuItem_InitializePassword.Visible := True;
                      ff.MenuItem_DimensionMgmt.Visible := True;
                      ff.MenuItem_RightMgmt.Visible := True;
                    end;
                  ff.ShowModal;
                finally
                  FreeAndNil(ff);
                end;
              end;
      except
        on e: EOleException do
          Label_Err.Caption := '数据库连接失败！';
      end;
    end;
end;

procedure TForm_Login.Edit_PasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    Button_Login.Click;
end;

procedure TForm_Login.Edit_UserIdKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    Edit_Password.SetFocus;
end;

end.
