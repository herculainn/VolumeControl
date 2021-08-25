unit CommandLineImpl;

interface

procedure RunCommandLineFunction;

implementation

uses System.SysUtils, GlobalUtils, Winapi.Windows, Messages;

procedure RunCommandLineFunction;
var
  i: integer;
  cParam, cParamName, cParamValue: string;

  bUpdateVolume: Boolean;
  bSendMediaKey: Boolean;
  bChangeMute: Boolean;

  VolumeLevel: Integer;
  MuteValue: Boolean;
  MediaKey: NativeInt;
  MediaTarget: String;
  pTargetProc: String;

begin
  try
    VolumeLevel := GetVolume;
    MediaTarget := '';

    // What do we want to do...

    for i := 2 to ParamCount do // skip "run"
    begin

      cParam      := paramStr(i);
      cParamName  := UpperCase(ParseStr(cParam, '=', 1));
      cParamValue := ParseStr(cParam, '=', 2);

      if (cParamName = 'SET_VOLUME') then
      begin
        bUpdateVolume := True;
        VolumeLevel := StrToInt(cParamValue)
      end

      else if (cParamName = 'INC_VOLUME_BY') then
      begin
        bUpdateVolume := True;
        VolumeLevel := VolumeLevel + StrToInt(cParamValue)
      end

      else if (cParamName = 'DEC_VOLUME_BY') then
      begin
        bUpdateVolume := True;
        VolumeLevel := VolumeLevel - StrToInt(cParamValue)
      end

      else if (cParamName = 'MUTE') then
      begin
        bChangeMute := True;
        MuteValue := True;
      end

      else if (cParamName = 'UNMUTE') then
      begin
        bChangeMute := True;
        MuteValue := False;
      end

      else if (cParamName = 'TOGGLE_MUTE') then
      begin
        ToggleMute; // Just do it here
      end

      else if (cParamName = 'MEDIA_PLAY_PAUSE') then
      begin
        bSendMediaKey := True;
        MediaKey := APPCOMMAND_MEDIA_PLAY_PAUSE;
      end

      else if (cParamName = 'MEDIA_STOP') then
      begin
        bSendMediaKey := True;
        MediaKey := APPCOMMAND_MEDIA_STOP;
      end

      else if (cParamName = 'MEDIA_NEXT_TRACK') then
      begin
        bSendMediaKey := True;
        MediaKey := APPCOMMAND_MEDIA_NEXTTRACK;
      end

      else if (cParamName = 'MEDIA_PREV_TRACK') then
      begin
        bSendMediaKey := True;
        MediaKey := APPCOMMAND_MEDIA_PREVIOUSTRACK;
      end

      else if (cParamName = 'MEDIA_TARGET') then
      begin
        MediaTarget := cParamValue;
      end

      ; // ugly if block you got here

    end;

    // Do things!

    if (bUpdateVolume) then
    begin
      if (VolumeLevel < VOL_MIN) then VolumeLevel := VOL_MIN;
      if (VolumeLevel > VOL_MAX) then VolumeLevel := VOL_MAX;
      SetVolume(VolumeLevel);
    end;

    if (bChangeMute) then
    begin
      SetMute(MuteValue);
    end;

    if (bSendMediaKey) then
    begin
      SendMessageWinAPI(MediaKey, MediaTarget);
    end;

  except
    ; // nothing to see here move along...
  end;
end;


end.
