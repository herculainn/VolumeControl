program VolumeControl;

{$R 'images.res' 'images.rc'}

uses
  Vcl.Forms,
  System.SysUtils,
  System.Classes,
  winapi.Windows,
  CommandLineImpl in 'CommandLineImpl.pas',
  GlobalUtils in 'GlobalUtils.pas',
  MainForm in 'MainForm.pas' {VolumeControlForm},
  MMDevAPI in 'MMDevAPI.pas',
  CtrlProcess in 'CtrlProcess.pas',
  CtrlWindow in 'CtrlWindow.pas';

{$R *.res}

begin

  if AnsiUpperCase(ParamStr(1)) = 'RUN' then
  begin

    // CLI
    RunCommandLineFunction;

  end
  else begin

    // GUI
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TVolumeControlForm, VolumeControlForm);
    Application.Run;

  end;

end.
