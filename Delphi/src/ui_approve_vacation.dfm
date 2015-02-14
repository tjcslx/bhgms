object Form_Approve_Vacation: TForm_Approve_Vacation
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #35831#20551#30003#35831#21450#23457#25209
  ClientHeight = 677
  ClientWidth = 632
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
  object GroupBox_Vacation: TGroupBox
    Left = 16
    Top = 97
    Width = 600
    Height = 362
    Caption = #35831#20551#30003#35831
    TabOrder = 1
    object Label_TitleTID: TLabel
      Left = 40
      Top = 82
      Width = 100
      Height = 21
      Alignment = taCenter
      AutoSize = False
      Caption = #35831#20551#26085#26399
      Layout = tlCenter
    end
    object Label_TitleTBT: TLabel
      Left = 40
      Top = 113
      Width = 100
      Height = 21
      Alignment = taCenter
      AutoSize = False
      Caption = #35831#20551#26102#38388#36215
      Layout = tlCenter
    end
    object Label_TitleTET: TLabel
      Left = 340
      Top = 113
      Width = 100
      Height = 21
      Alignment = taCenter
      AutoSize = False
      Caption = #35831#20551#26102#38388#27490
      Layout = tlCenter
    end
    object Label_TitleDBD: TLabel
      Left = 40
      Top = 171
      Width = 100
      Height = 21
      Alignment = taCenter
      AutoSize = False
      Caption = #35831#20551#26085#26399#36215
      Layout = tlCenter
    end
    object Label_TitleDED: TLabel
      Left = 340
      Top = 171
      Width = 100
      Height = 21
      Alignment = taCenter
      AutoSize = False
      Caption = #35831#20551#26085#26399#27490
      Layout = tlCenter
    end
    object Label_TitleVT: TLabel
      Left = 40
      Top = 212
      Width = 100
      Height = 21
      Alignment = taCenter
      AutoSize = False
      Caption = #35831#20551#31867#22411
      Layout = tlCenter
    end
    object Label_MD: TLabel
      Left = 40
      Top = 243
      Width = 100
      Height = 21
      Alignment = taCenter
      AutoSize = False
      Caption = #24773#20917#35828#26126
      Layout = tlCenter
    end
    object Label_TitleFaId: TLabel
      Left = 40
      Top = 24
      Width = 100
      Height = 21
      Alignment = taCenter
      AutoSize = False
      Caption = #27969#31243#23457#25209#27969#27700#21495
      Layout = tlCenter
    end
    object Label_FaId: TLabel
      Left = 160
      Top = 24
      Width = 100
      Height = 21
      Alignment = taCenter
      AutoSize = False
      Layout = tlCenter
    end
    object Label_VacationTypeErr: TLabel
      Left = 360
      Top = 212
      Width = 200
      Height = 21
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object RadioButton_ByTime: TRadioButton
      Left = 40
      Top = 55
      Width = 120
      Height = 17
      Caption = #25353#26102#35831#20551
      TabOrder = 0
      OnClick = RadioButton_ByTimeClick
    end
    object RadioButton_ByDate: TRadioButton
      Left = 40
      Top = 144
      Width = 120
      Height = 17
      Caption = #25353#22825#35831#20551
      TabOrder = 4
      OnClick = RadioButton_ByDateClick
    end
    object DateTimePicker_TIssueDate: TDateTimePicker
      Left = 160
      Top = 82
      Width = 100
      Height = 21
      Date = 42017.966318402780000000
      Format = 'yyyy-MM-dd'
      Time = 42017.966318402780000000
      TabOrder = 1
      OnKeyPress = DateTimePicker_TIssueDateKeyPress
    end
    object DateTimePicker_TBeginTime: TDateTimePicker
      Left = 160
      Top = 113
      Width = 100
      Height = 21
      Date = 42017.967668587960000000
      Format = 'HH:mm'
      Time = 42017.967668587960000000
      Kind = dtkTime
      TabOrder = 2
      OnKeyPress = DateTimePicker_TBeginTimeKeyPress
    end
    object DateTimePicker_TEndTime: TDateTimePicker
      Left = 460
      Top = 113
      Width = 100
      Height = 21
      Date = 42017.969689895830000000
      Format = 'HH:mm'
      Time = 42017.969689895830000000
      Kind = dtkTime
      TabOrder = 3
      OnKeyPress = DateTimePicker_TEndTimeKeyPress
    end
    object DateTimePicker_DBeginDate: TDateTimePicker
      Left = 160
      Top = 171
      Width = 100
      Height = 21
      Date = 42017.972318113430000000
      Format = 'yyyy-MM-dd'
      Time = 42017.972318113430000000
      TabOrder = 5
      OnKeyPress = DateTimePicker_DBeginDateKeyPress
    end
    object DateTimePicker_DEndDate: TDateTimePicker
      Left = 460
      Top = 171
      Width = 100
      Height = 21
      Date = 42017.972949259260000000
      Format = 'yyyy-MM-dd'
      Time = 42017.972949259260000000
      TabOrder = 6
      OnKeyPress = DateTimePicker_DEndDateKeyPress
    end
    object Memo_FavsDescription: TMemo
      Left = 160
      Top = 243
      Width = 400
      Height = 50
      Lines.Strings = (
        'Memo_FavsDescription')
      TabOrder = 8
    end
    object Button_Save: TButton
      Left = 120
      Top = 313
      Width = 80
      Height = 25
      Caption = #20445#23384#65288'&S'#65289
      TabOrder = 9
      OnClick = Button_SaveClick
    end
    object Button_Delete: TButton
      Left = 376
      Top = 313
      Width = 80
      Height = 25
      Caption = #21024#38500#65288'&D'#65289
      TabOrder = 10
      OnClick = Button_DeleteClick
    end
    object JvComboBox_VacationType: TJvComboBox
      Left = 160
      Top = 212
      Width = 120
      Height = 21
      Style = csDropDownList
      TabOrder = 7
    end
  end
  object GroupBox_Approve: TGroupBox
    Left = 16
    Top = 475
    Width = 600
    Height = 184
    Caption = #35831#20551#23457#25209
    TabOrder = 2
    object Label_NextControl: TLabel
      Left = 40
      Top = 24
      Width = 100
      Height = 21
      Alignment = taCenter
      AutoSize = False
      Caption = #19979#19968#25805#20316
      Layout = tlCenter
    end
    object Label_NextUser: TLabel
      Left = 300
      Top = 24
      Width = 100
      Height = 21
      Alignment = taCenter
      AutoSize = False
      Caption = #19979#19968#23703#20301#25805#20316#21592
      Layout = tlCenter
    end
    object Label_ApproveComment: TLabel
      Left = 40
      Top = 61
      Width = 100
      Height = 21
      Alignment = taCenter
      AutoSize = False
      Caption = #23457#25209#24847#35265
      Layout = tlCenter
    end
    object ComboBox_NextControl: TComboBox
      Left = 160
      Top = 24
      Width = 120
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = ComboBox_NextControlChange
    end
    object Memo_ApproveComment: TMemo
      Left = 160
      Top = 65
      Width = 380
      Height = 50
      TabOrder = 1
    end
    object Button_Confirm: TButton
      Left = 260
      Top = 135
      Width = 80
      Height = 25
      Caption = #30830#35748#65288'&C'#65289
      TabOrder = 2
      OnClick = Button_ConfirmClick
    end
    object JvComboBox_NextUser: TJvComboBox
      Left = 420
      Top = 24
      Width = 120
      Height = 21
      Style = csDropDownList
      TabOrder = 3
    end
  end
  object GroupBox_ApprovePersonnel: TGroupBox
    Left = 16
    Top = 16
    Width = 600
    Height = 65
    Caption = #30003#35831#35831#20551#20154#21592
    TabOrder = 0
    object RadioButton_BySelf: TRadioButton
      Left = 40
      Top = 24
      Width = 120
      Height = 17
      Caption = #26412#20154#30003#35831
      TabOrder = 0
      OnClick = RadioButton_BySelfClick
    end
    object RadioButton_Instead: TRadioButton
      Left = 280
      Top = 24
      Width = 120
      Height = 17
      Caption = #20195#26367#30003#35831
      TabOrder = 1
      OnClick = RadioButton_InsteadClick
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
end
