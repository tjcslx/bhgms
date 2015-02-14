unit ui_query_vacation_overall;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Mask, JvExMask, JvToolEdit, JvCombobox,
  logic_db, ui_session, StrUtils, OleCtrls, CELL50Lib_TLB;

type
  TForm_Query_Vacation_Overall = class(TForm)
    DateTimePicker_BeginDate: TDateTimePicker;
    DateTimePicker_EndDate: TDateTimePicker;
    JvCheckedComboBox_BtoId: TJvCheckedComboBox;
    JvCheckedComboBox_BtofId: TJvCheckedComboBox;
    Label1: TLabel;
    Label2: TLabel;
    JvCheckedComboBox_VacationType: TJvCheckedComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    JvCheckedComboBox_ApproveStatus: TJvCheckedComboBox;
    Label6: TLabel;
    Button_Query: TButton;
    Button_SelectAll: TButton;
    Button_DeselectAll: TButton;
    Button_InvertAll: TButton;
    Label7: TLabel;
    Cell_Query_Vacation: TCell;
    ComboBox_ExportOption: TComboBox;
    Button_Export: TButton;
    CheckBox_OpenPostExport: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure JvCheckedComboBox_BtoIdChange(Sender: TObject);
    function GetSelectedSQLString(jvccb: TJvCheckedComboBox; sc: integer): string;
    procedure Button_SelectAllClick(Sender: TObject);
    procedure Button_DeselectAllClick(Sender: TObject);
    procedure Button_InvertAllClick(Sender: TObject);
    procedure Button_QueryClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Query_Vacation_Overall: TForm_Query_Vacation_Overall;

implementation

{$R *.dfm}

procedure TForm_Query_Vacation_Overall.Button_DeselectAllClick(Sender: TObject);
begin
  if JvCheckedComboBox_BtofId.Items.Count > 0 then
    JvCheckedComboBox_BtofId.SetUnCheckedAll();
end;

procedure TForm_Query_Vacation_Overall.Button_InvertAllClick(Sender: TObject);
begin
  if JvCheckedComboBox_BtofId.Items.Count > 0 then
    JvCheckedComboBox_BtofId.SetInvertAll();
end;

procedure TForm_Query_Vacation_Overall.Button_QueryClick(Sender: TObject);
var
  d: TFormatSettings;
  current_row, rows, i: Integer;
