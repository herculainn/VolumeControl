object VolumeControlForm: TVolumeControlForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  BorderWidth = 2
  Caption = 'Volume Control'
  ClientHeight = 407
  ClientWidth = 59
  Color = clActiveBorder
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object pnlFormBody: TPanel
    Left = 0
    Top = 29
    Width = 59
    Height = 297
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      59
      297)
    object lblVolRead: TLabel
      Left = 0
      Top = 281
      Width = 59
      Height = 16
      Align = alBottom
      Alignment = taCenter
      AutoSize = False
      Caption = '10'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      Font.Quality = fqAntialiased
      ParentFont = False
      ExplicitTop = 328
    end
    object tbVolume: TTrackBar
      Left = 10
      Top = 6
      Width = 42
      Height = 269
      Anchors = [akLeft, akTop, akRight, akBottom]
      LineSize = 3
      Max = 100
      Orientation = trVertical
      ParentShowHint = False
      PageSize = 5
      Frequency = 10
      Position = 90
      ShowHint = False
      TabOrder = 0
      TickMarks = tmBoth
      OnChange = tbVolumeChange
    end
  end
  object pnlTitle: TPanel
    Left = 0
    Top = 0
    Width = 59
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Volume'
    Color = clActiveCaption
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clCaptionText
    Font.Height = -13
    Font.Name = 'Calibri'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    OnMouseDown = pnlTitleMouseDown
  end
  object pnlMenu: TPanel
    Left = 0
    Top = 326
    Width = 59
    Height = 81
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    DesignSize = (
      59
      81)
    object btnMute: TImage
      Left = 13
      Top = 11
      Width = 32
      Height = 32
      OnClick = btnMuteClick
    end
    object btnClose: TButton
      Left = 8
      Top = 49
      Width = 43
      Height = 25
      Anchors = [akLeft, akRight, akBottom]
      Caption = 'Close'
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
end
