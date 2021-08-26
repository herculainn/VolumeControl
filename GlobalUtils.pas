unit GlobalUtils;

interface

uses
  Winapi.Windows, MMDevApi, ActiveX, pngimage, Messages, System.Classes;
             
function IIFS(aCondition: Boolean; aTrue: String; aFalse: String): String;
function ParseStr(cStr: string; cDelim: char; nIndex: integer): string;
function GetResPNG(const ResID: String): TPngImage;
procedure SetVolume(aVolume: integer);
function GetVolume: Integer;
function GetMute: bool;
procedure SetMute(aMute: Boolean);
function ToggleMute: Boolean;
procedure SendMessageWinAPI(aCommand: NativeInt; aTarget: String = '');

const
  VOL_MAX = 100; // Could be taken from device
  VOL_MIN = 0;   // if arsed...

implementation

uses
  System.SysUtils, Vcl.Forms, CtrlProcess;

function IIFS(aCondition: Boolean; aTrue: String; aFalse: String): String;
begin
  if aCondition then Result := aTrue
  else Result := aFalse;
end;

function ParseStr(cStr: string; cDelim: char; nIndex: integer): string;
var
  i, nCount: integer;
  cCurrent: string;
begin
  cCurrent := '';
  nCount := 0;
  Result := '';
  for i := 1 to length(cStr) do
  begin
    if cStr[i] = cDelim then
    begin
      nCount := nCount + 1;
      if nCount = nIndex then
      begin
        Result := cCurrent;
        Break;
      end;
      cCurrent := '';
    end
    else
      cCurrent := cCurrent + cStr[i];
  end;
  nCount := nCount + 1;
  if nCount = nIndex then
    Result := cCurrent;
end;

function GetResPNG(const ResID: String): TPngImage;
begin
  Result := TPngImage.Create;
  try
    Result.LoadFromResourceName(hInstance, ResID);
  except
    Result := nil;
  end;
end;

function GetVolume: Integer;
var
  VolumeLevel: Single;
begin
  Result := -1;
  if EndpointVolume = nil then Exit;

  EndpointVolume.GetMasterVolumeLevelScalar(VolumeLevel);
  Result := round(VolumeLevel * VOL_MAX);
end;

procedure SetVolume(aVolume: integer);
var
  VolumeLevel: Single;
begin
  if EndpointVolume = nil then Exit;

  VolumeLevel := aVolume / VOL_MAX;
  EndpointVolume.SetMasterVolumeLevelScalar(VolumeLevel, nil);
  SetMute(VolumeLevel = VOL_MIN);
end;

function GetMute: bool;
var
  MuteValue: Boolean;
begin
  Result := false;
  if EndpointVolume = nil then Exit;

  MuteValue := bool(true); // own it
  EndpointVolume.GetMute(MuteValue);

  Result := bool(MuteValue);
end;

procedure SetMute(aMute: Boolean);
begin
  if EndpointVolume = nil then Exit;

  if (aMute) then EndpointVolume.SetMute(true, nil)
  else EndpointVolume.SetMute(false, nil);
end;

function ToggleMute: Boolean;
var
  tpMuted: Boolean;
begin
  Result := false;
  if EndpointVolume = nil then Exit;

  tpMuted := GetMute;
  if (tpMuted) then SetMute(false)
  else SetMute(true);
  Result := GetMute;
end; 

procedure SendMessageWinAPI(aCommand: NativeInt; aTarget: String = '');
var
  lTargets: TList;
  cPoint: Pointer;

begin

  if (aTarget <> '') then
  begin
    // TODO: Narrow down further...
    lTargets := GetWindowHandlesByProcessName(aTarget);
    for cPoint in lTargets do
      SendMessage(HWND(cPoint), WM_APPCOMMAND, 0, MAKELONG(0, aCommand));
  end
  else
  begin
    // TODO: Defect - This prevents the application from exiting!
    // This also confuses Spotify sometimes; repeats input and error when playing any tracks afterwards
    // https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-sendmessage
    SendMessage(HWND_BROADCAST, WM_APPCOMMAND, 0, MAKELONG(0, aCommand));
  end;
      
end;


end.
