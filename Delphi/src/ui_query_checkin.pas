unit ui_query_checkin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Grids,
  DBGrids, JvDBGridExport, ShellAPI, logic_db, ui_session, ComObj, Mask,
  JvExMask, JvToolEdit, JvCombobox, StrUtils, OleCtrls, CELL50Lib_TLB;

type
  TForm_Query_Checkin = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    DateTimePicker_BeginDate: TDateTimePicker;
    DateTimePicker_EndDate: TDateTimePicker;
    Button_Query: TButton;
    Button_Export: TButton;
    SaveDialog_Export: TSaveDialog;
    CheckBox_OpenPostExport: TCheckBox;
    JvCheckedComboBox_FcType: TJvCheckedComboBox;
    JvCheckedComboBox_BtoId: TJvCheckedComboBox;
    JvCheckedComboBox_BtofId: TJvCheckedComboBox;
    Button_SelectAll: TButton;
    Button_DeselectAll: TButton;
    Button_InvertAll: TButton;
    Label6: TLabel;
    Cell_Query_Checkin: TCell;
    ComboBox_ExportOption: TComboBox;
    procedure Button_ExportClick(Sender: TObject);
    function GetSelectedSQLString(jvccb: TJvCheckedComboBox; sc: integer): string;
    procedure Button_QueryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure JvCheckedComboBox_BtoIdChange(Sender: TObject);
    procedure Button_SelectAllClick(Sender: TObject);
    procedure Button_DeselectAllClick(Sender: TObject);
    procedure Button_InvertAllClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Query_Checkin: TForm_Query_Checkin;

implementation

{$R *.dfm}

procedure TForm_Query_Checkin.Button_DeselectAllClick(Sender: TObject);
begin
  if JvCheckedComboBox_BtofId.Items.Count > 0 then
    JvCheckedComboBox_BtofId.SetUnCheckedAll();
end;

procedure TForm_Query_Checkin.Button_ExportClick(Sender: TObject);
var
  d: TFormatSettings;
begin
  d.ShortDateFormat := 'yyyy年MM月dd日';
  SaveDialog_Export.Filename := DateToStr(DateTimePicker_BeginDate.Date, d) + '至' + DateToStr(DateTimePicker_EndDate.Date, d) + '签到情况表';
  if SaveDialog_Export.Execute then
    begin
      if (((ComboBox_ExportOption.ItemIndex = 0) and (Cell_Query_Checkin.GetCellString(1, 3, Cell_Query_Checkin.GetCurSheet) = '')) or ((ComboBox_ExportOption.ItemIndex = 1) and (Cell_Query_Checkin.GetCellString(1, 3, 0) = '') and (Cell_Query_Checkin.GetCellString(1, 3, 1) = ''))) then
        ShowMessage('记录数为0！')
      else
        begin
          try
            if ComboBox_ExportOption.ItemIndex = 0 then
              begin
                case SaveDialog_Export.FilterIndex of
                  1: Cell_Query_Checkin.ExportExcelFileEx(SaveDialog_Export.FileName, Cell_Query_Checkin.GetCurSheet);
                  2: Cell_Query_Checkin.ExportHtmlFile(SaveDialog_Export.FileName);
                end;
              end
            else
              begin
                case SaveDialog_Export.FilterIndex of
                  1: Cell_Query_Checkin.ExportExcelFile(SaveDialog_Export.FileName);
                  2: Cell_Query_Checkin.ExportHtmlFile(SaveDialog_Export.FileName);
                end;
              end;

            if CheckBox_OpenPostExport.Checked = True then
              ShellExecute(Handle, 'open', PChar(SaveDialog_Export.Filename), nil, nil, SW_SHOWNORMAL);
            ShowMessage('保存成功！');
          except
            on e: Exception do
              ShowMessage('保存失败！');
          end;
        end;
    end;
end;

procedure TForm_Query_Checkin.Button_InvertAllClick(Sender: TObject);
begin
  if JvCheckedComboBox_BtofId.Items.Count > 0 then
    JvCheckedComboBox_BtofId.SetInvertAll();
