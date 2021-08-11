unit CommandLineImpl;

interface

procedure RunCommandLineFunction;

implementation

uses System.SysUtils, GlobalUtils;

procedure RunCommandLineFunction;
var
  i: integer;
  cParam, cParamName, cParamValue: string;
  VolumeLevel, OriginalVolumeLevel: Integer;
begin
  try
    VolumeLevel := GetVolume;
    OriginalVolumeLevel := VolumeLevel;

    for i := 2 to ParamCount do // skip "run"
    begin

      cParam      := paramStr(i);
      cParamName  := UpperCase(ParseStr(cParam, '=', 1));
      cParamValue := ParseStr(cParam, '=', 2);

      if (cParamName = 'SET_VOLUME') then
        VolumeLevel := StrToInt(cParamValue)

      else if (cParamName = 'INC_VOLUME_BY') then
        VolumeLevel := VolumeLevel + StrToInt(cParamValue)

      else if (cParamName = 'DEC_VOLUME_BY') then
        VolumeLevel := VolumeLevel - StrToInt(cParamValue)

      else if (cParamName = 'MUTE') then
        SetMute(true)

      else if (cParamName = 'UNMUTE') then
        SetMute(false)

      else if (cParamName = 'TOGGLE_MUTE') then
        ToggleMute

      ; // Add other media keys?


    end;

    if (OriginalVolumeLevel <> VolumeLevel) then
    begin
      if (VolumeLevel < VOL_MIN) then VolumeLevel := VOL_MIN;
      if (VolumeLevel > VOL_MAX) then VolumeLevel := VOL_MAX;
      SetVolume(VolumeLevel);
    end;

  except
    ; // nothing to see here move along...
  end;
end;


end.
