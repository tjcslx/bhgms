unit ui_approve_overtime;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvExStdCtrls, JvCombobox;

type
  TForm_Approve_Overtime = class(TForm)
    GroupBox_ApprovePersonnel: TGroupBox;
    GroupBox_Overtime: TGroupBox;
    GroupBox_Approve: TGroupBox;
    RadioButton_BySelf: TRadioButton;
    RadioButton_Instead: TRadioButton;
    JvComboBox_IssuerInFact: TJvComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Approve_Overtime: TForm_Approve_Overtime;

implementation

{$R *.dfm}

end.
