unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
    scanBitmap: TBitmap;
    procedure OpenURL(url: string);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses ZXing.ScanManager, ZXing.BarcodeFormat, ZXing.ReadResult, Threading,
  ShellAPI;

var
  ScanManager: TScanManager;
  G_DC: HDC;
  text: string;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ScanManager := TScanManager.Create(TBarcodeFormat.Auto, nil);
  scanBitmap := TBitmap.Create(Width, Height);
  G_DC := GetWindowDC(0);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ScanManager.Free;
  scanBitmap.Free;
  ReleaseDC(0, G_DC);
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    WindowState := wsMiniMized
  else if Width < 600 then
  begin
    Width := Width + 150;
    Height := Height + 150;
    Canvas.FillRect(ClientRect);
    FormPaint(Sender);
  end
  else
  begin
    Width := 150;
    Height := 150;
    FormPaint(Sender);
  end;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  Left := Left - Width div 2 + X;
  Top := Top - Height div 2 + Y;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  Canvas.Rectangle(0, 0, Width, Height);
end;

procedure TForm1.OpenURL(url: string);
begin
  ShellExecute(0, 'open', PChar(url), '', '', SW_SHOWNORMAL);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  res: TReadResult;
  rec: TRect;
begin
  rec := Rect(0, 0, Width, Height);
  BitBlt(scanBitmap.Canvas.Handle, 0, 0, Width, Height, G_DC, Left,
    Top, SRCCOPY);
  TTask.Run(
    procedure
    begin
      res := ScanManager.Scan(scanBitmap);
      if Assigned(res) and (text <> res.text) then
      begin
        text := res.text;
        OpenURL(res.text);
        FreeAndNil(res);
      end
      else
        scanBitmap.FreeImage;
    end);
end;

end.
