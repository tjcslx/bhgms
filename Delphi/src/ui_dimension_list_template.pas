unit ui_dimension_list_template;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids;

type
  TForm_Dimension_List_Template = class(TForm)
    DBGrid1: TDBGrid;
    Button_New: TButton;
    Button_Modify: TButton;
    Button_Delete: TButton;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Button_Query: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Dimension_List_Template: TForm_Dimension_List_Template;

implementation

{$R *.dfm}

end.
