unit ui_approve_list_vacation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, ComCtrls, DBCtrls, StrUtils, logic_db, DB, ui_approve_vacation, ui_session, ui_approve_progress,
  Mask, JvExMask, JvToolEdit, JvCombobox;

type
  TForm_Approve_List_Vacation = class(TForm)
    DBGrid_Vacation: TDBGrid;
    Button_Lookup: TButton;
    Button_Delete: TButton;
    DateTimePicker_BeginDate: TDateTimePicker;
    DateTimePicker_EndDate: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Button_Query: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Button_LookupProcess: TButton;
    JvCheckedComboBox_CurrentNode: TJvCheckedComboBox;
    JvCheckedComboBox_ApproveStatus: TJvCheckedComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Button_QueryClick(Sender: TObject);
    function GetSelectedSQLString(jvccb: TJvCheckedComboBox; sc: integer): string;
    procedure Button_DeleteClick(Sender: TObject);
    procedure Button_LookupClick(Sender: TObject);
    procedure Button_LookupProcessClick(Sender: TObject);
    procedure DBGrid_VacationDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Approve_List_Vacation: TForm_Approve_List_Vacation;

implementation

{$R *.dfm}

procedure TForm_Approve_List_Vacation.Button_DeleteClick(Sender: TObject);
var
  fa_id: string;
