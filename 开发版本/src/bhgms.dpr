program bhgms;

uses
  Windows,
  Forms,
  Dialogs,
  ui_login in 'ui_login.pas' {Form_Login},
  ui_frame in 'ui_frame.pas' {Form_Frame},
  logic_db in 'logic_db.pas' {DataModule_sjhf: TDataModule},
  ui_changepwd in 'ui_changepwd.pas' {Form_ChangePassword},
  ui_approve_list_vacation in 'ui_approve_list_vacation.pas' {Form_Approve_List_Vacation},
  ui_session in 'ui_session.pas' {Form_Session},
  ui_approve_vacation in 'ui_approve_vacation.pas' {Form_Approve_Vacation},
  ui_approve_progress in 'ui_approve_progress.pas' {Form_Approve_Progress},
  ui_query_checkin in 'ui_query_checkin.pas' {Form_Query_Checkin},
  ui_initpwd in 'ui_initpwd.pas' {Form_InitializePassword},
  ui_query_vacation_details in 'ui_query_vacation_details.pas' {Form_Query_Vacation_Details},
  ui_about in 'ui_about.pas' {AboutBox},
  ui_dimension_list_template in 'ui_dimension_list_template.pas' {Form_Dimension_List_Template},
  ui_approve_overtime in 'ui_approve_overtime.pas' {Form_Approve_Overtime},
  ui_query_vacation_overall in 'ui_query_vacation_overall.pas' {Form_Query_Vacation_Overall};

{$R *.res}

const
  classname = 'TForm_Login';

var
  handle: Integer;

begin
  handle := FindWindow(classname, Nil);
  if handle <> 0 then
    begin
      ShowMessage('程序正在运行！');
      halt;
    end;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '滨海新区地税局综合管理系统';
  Application.CreateForm(TForm_Login, Form_Login);
  Application.CreateForm(TForm_Query_Checkin, Form_Query_Checkin);
  Application.CreateForm(TForm_Approve_Vacation, Form_Approve_Vacation);
  Application.CreateForm(TForm_Approve_List_Vacation, Form_Approve_List_Vacation);
  Application.CreateForm(TForm_Frame, Form_Frame);
  Application.CreateForm(TForm_ChangePassword, Form_ChangePassword);
  Application.CreateForm(TDataModule_sjhf, DataModule_sjhf);
  Application.CreateForm(TForm_Session, Form_Session);
  Application.CreateForm(TForm_Approve_Progress, Form_Approve_Progress);
  Application.CreateForm(TForm_InitializePassword, Form_InitializePassword);
  Application.CreateForm(TForm_Query_Vacation_Details, Form_Query_Vacation_Details);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TForm_Dimension_List_Template, Form_Dimension_List_Template);
  Application.CreateForm(TForm_Approve_Overtime, Form_Approve_Overtime);
  Application.CreateForm(TForm_Query_Vacation_Overall, Form_Query_Vacation_Overall);
  Application.Run;
end.
