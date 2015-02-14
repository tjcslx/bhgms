unit ui_session;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TForm_Session = class(TForm)
    Edit_BtofId: TEdit;
    Edit_BtoId: TEdit;
    Edit_BtofJobId: TEdit;
    DateTimePicker_LoginTime: TDateTimePicker;
    DateTimePicker_LogoutTime: TDateTimePicker;
    Edit_BtofName: TEdit;
    Edit_IpAddress: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Session: TForm_Session;

implementation

{$R *.dfm}

end.