begin
  if (DBGrid_Vacation.Fields[6].Value <> '保存') Or (DBGrid_Vacation.Fields[3].Value <> Form_Session.Edit_BtofName.Text) then
    ShowMessage('只有状态为“保存”，且受理人为当前操作员的请假记录才能删除！')
  else
    begin
      fa_id := DBGrid_Vacation.Fields[0].Value;
      DataModule_sjhf.ADOQuery_SjhfDb.Close;
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT F2.FAVS_ORIGIN FROM BHGMS_F_APPROVE_VACATION_SUB F2 WHERE F2.FA_ID=''' + fa_id + '''';
      DataModule_sjhf.ADOQuery_SjhfDb.Open;
      if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ORIGIN').AsString = '1' then
        ShowMessage('自动生成的请假记录无法删除！')
      else
        try
          fa_id := DBGrid_Vacation.Fields[0].Value;
          DataModule_sjhf.ADOQuery_SjhfDb.Close;
          DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'UPDATE BHGMS_F_APPROVE SET FA_STATUS = ''2'',ALTER_TIME=SYSDATE WHERE FA_ID=''' + fa_id + '''';
          DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
          DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
          ShowMessage('删除成功！');
          Button_Query.Click;
        except
          on e: Exception do
            ShowMessage('删除失败！');
        end;
    end;
end;

procedure TForm_Approve_List_Vacation.Button_LookupClick(Sender: TObject);
var
  fa_id, curr_user, first_user: string;
  i: Integer;
  date, time: TFormatSettings;
  fav: TForm_Approve_Vacation;
begin
  if DBGrid_Vacation.FieldCount = 0 then
    ShowMessage('记录数为0！')
  else
    begin
      date.ShortDateFormat := 'yyyy-MM-dd';
      date.DateSeparator := '-';
      time.ShortTimeFormat := 'hh:mm';
      time.TimeSeparator := ':';
      fa_id := VarToStr(DBGrid_Vacation.Fields[0].Value);
      DataModule_sjhf.ADOQuery_SjhfDb.Close;
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B1.FA_TYPE,B2.FA_ID,B2.FAVS_DESCRIPTION,B2.FAVS_TIME_TYPE,B1.FA_ISSUER,B1.FA_ISSUER_INFACT,B3.BTOF_NAME,B1.FA_CURRENTUSER,B2.FAVS_ISSUEDATE,B2.FAVS_ENDDATE,B2.FAVS_BEGINTIME,B2.FAVS_ENDTIME,B2.FAVS_TYPE,B1.FA_STATUS,B2.FAVS_ORIGIN FROM';
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(' BHGMS_F_APPROVE_VACATION_SUB B2,BHGMS_F_APPROVE B1,BHGMS_U_OFFICER B3 WHERE B1.FA_ID=B2.FA_ID AND B3.BTOF_ID(+)=B1.FA_ISSUER_INFACT AND B2.FA_ID=''' + fa_id + '''');
      DataModule_sjhf.ADOQuery_SjhfDb.Open;
      time.ShortTimeFormat := 'hh:nn';
      time.TimeSeparator := ':';
      curr_user := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FA_CURRENTUSER').AsString;
      first_user := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FA_ISSUER').AsString;
      if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FA_TYPE').AsString = '4' then
        ShowMessage('批量请假功能正在开发中-_-')
      else
        begin
          try
            fav := TForm_Approve_Vacation.Create(Self);

            if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FA_ISSUER_INFACT').AsString = '' then
              begin
                fav.RadioButton_BySelf.Checked := True;
                fav.RadioButton_Instead.Checked := False;
              end
            else
              begin
                fav.RadioButton_BySelf.Checked := False;
                fav.RadioButton_Instead.Checked := True;
                fav.JvComboBox_IssuerInFact.Text := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FA_ISSUER_INFACT').AsString + '|' + DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTOF_NAME').AsString;
              end;

            fav.Label_FaId.Caption := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FA_ID').AsString;
            if (DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_TIME_TYPE').AsString = '1') and (DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ORIGIN').AsString = '1') then
              begin
                fav.RadioButton_ByTime.Checked := True;
                fav.RadioButton_ByDate.Checked := False;
                fav.DateTimePicker_TIssueDate.Date := StrToDate(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ISSUEDATE').AsString, date);
                fav.DateTimePicker_TBeginTime.Time := StrToTime(LeftStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_BEGINTIME').AsString, 2) + ':' + RightStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_BEGINTIME').AsString, 2), time);
                fav.DateTimePicker_TEndTime.Time := StrToTime(LeftStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ENDTIME').AsString, 2) + ':' + RightStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ENDTIME').AsString, 2), time);
                fav.JvComboBox_VacationType.Items.Add('9|无需请假');
              end
            else
              if (DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_TIME_TYPE').AsString = '1') and (DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ORIGIN').AsString = '2') then
                begin
                  fav.RadioButton_ByTime.Checked := True;
                  fav.RadioButton_ByDate.Checked := False;
                  fav.DateTimePicker_TIssueDate.Date := StrToDate(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ISSUEDATE').AsString, date);
                  fav.DateTimePicker_TBeginTime.Time := StrToTime(LeftStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_BEGINTIME').AsString, 2) + ':' + RightStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_BEGINTIME').AsString, 2), time);
                  fav.DateTimePicker_TEndTime.Time := StrToTime(LeftStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ENDTIME').AsString, 2) + ':' + RightStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ENDTIME').AsString, 2), time);
                end
              else
                if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_TIME_TYPE').AsString = '2' then
                  begin
                    fav.RadioButton_ByTime.Checked := False;
                    fav.RadioButton_ByDate.Checked := True;
                    fav.DateTimePicker_DBeginDate.Date := StrToDate(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ISSUEDATE').AsString, date);
                    fav.DateTimePicker_DEndDate.Date := StrToDate(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ENDDATE').AsString, date);
                  end;

            for i := 0 to fav.JvComboBox_VacationType.Items.Count - 1 do
              if (LeftStr(fav.JvComboBox_VacationType.GetItemText(i), 1) = DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_TYPE').AsString) or (LeftStr(fav.JvComboBox_VacationType.GetItemText(i), 2) = DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_TYPE').AsString) then
                fav.JvComboBox_VacationType.ItemIndex := i;

            fav.Memo_FavsDescription.Text := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_DESCRIPTION').AsString;
            fav.Memo_ApproveComment.Text := '';
            fav.JvComboBox_NextUser.Enabled := False;
            fav.SetNext(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FA_TYPE').AsString);

            if first_user <> curr_user then
              begin
                fav.GroupBox_ApprovePersonnel.Enabled := False;
                fav.GroupBox_Vacation.Enabled := False;
              end
            else
              begin
                fav.GroupBox_ApprovePersonnel.Enabled := True;
                fav.GroupBox_Vacation.Enabled := True;
              end;

            fav.ShowModal;
          finally
            FreeAndNil(fav);
          end;
        end;
    end;
end;

procedure TForm_Approve_List_Vacation.Button_LookupProcessClick(
  Sender: TObject);
var
  fap: TForm_Approve_Progress;
  fa_id: string;
begin
  if DBGrid_Vacation.FieldCount = 0 then
    ShowMessage('记录数为0！')
  else
    begin
      try
        fa_id := VarToStr(DBGrid_Vacation.Fields[0].Value);
        fap := TForm_Approve_Progress.Create(Self);
        fap.Label_FaId.Caption := fa_id;
        fap.ShowModal;
      finally
        FreeAndNil(fap);
      end;
    end;
end;

procedure TForm_Approve_List_Vacation.Button_QueryClick(Sender: TObject);
var
  DateSetting: TFormatSettings;
begin
  DateSetting.ShortDateFormat := 'yyyy-MM-dd';
  DateSetting.DateSeparator := '-';
  if DateTimePicker_EndDate.Date < DateTimePicker_BeginDate.Date then
    ShowMessage('查询结束时间不能小于起始时间！')
  else
    if (JvCheckedComboBox_CurrentNode.Text = '') or (JvCheckedComboBox_ApproveStatus.Text = '') then
      ShowMessage('文书状态或环节未选择！')
    else
      begin
        if JvCheckedComboBox_CurrentNode.Text = '受理' then
          begin
            {查询当前受理人为操作员的审批}
            DataModule_sjhf.ADOQuery_SjhfDb.Close;
            DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
            DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B1.FA_ID,B1.FA_NAME,B3.BTOF_NAME AS BTOF_ISSUER_NAME,B5.BTOF_NAME AS BTOF_CURRENTUSER_NAME,B1.FA_ISSUEDATE,B4.DAS_NAME,';
            DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('DECODE(B2.FAVS_TIME_TYPE,''1'',''按时'',''2'',''按天'','''') AS FAVS_TIME_TYPE FROM BHGMS_F_APPROVE_VACATION_SUB B2,BHGMS_F_APPROVE B1,');
            DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('BHGMS_U_OFFICER B3,BHGMS_U_OFFICER B5,BHGMS_D_APPROVE_STATUS B4 WHERE B1.FA_ID=B2.FA_ID AND B3.BTOF_ID=B1.FA_ISSUER AND B5.BTOF_ID=B1.FA_CURRENTUSER AND B1.FA_STATUS=B4.DAS_ID AND B1.FA_CURRENTUSER=''' + Form_Session.Edit_BtofId.Text + ''' AND B4.DAS_NAME ' + GetSelectedSQLString(JvCheckedComboBox_ApproveStatus, JvCheckedComboBox_ApproveStatus.CheckedCount));
            DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(' AND B1.FA_ISSUEDATE>=TO_DATE(''' + DateToStr(DateTimePicker_BeginDate.Date, DateSetting) + ''',''YYYY-MM-DD'') AND B1.FA_ISSUEDATE<=TO_DATE(''' + DateToStr(DateTimePicker_EndDate.Date, DateSetting) + ''',''YYYY-MM-DD'') ORDER BY TO_NUMBER(B1.FA_ID)');
          end
        else
          if JvCheckedComboBox_CurrentNode.Text = '发起' then
            begin
              {查询发起人为操作员的审批}
              DataModule_sjhf.ADOQuery_SjhfDb.Close;
              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B1.FA_ID,B1.FA_NAME,B3.BTOF_NAME AS BTOF_ISSUER_NAME,B5.BTOF_NAME AS BTOF_CURRENTUSER_NAME,B1.FA_ISSUEDATE,B4.DAS_NAME,';
              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('DECODE(B2.FAVS_TIME_TYPE,''1'',''按时'',''2'',''按天'','''') AS FAVS_TIME_TYPE FROM BHGMS_F_APPROVE_VACATION_SUB B2,BHGMS_F_APPROVE B1,');
              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('BHGMS_U_OFFICER B3,BHGMS_U_OFFICER B5,BHGMS_D_APPROVE_STATUS B4 WHERE B1.FA_ID=B2.FA_ID AND B3.BTOF_ID=B1.FA_ISSUER AND B5.BTOF_ID=B1.FA_CURRENTUSER AND B1.FA_STATUS=B4.DAS_ID AND B1.FA_ISSUER=''' + Form_Session.Edit_BtofId.Text + ''' AND B4.DAS_NAME ' + GetSelectedSQLString(JvCheckedComboBox_ApproveStatus, JvCheckedComboBox_ApproveStatus.CheckedCount));
              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(' AND B1.FA_ISSUEDATE>=TO_DATE(''' + DateToStr(DateTimePicker_BeginDate.Date, DateSetting) + ''',''YYYY-MM-DD'') AND B1.FA_ISSUEDATE<=TO_DATE(''' + DateToStr(DateTimePicker_EndDate.Date, DateSetting) + ''',''YYYY-MM-DD'') ORDER BY TO_NUMBER(B1.FA_ID)');
            end
          else
            if JvCheckedComboBox_CurrentNode.Text = '发起,受理' then
              begin
                {查询发起人或当前受理人为操作员的审批}
                DataModule_sjhf.ADOQuery_SjhfDb.Close;
                DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B1.FA_ID,B1.FA_NAME,B3.BTOF_NAME AS BTOF_ISSUER_NAME,B5.BTOF_NAME AS BTOF_CURRENTUSER_NAME,B1.FA_ISSUEDATE,B4.DAS_NAME,';
                DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('DECODE(B2.FAVS_TIME_TYPE,''1'',''按时'',''2'',''按天'','''') AS FAVS_TIME_TYPE FROM BHGMS_F_APPROVE_VACATION_SUB B2,BHGMS_F_APPROVE B1,');
                DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('BHGMS_U_OFFICER B3,BHGMS_U_OFFICER B5,BHGMS_D_APPROVE_STATUS B4 WHERE B1.FA_ID=B2.FA_ID AND B3.BTOF_ID=B1.FA_ISSUER AND B5.BTOF_ID=B1.FA_CURRENTUSER AND B1.FA_STATUS=B4.DAS_ID AND ((B1.FA_ISSUER=''' + Form_Session.Edit_BtofId.Text + ''') OR (B1.FA_CURRENTUSER=''' + Form_Session.Edit_BtofId.Text + ''')) AND B4.DAS_NAME ' + GetSelectedSQLString(JvCheckedComboBox_ApproveStatus, JvCheckedComboBox_ApproveStatus.CheckedCount));
                DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(' AND B1.FA_ISSUEDATE>=TO_DATE(''' + DateToStr(DateTimePicker_BeginDate.Date, DateSetting) + ''',''YYYY-MM-DD'') AND B1.FA_ISSUEDATE<=TO_DATE(''' + DateToStr(DateTimePicker_EndDate.Date, DateSetting) + ''',''YYYY-MM-DD'') ORDER BY TO_NUMBER(B1.FA_ID)');
              end;
        DataModule_sjhf.ADOQuery_SjhfDb.Open;
        DBGrid_Vacation.DataSource := DataModule_sjhf.DataSource_FApprove;
      end;
end;

procedure TForm_Approve_List_Vacation.DBGrid_VacationDblClick(Sender: TObject);
begin
  Button_LookupClick(Sender);
end;

procedure TForm_Approve_List_Vacation.FormCreate(Sender: TObject);
var
  DateTimeSetting: TFormatSettings;
begin
  DateTimeSetting.ShortDateFormat := 'yyyy-MM-dd';
  DateTimeSetting.DateSeparator := '-';
  DateTimePicker_BeginDate.DateTime := StrToDate(FormatDateTime('yyyy-MM', Now) + '-01', DateTimeSetting);
  DateTimePicker_EndDate.DateTime := StrToDate(FormatDateTime('yyyy-MM-dd', Now), DateTimeSetting);

  {文书状态及环节下拉菜单无论选择的次序如何，均按菜单项排序}
  JvCheckedComboBox_CurrentNode.OrderedText := True;
  JvCheckedComboBox_ApproveStatus.OrderedText := True;
end;

function TForm_Approve_List_Vacation.GetSelectedSQLString(
  jvccb: TJvCheckedComboBox; sc: integer): string;
var
  desc: string;
begin
  sc := jvccb.Items.Count;
  if sc = 0 then
    desc := ''
  else
    if sc = 1 then
      desc := ' = ''' + jvccb.Text + ''''
    else
      if sc > 1 then
        desc := ' IN ' + '(''' + StringReplace(jvccb.Text, ',', ''', ''', [rfReplaceAll]) + ''')';
  result := desc;
end;

end.
