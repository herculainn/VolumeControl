unit GlobalUtils;

interface

uses
  Winapi.Windows, MMDevApi, ActiveX, pngimage ;


procedure ActivateEndpointVolume;
function IIFS(aCondition: Boolean; aTrue: String; aFalse: String): String;
function ParseStr(cStr: string; cDelim: char; nIndex: integer): string;
function GetResPNG(const ResID: String): TPngObject;
procedure SetVolume(aVolume: integer);
function GetVolume: Integer;
function GetMute: bool;
procedure SetMute(aMute: Boolean);
function ToggleMute: Boolean;


var
  EndpointVolume: IAudioEndpointVolume = nil;

const
  VOL_MAX = 100;
  VOL_MIN = 0;

implementation

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

function GetResPNG(const ResID: String): TPngObject;
begin
  Result := TpngObject.Create;
  try
    Result.LoadFromResourceName(hInstance, ResID);
  except
    Result := nil;
  end;
end;

procedure ActivateEndpointVolume;
var
  DeviceEnumerator: IMMDeviceEnumerator;
  DefaultDevice: IMMDevice;
begin
  CoCreateInstance(
    CLASS_IMMDeviceEnumerator, nil,
    CLSCTX_INPROC_SERVER, IID_IMMDeviceEnumerator,
    DeviceEnumerator);

  DeviceEnumerator.GetDefaultAudioEndpoint(
    eRender, eConsole, DefaultDevice);

  DefaultDevice.Activate(
    IID_IAudioEndpointVolume,
    CLSCTX_INPROC_SERVER, nil,
    EndpointVolume);
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

end.
