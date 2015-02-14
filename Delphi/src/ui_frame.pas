unit ui_frame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ui_changepwd, ComCtrls, ExtCtrls, StdCtrls, StrUtils,
  logic_db, ui_session, ui_approve_list_vacation, ui_approve_vacation, ui_query_checkin, ui_initpwd, ui_query_vacation_details, ui_query_vacation_overall;

type
  TForm_Frame = class(TForm)
    MainMenu_bhgms: TMainMenu;
    MenuItem_SysConfig: TMenuItem;
    MenuItem_ChangePassword: TMenuItem;
    StatusBar_Frame: TStatusBar;
    Timer_Panel: TTimer;
    Label_Checkin: TLabel;
    MenuItem_CheckinMgmt: TMenuItem;
    MenuItem_OffWork: TMenuItem;
    MenuItem_VacationMgmt: TMenuItem;
    MenuItem_VacationHandle: TMenuItem;
    MenuItem_NewVacation: TMenuItem;
    MenuItem_CheckinQuery: TMenuItem;
    MenuItem_DimensionMgmt: TMenuItem;
    MenuItem_RightMgmt: TMenuItem;
    MenuItem_OvertimeMgmt: TMenuItem;
    MenuItem_OvertimeHandle: TMenuItem;
    MenuItem_NewOvertime: TMenuItem;
    MenuItem_InitializePassword: TMenuItem;
    MenuItem_VacationDetailsQuery: TMenuItem;
    MenuItem_VacationOverallQuery: TMenuItem;
    MenuItem_ItemMgmt: TMenuItem;
    MenuItem_MenuGroupMgmt: TMenuItem;
    MenuItem_GroupOrganMgmt: TMenuItem;
    MenuItem_GroupOperatorMgmt: TMenuItem;
    MenuItem_SpecItemMgmt: TMenuItem;
    procedure MenuItem_ChangePasswordClick(Sender: TObject);
    procedure Timer_PanelTimer(Sender: TObject);
    procedure MenuItem_OffWorkClick(Sender: TObject);
    procedure MenuItem_VacationHandleClick(Sender: TObject);
    procedure MenuItem_NewVacationClick(Sender: TObject);
    procedure MenuItem_CheckinQueryClick(Sender: TObject);
    procedure MenuItem_InitializePasswordClick(Sender: TObject);
    procedure MenuItem_VacationDetailsQueryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuItem_VacationOverallQueryClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Frame: TForm_Frame;

implementation

{$R *.dfm}

{退出时判断应下班时间与当前时间的差是否小于等于5分钟，若小于等于，含当前时间大于下班时间的，提示进行签到}
procedure TForm_Frame.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DataModule_sjhf.ADOQuery_SjhfDb.Close;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B.FC_ID,B.FC_CHECKTIME FROM BHGMS_F_CHECKIN B WHERE B.FC_CHECKER=''' + Form_Session.Edit_BtofId.Text + ''' AND B.FC_DATE=TO_CHAR(SYSDATE,''YYYYMMDD'') AND B.FC_TYPE=''1''';
  DataModule_sjhf.ADOQuery_SjhfDb.Open;

  if DataModule_sjhf.ADOQuery_SjhfDb.RecordCount = 0 then
    begin
      DataModule_sjhf.ADOQuery_SjhfDb.Close;
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT ROUND((TO_DATE(D.DIT_TIMESTAMP,''HH24MI'')-TO_DATE(TO_CHAR(SYSDATE,''HH24MI''),''HH24MI''))*288,2) AS GAP FROM BHGMS_D_INTIME D,BHGMS_U_OFFICER B2,BHGMS_U_ORGAN B1 WHERE B1.BTO_ID=B2.BTO_ID AND B1.BTO_CATEGORY=D.BTO_CATEGORY AND B2.BTOF_ID=''' + Form_Session.Edit_BtofId.Text + '''';
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(' AND TO_CHAR(SYSDATE-1,''D'')=D.DIT_DAYOFWEEK AND D.DIT_STATUS =''1'' AND D.DIT_TYPE=''2''');
      DataModule_sjhf.ADOQuery_SjhfDb.Open;

      if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('GAP').AsInteger <= 1 then
        begin
          if Application.MessageBox(PChar('距离下班时间小于等于5分钟或已超过下班时间，是否进行下班签到并退出登录？'), PChar('提示'), MB_OKCANCEL) = IDOK then
            try
              MenuItem_OffWork.Click;
              Close;
            except
              on e: Exception do
                ShowMessage('签到失败！');
            end;
        end;
    end;
