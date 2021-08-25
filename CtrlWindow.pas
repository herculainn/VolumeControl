unit CtrlWindow;

// Based on: http://www.delphigroups.info/2/08/483794.html

interface

uses
  System.Classes, Winapi.Windows;

  function GetWindows(Handle: HWND; Info: Pointer): BOOL; stdcall;

var
  WindowList: TList = nil; // Need global Access for WinAPI

implementation

uses
  Vcl.Forms, System.SysUtils;

function GetWindows(Handle: HWND; Info: Pointer): BOOL; stdcall;
begin
  Result:= True;
  WindowList.Add(Pointer(Handle));
end;

function GetWindowHandleByTitle(const TitleName: string): HWND;
begin
  Result := Winapi.Windows.FindWindow(nil, PChar(TitleName));
end;

function GetFirstWindowHandleByPartialTitle(windowtitle: string): TList;
var
  h, TopWindow: HWND;
  dWinText: array[0..255] of char;
  i: integer;
  sWinText: string;
  resList: TList;

begin
  try
    resList:= TList.Create;
    TopWindow:= Application.Handle;
    i:= 0;
    while (i < WindowList.Count) do
    begin
      try
        if GetWindowText(HWND(WindowList[i]), dWinText, 255) > 0 then
        begin
          sWinText := StrPas(dWinText);
          if length(sWinText) > 0 then
          begin
            if (Pos(UpperCase(Windowtitle), UpperCase(sWinText)) >= 1) then
            begin
              h := HWND(WindowList[i]);
              if IsWindow(h) then
                resList.Add(Pointer(WindowList[i]))
            end
          end;
        end;
      except
        ; // Nothing to see here, ahem...
      end;
      inc(i)
    end;
  finally
    result := resList;
  end;
end;

initialization

  WindowList:= TList.Create;
  EnumWindows(@GetWindows, LongInt(@Application.Handle));


end.
