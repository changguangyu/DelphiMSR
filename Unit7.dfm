object Form7: TForm7
  Left = 0
  Top = 0
  Caption = 'Form7'
  ClientHeight = 181
  ClientWidth = 410
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LabelCurrentPkg: TLabel
    Left = 248
    Top = 88
    Width = 104
    Height = 40
    Caption = '0.00 W'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -33
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LabelTDP: TLabel
    Left = 288
    Top = 24
    Width = 33
    Height = 23
    Caption = '0 W'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LabelIsMSR: TLabel
    Left = 120
    Top = 24
    Width = 42
    Height = 23
    Caption = 'False'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 48
    Top = 24
    Width = 66
    Height = 23
    Caption = 'Is MSR:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 241
    Top = 24
    Width = 41
    Height = 23
    Caption = 'TDP:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 42
    Top = 88
    Width = 200
    Height = 40
    Caption = 'CPU Package:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -33
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 360
    Top = 24
  end
end
