unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
    scanBitmap: TBitmap;
    url: string;
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

procedure TForm1.FormClick(Sender: TObject);
begin
  WindowState := wsMiniMized;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ScanManager := TScanManager.Create(TBarcodeFormat.CODE_128, nil);
  scanBitmap := TBitmap.Create(Width, Height);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ScanManager.Free;
  scanBitmap.Free;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  rec: TRect;
begin
  Left := Left - Width div 2 + X;
  Top := Top - Height div 2 + Y;
  rec := Rect(0, 0, Width, Height);
  if scanBitmap.Empty then
    scanBitmap.Canvas.CopyRect(rec, Canvas, rec);
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
begin
  if scanBitmap.Empty then
    Exit;
  TTask.Run(
    procedure
    begin
      res := ScanManager.Scan(scanBitmap);
      if Assigned(res) then
        OpenURL(res.text)
      else
        scanBitmap.FreeImage;
      res.Free;
    end);
end;

end.
