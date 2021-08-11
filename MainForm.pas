unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,

  GlobalUtils, MMDevApi, StdCtrls, ComCtrls,
  Vcl.Menus, Vcl.ExtCtrls, Vcl.Buttons;

type
  TVolumeControlForm = class(TForm)
    pnlFormBody: TPanel;
    pnlTitle: TPanel;
    pnlMenu: TPanel;
    tbVolume: TTrackBar;
    btnClose: TButton;
    lblVolRead: TLabel;
    btnMute: TImage;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure pnlTitleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure tbVolumeChange(Sender: TObject);
    procedure btnMuteClick(Sender: TObject);
    procedure SetBtnMuteGlyph;
    procedure SetBtnMute(aMuted: Boolean);
  private
    fMuted: Boolean;
  public
    { Public declarations }
  end;

var
  VolumeControlForm: TVolumeControlForm;

implementation

{$R *.dfm}

procedure TVolumeControlForm.btnMuteClick(Sender: TObject);
begin
  try
    SetMute(not fMuted);
  finally
    SetBtnMute(not fMuted);
  end;
end;

procedure TVolumeControlForm.SetBtnMute(aMuted: Boolean);
begin
  fMuted := aMuted;
  SetBtnMuteGlyph;
end;

procedure TVolumeControlForm.SetBtnMuteGlyph;
begin
  btnMute.Picture.Assign(
    GetResPNG(
      IIFS(fMuted, 'MUTE_32', 'VOLUME_32')
    )
  );
end;

procedure TVolumeControlForm.FormCreate(Sender: TObject);
var
  oldTbVolumeOnChange: TNotifyEvent;
  VolumeLevel: Integer;
  MuteValue: Boolean;
begin
  // Prep
  VolumeLevel := GetVolume;
  MuteValue := GetMute;

  // Set tbVolume
  oldTbVolumeOnChange := tbVolume.OnChange;
  tbVolume.OnChange := nil;
  tbVolume.Position := VOL_MAX - VolumeLevel;
  tbVolume.OnChange := oldTbVolumeOnChange;

  // Set lblVolRead
  lblVolRead.Caption := IntToStr(VolumeLevel);

  // Set btnMute
  SetBtnMute(MuteValue);

end;

procedure TVolumeControlForm.tbVolumeChange(Sender: TObject);
var
  VolumeLevel: Integer;
begin
  VolumeLevel := VOL_MAX - tbVolume.Position;
  SetVolume(VolumeLevel);

  lblVolRead.Caption := IntToStr(VolumeLevel);
  if fMuted <> (VolumeLevel = VOL_MIN) then
    btnMuteClick(self);

end;

procedure TVolumeControlForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Ord(Key) = VK_ESCAPE) then btnCloseClick(self);
end;

procedure TVolumeControlForm.pnlTitleMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = $F012;
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TVolumeControlForm.btnCloseClick(Sender: TObject);
begin
  close;
end;

end.
