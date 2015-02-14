object Form_Approve_Overtime: TForm_Approve_Overtime
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #21152#29677#30003#35831#21450#23457#25209
  ClientHeight = 677
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox_ApprovePersonnel: TGroupBox
    Left = 16
    Top = 16
    Width = 600
    Height = 65
    Caption = #30003#35831#21152#29677#20154#21592
    TabOrder = 0
    object RadioButton_BySelf: TRadioButton
      Left = 40
      Top = 24
      Width = 120
      Height = 17
      Caption = #26412#20154#30003#35831
      TabOrder = 0
    end
    object RadioButton_Instead: TRadioButton
      Left = 280
      Top = 24
      Width = 120
      Height = 17
      Caption = #20195#26367#30003#35831
      TabOrder = 1
    end
    object JvComboBox_IssuerInFact: TJvComboBox
      Left = 440
      Top = 22
      Width = 120
      Height = 21
      Style = csDropDownList
      TabOrder = 2
    end
  end
  object GroupBox_Overtime: TGroupBox
    Left = 16
    Top = 97
    Width = 600
    Height = 362
    Caption = #21152#29677#30003#35831
    TabOrder = 1
  end
  object GroupBox_Approve: TGroupBox
    Left = 16
    Top = 475
    Width = 600
    Height = 184
    Caption = #21152#29677#23457#25209
    TabOrder = 2
  end
end
