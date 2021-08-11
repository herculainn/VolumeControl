program VolumeControl;

{$R 'images.res' 'images.rc'}

uses
  Vcl.Forms,
  System.SysUtils,
  CommandLineImpl in 'CommandLineImpl.pas',
  GlobalUtils in 'GlobalUtils.pas',
  MainForm in 'MainForm.pas' {VolumeControlForm},
  MMDevAPI in 'MMDevAPI.pas';

{$R *.res}

begin

  ActivateEndpointVolume;

  if AnsiUpperCase(ParamStr(1)) = 'RUN' then
  begin

    // Command Line
    RunCommandLineFunction;

  end
  else begin

    // Visual
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TVolumeControlForm, VolumeControlForm);
  Application.Run;

  end;

end.
