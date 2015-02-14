unit ui_approve_vacation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, logic_db, ui_session, StrUtils, ComObj,
  JvExStdCtrls, JvCombobox;

type
  TForm_Approve_Vacation = class(TForm)
    GroupBox_Vacation: TGroupBox;
    GroupBox_Approve: TGroupBox;
    Label_NextControl: TLabel;
    Label_ApproveComment: TLabel;
    ComboBox_NextControl: TComboBox;
    Memo_ApproveComment: TMemo;
    Button_Confirm: TButton;
    Label_TitleTID: TLabel;
    Label_TitleTBT: TLabel;
    Label_TitleTET: TLabel;
    Label_TitleDBD: TLabel;
    Label_TitleDED: TLabel;
    Label_TitleVT: TLabel;
    Label_MD: TLabel;
    Label_TitleFaId: TLabel;
    Label_FaId: TLabel;
    RadioButton_ByTime: TRadioButton;
    RadioButton_ByDate: TRadioButton;
    DateTimePicker_TIssueDate: TDateTimePicker;
    DateTimePicker_TBeginTime: TDateTimePicker;
    DateTimePicker_TEndTime: TDateTimePicker;
    DateTimePicker_DBeginDate: TDateTimePicker;
    DateTimePicker_DEndDate: TDateTimePicker;
    Memo_FavsDescription: TMemo;
    Button_Save: TButton;
    Button_Delete: TButton;
    Label_VacationTypeErr: TLabel;
    JvComboBox_NextUser: TJvComboBox;
    JvComboBox_VacationType: TJvComboBox;
    GroupBox_ApprovePersonnel: TGroupBox;
    RadioButton_BySelf: TRadioButton;
    RadioButton_Instead: TRadioButton;
    JvComboBox_IssuerInFact: TJvComboBox;
    procedure SetNext(dat_type: string);
    procedure ComboBox_NextControlChange(Sender: TObject);
    procedure DateTimePicker_TIssueDateKeyPress(Sender: TObject; var Key: Char);
    procedure DateTimePicker_TBeginTimeKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton_ByTimeClick(Sender: TObject);
    procedure RadioButton_ByDateClick(Sender: TObject);
    procedure Button_SaveClick(Sender: TObject);
    procedure Button_DeleteClick(Sender: TObject);
    procedure Button_ConfirmClick(Sender: TObject);
    procedure RadioButton_BySelfClick(Sender: TObject);
    procedure RadioButton_InsteadClick(Sender: TObject);
    procedure DateTimePicker_TEndTimeKeyPress(Sender: TObject; var Key: Char);
    procedure DateTimePicker_DBeginDateKeyPress(Sender: TObject; var Key: Char);
    procedure DateTimePicker_DEndDateKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Approve_Vacation: TForm_Approve_Vacation;
  sl_vacation_type_time: TStringList;
  sl_vacation_type_date: TStringList;
  sl_next_user: TStringList;

implementation

{$R *.dfm}

procedure TForm_Approve_Vacation.Button_ConfirmClick(Sender: TObject);
var
  fap_id, curr_node, prev_node, next_node, first_node, prev_user: string;
