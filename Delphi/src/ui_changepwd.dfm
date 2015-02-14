object Form_ChangePassword: TForm_ChangePassword
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #20462#25913#23494#30721
  ClientHeight = 239
  ClientWidth = 402
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
    Left = 80
    Top = 24
    Width = 80
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #25805#20316#21592#32534#21495
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 80
    Top = 65
    Width = 80
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #21407#23494#30721
    Layout = tlCenter
  end
  object Label3: TLabel
    Left = 80
    Top = 106
    Width = 80
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #36755#20837#26032#23494#30721
    Layout = tlCenter
  end
  object Label4: TLabel
    Left = 80
    Top = 147
    Width = 80
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #20877#27425#36755#20837
    Layout = tlCenter
  end
  object Label5: TLabel
    Left = 200
    Top = 24
    Width = 120
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = 'Label5'
    Layout = tlCenter
  end
  object Edit_PrevPasswd: TEdit
    Left = 200
    Top = 65
    Width = 120
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
    OnKeyPress = Edit_PrevPasswdKeyPress
  end
  object Edit_NewPasswd: TEdit
    Left = 200
    Top = 106
    Width = 120
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
    OnKeyPress = Edit_NewPasswdKeyPress
  end
  object Edit_ConfNewPasswd: TEdit
    Left = 200
    Top = 147
    Width = 120
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
    OnKeyPress = Edit_ConfNewPasswdKeyPress
  end
  object Button_Confirm: TButton
    Left = 100
    Top = 188
    Width = 75
    Height = 25
    Caption = #30830#35748#65288'&C'#65289
    TabOrder = 3
    OnClick = Button_ConfirmClick
  end
  object Button_Cancel: TButton
    Left = 220
    Top = 188
    Width = 75
    Height = 25
    Caption = #21462#28040#65288'&X'#65289
    TabOrder = 4
    OnClick = Button_CancelClick
  end
end
