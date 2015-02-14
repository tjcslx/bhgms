object Form_Approve_List_Vacation: TForm_Approve_List_Vacation
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #35831#20551#30003#35831#27719#24635#34920
  ClientHeight = 342
  ClientWidth = 732
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
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
    Caption = #26597#35810#36215#22987#26102#38388
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 40
    Top = 65
    Width = 100
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #26597#35810#32467#26463#26102#38388
    Layout = tlCenter
  end
  object Label3: TLabel
    Left = 450
    Top = 24
    Width = 100
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #29366#24577
    Layout = tlCenter
  end
  object Label4: TLabel
    Left = 450
    Top = 65
    Width = 100
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #25991#20070#29615#33410
    Layout = tlCenter
  end
  object DBGrid_Vacation: TDBGrid
    Left = 40
    Top = 151
    Width = 650
    Height = 120
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 5
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
    OnDblClick = DBGrid_VacationDblClick
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'FA_ID'
        Title.Alignment = taCenter
        Title.Caption = #24207#21495
        Width = 40
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'FA_NAME'
        Title.Alignment = taCenter
        Title.Caption = #20219#21153#21517#31216
        Width = 240
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'BTOF_ISSUER_NAME'
        Title.Alignment = taCenter
        Title.Caption = #21457#36215#20154
        Width = 60
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'BTOF_CURRENTUSER_NAME'
        Title.Alignment = taCenter
        Title.Caption = #21463#29702#20154
        Width = 60
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'FA_ISSUEDATE'
        Title.Alignment = taCenter
        Title.Caption = #21457#36215#26085#26399
        Width = 80
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'FAVS_TIME_TYPE'
        Title.Alignment = taCenter
        Title.Caption = #35831#20551#26102#27573
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'DAS_NAME'
        Title.Alignment = taCenter
        Title.Caption = #29366#24577
        Width = 60
        Visible = True
      end>
  end
  object Button_Lookup: TButton
    Left = 40
    Top = 291
    Width = 75
    Height = 25
    Caption = #26597#30475#65288'&L'#65289
    TabOrder = 6
    OnClick = Button_LookupClick
  end
  object Button_Delete: TButton
    Left = 135
    Top = 291
    Width = 75
    Height = 25
    Caption = #21024#38500#65288'&D'#65289
    TabOrder = 7
    OnClick = Button_DeleteClick
  end
  object DateTimePicker_BeginDate: TDateTimePicker
    Left = 160
    Top = 24
    Width = 100
    Height = 21
    Date = 41829.486105451390000000
    Format = 'yyyy-MM-dd'
    Time = 41829.486105451390000000
    TabOrder = 0
  end
  object DateTimePicker_EndDate: TDateTimePicker
    Left = 160
    Top = 65
    Width = 100
    Height = 21
    Date = 41829.486749097220000000
    Format = 'yyyy-MM-dd'
    Time = 41829.486749097220000000
    TabOrder = 1
  end
  object Button_Query: TButton
    Left = 615
    Top = 106
    Width = 75
    Height = 25
    Caption = #26597#35810#65288'&Q'#65289
    TabOrder = 4
    OnClick = Button_QueryClick
  end
  object Button_LookupProcess: TButton
    Left = 230
    Top = 291
    Width = 75
    Height = 25
    Caption = #27969#31243#65288'&P'#65289
    TabOrder = 8
    OnClick = Button_LookupProcessClick
  end
  object JvCheckedComboBox_CurrentNode: TJvCheckedComboBox
    Left = 570
    Top = 65
    Width = 120
    Height = 21
    Items.Strings = (
      #21457#36215
      #21463#29702)
    CapSelectAll = '&Select all'
    CapDeSelectAll = '&Deselect all'
    CapInvertAll = '&Invert all'
    TabOrder = 3
  end
  object JvCheckedComboBox_ApproveStatus: TJvCheckedComboBox
    Left = 570
    Top = 24
    Width = 120
    Height = 21
    Items.Strings = (
      #20445#23384
      #25552#20132
      #21024#38500
      #36890#36807
      #36864#22238
      #19981#36890#36807)
    CapSelectAll = '&Select all'
    CapDeSelectAll = '&Deselect all'
    CapInvertAll = '&Invert all'
    TabOrder = 2
  end
end