begin
  {ȡ���ڴ�������������ˮ�Ŷ�Ӧ�����������ӱ��������ӱ���ˮ�ţ�}
  DataModule_sjhf.ADOQuery_SjhfDb.Close;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT NVL(MAX(F.FAP_ID),''0'') AS FAP_ID FROM BHGMS_F_APPROVE_PROCESS F WHERE F.FA_ID=''' + Label_FaId.Caption + '''';
  DataModule_sjhf.ADOQuery_SjhfDb.Open;

  {���ֱ���ˮ�ż�һ������ǰ���̵���ˮ�ţ���δ��ѯ����ˮ�ţ����������δ����������������ǰ���̵���ˮ��Ϊ1��}
  if DataModule_sjhf.ADOQuery_SjhfDb.RecordCount = 0 then
    fap_id := '1'
  else
    fap_id := IntToStr(StrToInt(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAP_ID').AsString) + 1);

  {ȡ�������鷢��ڵ�}
  DataModule_sjhf.ADOQuery_SjhfDb.Close;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT F1.FAP_NODE_NOW FROM BHGMS_F_APPROVE_PROCESS F1 WHERE F1.FAP_ID=(SELECT MIN(F2.FAP_ID) FROM BHGMS_F_APPROVE_PROCESS F2 WHERE F2.FA_ID=''' + Label_FaId.Caption + ''') AND F1.FA_ID=''' + Label_FaId.Caption + ''' UNION ALL SELECT F1.FA_CURRENTNODE FROM BHGMS_F_APPROVE F1 ';
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('WHERE NOT EXISTS (SELECT 1 FROM BHGMS_F_APPROVE_PROCESS F2 WHERE F2.FA_ID=F1.FA_ID) AND F1.FA_ID=''' + Label_FaId.Caption + '''');
  DataModule_sjhf.ADOQuery_SjhfDb.Open;
  first_node := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAP_NODE_NOW').AsString;

  if ComboBox_NextControl.ItemIndex = -1 then
    ShowMessage('δѡ����һ��������')
  else
    if ((ComboBox_NextControl.Text = '�˻�����һ��λ') or (ComboBox_NextControl.Text = '�˻��������λ') or (ComboBox_NextControl.Text = '����ͨ��') or (JvComboBox_VacationType.Text = '9|�������')) and (Memo_ApproveComment.Text = '') then
      ShowMessage('�����������Ϊ�գ�')
    else
      if ComboBox_NextControl.Text = '��������һ��λ' then
        begin
          try
            DataModule_sjhf.ADOQuery_SjhfDb.Close;
            DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
            DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT D1.DAN_PREVNODE,D1.DAN_CURRNODE FROM BHGMS_F_APPROVE F1,BHGMS_D_APPROVE_NODE D2,BHGMS_D_APPROVE_PROCESS D1 WHERE F1.FA_CURRENTNODE=D1.DAN_PREVNODE AND F1.FA_TYPE=D1.DAT_ID AND D1.DAN_CURRNODE=D2.NODE_ID AND F1.FA_ID=''' + Label_FaId.Caption + '''  AND D1.DAN_FIRSTNODE LIKE ''%''||''' + first_node + '''||''%'' AND D2.NODE_STATUS=''1''';
            DataModule_sjhf.ADOQuery_SjhfDb.Open;
            curr_node := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DAN_PREVNODE').AsString;
            next_node := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DAN_CURRNODE').AsString;

            DataModule_sjhf.ADOQuery_SjhfDb.Close;
            DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
            DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
            DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'INSERT INTO BHGMS_F_APPROVE_PROCESS VALUES (''' + fap_id + ''',''' + Label_FaId.Caption + ''',''' + curr_node + ''',''' + Form_Session.Edit_BtofId.Text + ''',''' + next_node + ''',''' + LeftStr(JvComboBox_NextUser.Text, 6) + ''',''0'',''' + StringReplace(Memo_ApproveComment.Text, '''', '''''', [rfReplaceAll]) + '''';
            DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(',TO_DATE(TO_CHAR(SYSDATE,''YYYY-MM-DD''),''YYYY-MM-DD''),SYSDATE,SYSDATE)');
            DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
            DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
            DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'UPDATE BHGMS_F_APPROVE F SET F.FA_CURRENTUSER=''' + LeftStr(JvComboBox_NextUser.Text, 6) + ''',F.FA_CURRENTNODE=''' + next_node + ''',F.FA_LASTUSER=''' + Form_Session.Edit_BtofId.Text + ''',F.FA_STATUS=''1'',F.ALTER_TIME=SYSDATE WHERE F.FA_ID=''' + Label_FaId.Caption + '''';
            DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
            DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
            ShowMessage('���ͳɹ���');
            Button_Save.Enabled := False;
            Button_Delete.Enabled := False;
            Button_Confirm.Enabled := False;
          except
            on e: EOleException do
              begin
                ShowMessage('����ʧ�ܣ�');
                DataModule_sjhf.ADOConnection_SjhfDb.RollbackTrans;
              end;
          end;
        end
      else
        if ComboBox_NextControl.Text = '�˻�����һ��λ' then
          begin
            try
              DataModule_sjhf.ADOQuery_SjhfDb.Close;
              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT F.FA_CURRENTNODE,F1.FAP_USER_NOW,F1.FAP_NODE_NOW FROM BHGMS_F_APPROVE_PROCESS F1,BHGMS_F_APPROVE F WHERE F1.FA_ID=F.FA_ID AND F1.FAP_ID=(SELECT MAX(F2.FAP_ID) FROM BHGMS_F_APPROVE_PROCESS F2 WHERE F2.FA_ID=''' + Label_FaId.Caption + ''' AND F2.FAP_USER_NEXT=''' + Form_Session.Edit_BtofId.Text + ''') AND F1.FA_ID=''' + Label_FaId.Caption + '''';
              DataModule_sjhf.ADOQuery_SjhfDb.Open;
              curr_node := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FA_CURRENTNODE').AsString;
              prev_node := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAP_NODE_NOW').AsString;
              prev_user := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAP_USER_NOW').AsString;

              DataModule_sjhf.ADOQuery_SjhfDb.Close;
              DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'INSERT INTO BHGMS_F_APPROVE_PROCESS VALUES (''' + fap_id + ''',''' + Label_FaId.Caption + ''',''' + curr_node + ''',''' + Form_Session.Edit_BtofId.Text + ''',''' + prev_node + ''',''' + prev_user + ''',''2'',''' + StringReplace(Memo_ApproveComment.Text, '''', '''''', [rfReplaceAll]) + '''';
              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(',TO_DATE(TO_CHAR(SYSDATE,''YYYY-MM-DD''),''YYYY-MM-DD''),SYSDATE,SYSDATE)');
              DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'UPDATE BHGMS_F_APPROVE F SET F.FA_CURRENTUSER=''' + prev_user + ''',F.FA_CURRENTNODE=''' + prev_node + ''',F.FA_LASTUSER=''' + Form_Session.Edit_BtofId.Text + ''',F.ALTER_TIME=SYSDATE WHERE F.FA_ID=''' + Label_FaId.Caption + '''';
              DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
              DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
              ShowMessage('�ѳɹ��˻�����һ��λ��Ա��');
              Button_Save.Enabled := False;
              Button_Delete.Enabled := False;
              Button_Confirm.Enabled := False;
            except
              on e: EOleException do
                begin
                  ShowMessage('����ʧ�ܣ�');
                  DataModule_sjhf.ADOConnection_SjhfDb.RollbackTrans;
                end;
            end;
          end
        else
          if ComboBox_NextControl.Text = '�˻��������λ' then
            begin
              try
                DataModule_sjhf.ADOQuery_SjhfDb.Close;
                DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT F.FA_CURRENTNODE,F1.FAP_USER_NOW,F1.FAP_NODE_NOW FROM BHGMS_F_APPROVE_PROCESS F1,BHGMS_F_APPROVE F WHERE F1.FA_ID=F.FA_ID AND F1.FAP_ID=(SELECT MIN(F2.FAP_ID) FROM BHGMS_F_APPROVE_PROCESS F2 WHERE F2.FA_ID=''' + Label_FaId.Caption + ''') AND F1.FA_ID=''' + Label_FaId.Caption + '''';
                DataModule_sjhf.ADOQuery_SjhfDb.Open;
                curr_node := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FA_CURRENTNODE').AsString;
                prev_node := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAP_NODE_NOW').AsString;
                prev_user := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAP_USER_NOW').AsString;

                DataModule_sjhf.ADOQuery_SjhfDb.Close;
                DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
                DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'INSERT INTO BHGMS_F_APPROVE_PROCESS VALUES (''' + fap_id + ''',''' + Label_FaId.Caption + ''',''' + curr_node + ''',''' + Form_Session.Edit_BtofId.Text + ''',''' + prev_node + ''',''' + prev_user + ''',''3'',''' + StringReplace(Memo_ApproveComment.Text, '''', '''''', [rfReplaceAll]) + '''';
                DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(',TO_DATE(TO_CHAR(SYSDATE,''YYYY-MM-DD''),''YYYY-MM-DD''),SYSDATE,SYSDATE)');
                DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'UPDATE BHGMS_F_APPROVE F SET F.FA_CURRENTUSER=''' + prev_user + ''',F.FA_CURRENTNODE=''' + prev_node + ''',F.FA_LASTUSER=''' + Form_Session.Edit_BtofId.Text + ''',F.FA_STATUS=''4'',F.ALTER_TIME=SYSDATE WHERE F.FA_ID=''' + Label_FaId.Caption + '''';
                DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
                ShowMessage('�ѳɹ��˻��������λ��Ա��');
                Button_Save.Enabled := False;
                Button_Delete.Enabled := False;
                Button_Confirm.Enabled := False;
              except
                on e: EOleException do
                  begin
                    ShowMessage('����ʧ�ܣ�');
                    DataModule_sjhf.ADOConnection_SjhfDb.RollbackTrans;
                  end;
              end;
            end
          else
            if ComboBox_NextControl.Text = '����ͨ��' then
              begin
                try
                  DataModule_sjhf.ADOQuery_SjhfDb.Close;
                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT F1.FA_CURRENTNODE FROM BHGMS_F_APPROVE F1 WHERE F1.FA_ID=''' + Label_FaId.Caption + '''';
                  DataModule_sjhf.ADOQuery_SjhfDb.Open;
                  curr_node := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FA_CURRENTNODE').AsString;

                  DataModule_sjhf.ADOQuery_SjhfDb.Close;
                  DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'INSERT INTO BHGMS_F_APPROVE_PROCESS VALUES (''' + fap_id + ''',''' + Label_FaId.Caption + ''',''' + curr_node + ''',''' + Form_Session.Edit_BtofId.Text + ''','''','''',''1'',';
                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('''' + StringReplace(Memo_ApproveComment.Text, '''', '''''', [rfReplaceAll]) + ''',TO_DATE(TO_CHAR(SYSDATE,''YYYY-MM-DD''),''YYYY-MM-DD''),SYSDATE,SYSDATE)');
                  DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'UPDATE BHGMS_F_APPROVE F SET F.FA_CURRENTUSER=''' + Form_Session.Edit_BtofId.Text + ''',F.FA_CURRENTNODE=''' + curr_node + ''',F.FA_LASTUSER=''' + Form_Session.Edit_BtofId.Text + ''',F.FA_FINALDATE=TO_DATE(TO_CHAR(SYSDATE,''YYYY-MM-DD''),''YYYY-MM-DD''),F.FA_STATUS=''3'',F.ALTER_TIME=SYSDATE WHERE F.FA_ID=''' + Label_FaId.Caption + '''';
                  DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                  DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
                  ShowMessage('������ͨ����');
                  Button_Save.Enabled := False;
                  Button_Delete.Enabled := False;
                  Button_Confirm.Enabled := False;
                except
                  on e: EOleException do
                    begin
                      ShowMessage('����ʧ�ܣ�');
                      DataModule_sjhf.ADOConnection_SjhfDb.RollbackTrans;
                    end;
                end;
              end
            else
              if ComboBox_NextControl.Text = '����ͨ��' then
                begin
                  try
                    DataModule_sjhf.ADOQuery_SjhfDb.Close;
                    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT F.FA_CURRENTNODE,F1.FAP_USER_NOW,F1.FAP_NODE_NOW FROM BHGMS_F_APPROVE_PROCESS F1,BHGMS_F_APPROVE F WHERE F1.FA_ID=F.FA_ID AND F1.FAP_ID=(SELECT MIN(F2.FAP_ID) FROM BHGMS_F_APPROVE_PROCESS F2 WHERE F2.FA_ID=''' + Label_FaId.Caption + ''') AND F1.FA_ID=''' + Label_FaId.Caption + '''';
                    DataModule_sjhf.ADOQuery_SjhfDb.Open;
                    curr_node := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FA_CURRENTNODE').AsString;
                    prev_node := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAP_NODE_NOW').AsString;
                    prev_user := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAP_USER_NOW').AsString;

                    DataModule_sjhf.ADOQuery_SjhfDb.Close;
                    DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
                    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'INSERT INTO BHGMS_F_APPROVE_PROCESS VALUES (''' + fap_id + ''',''' + Label_FaId.Caption + ''',''' + curr_node + ''',''' + Form_Session.Edit_BtofId.Text + ''',''' + prev_node + ''',''' + prev_user + ''',''4'',';
                    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('''' + StringReplace(Memo_ApproveComment.Text, '''', '''''', [rfReplaceAll]) + ''',TO_DATE(TO_CHAR(SYSDATE,''YYYY-MM-DD''),''YYYY-MM-DD''),SYSDATE,SYSDATE)');
                    DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'UPDATE BHGMS_F_APPROVE F SET F.FA_CURRENTUSER=''' + prev_user + ''',F.FA_CURRENTNODE=''' + prev_node + ''',F.FA_LASTUSER=''' + Form_Session.Edit_BtofId.Text + ''',F.FA_FINALDATE=TO_DATE(TO_CHAR(SYSDATE,''YYYY-MM-DD''),''YYYY-MM-DD''),F.FA_STATUS=''5'',F.ALTER_TIME=SYSDATE WHERE F.FA_ID=''' + Label_FaId.Caption + '''';
                    DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                    DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
                    ShowMessage('����δͨ����');
                    Button_Save.Enabled := False;
                    Button_Delete.Enabled := False;
                    Button_Confirm.Enabled := False;
                  except
                    on e: EOleException do
                      begin
                        ShowMessage('����ʧ�ܣ�');
                        DataModule_sjhf.ADOConnection_SjhfDb.RollbackTrans;
                      end;
                  end;
                end;
end;

procedure TForm_Approve_Vacation.Button_DeleteClick(Sender: TObject);
begin
  DataModule_sjhf.ADOQuery_SjhfDb.Close;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B1.DAN_PREVNODE FROM BHGMS_F_APPROVE B2,BHGMS_D_APPROVE_PROCESS B1 WHERE B1.DAN_CURRNODE=B2.FA_CURRENTNODE AND B1.DAT_ID=B1.DAT_ID AND B2.FA_ID=''' + Label_FaId.Caption + ''' AND B1.DAP_STATUS=''1''';
  DataModule_sjhf.ADOQuery_SjhfDb.Open;

  if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DAN_PREVNODE').AsString <> '' then
    ShowMessage('ֻ�������λ����ɾ�����飡')
  else
    begin
      try
        DataModule_sjhf.ADOQuery_SjhfDb.Close;
        DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
        DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
        DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'UPDATE BHGMS_F_APPROVE SET FA_STATUS=''2'' WHERE FA_ID=''' + Label_FaId.Caption + '''';
        DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
        DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
        ShowMessage('ɾ���ɹ���');
        GroupBox_Vacation.Enabled := False;
        GroupBox_Approve.Enabled := False;
      except
        on e: EOleException do
          begin
            ShowMessage('ɾ��ʧ�ܣ�');
            DataModule_sjhf.ADOConnection_SjhfDb.RollbackTrans;
          end;
      end;
    end;
end;

procedure TForm_Approve_Vacation.Button_SaveClick(Sender: TObject);
var
  date, date_chn, time: TFormatSettings;
  fa_id, curr_node, dup_str: string;
  gap, annual_days, ad_applied, i: Integer;
begin
  date.ShortDateFormat := 'yyyymmdd';
  time.LongTimeFormat := 'hhnn';

  {����������١�ѡ�У���ȡ������ٲ���Ա��ţ�����Ϊ�գ�
  ��ѡ���˴�����٣����ظ����У�顢�ڵ㼰������̾����������˲���Ա��Ź�����}
  {if RadioButton_BySelf.Checked = True then
    begin
      fa_issuer_id := Form_Session.Edit_BtofId.Text;
      fa_issuer_infact := '';
      fa_issuer_name := Form_Session.Edit_BtofName.Text;
    end
  else
    if RadioButton_Instead.Checked = True then
      begin
        fa_issuer_id := LeftStr(JvComboBox_IssuerInFact.Text, 6);
        fa_issuer_infact := LeftStr(JvComboBox_IssuerInFact.Text, 6);
        fa_issuer_name := RightStr(JvComboBox_IssuerInFact.Text, Length(JvComboBox_IssuerInFact.Text) - 7);
      end;}

  if (RadioButton_Instead.Checked = True) and (JvComboBox_IssuerInFact.Text = '') then
    ShowMessage('δѡ��ʵ������ˣ�')
  else
    if ((RadioButton_ByTime.Checked = True) and (DateTimePicker_TBeginTime.Time >= DateTimePicker_TEndTime.Time)) or ((RadioButton_ByDate.Checked = True) and (DateTimePicker_DBeginDate.Date > DateTimePicker_DEndDate.Date)) then
      ShowMessage('������ʼ����/ʱ�䲻�ܴ��ڵ��ڽ�������/ʱ�䣡')
    else
      if JvComboBox_VacationType.Text = '' then
        Label_VacationTypeErr.Caption := '������Ͳ���Ϊ�գ�'
      else
        if ((JvComboBox_VacationType.Text = '8|����') or (JvComboBox_VacationType.Text = '9|�������')) and (Memo_FavsDescription.Text = '') then
          Label_VacationTypeErr.Caption := '���˵������Ϊ�գ�'
        else
	        begin
            Label_VacationTypeErr.Caption := '';
            if Label_FaId.Caption = '' then
              begin
                if RadioButton_ByTime.Checked = True then
                  begin
                    DataModule_sjhf.ADOQuery_SjhfDb.Close;
                    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT ISWORKDATE FROM C_HOLIDAY WHERE CH_DATE=TO_DATE(''' + DateToStr(DateTimePicker_TIssueDate.Date, date) + ''',''YYYYMMDD'')';
                    DataModule_sjhf.ADOQuery_SjhfDb.Open;
                    if DataModule_sjhf.ADOQuery_SjhfDb.RecordCount = 0 then
                      ShowMessage('������δά����')
                    else
                      if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('ISWORKDATE').AsString = '0' then
                        ShowMessage('������ڷǹ����գ�')
                      else
                        begin
                          {ȡ������������ڼ�ʱ�䣬�����뱾������������ڼ�ʱ����бȶ�}
                          DataModule_sjhf.ADOQuery_SjhfDb.Close;
                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT F2.FAVS_TIME_TYPE,F2.FAVS_ISSUEDATE,F2.FAVS_ENDDATE,F2.FAVS_BEGINTIME,F2.FAVS_ENDTIME,D.DVT_NAME FROM BHGMS_F_APPROVE_VACATION_SUB F2,BHGMS_F_APPROVE F1,BHGMS_D_VACATION_TYPE D WHERE F1.FA_ID=F2.FA_ID AND F2.FAVS_TYPE=D.DVT_ID AND ((';
                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('F2.FAVS_TIME_TYPE=''2'' AND TO_DATE(''' + DateToStr(DateTimePicker_TIssueDate.Date, date) + ''',''YYYYMMDD'')>=F2.FAVS_ISSUEDATE AND TO_DATE(''' + DateToStr(DateTimePicker_TIssueDate.Date, date) + ''',''YYYYMMDD'')<=F2.FAVS_ENDDATE) OR (F2.FAVS_TIME_TYPE=''1'' AND TO_DATE(''' + DateToStr(DateTimePicker_TIssueDate.Date, date) + ''',''YYYYMMDD'')=F2.FAVS_ISSUEDATE AND ((TO_DATE(''' + TimeToStr(DateTimePicker_TBeginTime.Time, time) + ''',''HH24MI'')>=TO_DATE(F2.FAVS_BEGINTIME,''HH24MI'') AND TO_DATE(''' + TimeToStr(DateTimePicker_TBeginTime.Time, time) + ''',''HH24MI'')');
                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('<=TO_DATE(F2.FAVS_ENDTIME,''HH24MI'')) OR (TO_DATE(''' + TimeToStr(DateTimePicker_TEndTime.Time, time) + ''',''HH24MI'')>=TO_DATE(F2.FAVS_BEGINTIME,''HH24MI'') AND TO_DATE(''' + TimeToStr(DateTimePicker_TEndTime.Time, time) + ''',''HH24MI'')<=TO_DATE(F2.FAVS_ENDTIME,''HH24MI''))))) AND F1.FA_ISSUER=''' + Form_Session.Edit_BtofId.Text + ''' AND F1.FA_STATUS IN (''0'',''1'',''3'',''4'') AND F2.FAVS_TYPE<>''9''');
                          DataModule_sjhf.ADOQuery_SjhfDb.Open;

                          {�������ظ���¼������ʾ�ظ�����ļ�¼���ݣ����������һ������}
                          if DataModule_sjhf.ADOQuery_SjhfDb.RecordCount > 0 then
                            begin
                              date_chn.ShortDateFormat := 'yyyy��m��d��';
                              dup_str := '';
                              DataModule_sjhf.ADOQuery_SjhfDb.First;
                              for i := 0 to DataModule_sjhf.ADOQuery_SjhfDb.RecordCount - 1 do
                                begin
                                  if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_TIME_TYPE').AsString = '1' then
                                    dup_str := dup_str + IntToStr(i + 1) + '���������Ϊ' + DateTimeToStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ISSUEDATE').AsDateTime, date_chn) + '�������ʼʱ��Ϊ' + LeftStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_BEGINTIME').AsString, 2) + 'ʱ' + RightStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_BEGINTIME').AsString, 2) + '�֣�����ʱ��Ϊ' + LeftStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ENDTIME').AsString, 2) + 'ʱ' + RightStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ENDTIME').AsString, 2) + '�֣��������Ϊ' + DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DVT_NAME').AsString + '��' + #13#10
                                  else
                                    dup_str := dup_str + IntToStr(i + 1) + '�������ʼ����Ϊ' + DateTimeToStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ISSUEDATE').AsDateTime, date_chn) + '����������Ϊ' + DateTimeToStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ENDDATE').AsDateTime, date_chn) + '���������Ϊ' + DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DVT_NAME').AsString + '��' + #13#10;
                                  DataModule_sjhf.ADOQuery_SjhfDb.Next;
                                end;
                              ShowMessage('���������ʱ������������ɻ��������������ظ���' + #13#10 + dup_str);
                            end
                          else
                            begin
                              {��������FA_IDȡ�µ�����������ˮ��}
                              DataModule_sjhf.ADOQuery_SjhfDb.Close;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT FA_ID.NEXTVAL AS FA_ID_SQL FROM DUAL';
                              DataModule_sjhf.ADOQuery_SjhfDb.Open;
                              fa_id := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FA_ID_SQL').AsString;

                              {���ݷ����˵Ŀ���������λ��󶨸�λ�����ȡ����ڵ���룻}
                              DataModule_sjhf.ADOQuery_SjhfDb.Close;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT D.DAT_ID,D.DAN_CURRNODE FROM BHGMS_U_OFFICER B,BHGMS_R_NODE_JOB R,BHGMS_D_APPROVE_PROCESS D WHERE B.JOB_ID=R.RNJ_JOBID AND R.RNJ_NODEID=D.DAN_CURRNODE AND B.BTOF_ISUNI=''0'' AND R.RNJ_STATUS=''1'' ';
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('AND D.DAP_STATUS=''1'' AND R.RNJ_TYPE=''1'' AND D.DAN_PREVNODE IS NULL AND B.BTOF_ID=''' + Form_Session.Edit_BtofId.Text + ''' UNION ALL SELECT D.DAT_ID, D.DAN_CURRNODE FROM BHGMS_U_OFFICER B,BHGMS_R_NODE_JOB R,BHGMS_D_APPROVE_PROCESS D WHERE B.BTOF_ID=R.RNJ_BTOFID AND ');
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('R.RNJ_NODEID=D.DAN_CURRNODE AND B.BTOF_ISUNI=''1'' AND R.RNJ_STATUS=''1'' AND D.DAP_STATUS=''1'' AND R.RNJ_TYPE=''2'' AND D.DAN_PREVNODE IS NULL AND B.BTOF_ID=''' + Form_Session.Edit_BtofId.Text + '''');
                              DataModule_sjhf.ADOQuery_SjhfDb.Open;
                              curr_node := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DAN_CURRNODE').AsString;

                              {ִ�в���������ֱ��������BHGMS_F_APPROVE���ӱ�BHGMS_F_APPROVE_VACATION_SUB����������ʱΪ��}
                              DataModule_sjhf.ADOQuery_SjhfDb.Close;
                              DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'INSERT INTO BHGMS_F_APPROVE(FA_ID,FA_NAME,FA_TYPE,FA_ISSUER,FA_ISSUER_INFACT,FA_CURRENTUSER,FA_CURRENTNODE,FA_LASTUSER,FA_ISSUEDATE,FA_STATUS,INSERT_TIME,ALTER_TIME) VALUES (''' + fa_id + ''',''' + Form_Session.Edit_BtofName.Text + '''||''' + LeftStr(DateToStr(DateTimePicker_TIssueDate.Date, date), 4) + '''||''��''||''' + Copy(DateToStr(DateTimePicker_TIssueDate.Date, date), 5, 2) + '''||''��''||''' + RightStr(DateToStr(DateTimePicker_TIssueDate.Date, date), 2) + '''||''���������'',';
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('''1'',''' + Form_Session.Edit_BtofId.Text + ''','''',''' + Form_Session.Edit_BtofId.Text + ''',''' + curr_node + ''',''' + Form_Session.Edit_BtofId.Text + ''',TO_DATE(''' + DateToStr(Now, date) + ''',''YYYYMMDD''),''0'',SYSDATE,SYSDATE)');
                              DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'INSERT INTO BHGMS_F_APPROVE_VACATION_SUB(FA_ID,FAVS_TIME_TYPE,FAVS_DESCRIPTION,FAVS_ISSUEDATE,FAVS_BEGINTIME,FAVS_ENDTIME,FAVS_VACATION_HOUR,FAVS_VACATION_MIN,FAVS_TYPE,FAVS_ORIGIN,INSERT_TIME,ALTER_TIME)';
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('VALUES (''' + fa_id + ''',''1'',''' + StringReplace(Memo_FavsDescription.Text, '''', '''''', [rfReplaceAll]) + ''',TO_DATE(''' + DateToStr(DateTimePicker_TIssueDate.Date, date) + ''',''YYYYMMDD''),''' + TimeToStr(DateTimePicker_TBeginTime.Time, time) + ''',''' + TimeToStr(DateTimePicker_TEndTime.Time, time) + ''',');
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('PACKAGE_BHGMS_TRANSACTION.GENERATE_HOUR_GAP(''' + TimeToStr(DateTimePicker_TBeginTime.Time, time) + ''',''' + TimeToStr(DateTimePicker_TEndTime.Time, time) + '''),PACKAGE_BHGMS_TRANSACTION.GENERATE_MIN_GAP(''' + TimeToStr(DateTimePicker_TBeginTime.Time, time) + ''',''' + TimeToStr(DateTimePicker_TEndTime.Time, time) + '''),''' + LeftStr(JvComboBox_VacationType.Text, 1) + ''',''2'',SYSDATE,SYSDATE)');
                              DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                              DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
                              ShowMessage('����ɹ���');
                              Label_FaId.Caption := fa_id;
                              Button_Delete.Enabled := True;
                              Button_Confirm.Enabled := True;
                              SetNext('1');
                            end;
                        end
                  end
                else
                  if RadioButton_ByDate.Checked = True then
                    begin
                      DataModule_sjhf.ADOQuery_SjhfDb.Close;
                      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT PACKAGE_BHGMS_TRANSACTION.GENERATE_HOUR_GAP_IN_DATE (TO_DATE (''' + DateToStr(DateTimePicker_DBeginDate.Date, date) + ''',''YYYYMMDD''), TO_DATE(''' + DateToStr(DateTimePicker_DEndDate.Date, date) + ''',''YYYYMMDD'')) AS GAP FROM DUAL';
                      DataModule_sjhf.ADOQuery_SjhfDb.Open;
                      gap := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('GAP').AsInteger;
                      if gap = 0 then
                        ShowMessage('�������Ϊ���죡')
                      else
                        begin
                          {ͨ������Ա���ȡ�ò���Ա�����������ݼٵ�������}
                          DataModule_sjhf.ADOQuery_SjhfDb.Close;
                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT D.DAV_DAYS FROM BHGMS_D_ANNUAL_VACATION D,BHGMS_U_OFFICER U WHERE U.BTOF_YEARS>=D.DAV_YEARS_MIN AND U.BTOF_YEARS<=D.DAV_YEARS_MAX AND U.BTOF_ID=''' + Form_Session.Edit_BtofId.Text + ''' AND D.DAV_STATUS=''1''';
                          DataModule_sjhf.ADOQuery_SjhfDb.Open;
                          annual_days := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DAV_DAYS').AsInteger;

                          {��������������ݼ�����������������������ֱ�ӵ���������ʾ��
                          ����ȡʣ�������������������������ʣ��������������бȽ�}
                          if (JvComboBox_VacationType.Text = '4|���ݼ�') and (gap > annual_days * 8) then
                            ShowMessage('��������������ݼ��������ܳ���' + IntToStr(annual_days) + '�졣')
                          else
                            begin
                              {ȡʣ����������ݼ�����}
                              DataModule_sjhf.ADOQuery_SjhfDb.Close;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT NVL(SUM(F2.FAVS_VACATION_HOUR)/8,0) AS DAYS FROM BHGMS_F_APPROVE_VACATION_SUB F2,BHGMS_F_APPROVE F1 WHERE F1.FA_ID=F2.FA_ID AND F1.FA_ISSUER=''' + Form_Session.Edit_BtofId.Text + ''' AND F1.FA_STATUS IN (''0'',''1'',''3'',''4'') AND F2.FAVS_TYPE=''4''';
                              DataModule_sjhf.ADOQuery_SjhfDb.Open;
                              ad_applied := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DAYS').AsInteger;

                              {��ʣ����������ݼ������뱾����������֮�ʹ��ڿ������������򵯳�������ʾ�������������}
                              if (JvComboBox_VacationType.Text = '4|���ݼ�') and (gap + ad_applied * 8 > annual_days * 8) then
                                ShowMessage('������ɻ�������������ݼ�����Ϊ' + IntToStr(ad_applied) + '�죬���������������ܳ���' + IntToStr(annual_days - ad_applied) + '�졣')
                              else
                                begin
                                  {ȡ������������ڼ�ʱ�䣬�����뱾������������ڼ�ʱ����бȶ�}
                                  DataModule_sjhf.ADOQuery_SjhfDb.Close;
                                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT F2.FAVS_TIME_TYPE,F2.FAVS_ISSUEDATE,F2.FAVS_ENDDATE,F2.FAVS_BEGINTIME,F2.FAVS_ENDTIME,D.DVT_NAME FROM BHGMS_F_APPROVE_VACATION_SUB F2,BHGMS_F_APPROVE F1,BHGMS_D_VACATION_TYPE D WHERE F1.FA_ID=F2.FA_ID';
                                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(' AND F2.FAVS_TYPE=D.DVT_ID AND ((F2.FAVS_TIME_TYPE=''2'' AND ((TO_DATE(''' + DateToStr(DateTimePicker_DBeginDate.Date, date) + ''',''YYYYMMDD'')>=F2.FAVS_ISSUEDATE AND TO_DATE(''' + DateToStr(DateTimePicker_DBeginDate.Date, date) + ''',''YYYYMMDD'')<=F2.FAVS_ENDDATE) OR (TO_DATE(''' + DateToStr(DateTimePicker_DEndDate.Date, date) + ''',''YYYYMMDD'')>=F2.FAVS_ISSUEDATE AND TO_DATE(''' + DateToStr(DateTimePicker_DEndDate.Date, date) + ''',''YYYYMMDD'')<=F2.FAVS_ENDDATE');
                                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('))) OR (F2.FAVS_TIME_TYPE=''1'' AND F2.FAVS_ISSUEDATE BETWEEN TO_DATE(''' + DateToStr(DateTimePicker_DBeginDate.Date, date) + ''',''YYYYMMDD'') AND TO_DATE(''' + DateToStr(DateTimePicker_DEndDate.Date, date) + ''',''YYYYMMDD''))) AND F1.FA_ISSUER=''' + Form_Session.Edit_BtofId.Text + ''' AND F1.FA_STATUS IN (''0'',''1'',''3'',''4'')');
                                  DataModule_sjhf.ADOQuery_SjhfDb.Open;

                                  if DataModule_sjhf.ADOQuery_SjhfDb.RecordCount > 0 then
                                    begin
                                      date_chn.ShortDateFormat := 'yyyy��m��d��';
                                      dup_str := '';
                                      DataModule_sjhf.ADOQuery_SjhfDb.First;
                                      for i := 0 to DataModule_sjhf.ADOQuery_SjhfDb.RecordCount - 1 do
                                        begin
                                          if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_TIME_TYPE').AsString = '1' then
                                            dup_str := dup_str + IntToStr(i + 1) + '���������Ϊ' + DateTimeToStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ISSUEDATE').AsDateTime, date_chn) + '�������ʼʱ��Ϊ' + LeftStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_BEGINTIME').AsString, 2) + 'ʱ' + RightStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_BEGINTIME').AsString, 2) + '�֣�����ʱ��Ϊ' + LeftStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ENDTIME').AsString, 2) + 'ʱ' + RightStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ENDTIME').AsString, 2) + '�֣��������Ϊ' + DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DVT_NAME').AsString + '��' + #13#10
                                          else
                                            dup_str := dup_str + IntToStr(i + 1) + '�������ʼ����Ϊ' + DateTimeToStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ISSUEDATE').AsDateTime, date_chn) + '����������Ϊ' + DateTimeToStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ENDDATE').AsDateTime, date_chn) + '���������Ϊ' + DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DVT_NAME').AsString + '��' + #13#10;
                                          DataModule_sjhf.ADOQuery_SjhfDb.Next;
                                        end;
                                      ShowMessage('���������ʱ������������ɻ��������������ظ���' + #13#10 + dup_str);
                                    end
                                  else
                                    begin
                                      {ȡ��ˮ�š���ǰ�ڵ㼰��������밴ʱ�����ȫ��ͬ���������ڸ�������¼��Ƿ񳬹�2�죬���벻ͬ���������}
                                      DataModule_sjhf.ADOQuery_SjhfDb.Close;
                                      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                                      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT FA_ID.NEXTVAL AS FA_ID_SQL FROM DUAL';
                                      DataModule_sjhf.ADOQuery_SjhfDb.Open;
                                      fa_id := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FA_ID_SQL').AsString;

                                      DataModule_sjhf.ADOQuery_SjhfDb.Close;
                                      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                                      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT D.DAT_ID,D.DAN_CURRNODE FROM BHGMS_U_OFFICER B,BHGMS_R_NODE_JOB R,BHGMS_D_APPROVE_PROCESS D WHERE B.JOB_ID=R.RNJ_JOBID AND R.RNJ_NODEID=D.DAN_CURRNODE AND B.BTOF_ISUNI=''0'' AND R.RNJ_STATUS=''1'' ';
                                      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('AND D.DAP_STATUS=''1'' AND R.RNJ_TYPE=''1'' AND D.DAN_PREVNODE IS NULL AND B.BTOF_ID=''' + Form_Session.Edit_BtofId.Text + ''' UNION ALL SELECT D.DAT_ID, D.DAN_CURRNODE FROM BHGMS_U_OFFICER B,BHGMS_R_NODE_JOB R,BHGMS_D_APPROVE_PROCESS D WHERE B.BTOF_ID=R.RNJ_BTOFID AND ');
                                      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('R.RNJ_NODEID=D.DAN_CURRNODE AND B.BTOF_ISUNI=''1'' AND R.RNJ_STATUS=''1'' AND D.DAP_STATUS=''1'' AND R.RNJ_TYPE=''2'' AND D.DAN_PREVNODE IS NULL AND B.BTOF_ID=''' + Form_Session.Edit_BtofId.Text + '''');
                                      DataModule_sjhf.ADOQuery_SjhfDb.Open;
                                      curr_node := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DAN_CURRNODE').AsString;

                                        if gap <= 16 then
                                        begin
                                          DataModule_sjhf.ADOQuery_SjhfDb.Close;
                                          DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'INSERT INTO BHGMS_F_APPROVE(FA_ID,FA_NAME,FA_TYPE,FA_ISSUER,FA_ISSUER_INFACT,FA_CURRENTUSER,FA_CURRENTNODE,FA_LASTUSER,FA_ISSUEDATE,FA_STATUS,INSERT_TIME,ALTER_TIME) VALUES (''' + fa_id + ''',''' + Form_Session.Edit_BtofName.Text + '''||''' + LeftStr(DateToStr(DateTimePicker_DBeginDate.Date, date), 4) + '''||''��''||''' + Copy(DateToStr(DateTimePicker_DBeginDate.Date, date), 5, 2) + '''||''��''||''' + RightStr(DateToStr(DateTimePicker_DBeginDate.Date, date), 2) + '''||''����''||''' + LeftStr(DateToStr(DateTimePicker_DEndDate.Date, date), 4) + '''||''��''||''' + Copy(DateToStr(DateTimePicker_DEndDate.Date, date), 5, 2) + '''||''��''||''' + RightStr(DateToStr(DateTimePicker_DEndDate.Date, date), 2) + '''||''���������'',';
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('''1'',''' + Form_Session.Edit_BtofId.Text + ''','''',''' + Form_Session.Edit_BtofId.Text + ''',''' + curr_node + ''',''' + Form_Session.Edit_BtofId.Text + ''',TO_DATE(''' + DateToStr(Now, date) + ''',''YYYYMMDD''),''0'',SYSDATE,SYSDATE)');
                                          DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'INSERT INTO BHGMS_F_APPROVE_VACATION_SUB(FA_ID,FAVS_TIME_TYPE,FAVS_DESCRIPTION,FAVS_ISSUEDATE,FAVS_ENDDATE,FAVS_VACATION_HOUR,FAVS_VACATION_MIN,FAVS_TYPE,FAVS_ORIGIN,INSERT_TIME,ALTER_TIME)';
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('VALUES (''' + fa_id + ''',''2'',''' + StringReplace(Memo_FavsDescription.Text, '''', '''''', [rfReplaceAll]) + ''',TO_DATE(''' + DateToStr(DateTimePicker_DBeginDate.Date, date) + ''',''YYYYMMDD''),TO_DATE(''' + DateToStr(DateTimePicker_DEndDate.Date, date) + ''',''YYYYMMDD''),');
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('PACKAGE_BHGMS_TRANSACTION.GENERATE_HOUR_GAP_IN_DATE(TO_DATE(''' + DateToStr(DateTimePicker_DBeginDate.Date, date) + ''',''YYYYMMDD''),TO_DATE(''' + DateToStr(DateTimePicker_DEndDate.Date, date) + ''',''YYYYMMDD'')),0,'''+ LeftStr(JvComboBox_VacationType.Text, 1) + ''',''2'',SYSDATE,SYSDATE)');
                                          DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;

                                          DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
                                          ShowMessage('����ɹ���');
                                          Label_FaId.Caption := fa_id;
                                          Button_Delete.Enabled := True;
                                          Button_Confirm.Enabled := True;
                                          SetNext('1');
                                        end
                                      else
                                        begin
                                          DataModule_sjhf.ADOQuery_SjhfDb.Close;
                                          DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'INSERT INTO BHGMS_F_APPROVE(FA_ID,FA_NAME,FA_TYPE,FA_ISSUER,FA_ISSUER_INFACT,FA_CURRENTUSER,FA_CURRENTNODE,FA_LASTUSER,FA_ISSUEDATE,FA_STATUS,INSERT_TIME,ALTER_TIME) VALUES (''' + fa_id + ''',''' + Form_Session.Edit_BtofName.Text + '''||''' + LeftStr(DateToStr(DateTimePicker_DBeginDate.Date, date), 4) + '''||''��''||''' + Copy(DateToStr(DateTimePicker_DBeginDate.Date, date), 5, 2) + '''||''��''||''' + RightStr(DateToStr(DateTimePicker_DBeginDate.Date, date), 2) + '''||''����''||''' + LeftStr(DateToStr(DateTimePicker_DEndDate.Date, date), 4) + '''||''��''||''' + Copy(DateToStr(DateTimePicker_DEndDate.Date, date), 5, 2) + '''||''��''||''' + RightStr(DateToStr(DateTimePicker_DEndDate.Date, date), 2) + '''||''���������'',';
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('''3'',''' + Form_Session.Edit_BtofId.Text + ''','''',''' + Form_Session.Edit_BtofId.Text + ''',''' + curr_node + ''',''' + Form_Session.Edit_BtofId.Text + ''',TO_DATE(''' + DateToStr(Now, date) + ''',''YYYYMMDD''),''0'',SYSDATE,SYSDATE)');
                                          DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'INSERT INTO BHGMS_F_APPROVE_VACATION_SUB(FA_ID,FAVS_TIME_TYPE,FAVS_DESCRIPTION,FAVS_ISSUEDATE,FAVS_ENDDATE,FAVS_VACATION_HOUR,FAVS_VACATION_MIN,FAVS_TYPE,FAVS_ORIGIN,INSERT_TIME,ALTER_TIME)';
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('VALUES (''' + fa_id + ''',''2'',''' + StringReplace(Memo_FavsDescription.Text, '''', '''''', [rfReplaceAll]) + ''',TO_DATE(''' + DateToStr(DateTimePicker_DBeginDate.Date, date) + ''',''YYYYMMDD''),TO_DATE(''' + DateToStr(DateTimePicker_DEndDate.Date, date) + ''',''YYYYMMDD''),');
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('PACKAGE_BHGMS_TRANSACTION.GENERATE_HOUR_GAP_IN_DATE(TO_DATE(''' + DateToStr(DateTimePicker_DBeginDate.Date, date) + ''',''YYYYMMDD''),TO_DATE(''' + DateToStr(DateTimePicker_DEndDate.Date, date) + ''',''YYYYMMDD'')),0,'''+ LeftStr(JvComboBox_VacationType.Text, 1) + ''',''2'',SYSDATE,SYSDATE)');
                                          DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;

                                          DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;
                                          ShowMessage('����ɹ���');
                                          Label_FaId.Caption := fa_id;
                                          Button_Delete.Enabled := True;
                                          Button_Confirm.Enabled := True;
                                          SetNext('3');
                                        end;
                                    end;
                                end;
                            end
                        end;
                    end
              end
            else
              begin
                if RadioButton_ByTime.Checked = True then
                  begin
                    DataModule_sjhf.ADOQuery_SjhfDb.Close;
                    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                    DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT ISWORKDATE FROM C_HOLIDAY WHERE CH_DATE=TO_DATE(''' + DateToStr(DateTimePicker_TIssueDate.Date, date) + ''',''YYYYMMDD'')';
                    DataModule_sjhf.ADOQuery_SjhfDb.Open;
                    if DataModule_sjhf.ADOQuery_SjhfDb.RecordCount = 0 then
                      ShowMessage('������δά����')
                    else
                      if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('ISWORKDATE').AsString = '0' then
                        ShowMessage('������ڷǹ����գ�')
                      else
                        begin
                          {ȡ������������ڼ�ʱ�䣬�����뱾������������ڼ�ʱ����бȶԣ�
                          ȡ�������¼ʱ��Ӧ����������ټ�¼���Է�ֹ�޷����棻}
                          DataModule_sjhf.ADOQuery_SjhfDb.Close;
                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT F2.FAVS_TIME_TYPE,F2.FAVS_ISSUEDATE,F2.FAVS_ENDDATE,F2.FAVS_BEGINTIME,F2.FAVS_ENDTIME,D.DVT_NAME FROM BHGMS_F_APPROVE_VACATION_SUB F2,BHGMS_F_APPROVE F1,BHGMS_D_VACATION_TYPE D WHERE F1.FA_ID=F2.FA_ID AND F2.FAVS_TYPE=D.DVT_ID AND F1.FA_ID<>''' + Label_FaId.Caption + ''' AND ((';
                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('F2.FAVS_TIME_TYPE=''2'' AND TO_DATE(''' + DateToStr(DateTimePicker_TIssueDate.Date, date) + ''',''YYYYMMDD'')>=F2.FAVS_ISSUEDATE AND TO_DATE(''' + DateToStr(DateTimePicker_TIssueDate.Date, date) + ''',''YYYYMMDD'')<=F2.FAVS_ENDDATE) OR (F2.FAVS_TIME_TYPE=''1'' AND TO_DATE(''' + DateToStr(DateTimePicker_TIssueDate.Date, date) + ''',''YYYYMMDD'')=F2.FAVS_ISSUEDATE AND ((TO_DATE(''' + TimeToStr(DateTimePicker_TBeginTime.Time, time) + ''',''HH24MI'')>=TO_DATE(F2.FAVS_BEGINTIME,''HH24MI'') AND TO_DATE(''' + TimeToStr(DateTimePicker_TBeginTime.Time, time) + ''',''HH24MI'')');
                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('<=TO_DATE(F2.FAVS_ENDTIME,''HH24MI'')) OR (TO_DATE(''' + TimeToStr(DateTimePicker_TEndTime.Time, time) + ''',''HH24MI'')>=TO_DATE(F2.FAVS_BEGINTIME,''HH24MI'') AND TO_DATE(''' + TimeToStr(DateTimePicker_TEndTime.Time, time) + ''',''HH24MI'')<=TO_DATE(F2.FAVS_ENDTIME,''HH24MI''))))) AND F1.FA_ISSUER=''' + Form_Session.Edit_BtofId.Text + ''' AND F1.FA_STATUS IN (''0'',''1'',''3'',''4'') AND F2.FAVS_TYPE<>''9''');
                          DataModule_sjhf.ADOQuery_SjhfDb.Open;

                          {�������ظ���¼������ʾ�ظ�����ļ�¼���ݣ����������һ������}
                          if DataModule_sjhf.ADOQuery_SjhfDb.RecordCount > 0 then
                            begin
                              date_chn.ShortDateFormat := 'yyyy��m��d��';
                              dup_str := '';
                              DataModule_sjhf.ADOQuery_SjhfDb.First;
                              for i := 0 to DataModule_sjhf.ADOQuery_SjhfDb.RecordCount - 1 do
                                begin
                                  if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_TIME_TYPE').AsString = '1' then
                                    dup_str := dup_str + IntToStr(i + 1) + '���������Ϊ' + DateTimeToStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ISSUEDATE').AsDateTime, date_chn) + '�������ʼʱ��Ϊ' + LeftStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_BEGINTIME').AsString, 2) + 'ʱ' + RightStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_BEGINTIME').AsString, 2) + '�֣�����ʱ��Ϊ' + LeftStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ENDTIME').AsString, 2) + 'ʱ' + RightStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ENDTIME').AsString, 2) + '�֣��������Ϊ' + DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DVT_NAME').AsString + '��' + #13#10
                                  else
                                    dup_str := dup_str + IntToStr(i + 1) + '�������ʼ����Ϊ' + DateTimeToStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ISSUEDATE').AsDateTime, date_chn) + '����������Ϊ' + DateTimeToStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ENDDATE').AsDateTime, date_chn) + '���������Ϊ' + DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DVT_NAME').AsString + '��' + #13#10;
                                  DataModule_sjhf.ADOQuery_SjhfDb.Next;
                                end;
                              ShowMessage('���������ʱ������������ɻ��������������ظ���' + #13#10 + dup_str);
                            end
                          else
                            begin
                              {���²���ʱ����ǰ�ڵ㼴Ϊ�ѱ�������ĵ�ǰ�ڵ�}
                              DataModule_sjhf.ADOQuery_SjhfDb.Close;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B2.FA_CURRENTNODE FROM BHGMS_F_APPROVE B2 WHERE B2.FA_ID=''' + Label_FaId.Caption + '''';
                              DataModule_sjhf.ADOQuery_SjhfDb.Open;
                              curr_node := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FA_CURRENTNODE').AsString;

                              DataModule_sjhf.ADOQuery_SjhfDb.Close;
                              DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'UPDATE BHGMS_F_APPROVE F1 SET F1.FA_NAME=''' + Form_Session.Edit_BtofName.Text + '''||''' + LeftStr(DateToStr(DateTimePicker_TIssueDate.Date, date), 4) + '''||''��''||''' + Copy(DateToStr(DateTimePicker_TIssueDate.Date, date), 5, 2) + '''||''��''||''' + RightStr(DateToStr(DateTimePicker_TIssueDate.Date, date), 2) + '''||''���������'',F1.FA_ISSUER_INFACT='''',F1.FA_TYPE=''1'',F1.ALTER_TIME=SYSDATE WHERE F1.FA_ID=''' + Label_FaId.Caption + '''';
                              DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'UPDATE BHGMS_F_APPROVE_VACATION_SUB F2 SET F2.FAVS_TIME_TYPE=''1'',F2.FAVS_DESCRIPTION=''' + StringReplace(Memo_FavsDescription.Text, '''', '''''', [rfReplaceAll]) + ''',F2.FAVS_ISSUEDATE=TO_DATE(''' + DateToStr(DateTimePicker_TIssueDate.Date, date) + ''',''YYYYMMDD''),F2.FAVS_ENDDATE='''',F2.FAVS_BEGINTIME=''' + TimeToStr(DateTimePicker_TBeginTime.Time, time) + ''',F2.FAVS_ENDTIME=''' + TimeToStr(DateTimePicker_TEndTime.Time, time) + ''',';
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('F2.FAVS_VACATION_HOUR=PACKAGE_BHGMS_TRANSACTION.GENERATE_HOUR_GAP(''' + TimeToStr(DateTimePicker_TBeginTime.Time, time) + ''',''' + TimeToStr(DateTimePicker_TEndTime.Time, time) + '''),F2.FAVS_VACATION_MIN=PACKAGE_BHGMS_TRANSACTION.GENERATE_MIN_GAP(''' + TimeToStr(DateTimePicker_TBeginTime.Time, time) + ''',''' + TimeToStr(DateTimePicker_TEndTime.Time, time) + '''),F2.FAVS_TYPE=''' + LeftStr(JvComboBox_VacationType.Text, 1) + ''',F2.ALTER_TIME=SYSDATE WHERE F2.FA_ID=''' + Label_FaId.Caption + '''');
                              DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                              DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;

                              ShowMessage('����ɹ���');
                              SetNext('1');
                            end;
                        end;
                  end
                else
                  if RadioButton_ByDate.Checked = True then
                    begin
                      DataModule_sjhf.ADOQuery_SjhfDb.Close;
                      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT PACKAGE_BHGMS_TRANSACTION.GENERATE_HOUR_GAP_IN_DATE (TO_DATE (''' + DateToStr(DateTimePicker_DBeginDate.Date, date) + ''',''YYYYMMDD''), TO_DATE(''' + DateToStr(DateTimePicker_DEndDate.Date, date) + ''',''YYYYMMDD'')) AS GAP FROM DUAL';
                      DataModule_sjhf.ADOQuery_SjhfDb.Open;
                      gap := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('GAP').AsInteger;
                      if gap = 0 then
                        ShowMessage('�������Ϊ���죡')
                      else
                        begin
                          {ͨ������Ա���ȡ�ò���Ա�����������ݼٵ�������}
                          DataModule_sjhf.ADOQuery_SjhfDb.Close;
                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT D.DAV_DAYS FROM BHGMS_D_ANNUAL_VACATION D,BHGMS_U_OFFICER U WHERE U.BTOF_YEARS>=D.DAV_YEARS_MIN AND U.BTOF_YEARS<=D.DAV_YEARS_MAX AND U.BTOF_ID=''' + Form_Session.Edit_BtofId.Text + ''' AND D.DAV_STATUS=''1''';
                          DataModule_sjhf.ADOQuery_SjhfDb.Open;
                          annual_days := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DAV_DAYS').AsInteger;

                          {��������������ݼ�����������������������ֱ�ӵ���������ʾ��
                          ����ȡʣ�������������������������ʣ��������������бȽ�}
                          if (JvComboBox_VacationType.Text = '4|���ݼ�') and (gap > annual_days * 8) then
                            ShowMessage('��������������ݼ��������ܳ���' + IntToStr(annual_days) + '�졣')
                          else
                            begin
                              {ȡʣ����������ݼ�����}
                              DataModule_sjhf.ADOQuery_SjhfDb.Close;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                              DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT NVL(SUM(F2.FAVS_VACATION_HOUR)/8,0) AS DAYS FROM BHGMS_F_APPROVE_VACATION_SUB F2,BHGMS_F_APPROVE F1 WHERE F1.FA_ID=F2.FA_ID AND F1.FA_ISSUER=''' + Form_Session.Edit_BtofId.Text + ''' AND F1.FA_STATUS IN (''0'',''1'',''3'',''4'') AND F2.FAVS_TYPE=''4''';
                              DataModule_sjhf.ADOQuery_SjhfDb.Open;
                              ad_applied := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DAYS').AsInteger;

                              {��ʣ����������ݼ������뱾����������֮�ʹ��ڿ������������򵯳�������ʾ�������������}
                              if (JvComboBox_VacationType.Text = '4|���ݼ�') and (gap + ad_applied * 8 > annual_days * 8) then
                                ShowMessage('������ɻ�������������ݼ�����Ϊ' + IntToStr(ad_applied) + '�죬���������������ܳ���' + IntToStr(annual_days - ad_applied) + '�졣')
                              else
                                begin
                                  {ȡ������������ڼ�ʱ�䣬�����뱾������������ڼ�ʱ����бȶԣ�
                                  ȡ�������¼ʱ��Ӧ����������ټ�¼���Է�ֹ�޷����棻}
                                  DataModule_sjhf.ADOQuery_SjhfDb.Close;
                                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT F2.FAVS_TIME_TYPE,F2.FAVS_ISSUEDATE,F2.FAVS_ENDDATE,F2.FAVS_BEGINTIME,F2.FAVS_ENDTIME,D.DVT_NAME FROM BHGMS_F_APPROVE_VACATION_SUB F2,BHGMS_F_APPROVE F1,BHGMS_D_VACATION_TYPE D WHERE F1.FA_ID=F2.FA_ID';
                                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(' AND F2.FAVS_TYPE=D.DVT_ID AND F1.FA_ID<>''' + Label_FaId.Caption + ''' AND ((F2.FAVS_TIME_TYPE=''2'' AND ((TO_DATE(''' + DateToStr(DateTimePicker_DBeginDate.Date, date) + ''',''YYYYMMDD'')>=F2.FAVS_ISSUEDATE AND TO_DATE(''' + DateToStr(DateTimePicker_DBeginDate.Date, date) + ''',''YYYYMMDD'')<=F2.FAVS_ENDDATE) OR (TO_DATE(''' + DateToStr(DateTimePicker_DEndDate.Date, date) + ''',''YYYYMMDD'')>=F2.FAVS_ISSUEDATE AND TO_DATE(''' + DateToStr(DateTimePicker_DEndDate.Date, date) + ''',''YYYYMMDD'')<=F2.FAVS_ENDDATE');
                                  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('))) OR (F2.FAVS_TIME_TYPE=''1'' AND F2.FAVS_ISSUEDATE BETWEEN TO_DATE(''' + DateToStr(DateTimePicker_DBeginDate.Date, date) + ''',''YYYYMMDD'') AND TO_DATE(''' + DateToStr(DateTimePicker_DEndDate.Date, date) + ''',''YYYYMMDD''))) AND F1.FA_ISSUER=''' + Form_Session.Edit_BtofId.Text + ''' AND F1.FA_STATUS IN (''0'',''1'',''3'',''4'')');
                                  DataModule_sjhf.ADOQuery_SjhfDb.Open;

                                  {�������ظ���¼������ʾ�ظ�����ļ�¼���ݣ����������һ������}
                                  if DataModule_sjhf.ADOQuery_SjhfDb.RecordCount > 0 then
                                    begin
                                      date_chn.ShortDateFormat := 'yyyy��m��d��';
                                      dup_str := '';
                                      DataModule_sjhf.ADOQuery_SjhfDb.First;
                                      for i := 0 to DataModule_sjhf.ADOQuery_SjhfDb.RecordCount - 1 do
                                        begin
                                          if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_TIME_TYPE').AsString = '1' then
                                            dup_str := dup_str + IntToStr(i + 1) + '���������Ϊ' + DateTimeToStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ISSUEDATE').AsDateTime, date_chn) + '�������ʼʱ��Ϊ' + LeftStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_BEGINTIME').AsString, 2) + 'ʱ' + RightStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_BEGINTIME').AsString, 2) + '�֣�����ʱ��Ϊ' + LeftStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ENDTIME').AsString, 2) + 'ʱ' + RightStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ENDTIME').AsString, 2) + '�֣��������Ϊ' + DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DVT_NAME').AsString + '��' + #13#10
                                          else
                                            dup_str := dup_str + IntToStr(i + 1) + '�������ʼ����Ϊ' + DateTimeToStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ISSUEDATE').AsDateTime, date_chn) + '����������Ϊ' + DateTimeToStr(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAVS_ENDDATE').AsDateTime, date_chn) + '���������Ϊ' + DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DVT_NAME').AsString + '��' + #13#10;
                                          DataModule_sjhf.ADOQuery_SjhfDb.Next;
                                        end;
                                      ShowMessage('���������ʱ������������ɻ��������������ظ���' + #13#10 + dup_str);
                                    end
                                  else
                                    begin
                                      DataModule_sjhf.ADOQuery_SjhfDb.Close;
                                      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                                      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B2.FA_CURRENTNODE FROM BHGMS_F_APPROVE B2 WHERE B2.FA_ID=''' + Label_FaId.Caption + '''';
                                      DataModule_sjhf.ADOQuery_SjhfDb.Open;
                                      curr_node := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FA_CURRENTNODE').AsString;

                                      if gap <= 16 then
                                        begin
                                          DataModule_sjhf.ADOQuery_SjhfDb.Close;
                                          DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'UPDATE BHGMS_F_APPROVE F1 SET F1.FA_NAME=''' + Form_Session.Edit_BtofId.Text + '''||''' + LeftStr(DateToStr(DateTimePicker_DBeginDate.Date, date), 4) + '''||''��''||''' + Copy(DateToStr(DateTimePicker_DBeginDate.Date, date), 5, 2) + '''||''��''||''' + RightStr(DateToStr(DateTimePicker_DBeginDate.Date, date), 2) + '''||''����''||''' + LeftStr(DateToStr(DatetimePicker_DEndDate.Date, date), 4) + '''||''��''||''' + Copy(DateToStr(DatetimePicker_DEndDate.Date, date), 5, 2) + '''||''��''||''' + RightStr(DateToStr(DatetimePicker_DEndDate.Date, date), 2) + '''||''���������'',F1.FA_ISSUER_INFACT='''',F1.FA_TYPE=''1'',F1.ALTER_TIME=SYSDATE WHERE F1.FA_ID=''' + Label_FaId.Caption + '''';
                                          DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'UPDATE BHGMS_F_APPROVE_VACATION_SUB F2 SET F2.FAVS_TIME_TYPE=''2'',F2.FAVS_DESCRIPTION=''' + StringReplace(Memo_FavsDescription.Text, '''', '''''', [rfReplaceAll]) + ''',F2.FAVS_ISSUEDATE=TO_DATE(''' + DateToStr(DateTimePicker_DBeginDate.Date, date) + ''',''YYYYMMDD''),F2.FAVS_ENDDATE=TO_DATE(''' + DateToStr(DateTimePicker_DEndDate.Date, date) + ''',''YYYYMMDD''),F2.FAVS_BEGINTIME='''',F2.FAVS_ENDTIME='''',';
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('F2.FAVS_VACATION_HOUR=PACKAGE_BHGMS_TRANSACTION.GENERATE_HOUR_GAP_IN_DATE(TO_DATE(''' + DateToStr(DateTimePicker_DBeginDate.Date, date) + ''',''YYYYMMDD''),TO_DATE(''' + DateToStr(DateTimePicker_DEndDate.Date, date) + ''',''YYYYMMDD'')),F2.FAVS_VACATION_MIN=0,F2.FAVS_TYPE=''' + LeftStr(JvComboBox_VacationType.Text, 1) + ''',F2.ALTER_TIME=SYSDATE WHERE F2.FA_ID=''' + Label_FaId.Caption + '''');
                                          DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                                          DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;

                                          ShowMessage('����ɹ���');
                                          SetNext('1');
                                        end
                                      else
                                        begin
                                          DataModule_sjhf.ADOQuery_SjhfDb.Close;
                                          DataModule_sjhf.ADOConnection_SjhfDb.BeginTrans;
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'UPDATE BHGMS_F_APPROVE F1 SET F1.FA_NAME=''' + Form_Session.Edit_BtofId.Text + '''||''' + LeftStr(DateToStr(DateTimePicker_DBeginDate.Date, date), 4) + '''||''��''||''' + Copy(DateToStr(DateTimePicker_DBeginDate.Date, date), 5, 2) + '''||''��''||''' + RightStr(DateToStr(DateTimePicker_DBeginDate.Date, date), 2) + '''||''����''||''' + LeftStr(DateToStr(DatetimePicker_DEndDate.Date, date), 4) + '''||''��''||''' + Copy(DateToStr(DatetimePicker_DEndDate.Date, date), 5, 2) + '''||''��''||''' + RightStr(DateToStr(DatetimePicker_DEndDate.Date, date), 2) + '''||''���������'',F1.FA_ISSUER_INFACT='''',F1.FA_TYPE=''3'',F1.ALTER_TIME=SYSDATE WHERE F1.FA_ID=''' + Label_FaId.Caption + '''';
                                          DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'UPDATE BHGMS_F_APPROVE_VACATION_SUB F2 SET F2.FAVS_TIME_TYPE=''2'',F2.FAVS_DESCRIPTION=''' + StringReplace(Memo_FavsDescription.Text, '''', '''''', [rfReplaceAll]) + ''',F2.FAVS_ISSUEDATE=TO_DATE(''' + DateToStr(DateTimePicker_DBeginDate.Date, date) + ''',''YYYYMMDD''),F2.FAVS_ENDDATE=TO_DATE(''' + DateToStr(DateTimePicker_DEndDate.Date, date) + ''',''YYYYMMDD''),F2.FAVS_BEGINTIME='''',F2.FAVS_ENDTIME='''',';
                                          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('F2.FAVS_VACATION_HOUR=PACKAGE_BHGMS_TRANSACTION.GENERATE_HOUR_GAP_IN_DATE(TO_DATE(''' + DateToStr(DateTimePicker_DBeginDate.Date, date) + ''',''YYYYMMDD''),TO_DATE(''' + DateToStr(DateTimePicker_DEndDate.Date, date) + ''',''YYYYMMDD'')),F2.FAVS_VACATION_MIN=0,F2.FAVS_TYPE=''' + LeftStr(JvComboBox_VacationType.Text, 1) + ''',F2.ALTER_TIME=SYSDATE WHERE F2.FA_ID=''' + Label_FaId.Caption + '''');
                                          DataModule_sjhf.ADOQuery_SjhfDb.ExecSQL;
                                          DataModule_sjhf.ADOConnection_SjhfDb.CommitTrans;

                                          ShowMessage('����ɹ���');
                                          SetNext('3');
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end
              end;
	        end;
end;

procedure TForm_Approve_Vacation.ComboBox_NextControlChange(Sender: TObject);
var
  first_node, first_btof_id: string;
  i: Integer;
begin
  if ComboBox_NextControl.Text <> '��������һ��λ' then
    begin
      {����һ�������ǡ���������һ��λ��������һ��λ����Ա�б���ѡ���������ѡ��}
      JvComboBox_NextUser.ItemIndex := -1;
      JvComboBox_NextUser.Enabled := False;
    end
  else
    begin
      {����һ�����ǡ���������һ��λ��������һ��λ�ǡ����ֳ�����������Ĭ�ϴ�������˰����ص����ܸ��ֳ�����ѡ��������
      ����һ��λ���ǡ����ֳ�����������Ĭ�ϴ�����һ����λ��Ա�б��еĵ�һ�������Ա�����С�ģ�}
      JvComboBox_NextUser.Enabled := True;
      JvComboBox_NextUser.Items := sl_next_user;

      {���������������ڽ���������������ȥ���������ӱ�����С��ˮ�ż�¼�еġ���ǰ�ڵ㡱������ǰ����Ա����Ϊ���鷢��ڵ㼰�������Ա��
      �����δ��ʼ�������������������ڷ����λ�����������������еķ����˼���ǰ�ڵ㼴Ϊ���鷢��ڵ㼰�������Ա��}
      DataModule_sjhf.ADOQuery_SjhfDb.Close;
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT F1.FAP_NODE_NOW,F1.FAP_USER_NOW FROM BHGMS_F_APPROVE_PROCESS F1 WHERE F1.FAP_ID=(SELECT MIN(F2.FAP_ID) FROM BHGMS_F_APPROVE_PROCESS F2 WHERE F2.FA_ID=''' + Label_FaId.Caption + ''') AND F1.FA_ID=''' + Label_FaId.Caption + ''' UNION ALL SELECT F1.FA_CURRENTNODE,FA_ISSUER FROM BHGMS_F_APPROVE F1 ';
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('WHERE NOT EXISTS (SELECT 1 FROM BHGMS_F_APPROVE_PROCESS F2 WHERE F2.FA_ID=F1.FA_ID) AND F1.FA_ID=''' + Label_FaId.Caption + '''');
      DataModule_sjhf.ADOQuery_SjhfDb.Open;
      first_node := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAP_NODE_NOW').AsString;
      first_btof_id := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAP_USER_NOW').AsString;

      {���ݷ���ڵ���뼰���鵱ǰ�ڵ㣬ȡ��һ�ڵ����}
      DataModule_sjhf.ADOQuery_SjhfDb.Close;
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT D.DAN_NEXTNODE FROM BHGMS_F_APPROVE F,BHGMS_D_APPROVE_PROCESS D WHERE D.DAT_ID=F.FA_TYPE AND D.DAN_CURRNODE=F.FA_CURRENTNODE AND F.FA_ID=''' + Label_FaId.Caption + ''' AND D.DAN_FIRSTNODE LIKE ''%''||''' + first_node + '''||''%''';
      DataModule_sjhf.ADOQuery_SjhfDb.Open;

      {�����ֳ�����������Ϊ04}
      if DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DAN_NEXTNODE').AsString <> '04' then
        JvComboBox_NextUser.ItemIndex := 0
      else
        begin
          DataModule_sjhf.ADOQuery_SjhfDb.Close;
          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
          DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B2.LEADER_BTOF_ID FROM BHGMS_D_LEADER_BTO B2,BHGMS_U_OFFICER B1 WHERE B1.BTO_ID=B2.BTO_ID AND B1.BTOF_ID=''' + first_btof_id + '''';
          DataModule_sjhf.ADOQuery_SjhfDb.Open;

          for i := 0 to JvComboBox_NextUser.Items.Count - 1 do
            if LeftStr(JvComboBox_NextUser.GetItemText(i), 6) = DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('LEADER_BTOF_ID').AsString then
              JvComboBox_NextUser.ItemIndex := i;
        end;
    end;
end;

procedure TForm_Approve_Vacation.DateTimePicker_DBeginDateKeyPress(
  Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    DateTimePicker_DEndDate.SetFocus;
end;

procedure TForm_Approve_Vacation.DateTimePicker_DEndDateKeyPress(
  Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    JvComboBox_VacationType.SetFocus;
end;

procedure TForm_Approve_Vacation.DateTimePicker_TBeginTimeKeyPress(
  Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    DateTimePicker_TEndTime.SetFocus;
end;

procedure TForm_Approve_Vacation.DateTimePicker_TEndTimeKeyPress(
  Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    JvComboBox_VacationType.SetFocus;
end;

procedure TForm_Approve_Vacation.DateTimePicker_TIssueDateKeyPress(
  Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    DateTimePicker_TBeginTime.SetFocus;
end;

procedure TForm_Approve_Vacation.FormCreate(Sender: TObject);
begin
  sl_vacation_type_time := TStringList.Create;
  sl_vacation_type_date := TStringList.Create;

  sl_vacation_type_time.Add('1|����');
  sl_vacation_type_time.Add('2|�¼�');
  sl_vacation_type_time.Add('8|����');

  sl_vacation_type_date.Add('3|̽�׼�');
  sl_vacation_type_date.Add('4|���ݼ�');
  sl_vacation_type_date.Add('5|���');
  sl_vacation_type_date.Add('6|����');
  sl_vacation_type_date.Add('7|ɥ��');
  sl_vacation_type_date.Add('8|����');
end;

procedure TForm_Approve_Vacation.RadioButton_ByDateClick(Sender: TObject);
begin
  DateTimePicker_TIssueDate.Enabled := False;
  DateTimePicker_TBeginTime.Enabled := False;
  DateTimePicker_TEndTime.Enabled := False;
  DateTimePicker_DBeginDate.Enabled := True;
  DateTimePicker_DEndDate.Enabled := True;

  JvComboBox_VacationType.Items := sl_vacation_type_date;
end;

procedure TForm_Approve_Vacation.RadioButton_BySelfClick(Sender: TObject);
begin
  JvComboBox_IssuerInFact.ItemIndex := -1;
  JvComboBox_IssuerInFact.Enabled := False;
end;

procedure TForm_Approve_Vacation.RadioButton_ByTimeClick(Sender: TObject);
begin
  DateTimePicker_TIssueDate.Enabled := True;
  DateTimePicker_TBeginTime.Enabled := True;
  DateTimePicker_TEndTime.Enabled := True;
  DateTimePicker_DBeginDate.Enabled := False;
  DateTimePicker_DEndDate.Enabled := False;

  JvComboBox_VacationType.Items := sl_vacation_type_time;
end;

procedure TForm_Approve_Vacation.RadioButton_InsteadClick(Sender: TObject);
begin
  JvComboBox_IssuerInFact.Enabled := True;
end;

procedure TForm_Approve_Vacation.SetNext(dat_type: string);
var
  date, time: TFormatSettings;
  first_node, curr_node, next_node: string;
  i: Integer;
begin
  date.ShortDateFormat := 'yyyymmdd';
  time.LongTimeFormat := 'hhnn';

  {�����������͡�����ڵ㼰��ǰ�ڵ���룬ȡ��һ�ڵ���룬��������һ�ڵ��Ƿ���ڡ�������������󣬲����������󡪡�������һ�������б��е���Ŀ��
  �����Ѿ��������ˮ��������������ˮ�ӱ��е���С����ȡ����ڵ���룻��������ˮ����������δ������������λ����������ǰ�ڵ���뼴����ڵ����}
  DataModule_sjhf.ADOQuery_SjhfDb.Close;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT F1.FAP_NODE_NOW FROM BHGMS_F_APPROVE_PROCESS F1 WHERE F1.FAP_ID=(SELECT MIN(F2.FAP_ID) FROM BHGMS_F_APPROVE_PROCESS F2 WHERE F2.FA_ID=''' + Label_FaId.Caption + ''') AND F1.FA_ID=''' + Label_FaId.Caption + ''' UNION ALL SELECT F1.FA_CURRENTNODE FROM BHGMS_F_APPROVE F1 ';
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('WHERE NOT EXISTS (SELECT 1 FROM BHGMS_F_APPROVE_PROCESS F2 WHERE F2.FA_ID=F1.FA_ID) AND F1.FA_ID=''' + Label_FaId.Caption + '''');
  DataModule_sjhf.ADOQuery_SjhfDb.Open;
  first_node := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FAP_NODE_NOW').AsString;

  {������������ȡ��ǰ�ڵ����}
  DataModule_sjhf.ADOQuery_SjhfDb.Close;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B1.FA_CURRENTNODE FROM BHGMS_F_APPROVE B1 WHERE B1.FA_ID=''' + Label_FaId.Caption + '''';
  DataModule_sjhf.ADOQuery_SjhfDb.Open;
  curr_node := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FA_CURRENTNODE').AsString;

  {���������̴������ȡ��һ�ڵ����}
  DataModule_sjhf.ADOQuery_SjhfDb.Close;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B.DAN_NEXTNODE FROM BHGMS_D_APPROVE_PROCESS B WHERE B.DAN_CURRNODE=''' + curr_node + ''' AND B.DAT_ID=''' + dat_type + ''' AND B.DAN_FIRSTNODE LIKE ''%''||''' + first_node + '''||''%''';
  DataModule_sjhf.ADOQuery_SjhfDb.Open;
  next_node := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DAN_NEXTNODE').AsString;

  GroupBox_Approve.Enabled := True;
  if ComboBox_NextControl.Items.Count > 0 then
    ComboBox_NextControl.Items.Clear;

  {����һ�ڵ����Ϊ�գ���ǰ�ڵ�Ϊ����ڵ㣬��һ�����������˵���������ѡ���һ��λ����Ա�޷�ѡ�񣻷���û������ѡ��}
  if next_node = '' then
    begin
      ComboBox_NextControl.Items.Add('����ͨ��');
      ComboBox_NextControl.Items.Add('����ͨ��');
      ComboBox_NextControl.Items.Add('�˻�����һ��λ');
      ComboBox_NextControl.Items.Add('�˻��������λ');
    end
  else
    begin
      {��һ��λ����Ա�����˵���ʼ��}
      sl_next_user := TStringList.Create;

      {ȡ��һ��λ����Ա����Ҫ��ѯ��������������λ�������������Ա�Ľڵ㣺
      1������ڵ��Ӧ�Ŀ�������Ϊ12000�������۸ýڵ��ǹ�������λ���ǲ���Ա���������п��������������Ӳ���Ա�������룬��ȡ����Ա��ͬ�����Ķ�Ӧ��λ����Ա��
      2��������벻Ϊ12000�������������ĳ�������������ṩ����Ա�������룬ֱ��ȡ�ÿ�����Ӧ��λ����Ա��ֱ��ȡ����Ա��
      3�������һ��λΪ���ֳ�������������������񣬶�ӦĬ�ϴ�����������ķֹܸ��ֳ���Ҳ����ѡ���������ֳ�����}
      DataModule_sjhf.ADOQuery_SjhfDb.Close;
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B3.BTOF_ID,B3.BTOF_NAME FROM BHGMS_U_OFFICER B3,BHGMS_R_NODE_JOB B2,BHGMS_D_APPROVE_NODE B1 WHERE B1.NODE_ID=B2.RNJ_NODEID AND B1.NODE_STATUS=''1'' AND B2.RNJ_STATUS=''1'' AND B3.BTOF_STATUS=''1'' AND B1.NODE_ID=''' + next_node + '''';
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(' AND ((B2.RNJ_TYPE=''1'' AND B2.RNJ_JOBID=B3.JOB_ID AND B1.NODE_BTO_ID=''12000'' AND B3.BTO_ID=''' + Form_Session.Edit_BtoId.Text + ''') OR (B2.RNJ_TYPE=''1'' AND B2.RNJ_JOBID=B3.JOB_ID AND B1.NODE_BTO_ID=B3.BTO_ID) OR (B2.RNJ_TYPE=''2'' AND B2.RNJ_BTOFID=B3.BTOF_ID AND B1.NODE_BTO_ID=''12000''');
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(' AND B3.BTO_ID=''' + Form_Session.Edit_BtoId.Text + ''') OR (B2.RNJ_TYPE=''2'' AND B2.RNJ_BTOFID=B3.BTOF_ID AND B1.NODE_BTO_ID=B3.BTO_ID))');
      DataModule_sjhf.ADOQuery_SjhfDb.Open;

      if DataModule_sjhf.ADOQuery_SjhfDb.RecordCount > 0 then
        begin
          DataModule_sjhf.ADOQuery_SjhfDb.First;
            for i := 0 to DataModule_sjhf.ADOQuery_SjhfDb.RecordCount - 1 do
              begin
                sl_next_user.Add(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTOF_ID').AsString + '|' + DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTOF_NAME').AsString);
                DataModule_sjhf.ADOQuery_SjhfDb.Next;
              end;
        end;
      JvComboBox_NextUser.Items := sl_next_user;

      {����ǰ�ڵ���ڷ���ڵ㣬����һ�����������˵���ֻ�С���������һ��λ��ѡ������з��ͼ��˻�ѡ��}
      if curr_node = first_node then
        ComboBox_NextControl.Items.Add('��������һ��λ')
      else
        begin
          ComboBox_NextControl.Items.Add('��������һ��λ');
          ComboBox_NextControl.Items.Add('�˻�����һ��λ');
          ComboBox_NextControl.Items.Add('�˻��������λ');
        end;
    end;
end;

end.
