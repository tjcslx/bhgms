object Form_InitializePassword: TForm_InitializePassword
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #23494#30721#21021#22987#21270
  ClientHeight = 157
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
    Caption = #25805#20316#21592#22995#21517
    Layout = tlCenter
  end
  object Edit_UserId: TEdit
    Left = 200
    Top = 24
    Width = 120
    Height = 21
    MaxLength = 6
    TabOrder = 0
    OnKeyPress = Edit_UserIdKeyPress
  end
  object Edit_UserName: TEdit
    Left = 200
    Top = 65
    Width = 120
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 1
  end
  object Button_InitPwd: TButton
    Left = 100
    Top = 106
    Width = 80
    Height = 25
    Caption = #21021#22987#21270#65288'&I'#65289
    TabOrder = 2
    OnClick = Button_InitPwdClick
  end
  object Button_Cancel: TButton
    Left = 220
    Top = 106
    Width = 80
    Height = 25
    Caption = #21462#28040#65288'&X'#65289
    TabOrder = 3
    OnClick = Button_CancelClick
  end
end
