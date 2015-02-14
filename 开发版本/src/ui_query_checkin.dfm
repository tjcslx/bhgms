object Form_Query_Checkin: TForm_Query_Checkin
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #31614#21040#24773#20917#26597#35810
  ClientHeight = 377
  ClientWidth = 700
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 24
    Width = 100
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #26597#35810#36215#22987#26085#26399
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 440
    Top = 24
    Width = 100
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #26597#35810#32467#26463#26085#26399
    Layout = tlCenter
  end
  object Label3: TLabel
    Left = 40
    Top = 65
    Width = 100
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #31614#21040#31867#22411
    Layout = tlCenter
  end
  object Label4: TLabel
    Left = 340
    Top = 65
    Width = 100
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #31246#21153#26426#20851
    Layout = tlCenter
  end
  object Label5: TLabel
    Left = 40
    Top = 106
    Width = 100
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #20154#21592
    Layout = tlCenter
  end
  object Label6: TLabel
    Left = 40
    Top = 147
    Width = 100
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = #20154#21592#36873#25321
    Layout = tlCenter
  end
  object DateTimePicker_BeginDate: TDateTimePicker
    Left = 160
    Top = 24
    Width = 100
    Height = 21
    Date = 41864.842967500000000000
    Format = 'yyyy-MM-dd'
    Time = 41864.842967500000000000
    TabOrder = 0
  end
  object DateTimePicker_EndDate: TDateTimePicker
    Left = 560
    Top = 24
    Width = 100
    Height = 21
    Date = 41864.843142418980000000
    Format = 'yyyy-MM-dd'
    Time = 41864.843142418980000000
    TabOrder = 1
  end
  object Button_Query: TButton
    Left = 580
    Top = 147
    Width = 80
    Height = 25
    Caption = #26597#35810#65288'&Q'#65289
    TabOrder = 8
    OnClick = Button_QueryClick
  end
  object Button_Export: TButton
    Left = 300
    Top = 332
    Width = 80
    Height = 25
    Caption = #23548#20986#65288'&E'#65289
    TabOrder = 10
    OnClick = Button_ExportClick
  end
  object CheckBox_OpenPostExport: TCheckBox
    Left = 400
    Top = 332
    Width = 140
    Height = 25
    Caption = #23548#20986#21518#25171#24320#25991#20214#65288'&O'#65289
    TabOrder = 11
  end
  object JvCheckedComboBox_FcType: TJvCheckedComboBox
    Left = 160
    Top = 65
    Width = 100
    Height = 21
    Items.Strings = (
      #19978#29677
      #19979#29677)
    CapSelectAll = '&Select all'
    CapDeSelectAll = '&Deselect all'
    CapInvertAll = '&Invert all'
    TabOrder = 2
  end
  object JvCheckedComboBox_BtoId: TJvCheckedComboBox
    Left = 460
    Top = 65
    Width = 200
    Height = 21
    CapSelectAll = '&Select all'
    CapDeSelectAll = '&Deselect all'
    CapInvertAll = '&Invert all'
    TabOrder = 3
    OnChange = JvCheckedComboBox_BtoIdChange
  end
  object JvCheckedComboBox_BtofId: TJvCheckedComboBox
    Left = 160
    Top = 106
    Width = 500
    Height = 21
    CapSelectAll = '&Select all'
    CapDeSelectAll = '&Deselect all'
    CapInvertAll = '&Invert all'
    TabOrder = 4
  end
  object Button_SelectAll: TButton
    Left = 160
    Top = 147
    Width = 80
    Height = 25
    Caption = #20840#36873#65288'&S'#65289
    TabOrder = 5
    OnClick = Button_SelectAllClick
  end
  object Button_DeselectAll: TButton
    Left = 260
    Top = 147
    Width = 80
    Height = 25
    Caption = #20840#19981#36873#65288'&D'#65289
    TabOrder = 6
    OnClick = Button_DeselectAllClick
  end
  object Button_InvertAll: TButton
    Left = 360
    Top = 147
    Width = 80
    Height = 25
    Caption = #21453#36873#65288'&I'#65289
    TabOrder = 7
    OnClick = Button_InvertAllClick
  end
  object Cell_Query_Checkin: TCell
    Left = 40
    Top = 192
    Width = 620
    Height = 120
    TabOrder = 9
    ControlData = {0000010014400000670C000000000000}
  end
  object ComboBox_ExportOption: TComboBox
    Left = 160
    Top = 334
    Width = 120
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 12
    Text = #23548#20986#24403#21069#39029
    Items.Strings = (
      #23548#20986#24403#21069#39029
      #23548#20986#20840#37096#39029)
  end
  object SaveDialog_Export: TSaveDialog
    DefaultExt = 'xls'
    Filter = 'Excel 97-2003 '#24037#20316#31807'|*.xls|'#32593#39029'|*.htm;*.html'
    Left = 40
    Top = 328
  end
end
