unit CtrlProcess;

// Based on: https://www.swissdelphicenter.ch/en/showcode.php?id=2010

interface

uses
  System.Classes;

function BuildPIDList(const aList: TStrings; aFullPath: Boolean): Boolean;
function GetWindowHandlesByProcessName(aProcName: String): TList;

var
  PIDList: TStrings = nil;

const
  RsSystemIdleProcess = 'System Idle Process';
  RsSystemProcess = 'System Process';

implementation

uses
  PsAPI, TlHelp32, System.SysUtils, Winapi.Windows, Vcl.Forms,
  CtrlWindow;

function BuildPIDList(const aList: TStrings; aFullPath: Boolean): Boolean;
var
  SnapProcHandle: THandle;
  ProcEntry: TProcessEntry32;
  NextProc: Boolean;
  FileName: string;
begin
  SnapProcHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  Result := (SnapProcHandle <> INVALID_HANDLE_VALUE);
  if Result then
  begin
    try
      ProcEntry.dwSize := SizeOf(ProcEntry);
      NextProc := Process32First(SnapProcHandle, ProcEntry);
      while NextProc do
      begin
        if ProcEntry.th32ProcessID = 0 then
        begin
          // PID 0 is always the "System Idle Process" but this name cannot be
          // retrieved from the system and has to be fabricated.
          FileName := RsSystemIdleProcess;
        end
        else
        begin
          FileName := ProcEntry.szExeFile;
          if not aFullPath then
            FileName := ExtractFileName(FileName);
        end;
        aList.AddObject(FileName, Pointer(ProcEntry.th32ProcessID));
        NextProc := Process32Next(SnapProcHandle, ProcEntry);
      end;
    finally
      CloseHandle(SnapProcHandle);
    end;
  end;
end;

function ProcessFileName(aPID: DWORD; aFullPath: Boolean): string;
var
  Handle: THandle;
begin
  Result := '';
  Handle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, aPID);
  if Handle <> 0 then
    try
      SetLength(Result, MAX_PATH);
      if aFullPath then
      begin
        if GetModuleFileNameEx(Handle, 0, PChar(Result), MAX_PATH) > 0 then
          SetLength(Result, StrLen(PChar(Result)))
        else
          Result := '';
      end
      else
      begin
        if GetModuleBaseNameW(Handle, 0, PChar(Result), MAX_PATH) > 0 then // GetModuleBaseNameA to GetModuleBaseNameW
          SetLength(Result, StrLen(PChar(Result)))
        else
          Result := '';
      end;
    finally
      CloseHandle(Handle);
    end;
end;

function GetProcessNameFromHandle(aHWND: HWND; const aList: TStrings): string;
var
  PID: DWORD;
  i: Integer;

begin
  Result := '';
  if IsWindow(aHWND) then
  begin
    PID := INVALID_HANDLE_VALUE;
    GetWindowThreadProcessId(aHWND, @PID);
    i := aList.IndexOfObject(Pointer(PID));
    if i > -1 then
      Result := aList[I];
  end;
end;

function GetWindowHandlesByProcessName(aProcName: String): TList;
var
  TopWindow: HWND;
  sProcName: String;
  i: integer;
  resList: TList;

begin
  try
    resList:= TList.Create;
    TopWindow:= Application.Handle;

    i:= 0;
    while (i < WindowList.Count) do
    begin
      try
        sProcName := GetProcessNameFromHandle(HWND(WindowList[i]), PIDList);
        if (UpperCase(sProcName) = UpperCase(aProcName) ) then
        begin
          resList.Add(Pointer(WindowList[i]));
        end;
      except
        ; // Nothing to see here, just move on.. quickly
      end;
      inc(i)
    end;
  finally
    result := resList;
    //resList.Free;
    WindowList.Free;
  end;
end;


initialization

  PIDList := TStringList.Create;
  BuildPIDList(PIDList, True);


end.