end;

{密码修改功能}
procedure TForm_Frame.MenuItem_ChangePasswordClick(Sender: TObject);
var
  fcp: TForm_ChangePassword;
begin
  try
    fcp := TForm_ChangePassword.Create(Self);
    fcp.Label5.Caption := Form_Session.Edit_BtofName.Text;
    fcp.ShowModal;
  finally
    FreeAndNil(fcp);
  end;
end;

{下班签到功能}
procedure TForm_Frame.MenuItem_OffWorkClick(Sender: TObject);
begin
  if Form_Session.Edit_BtofId.Text <> 'admin' then
    begin
      DataModule_sjhf.ADOQuery_SjhfDb.Close;
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B.FC_ID,B.FC_CHECKTIME FROM BHGMS_F_CHECKIN B WHERE B.FC_CHECKER=''' + Form_Session.Edit_BtofId.Text + ''' AND B.FC_DATE=TO_CHAR(SYSDATE,''YYYYMMDD'') AND B.FC_TYPE=''1''';
      DataModule_sjhf.ADOQuery_SjhfDb.Open;
      if DataModule_sjhf.ADOQuery_SjhfDb.RecordCount = 1 then
        ShowMessage('今日已签到，时间为' + LeftStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FC_CHECKTIME').AsString, 2) + '时' + RightStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FC_CHECKTIME').AsString, 2) + '分')
      else
        begin
          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT ISWORKDATE FROM C_HOLIDAY WHERE TO_CHAR(CH_DATE,''YYYYMMDD'')=TO_CHAR(SYSDATE, ''YYYYMMDD'')';
          DataModule_sjhf.ADOQuery_SjhfDb.Open;
          if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('ISWORKDATE').AsString = '0' then
            begin
              DataModule_sjhf.ADOQuery_SjhfDb.Close;
              DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'INSERT INTO BHGMS_F_CHECKIN (FC_ID,FC_DATE,FC_TYPE,FC_CHECKER,FC_CHECKTIME,FC_STATUS,INSERT_TIME,ALTER_TIME) VALUES (FC_ID.NEXTVAL,TO_CHAR(SYSDATE,''YYYYMMDD''),''1'',''' + Form_Session.Edit_BtofId.Text + ''',TO_CHAR(SYSDATE,''HH24MI''),''5'',SYSDATE,SYSDATE)';
              DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
              DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
            end
          else
            begin
              DataModule_sjhf.ADOQuery_SjhfDb.Close;
              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT D.DIT_TIMESTAMP,TO_CHAR(SYSDATE,''HH24MI'') AS SYSTIME FROM BHGMS_D_INTIME D,BHGMS_U_OFFICER B2,BHGMS_U_ORGAN B1 WHERE B1.BTO_ID=B2.BTO_ID AND B1.BTO_CATEGORY=D.BTO_CATEGORY AND B2.BTOF_ID=''' + Form_Session.Edit_BtofId.Text + '''';
              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(' AND TO_CHAR(SYSDATE-1,''D'')=D.DIT_DAYOFWEEK AND D.DIT_STATUS =''1'' AND D.DIT_TYPE=''2''');
              DataModule_sjhf.ADOQuery_SjhfDb.Open;
              if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('SYSTIME').AsString > DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DIT_TIMESTAMP').AsString then
                begin
                  DataModule_sjhf.ADOQuery_SjhfDb.Close;
                  DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'INSERT INTO BHGMS_F_CHECKIN (FC_ID,FC_DATE,FC_TYPE,FC_CHECKER,FC_CHECKTIME,FC_STATUS,INSERT_TIME,ALTER_TIME) VALUES (FC_ID.NEXTVAL,TO_CHAR(SYSDATE,''YYYYMMDD''),''1'',''' + Form_Session.Edit_BtofId.Text + ''',TO_CHAR(SYSDATE,''HH24MI''),''7'',SYSDATE,SYSDATE)';
                  DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                  DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
                end
              else
                if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('SYSTIME').AsString < DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DIT_TIMESTAMP').AsString then
                  begin
                    DataModule_sjhf.ADOQuery_SjhfDb.Close;
                    DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
                    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'INSERT INTO BHGMS_F_CHECKIN (FC_ID,FC_DATE,FC_TYPE,FC_CHECKER,FC_CHECKTIME,FC_STATUS,INSERT_TIME,ALTER_TIME) VALUES (FC_ID.NEXTVAL,TO_CHAR(SYSDATE,''YYYYMMDD''),''1'',''' + Form_Session.Edit_BtofId.Text + ''', TO_CHAR(SYSDATE,''HH24MI''),''6'',SYSDATE,SYSDATE)';
                    DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                    DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
                  end
                else
                  if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('SYSTIME').AsString = DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DIT_TIMESTAMP').AsString then
                    begin
                      DataModule_sjhf.ADOQuery_SjhfDb.Close;
                      DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
                      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'INSERT INTO BHGMS_F_CHECKIN (FC_ID,FC_DATE,FC_TYPE,FC_CHECKER,FC_CHECKTIME,FC_STATUS,INSERT_TIME,ALTER_TIME) VALUES (FC_ID.NEXTVAL,TO_CHAR(SYSDATE,''YYYYMMDD''),''1'',''' + Form_Session.Edit_BtofId.Text + ''',TO_CHAR(SYSDATE,''HH24MI''),''3'',SYSDATE,SYSDATE)';
                      DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                      DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
                    end;
            end;
          DataModule_sjhf.ADOQuery_SjhfDb.Close;
          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B.FC_ID,B.FC_CHECKTIME FROM BHGMS_F_CHECKIN B WHERE B.FC_CHECKER=''' + Form_Session.Edit_BtofId.Text + ''' AND B.FC_DATE=TO_CHAR(SYSDATE,''YYYYMMDD'') AND B.FC_TYPE=''1''';
          DataModule_sjhf.ADOQuery_SjhfDb.Open;
          ShowMessage('今日已签到，时间为' + LeftStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FC_CHECKTIME').AsString, 2) + '时' + RightStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FC_CHECKTIME').AsString, 2) + '分');
        end;
    end;
