unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,

  GlobalUtils, MMDevApi, StdCtrls, ComCtrls,
  Vcl.Menus, Vcl.ExtCtrls;

type
  TVolumeControlForm = class(TForm)
    pnlFormBody: TPanel;
    pnlTitle: TPanel;
    pnlMenu: TPanel;
    tbVolume: TTrackBar;
    btnClose: TButton;
    lblVolRead: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure pnlTitleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure tbVolumeChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VolumeControlForm: TVolumeControlForm;

implementation

{$R *.dfm}

procedure TVolumeControlForm.FormCreate(Sender: TObject);
begin
  ActivateEndpointVolume;
  tbVolume.Position := 100 - getVolume();
end;

procedure TVolumeControlForm.tbVolumeChange(Sender: TObject);
begin
  SetVolume(100 - tbVolume.Position);
  lblVolRead.Caption := IntToStr(GetVolume);
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