end;

procedure TForm_Query_Checkin.Button_QueryClick(Sender: TObject);
var
  d: TFormatSettings;
  current_row, rows, i: Integer;
begin
  if DateTimePicker_BeginDate.Date > DateTimePicker_EndDate.Date then
    ShowMessage('查询结束日期不能小于起始日期！')
  else
    if (JvCheckedComboBox_FcType.Text = '') or (JvCheckedComboBox_BtofId.Text = '') then
      ShowMessage('签到类型或人员不能为空！')
    else
      begin
        //查询已签到情况，并将其写入“已签到”标签页
        d.ShortDateFormat := 'yyyy-MM-dd';
        d.DateSeparator := '-';
        DataModule_sjhf.ADOQuery_SjhfDb.Close;
        DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
        DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B1.BTO_NAME,T.BTOF_NAME,TO_DATE(B.FC_DATE,''YYYYMMDD'') AS FC_DATE,DECODE(B.FC_TYPE,''0'',''上班'',''1'',''下班'','''') AS FC_TYPE,SUBSTR(B.FC_CHECKTIME,1,2)||'':''||SUBSTR(B.FC_CHECKTIME,3,2) AS FC_CHECKTIME,B2.DCS_NAME';
        DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(' FROM BHGMS_F_CHECKIN B,BHGMS_U_OFFICER T,BHGMS_U_ORGAN B1,BHGMS_D_CHECKIN_STATUS B2 WHERE B.FC_CHECKER=T.BTOF_ID AND B.FC_STATUS=B2.DCS_ID AND T.BTO_ID=B1.BTO_ID AND TO_DATE(B.FC_DATE,''YYYYMMDD'')>=TO_DATE(''' + DateTimeToStr(DateTimePicker_BeginDate.Date, d) + ''',''YYYY-MM-DD'') AND TO_DATE(B.FC_DATE,''YYYYMMDD'')<=TO_DATE(''' + DateTimeToStr(DateTimePicker_EndDate.Date, d) + ''',''YYYY-MM-DD'')');
        DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(' AND DECODE(B.FC_TYPE,''0'',''上班'',''1'',''下班'','''')' + GetSelectedSQLString(JvCheckedComboBox_FcType, JvCheckedComboBox_FcType.CheckedCount));
        DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(' AND T.BTOF_NAME' + GetSelectedSQLString(JvCheckedComboBox_BtofId, JvCheckedComboBox_BtofId.CheckedCount) + ' ORDER BY TO_NUMBER(B.FC_ID)');
        DataModule_sjhf.ADOQuery_SjhfDb.Open;

        if Cell_Query_Checkin.GetRows(0) > 3 then
          begin
            Cell_Query_Checkin.DeleteRow(2, Cell_Query_Checkin.GetRows(0) - 3, 0);
          end;
        Cell_Query_Checkin.ClearArea(1, 6, 4, 6, 0, 1);

        if DataModule_sjhf.ADOQuery_SjhfDb.RecordCount > 0 then
          begin
            rows := Cell_Query_Checkin.GetRows(0);
            Cell_Query_Checkin.InsertRow(rows, DataModule_sjhf.ADOQuery_SjhfDb.RecordCount - 1, 0);
            rows := Cell_Query_Checkin.GetRows(0);
            for i := 3 to rows do
              Cell_Query_Checkin.SetRowHeight(1, 24, i, 0);

            DataModule_sjhf.ADOQuery_SjhfDb.First;
            for current_row := 2 to rows do
              begin
                Cell_Query_Checkin.S(1, current_row, 0, DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTO_NAME').AsString);
                Cell_Query_Checkin.S(2, current_row, 0, DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTOF_NAME').AsString);
                Cell_Query_Checkin.SetCellDateTime(3, current_row, 0, DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FC_DATE').AsString);
                Cell_Query_Checkin.S(4, current_row, 0, DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FC_TYPE').AsString);
                Cell_Query_Checkin.S(5, current_row, 0, DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FC_CHECKTIME').AsString);
                Cell_Query_Checkin.S(6, current_row, 0, DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DCS_NAME').AsString);
                DataModule_sjhf.ADOQuery_SjhfDb.Next;
              end;
          end;

        //查询已签到情况，并将其写入“已签到”标签页
        DataModule_sjhf.ADOQuery_SjhfDb.Close;
        DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT * FROM (SELECT B1.BTO_NAME,B2.BTOF_NAME,C.CH_DATE AS FC_DATE,Q.FC_TYPE FROM C_HOLIDAY C,BHGMS_U_OFFICER B2,BHGMS_U_ORGAN B1,(SELECT ''上班'' AS FC_TYPE FROM DUAL UNION ALL SELECT ''下班'' FROM DUAL) Q WHERE B1.BTO_ID=B2.BTO_ID AND B2.BTOF_NAME ';
        DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(GetSelectedSQLString(JvCheckedComboBox_BtofId, JvCheckedComboBox_BtofId.CheckedCount) + ' AND C.CH_DATE>=TO_DATE(''' + DateTimeToStr(DateTimePicker_BeginDate.Date, d) + ''',''YYYY-MM-DD'') AND C.CH_DATE<=TO_DATE(''' + DateTimeToStr(DateTimePicker_EndDate.Date, d) + ''',''YYYY-MM-DD'') AND Q.FC_TYPE ' + GetSelectedSQLString(JvCheckedComboBox_FcType, JvCheckedComboBox_FcType.CheckedCount) + ' MINUS ');
        DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('SELECT B1.BTO_NAME,T.BTOF_NAME,TO_DATE(B.FC_DATE,''YYYYMMDD'') AS FC_DATE,DECODE(B.FC_TYPE,''0'',''上班'',''1'',''下班'','''') AS FC_TYPE FROM BHGMS_F_CHECKIN B,BHGMS_U_OFFICER T,BHGMS_U_ORGAN B1 WHERE B.FC_CHECKER=T.BTOF_ID AND T.BTO_ID=B1.BTO_ID');
        DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(' AND TO_DATE(B.FC_DATE,''YYYYMMDD'')>=TO_DATE(''' + DateTimeToStr(DateTimePicker_BeginDate.Date, d) + ''',''YYYY-MM-DD'') AND TO_DATE(B.FC_DATE,''YYYYMMDD'')<=TO_DATE(''' + DateTimeToStr(DateTimePicker_EndDate.Date, d) + ''',''YYYY-MM-DD'') AND DECODE(B.FC_TYPE,''0'',''上班'',''1'',''下班'','''') ');
        DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(GetSelectedSQLString(JvCheckedComboBox_FcType, JvCheckedComboBox_FcType.CheckedCount) + ' AND T.BTOF_NAME ' + GetSelectedSQLString(JvCheckedComboBox_BtofId, JvCheckedComboBox_BtofId.CheckedCount) + ') ORDER BY FC_DATE,FC_TYPE');
        DataModule_sjhf.ADOQuery_SjhfDb.Open;

        if Cell_Query_Checkin.GetRows(1) > 3 then
          begin
            Cell_Query_Checkin.DeleteRow(2, Cell_Query_Checkin.GetRows(1) - 3, 1);
          end;
        Cell_Query_Checkin.ClearArea(1, 4, 4, 4, 1, 1);

        if DataModule_sjhf.ADOQuery_SjhfDb.RecordCount > 0 then
          begin
            Cell_Query_Checkin.InsertRow(Cell_Query_Checkin.GetRows(1), DataModule_sjhf.ADOQuery_SjhfDb.RecordCount - 1, 1);
            for i := 3 to Cell_Query_Checkin.GetRows(1) do
              Cell_Query_Checkin.SetRowHeight(1, 24, i, 1);

            DataModule_sjhf.ADOQuery_SjhfDb.First;
            for current_row := 2 to Cell_Query_Checkin.GetRows(1) do
              begin
                Cell_Query_Checkin.S(1, current_row, 1, DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTO_NAME').AsString);
                Cell_Query_Checkin.S(2, current_row, 1, DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('BTOF_NAME').AsString);
                Cell_Query_Checkin.SetCellDateTime(3, current_row, 1, DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FC_DATE').AsString);
                Cell_Query_Checkin.S(4, current_row, 1, DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('FC_TYPE').AsString);
                DataModule_sjhf.ADOQuery_SjhfDb.Next;
              end;
          end;

        Cell_Query_Checkin.SetCurSheet(0);
        Cell_Query_Checkin.MoveToCell(1, 1);
      end;
end;

procedure TForm_Query_Checkin.Button_SelectAllClick(Sender: TObject);
begin
  if JvCheckedComboBox_BtofId.Items.Count > 0 then
    JvCheckedComboBox_BtofId.SetCheckedAll();
end;

procedure TForm_Query_Checkin.FormActivate(Sender: TObject);
var
  i: Integer;
  Cell_Name: string;
begin
  if JvCheckedComboBox_BtoId.Items.Count > 0 then
    JvCheckedComboBox_BtoId.Items.Clear;

  if JvCheckedComboBox_BtofId.Items.Count > 0 then
    JvCheckedComboBox_BtofId.Items.Clear;

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
  if Cell_Query_Checkin.Login('天津市地方税务局', '11100101900', '0700-1254-0142-2004') = 0 then
    ShowMessage('华表组件注册失败！');
  if Cell_Query_Checkin.GetFileName = '' then
    Cell_Name := ExtractFilePath(Application.ExeName) + '\..\cll\cell_query_checkin.cll';
  if (Cell_Query_Checkin.OpenFile(Cell_Name, '') <> 1) and (Cell_Query_Checkin.OpenFile(Cell_Name, '') <> 0) then
    ShowMessage('加载数据模板错误【' + IntToStr(Cell_Query_Checkin.OpenFile(Cell_Name, '')) + '】');

  Cell_Query_Checkin.AllowExtend := False;
  Cell_Query_Checkin.AllowDragdrop := False;
  Cell_Query_Checkin.ShowPageBreak(0);
  {设置是否显示页签 0:不显示 1:显示}
  Cell_Query_Checkin.ShowSheetLabel(1, 0);
  Cell_Query_Checkin.ShowSheetLabel(1, 1);
  {设置是否显示列标 0:不显示 1:显示}
  Cell_Query_Checkin.ShowTopLabel(0, 0);
  Cell_Query_Checkin.ShowTopLabel(0, 1);
  {设置是否显示行标 0:不显示 1:显示}
  Cell_Query_Checkin.ShowSideLabel(0, 0);
  Cell_Query_Checkin.ShowSideLabel(0, 1);
  {设置是否显示表格线 0:不显示 1:显示}
  Cell_Query_Checkin.ShowGridLine(0, 0);
  Cell_Query_Checkin.ShowGridLine(0, 1);
  {设置是否显示不滚动行列标志线 0:不显示 1:显示}
  Cell_Query_Checkin.ShowFixedLines(0, 0);
  Cell_Query_Checkin.ShowFixedLines(0, 1);
end;

procedure TForm_Query_Checkin.FormCreate(Sender: TObject);
var
  d: TFormatSettings;
begin
  d.ShortDateFormat := 'yyyy-MM-dd';
  d.DateSeparator := '-';
  DateTimePicker_BeginDate.Date := StrToDate(FormatDateTime('yyyy-MM', Now) + '-01', d);
  DateTimePicker_EndDate.Date := StrToDate(FormatDateTime('yyyy-MM-dd', Now), d);

  JvCheckedComboBox_FcType.OrderedText := True;
  JvCheckedComboBox_BtoId.OrderedText := True;
  JvCheckedComboBox_BtofId.OrderedText := True;
end;

function TForm_Query_Checkin.GetSelectedSQLString(
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

procedure TForm_Query_Checkin.JvCheckedComboBox_BtoIdChange(Sender: TObject);
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