end;

{请假文书查询与受理功能}
procedure TForm_Frame.MenuItem_VacationHandleClick(Sender: TObject);
var
  falv: TForm_Approve_List_Vacation;
  d: TFormatSettings;
begin
  try
    d.ShortDateFormat := 'yyyy-MM-dd';
    d.DateSeparator := '-';
    falv := TForm_Approve_List_Vacation.Create(Self);
    falv.JvCheckedComboBox_ApproveStatus.Checked[0] := True;
    falv.JvCheckedComboBox_ApproveStatus.Checked[1] := True;
    falv.JvCheckedComboBox_ApproveStatus.Checked[4] := True;
    falv.JvCheckedComboBox_CurrentNode.Checked[1] := True;
    DataModule_sjhf.ADOQuery_SjhfDb.Close;
    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B1.FA_ID,B1.FA_NAME,B3.BTOF_NAME AS BTOF_ISSUER_NAME,B5.BTOF_NAME AS BTOF_CURRENTUSER_NAME,B1.FA_ISSUEDATE,B4.DAS_NAME,';
    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('DECODE(B2.FAVS_TIME_TYPE, ''1'',''按时'',''2'',''按天'','''') AS FAVS_TIME_TYPE FROM BHGMS_F_APPROVE_VACATION_SUB B2, BHGMS_F_APPROVE B1,');
    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('BHGMS_U_OFFICER B3,BHGMS_U_OFFICER B5,BHGMS_D_APPROVE_STATUS B4 WHERE B1.FA_ID=B2.FA_ID AND B3.BTOF_ID=B1.FA_ISSUER AND B5.BTOF_ID=B1.FA_CURRENTUSER AND B1.FA_STATUS=B4.DAS_ID AND B1.FA_CURRENTUSER=''' + Form_Session.Edit_BtofId.Text + '''');
    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(' AND B1.FA_STATUS IN (''0'',''1'',''4'') ORDER BY TO_NUMBER(B1.FA_ID)');
    DataModule_sjhf.ADOQuery_SjhfDb.Open;
    falv.DBGrid_Vacation.DataSource := DataModule_sjhf.DataSource_FApprove;
    falv.ShowModal;
  finally
    FreeAndNil(falv);
  end;
end;

procedure TForm_Frame.MenuItem_VacationOverallQueryClick(Sender: TObject);
var
  fqvo: TForm_Query_Vacation_Overall;
begin
  try
    fqvo := TForm_Query_Vacation_Overall.Create(Self);
    fqvo.ShowModal;
  finally
    FreeAndNil(fqvo);
  end;
end;

procedure TForm_Frame.MenuItem_VacationDetailsQueryClick(Sender: TObject);
var
  fqvd: TForm_Query_Vacation_Details;
begin
  try
    fqvd := TForm_Query_Vacation_Details.Create(Self);
    fqvd.ShowModal;
  finally
    FreeAndNil(fqvd);
  end;
end;

procedure TForm_Frame.MenuItem_NewVacationClick(Sender: TObject);
var
  fav: TForm_Approve_Vacation;
  i: Integer;
begin
  try
    fav := TForm_Approve_Vacation.Create(Self);

    DataModule_sjhf.ADOQuery_SjhfDb.Close;
    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT BTOF_ID||''|''||BTOF_NAME AS BTOF FROM BHGMS_U_OFFICER WHERE BTOF_STATUS=''1'' AND BTO_ID=''' + Form_Session.Edit_BtoId.Text + ''' AND BTOF_ID<>''' + Form_Session.Edit_BtofId.Text + ''' ORDER BY BTOF_ID';
    DataModule_sjhf.ADOQuery_SjhfDb.Open;

    DataModule_sjhf.ADOQuery_SjhfDb.First;
    for i := 0 to DataModule_sjhf.ADOQuery_SjhfDb.RecordCount - 1 do
      begin
        fav.JvComboBox_IssuerInFact.Items.Add(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTOF').AsString);
        DataModule_sjhf.ADOQuery_SjhfDb.Next;
      end;

    fav.RadioButton_BySelf.Checked := True;
    fav.RadioButton_Instead.Checked := False;
    fav.DateTimePicker_TIssueDate.Date := Now;
    fav.DateTimePicker_TBeginTime.Time := Now;
    fav.DateTimePicker_TEndTime.Time := Now;
    fav.DateTimePicker_DBeginDate.Date := Now;
    fav.DateTimePicker_DEndDate.Date := Now;
    fav.RadioButton_ByTime.Checked := True;
    fav.RadioButton_ByDate.Checked := False;
    fav.Memo_FavsDescription.Text := '';
    fav.Button_Delete.Enabled := False;
    fav.ComboBox_NextControl.Enabled := False;
    fav.JvComboBox_NextUser.Enabled := False;
    fav.Button_Confirm.Enabled := False;
    fav.Memo_ApproveComment.Text := '';
    fav.ShowModal;
  finally
    FreeAndNil(fav);
  end;
end;

procedure TForm_Frame.MenuItem_CheckinQueryClick(Sender: TObject);
var
  fcq: TForm_Query_Checkin;
begin
  try
    fcq := TForm_Query_Checkin.Create(Self);
    fcq.ShowModal;
  finally
    FreeAndNil(fcq);
  end;
end;

procedure TForm_Frame.MenuItem_InitializePasswordClick(Sender: TObject);
var
  fip: TForm_InitializePassword;
begin
  try
    fip := TForm_InitializePassword.Create(Self);
    fip.ShowModal;
  finally
    FreeAndNil(fip);
  end;
end;

procedure TForm_Frame.Timer_PanelTimer(Sender: TObject);
begin
  Self.StatusBar_Frame.Panels[1].Text := DateTimeToStr(Now);
end;

end.
