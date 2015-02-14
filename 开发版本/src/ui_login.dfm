object Form_Login: TForm_Login
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #30331#24405
  ClientHeight = 196
  ClientWidth = 425
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
    Left = 100
    Top = 24
    Width = 85
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #25805#20316#21592#32534#21495
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 100
    Top = 65
    Width = 85
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #23494#30721
    Layout = tlCenter
  end
  object Label_Err: TLabel
    Left = 100
    Top = 106
    Width = 225
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Layout = tlCenter
  end
  object Edit_UserId: TEdit
    Left = 205
    Top = 24
    Width = 120
    Height = 21
    MaxLength = 6
    TabOrder = 0
    OnKeyPress = Edit_UserIdKeyPress
  end
  object Edit_Password: TEdit
    Left = 205
    Top = 65
    Width = 120
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
    OnKeyPress = Edit_PasswordKeyPress
  end
  object Button_Login: TButton
    Left = 80
    Top = 147
    Width = 75
    Height = 25
    Caption = #30331#24405#65288'&L'#65289
    TabOrder = 2
    OnClick = Button_LoginClick
  end
  object Button_Clear: TButton
    Left = 175
    Top = 147
    Width = 75
    Height = 25
    Caption = #28165#31354#65288'&C'#65289
    TabOrder = 3
    OnClick = Button_ClearClick
  end
  object Button_Exit: TButton
    Left = 270
    Top = 147
    Width = 75
    Height = 25
    Caption = #36864#20986#65288'&E'#65289
    TabOrder = 4
    OnClick = Button_ExitClick
  end
  object IdIPWatch_Local: TIdIPWatch
    Active = False
    HistoryEnabled = False
    HistoryFilename = 'iphist.dat'
    Left = 40
    Top = 48
  end
end