begin
  if DateTimePicker_BeginDate.Date > DateTimePicker_EndDate.Date then
    ShowMessage('查询结束日期不能小于起始日期！')
  else
    if ((JvCheckedComboBox_VacationType.Text = '') or (JvCheckedComboBox_ApproveStatus.Text = '') or (JvCheckedComboBox_BtofId.Text = '')) then
      ShowMessage('请假类型、审批文书状态或税务人员不能为空！')
    else
      begin
        d.ShortDateFormat := 'yyyy-MM-dd';
        d.DateSeparator := '-';
        DataModule_sjhf.ADOQuery_SjhfDb.Close;
        DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
        DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B1.BTO_ID,B1.BTO_NAME,(CASE WHEN F1.FA_ISSUER_INFACT IS NOT NULL THEN F1.FA_ISSUER||''（''||F1.FA_ISSUER_INFACT||''）'' ELSE F1.FA_ISSUER END) AS BTOF_ISSUER_ID,';
        DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('(CASE WHEN F1.FA_ISSUER_INFACT IS NOT NULL THEN B2.BTOF_NAME||''（''||B3.BTOF_NAME||''）'' ELSE B2.BTOF_NAME END) AS BTOF_ISSUER_NAME,D2.DVT_NAME,D1.DAS_NAME,SUM(F2.FAVS_VACATION_HOUR)*60+SUM(F2.FAVS_VACATION_MIN) AS MINS FROM BHGMS_F_APPROVE_VACATION_SUB ');
        DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('F2,BHGMS_F_APPROVE F1,BHGMS_U_OFFICER B3,BHGMS_U_OFFICER B2,BHGMS_U_ORGAN B1,BHGMS_D_VACATION_TYPE D2,BHGMS_D_APPROVE_STATUS D1 WHERE F1.FA_STATUS=D1.DAS_ID AND F2.FAVS_TYPE=D2.DVT_ID AND F1.FA_ISSUER=B2.BTOF_ID AND F1.FA_ISSUER_INFACT=B3.BTOF_ID(+) ');
        DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('AND B1.BTO_ID=B2.BTO_ID AND F1.FA_ID=F2.FA_ID AND (B2.BTOF_NAME ' + GetSelectedSQLString(JvCheckedComboBox_BtofId, JvCheckedComboBox_BtofId.CheckedCount) + ' OR B3.BTOF_NAME ' + GetSelectedSQLString(JvCheckedComboBox_BtofId, JvCheckedComboBox_BtofId.CheckedCount) + ') AND D1.DAS_NAME ' + GetSelectedSQLString(JvCheckedComboBox_ApproveStatus, JvCheckedComboBox_ApproveStatus.CheckedCount) + ' AND D2.DVT_NAME ');
        DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(GetSelectedSQLString(JvCheckedComboBox_VacationType, JvCheckedComboBox_VacationType.CheckedCount) + 'GROUP BY B1.BTO_ID,B1.BTO_NAME,(CASE WHEN F1.FA_ISSUER_INFACT IS NOT NULL THEN F1.FA_ISSUER||''（''||F1.FA_ISSUER_INFACT||''）'' ELSE F1.FA_ISSUER END),');
        DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('(CASE WHEN F1.FA_ISSUER_INFACT IS NOT NULL THEN B2.BTOF_NAME||''（''||B3.BTOF_NAME||''）'' ELSE B2.BTOF_NAME END),D2.DVT_NAME,D1.DAS_NAME');
        DataModule_sjhf.ADOQuery_SjhfDb.Open;

        if Cell_Query_Vacation.GetRows(0) > 3 then
          begin
            Cell_Query_Vacation.DeleteRow(2, Cell_Query_Vacation.GetRows(0) - 3, 0);
          end;
        Cell_Query_Vacation.ClearArea(1, 6, 7, 6, 0, 1);

        if DataModule_sjhf.ADOQuery_SjhfDb.RecordCount > 0 then
          begin
            rows := Cell_Query_Vacation.GetRows(0);
            Cell_Query_Vacation.InsertRow(rows, DataModule_sjhf.ADOQuery_SjhfDb.RecordCount - 1, 0);
            rows := Cell_Query_Vacation.GetRows(0);
            for i := 3 to rows do
              Cell_Query_Vacation.SetRowHeight(1, 24, i, 0);

            DataModule_sjhf.ADOQuery_SjhfDb.First;
            for current_row := 2 to rows do
              begin
                Cell_Query_Vacation.S(1, current_row, 0, DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTO_NAME').AsString);
                Cell_Query_Vacation.S(2, current_row, 0, DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTOF_ISSUER_NAME').AsString);
                Cell_Query_Vacation.S(3, current_row, 0, DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DVT_NAME').AsString);
                Cell_Query_Vacation.S(4, current_row, 0, DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DAS_NAME').AsString);
                Cell_Query_Vacation.D(5, current_row, 0, Trunc(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('MINS').AsInteger / 480));
                Cell_Query_Vacation.D(6, current_row, 0, Trunc((DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('MINS').AsInteger - Trunc(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('MINS').AsInteger / 480) * 480) / 60));
                Cell_Query_Vacation.D(7, current_row, 0, DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('MINS').AsInteger Mod 60);
                DataModule_sjhf.ADOQuery_SjhfDb.Next;
              end;
          end;
      end;
end;

procedure TForm_Query_Vacation_Overall.Button_SelectAllClick(Sender: TObject);
begin
  if JvCheckedComboBox_BtofId.Items.Count > 0 then
    JvCheckedComboBox_BtofId.SetCheckedAll();
end;

procedure TForm_Query_Vacation_Overall.FormActivate(Sender: TObject);
var
  d: TFormatSettings;
  i: Integer;
  Cell_Name: string;
begin
  d.ShortDateFormat := 'yyyy-MM-dd';
  d.DateSeparator := '-';
  DateTimePicker_BeginDate.Date := StrToDate(FormatDateTime('yyyy-MM', Now) + '-01', d);
  DateTimePicker_EndDate.Date := StrToDate(FormatDateTime('yyyy-MM-dd', Now), d);

  JvCheckedComboBox_VacationType.OrderedText := True;
  JvCheckedComboBox_ApproveStatus.OrderedText := True;
  JvCheckedComboBox_BtoId.OrderedText := True;
  JvCheckedComboBox_BtofId.OrderedText := True;

  if JvCheckedComboBox_BtoId.Items.Count > 0 then
    JvCheckedComboBox_BtoId.Items.Clear;

  if JvCheckedComboBox_BtofId.Items.Count > 0 then
    JvCheckedComboBox_BtofId.Items.Clear;

  if JvCheckedComboBox_VacationType.Items.Count > 0 then
    JvCheckedComboBox_VacationType.Items.Clear;

  DataModule_sjhf.ADOQuery_SjhfDb.Close;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT D.DVT_NAME FROM BHGMS_D_VACATION_TYPE D WHERE D.DVT_STATUS=''1''';
  DataModule_sjhf.ADOQuery_SjhfDb.Open;

  if DataModule_sjhf.ADOQuery_SjhfDb.RecordCount > 0 then
    begin
      for i := 0 to DataModule_sjhf.ADOQuery_SjhfDb.RecordCount - 1 do
        begin
          JvCheckedComboBox_VacationType.Items.Add(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DVT_NAME').AsString);
          DataModule_sjhf.ADOQuery_SjhfDb.Next;
        end;
    end;

  DataModule_sjhf.ADOQuery_SjhfDb.Close;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT BTO_ID,BTO_NAME FROM (SELECT B1.BTO_ID,B1.BTO_NAME,B1.BTO_STATUS FROM BHGMS_U_ORGAN B1 WHERE B1.BTO_ID=''' + Form_Session.Edit_BtoId.Text + ''' UNION SELECT B1.BTO_ID,B1.BTO_NAME,B1.BTO_STATUS FROM BHGMS_U_ORGAN B1 WHERE SUBSTR(B1.BTO_ID,1,2)<>''CZ'' AND ((';
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('''' + Form_Session.Edit_BtoId.Text + '''=''12011'') OR (''' + Form_Session.Edit_BtoId.Text + '''=''12008'' AND ''' + LeftStr(Form_Session.Edit_BtofJobId.Text, 2) + '''=''01'')) UNION ');
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('SELECT B1.BTO_ID,B1.BTO_NAME,B1.BTO_STATUS FROM BHGMS_U_ORGAN B1,BHGMS_D_LEADER_BTO D WHERE D.BTO_ID=B1.BTO_ID AND D.LEADER_BTOF_ID=''' + Form_Session.Edit_BtofId.Text + ''' AND ''' + Form_Session.Edit_BtoId.Text + '''=''12008'' AND ''' + LeftStr(Form_Session.Edit_BtofJobId.Text, 2) + '''<>''01'') WHERE BTO_STATUS=''1'' ORDER BY BTO_ID');
  DataModule_sjhf.ADOQuery_SjhfDb.Open;

  if DataModule_sjhf.ADOQuery_SjhfDb.RecordCount > 0 then
    begin
      for i := 0 to DataModule_sjhf.ADOQuery_SjhfDb.RecordCount - 1 do
        begin
          JvCheckedComboBox_BtoId.Items.Add(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTO_NAME').AsString);
          DataModule_sjhf.ADOQuery_SjhfDb.Next;
        end;
    end;

  {打开“签到查询”窗口时，“税务机关”默认显示操作员所在的税务机关，“人员”默认显示操作员本人；}
  DataModule_sjhf.ADOQuery_SjhfDb.Close;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B1.BTO_NAME FROM BHGMS_U_ORGAN B1 WHERE B1.BTO_ID=''' + Form_Session.Edit_BtoId.Text + '''';
  DataModule_sjhf.ADOQuery_SjhfDb.Open;

  for i := 0 to JvCheckedComboBox_BtoId.Items.Count - 1 do
    if JvCheckedComboBox_BtoId.Items.Strings[i] = DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTO_NAME').AsString then
      JvCheckedComboBox_BtoId.Checked[i] := True;

  for i := 0 to JvCheckedComboBox_BtofId.Items.Count - 1 do
    if JvCheckedComboBox_BtofId.Items.Strings[i] = Form_Session.Edit_BtofName.Text then
      JvCheckedComboBox_BtofId.Checked[i] := True;

    {华表控件模版初始化，并进行模版显示设置}
  if Cell_Query_Vacation.Login('天津市地方税务局', '11100101900', '0700-1254-0142-2004') = 0 then
    ShowMessage('华表组件注册失败！');
  if Cell_Query_Vacation.GetFileName = '' then
    Cell_Name := ExtractFilePath(Application.ExeName) + '\..\cll\cell_query_vacation_overall.cll';
  if (Cell_Query_Vacation.OpenFile(Cell_Name, '') <> 1) and (Cell_Query_Vacation.OpenFile(Cell_Name, '') <> 0) then
    ShowMessage('加载数据模板错误【' + IntToStr(Cell_Query_Vacation.OpenFile(Cell_Name, '')) + '】');

  Cell_Query_Vacation.ShowPageBreak(0);
  {设置是否显示页签 0:不显示 1:显示}
  Cell_Query_Vacation.ShowSheetLabel(0, 0);
  {设置是否显示列标 0:不显示 1:显示}
  Cell_Query_Vacation.ShowTopLabel(0, 0);
  {设置是否显示行标 0:不显示 1:显示}
  Cell_Query_Vacation.ShowSideLabel(0, 0);
  {设置是否显示表格线 0:不显示 1:显示}
  Cell_Query_Vacation.ShowGridLine(0, 0);
  {设置是否显示不滚动行列标志线 0:不显示 1:显示}
  Cell_Query_Vacation.ShowFixedLines(0, 0);
end;

function TForm_Query_Vacation_Overall.GetSelectedSQLString(jvccb: TJvCheckedComboBox;
  sc: integer): string;
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

procedure TForm_Query_Vacation_Overall.JvCheckedComboBox_BtoIdChange(Sender: TObject);
var
  i: Integer;
begin
  if JvCheckedComboBox_BtoId.CheckedCount = 0 then
    JvCheckedComboBox_BtofId.Items.Clear
  else
    begin
      JvCheckedComboBox_BtofId.Items.Clear;

      DataModule_sjhf.ADOQuery_SjhfDb.Close;
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT BTOF_ID,BTOF_NAME,BTO_ID,BTO_NAME FROM (';
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('SELECT B2.BTOF_ID,B2.BTOF_NAME,B1.BTO_ID,B1.BTO_NAME FROM BHGMS_U_OFFICER B2,BHGMS_U_ORGAN B1 WHERE B1.BTO_ID=B2.BTO_ID AND B2.BTOF_ID=''' + Form_Session.Edit_BtofId.Text + ''' UNION ');
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('SELECT B2.BTOF_ID,B2.BTOF_NAME,B1.BTO_ID,B1.BTO_NAME FROM BHGMS_U_OFFICER B2,BHGMS_U_ORGAN B1 WHERE B1.BTO_ID=B2.BTO_ID AND B1.BTO_ID=''' + Form_Session.Edit_BtoId.Text + ''' AND ''' + Form_Session.Edit_BtoId.Text + '''<>''12011'' AND ''' + Form_Session.Edit_BtofJobId.Text + ''' IN (''030'',''041'',''050'') UNION ');
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('SELECT B2.BTOF_ID,B2.BTOF_NAME,B1.BTO_ID,B1.BTO_NAME FROM BHGMS_U_OFFICER B2,BHGMS_U_ORGAN B1 WHERE B1.BTO_ID=B2.BTO_ID AND SUBSTR(B1.BTO_ID,1,2)<>''CZ'' AND ((''' + Form_Session.Edit_BtoId.Text + '''=''12008'' AND ''' + Form_Session.Edit_BtofJobId.Text + '''=''010'') OR (''' + Form_Session.Edit_BtoId.Text + '''=''12011'')) UNION ');
      DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('SELECT B2.BTOF_ID,B2.BTOF_NAME,B1.BTO_ID,B1.BTO_NAME FROM BHGMS_U_OFFICER B2,BHGMS_U_ORGAN B1,BHGMS_D_LEADER_BTO DL WHERE B1.BTO_ID=B2.BTO_ID AND B1.BTO_ID=DL.BTO_ID AND ''' + Form_Session.Edit_BtoId.Text + '''=''12008'' AND ''' + Form_Session.Edit_BtofJobId.Text + '''<>''010'' AND DL.LEADER_BTOF_ID=''' + Form_Session.Edit_BtofId.Text + ''') WHERE BTO_NAME ' + GetSelectedSQLString(JvCheckedComboBox_BtoId, JvCheckedComboBox_BtoId.CheckedCount) + ' ORDER BY BTO_ID,BTOF_ID');
      DataModule_sjhf.ADOQuery_SjhfDb.Open;

      if DataModule_sjhf.ADOQuery_SjhfDb.RecordCount > 0 then
        begin
          DataModule_sjhf.ADOQuery_SjhfDb.First;
          for i := 0 to DataModule_sjhf.ADOQuery_SjhfDb.RecordCount - 1 do
            begin
              JvCheckedComboBox_BtofId.Items.Add(DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTOF_NAME').AsString);
              DataModule_sjhf.ADOQuery_SjhfDb.Next;
            end;
        end;
    end;
end;

end.
