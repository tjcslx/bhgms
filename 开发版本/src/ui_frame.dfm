object Form_Frame: TForm_Frame
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #28392#28023#26032#21306#22320#31246#23616#32508#21512#31649#29702#31995#32479
  ClientHeight = 208
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu_bhgms
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label_Checkin: TLabel
    Left = 120
    Top = 32
    Width = 217
    Height = 13
    AutoSize = False
    Caption = 'Label_Checkin'
    Layout = tlCenter
  end
  object StatusBar_Frame: TStatusBar
    Left = 0
    Top = 189
    Width = 457
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 50
      end>
  end
  object MainMenu_bhgms: TMainMenu
    Left = 48
    Top = 32
    object MenuItem_CheckinMgmt: TMenuItem
      Caption = #31614#21040#31649#29702
      object MenuItem_OffWork: TMenuItem
        Caption = #19979#29677#31614#21040
        OnClick = MenuItem_OffWorkClick
      end
      object MenuItem_CheckinQuery: TMenuItem
        Caption = #31614#21040#26597#35810
        OnClick = MenuItem_CheckinQueryClick
      end
    end
    object MenuItem_VacationMgmt: TMenuItem
      Caption = #35831#20551#31649#29702
      object MenuItem_VacationHandle: TMenuItem
        Caption = #20219#21153#22788#29702
        OnClick = MenuItem_VacationHandleClick
      end
      object MenuItem_NewVacation: TMenuItem
        Caption = #26032#35831#20551
        OnClick = MenuItem_NewVacationClick
      end
      object MenuItem_VacationDetailsQuery: TMenuItem
        Caption = #35831#20551#26126#32454#26597#35810
        OnClick = MenuItem_VacationDetailsQueryClick
      end
      object MenuItem_VacationOverallQuery: TMenuItem
        Caption = #35831#20551#27719#24635#26597#35810
        OnClick = MenuItem_VacationOverallQueryClick
      end
    end
    object MenuItem_OvertimeMgmt: TMenuItem
      Caption = #21152#29677#31649#29702
      object MenuItem_OvertimeHandle: TMenuItem
        Caption = #20219#21153#22788#29702
      end
      object MenuItem_NewOvertime: TMenuItem
        Caption = #26032#21152#29677
      end
    end
    object MenuItem_SysConfig: TMenuItem
      Caption = #31995#32479#35774#32622
      object MenuItem_ChangePassword: TMenuItem
        Caption = #20462#25913#23494#30721
        OnClick = MenuItem_ChangePasswordClick
      end
      object MenuItem_InitializePassword: TMenuItem
        Caption = #21021#22987#21270#23494#30721
        OnClick = MenuItem_InitializePasswordClick
      end
    end
    object MenuItem_DimensionMgmt: TMenuItem
      Caption = #20195#30721#31649#29702
    end
    object MenuItem_RightMgmt: TMenuItem
      Caption = #26435#38480#31649#29702
      object MenuItem_ItemMgmt: TMenuItem
        Caption = #33756#21333#39033#30446#31649#29702
      end
      object MenuItem_MenuGroupMgmt: TMenuItem
        Caption = #33756#21333#26435#38480#32452#31649#29702
      end
      object MenuItem_GroupOrganMgmt: TMenuItem
        Caption = #26435#38480#32452#26426#20851#20851#32852#31649#29702
      end
      object MenuItem_GroupOperatorMgmt: TMenuItem
        Caption = #26435#38480#32452#20154#21592#20851#32852#31649#29702
      end
      object MenuItem_SpecItemMgmt: TMenuItem
        Caption = #29305#21035#26435#38480#31649#29702
      end
    end
  end
  object Timer_Panel: TTimer
    OnTimer = Timer_PanelTimer
    Left = 360
    Top = 24
  end
end
