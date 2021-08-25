# VolumeControl
Delphi Application to control system volume and media on the local machine.  

When using a Remote Desktop, media keys are sent to the remote machine and do not affect the local machine.  
Via another utility on the local machine, such as Corsair iCue or AutoHotKey, we can remap device media keys to run this application instead.  
The keys could be mapped to any relevant function using the command line parameters listed here.

## Commands
Run the application from command line using these parameters:

### Volume

- VolumeControl.exe run SET_VOLUME=69
- VolumeControl.exe run INC_VOLUME=4
- VolumeControl.exe run DEC_VOLUME=20
- VolumeControl.exe run MUTE
- VolumeControl.exe run UNMUTE
- VolumeControl.exe run TOGGLEMUTE

### Media
They use Windows API SendMessage with HWND_BROADCAST.  
This can confuse Spotify sometimes...  

- VolumeControl.exe run MEDIA_PLAY_PAUSE
- VolumeControl.exe run MEDIA_NEXT_TRACK
- VolumeControl.exe run MEDIA_PREV_TRACK
- VolumeControl.exe run MEDIA_STOP

### Media Target
This can make the media keys a little more reliable by focussing the message on specific processes.  

- VolumeControl.exe run MEDIA_TARGET="Spotify.exe"

### C-C-C-Combo
Combine parameters for multiple actions:  

- VolumeControl.exe run MEDIA_PLAY_PAUSE MEDIA_TARGET="Spotify.exe"
- VolumeControl.exe run UNMUTE SET_VOLUME=69

## /UPX
Contains bat file to compress release build. Not required. 
Find UPX executable here: https://upx.github.io/

## Sources
MMDevAPI soolution from https://codeverge.com/embarcadero.delphi.vcl.using/system-audio-volume/1077006  
Icons made by [Vignesh Oviyan](https://www.flaticon.com/authors/vignesh-oviyan) from [www.flaticon.com](https://www.flaticon.com/)  

