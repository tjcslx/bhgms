object Form_Approve_Progress: TForm_Approve_Progress
  Left = 0
  Top = 0
  Caption = #23457#25209#36827#24230#26597#35810
  ClientHeight = 249
  ClientWidth = 685
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 24
    Width = 60
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #27969#27700#21495
    Layout = tlCenter
  end
  object Label_FaId: TLabel
    Left = 120
    Top = 24
    Width = 120
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Layout = tlCenter
  end
  object Label3: TLabel
    Left = 280
    Top = 24
    Width = 60
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #23457#25209#31867#22411
    Layout = tlCenter
  end
  object Label_DatName: TLabel
    Left = 376
    Top = 24
    Width = 160
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Layout = tlCenter
  end
  object DBGrid_VAP: TDBGrid
    Left = 40
    Top = 65
    Width = 605
    Height = 120
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'FAP_ID'
        Title.Alignment = taCenter
        Title.Caption = #24207#21495
        Width = 60
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'BTOF_NAME_NOW'
        Title.Alignment = taCenter
        Title.Caption = #21457#36865#20154
        Width = 80
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'BTOF_NAME_NEXT'
        Title.Alignment = taCenter
        Title.Caption = #25509#25910#20154
        Width = 80
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'FAP_DATE'
        Title.Alignment = taCenter
        Title.Caption = #25805#20316#26085#26399
        Width = 100
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'FAP_CONTROL'
        Title.Alignment = taCenter
        Title.Caption = #25805#20316#31867#22411
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FAP_COMMENT'
        Title.Alignment = taCenter
        Title.Caption = #23457#25209#24847#35265
        Width = 160
        Visible = True
      end>
  end
  object Button_Close: TButton
    Left = 305
    Top = 205
    Width = 75
    Height = 25
    Caption = #20851#38381#65288'&C'#65289
    TabOrder = 1
    OnClick = Button_CloseClick
  end
end
