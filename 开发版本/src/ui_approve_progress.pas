unit ui_approve_progress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, logic_db;

type
  TForm_Approve_Progress = class(TForm)
    DBGrid_VAP: TDBGrid;
    Button_Close: TButton;
    Label1: TLabel;
    Label_FaId: TLabel;
    Label3: TLabel;
    Label_DatName: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure Button_CloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Approve_Progress: TForm_Approve_Progress;

implementation

{$R *.dfm}

procedure TForm_Approve_Progress.Button_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_Approve_Progress.FormActivate(Sender: TObject);
begin
  DataModule_sjhf.ADOQuery_SjhfDb.Close;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT D.DAT_NAME FROM BHGMS_F_APPROVE B1,BHGMS_D_APPROVE_TYPE D WHERE B1.FA_TYPE=D.DAT_ID AND B1.FA_ID=''' + Label_FaId.Caption + '''';
  DataModule_sjhf.ADOQuery_SjhfDb.Open;
  Label_DatName.Caption := DataModule_sjhf.ADOQuery_SjhfDb.FieldByName('DAT_NAME').AsString;

  DataModule_sjhf.ADOQuery_SjhfDb.Close;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Clear;
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Text := 'SELECT B1.FAP_ID,B2.BTOF_NAME AS BTOF_NAME_NOW,B3.BTOF_NAME AS BTOF_NAME_NEXT,B1.FAP_DATE,DECODE(B1.FAP_CONTROL,''0'',''发送'',''1'',''终审通过'',''2'',''退回至上一岗位'',''3'',''退回至发起岗位'',''4'',''终审未通过'','''') AS FAP_CONTROL,B1.FAP_COMMENT FROM ';
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add('BHGMS_F_APPROVE_PROCESS B1,BHGMS_U_OFFICER B2,BHGMS_U_OFFICER B3 WHERE B1.FAP_USER_NOW=B2.BTOF_ID AND B1.FAP_USER_NEXT=B3.BTOF_ID(+) AND B1.FA_ID=''' + Label_FaId.Caption + '''');
  DataModule_sjhf.ADOQuery_SjhfDb.SQL.Add(' ORDER BY TO_NUMBER(B1.FAP_ID)');
  DataModule_sjhf.ADOQuery_SjhfDb.Open;
  DBGrid_VAP.DataSource := DataModule_sjhf.DataSource_FApprove;
end;

end.
