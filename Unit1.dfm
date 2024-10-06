object Form1: TForm1
  Left = 465
  Top = 362
  AlphaBlend = True
  AlphaBlendValue = 50
  BorderStyle = bsNone
  Caption = 'Form1'
  ClientHeight = 150
  ClientWidth = 150
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  TextHeight = 15
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 64
    Top = 24
  end
end
