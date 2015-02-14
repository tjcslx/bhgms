object Form_Dimension_List_Template: TForm_Dimension_List_Template
  Left = 0
  Top = 0
  Caption = #20195#30721#34920#20462#25913
  ClientHeight = 262
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 24
    Width = 100
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = #26377#25928#26631#24535
    Layout = tlCenter
  end
  object DBGrid1: TDBGrid
    Left = 40
    Top = 69
    Width = 320
    Height = 120
    TabOrder = 2
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        ReadOnly = True
        Title.Alignment = taCenter
        Title.Caption = #20195#30721
        Width = 40
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        Title.Alignment = taCenter
        Title.Caption = #21517#31216
        Width = 160
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        Title.Alignment = taCenter
        Title.Caption = #26377#25928#26631#24535
        Width = 80
        Visible = True
      end>
  end
  object Button_New: TButton
    Left = 40
    Top = 213
    Width = 80
    Height = 25
    Caption = #26032#22686#65288'&N'#65289
    TabOrder = 3
  end
  object Button_Modify: TButton
    Left = 160
    Top = 213
    Width = 80
    Height = 25
    Caption = #20462#25913#65288'&M'#65289
    TabOrder = 4
  end
  object Button_Delete: TButton
    Left = 280
    Top = 213
    Width = 80
    Height = 25
    Caption = #21024#38500#65288'&D'#65289
    TabOrder = 5
  end
  object ComboBox1: TComboBox
    Left = 160
    Top = 26
    Width = 100
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 0
    Text = #26377#25928
    Items.Strings = (
      #26377#25928
      #26080#25928)
  end
  object Button_Query: TButton
    Left = 280
    Top = 24
    Width = 80
    Height = 25
    Caption = #26597#35810#65288'&Q'#65289
    TabOrder = 1
  end
end
