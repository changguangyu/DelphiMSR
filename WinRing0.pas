unit WinRing0;

interface

uses Winapi.Windows, System.SysUtils;

type
  TWinRing0 = class
  const
    dllNameX64 = 'WinRing0x64.dll';
    dllName = 'WinRing0.dll';
  public type
    TStatus = (NO_ERROR = 0, DLL_NOT_FOUND = 1, DLL_INCORRECT_VERSION = 2,
      DLL_INITIALIZE_ERROR = 3);

    TOlsDllStatus = (OLS_DLL_NO_ERROR = 0, OLS_DLL_UNSUPPORTED_PLATFORM = 1,
      OLS_DLL_DRIVER_NOT_LOADED = 2, OLS_DLL_DRIVER_NOT_FOUND = 3,
      OLS_DLL_DRIVER_UNLOADED = 4, OLS_DLL_DRIVER_NOT_LOADED_ON_NETWORK = 5,
      OLS_DLL_UNKNOWN_ERROR = 6);

    TOlsDriverType = (OLS_DRIVER_TYPE_UNKNOWN = 0, OLS_DRIVER_TYPE_WIN_9X = 1,
      OLS_DRIVER_TYPE_WIN_NT = 2, OLS_DRIVER_TYPE_WIN_NT4 = 3 { Obsolete } ,
      OLS_DRIVER_TYPE_WIN_NT_X64 = 4, OLS_DRIVER_TYPE_WIN_NT_IA64 = 5);

    TGetDllStatus = function: DWORD; stdcall;
    TGetDriverType = function: DWORD; stdcall;
    TGetDllVersion = function(var major, minor, revision, release: Byte)
      : DWORD; stdcall;
    TGetDriverVersion = function(var major, minor, revision, release: Byte)
      : DWORD; stdcall;
    TInitializeOls = function: BOOL; stdcall;
    TDeinitializeOls = procedure; stdcall;
    TIsMsr = function: BOOL; stdcall;
    TRdmsr = function(index: DWORD; var eax: DWORD; var edx: DWORD)
      : BOOL; stdcall;
    TRdmsrTx = function(index: DWORD; var eax: DWORD; var edx: DWORD;
      threadAffinityMask: DWORD_PTR): BOOL; stdcall;
    TRdmsrPx = function(index: DWORD; var eax: DWORD; var edx: DWORD;
      processAffinityMask: DWORD_PTR): BOOL; stdcall;
    TWrmsr = function(index: DWORD; eax: DWORD; edx: DWORD): BOOL; stdcall;
    TWrmsrTx = function(index: DWORD; eax: DWORD; edx: DWORD;
      threadAffinityMask: DWORD_PTR): BOOL; stdcall;
    TWrmsrPx = function(index: DWORD; eax: DWORD; edx: DWORD;
      processAffinityMask: DWORD_PTR): BOOL; stdcall;
  private
    FModule: THandle;
    FStatus: TStatus;
    FGetDllStatus: TGetDllStatus;
    FGetDriverType: TGetDriverType;
    FGetDllVersion: TGetDllVersion;
    FGetDriverVersion: TGetDriverVersion;
    FInitializeOls: TInitializeOls;
    FDeinitializeOls: TDeinitializeOls;
    FIsMsr: TIsMsr;
    FRdmsr: TRdmsr;
    FWrmsr: TWrmsr;
    FRdmsrPx: TRdmsrPx;
    FRdmsrTx: TRdmsrTx;
    FWrmsrPx: TWrmsrPx;
    FWrmsrTx: TWrmsrTx;
  public
    // -----------------------------------------------------------------------------
    // DLL Information
    // -----------------------------------------------------------------------------
    property GetDllStatus: TGetDllStatus read FGetDllStatus;
    property GetDriverType: TGetDriverType read FGetDriverType;
    property GetDllVersion: TGetDllVersion read FGetDllVersion;
    property GetDriverVersion: TGetDriverVersion read FGetDriverVersion;
    property InitializeOls: TInitializeOls read FInitializeOls;
    property DeinitializeOls: TDeinitializeOls read FDeinitializeOls;
    // -----------------------------------------------------------------------------
    // CPU MSR
    // -----------------------------------------------------------------------------
    property IsMsr: TIsMsr read FIsMsr;
    property Rdmsr: TRdmsr read FRdmsr;
    property RdmsrTx: TRdmsrTx read FRdmsrTx;
    property RdmsrPx: TRdmsrPx read FRdmsrPx;
    property Wrmsr: TWrmsr read FWrmsr;
    property WrmsrTx: TWrmsrTx read FWrmsrTx;
    property WrmsrPx: TWrmsrPx read FWrmsrPx;
    constructor Create;
    destructor Destroy; override;
    function GetStatus: TStatus;
  end;

implementation

{ TWinRing0 }

constructor TWinRing0.Create;
var
  LFileName: String;
begin
{$IFDEF WIN64}
  LFileName := dllNameX64;
{$ELSE}
  LFileName := dllName;
{$ENDIF}
  FModule := LoadLibrary(PWideChar(LFileName));

  if FModule = 0 then
  begin
    FStatus := TStatus.DLL_NOT_FOUND;
  end
  else
  begin
    // 获取导出函数
    FGetDllStatus := GetProcAddress(FModule, 'GetDllStatus');
    FGetDllVersion := GetProcAddress(FModule, 'GetDllVersion');
    FGetDriverVersion := GetProcAddress(FModule, 'GetDriverVersion');
    FGetDriverType := GetProcAddress(FModule, 'GetDriverType');

    FInitializeOls := GetProcAddress(FModule, 'InitializeOls');
    FDeinitializeOls := GetProcAddress(FModule, 'DeinitializeOls');

    FIsMsr := GetProcAddress(FModule, 'IsMsr');
    FRdmsr := GetProcAddress(FModule, 'Rdmsr');
    FRdmsrPx := GetProcAddress(FModule, 'RdmsrPx');
    FRdmsrTx := GetProcAddress(FModule, 'RdmsrTx');
    FWrmsr := GetProcAddress(FModule, 'Wrmsr');
    FWrmsrPx := GetProcAddress(FModule, 'WrmsrPx');
    FWrmsrTx := GetProcAddress(FModule, 'WrmsrTx');

    // Check Functions
    if (not(Assigned(FGetDllStatus) and Assigned(FGetDllVersion) and
      Assigned(FGetDriverVersion) and Assigned(FGetDriverType) and
      Assigned(FInitializeOls) and Assigned(FDeinitializeOls) and
      Assigned(FIsMsr) and Assigned(FRdmsr) and Assigned(FRdmsrPx) and
      Assigned(FRdmsrTx) and Assigned(FWrmsr) and Assigned(FWrmsrPx) and
      Assigned(FWrmsrTx))) then
    begin
      FStatus := TStatus.DLL_INCORRECT_VERSION;
    end;

    if not FInitializeOls() then
    begin
      FStatus := TStatus.DLL_INITIALIZE_ERROR;
    end;
  end;
end;

destructor TWinRing0.Destroy;
begin
  if FModule <> 0 then
  begin
    FDeinitializeOls();
    FreeLibrary(FModule);
    FModule := 0;
  end;

  inherited;
end;

function TWinRing0.GetStatus: TStatus;
begin
  result := FStatus;
end;

end.
