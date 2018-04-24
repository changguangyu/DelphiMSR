unit Unit7;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Math,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm7 = class(TForm)
    Timer1: TTimer;
    LabelCurrentPkg: TLabel;
    LabelTDP: TLabel;
    LabelIsMSR: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

uses WinRing0;

{$R *.dfm}

const
  MSR_RAPL_POWER_UNIT = $606;
  MSR_PKG_ENERGY_STATUS = $611;
  MSR_PKG_POWER_INFO = $614;

var
  Ring0: TWinRing0;

procedure TForm7.FormCreate(Sender: TObject);
var
  LPowerUnit, LTDP: Double;

  leax, ledx: Cardinal;
begin

  if Ring0.IsMsr then
  begin
    // Get units
    Ring0.Rdmsr(MSR_RAPL_POWER_UNIT, leax, ledx);
    LPowerUnit := 1 shl (leax and $F);
    // Get power defaults for this SKU
    Ring0.Rdmsr(MSR_PKG_POWER_INFO, leax, ledx);
    LTDP := leax and $7FFF;

    // 输出TDP
    LabelTDP.Caption := ((LTDP / LPowerUnit).ToString + ' W');
    // 支持的处理器
    LabelIsMSR.Caption := 'True';
  end
  else
  begin
    // 输出TDP
    LabelTDP.Caption := '0 W';
    // 支持的处理器
    LabelIsMSR.Caption := 'False';
  end;

end;

var
  LastPkgEnergy: Cardinal;

procedure TForm7.Timer1Timer(Sender: TObject);
var
  leax, ledx: Cardinal;
  LEnergyStatusUnits: Double;
  LCurrent: Cardinal;
  LPkg: String;
begin
  // Get Energy Status Units
  Ring0.Rdmsr(MSR_RAPL_POWER_UNIT, leax, ledx);
  LEnergyStatusUnits := 1 / Power(2, ((leax and $1F00) shr 8));
  // Read MSR_PKG_ENERGY_STATUS
  Ring0.Rdmsr(MSR_PKG_ENERGY_STATUS, leax, ledx);
  // calc increment
  LCurrent := leax - LastPkgEnergy;

  if LastPkgEnergy <> 0 then
  begin
    LPkg := FormatFloat('0.00', LCurrent * LEnergyStatusUnits);
    LabelCurrentPkg.Caption := LPkg + ' W';
  end;

  // save
  LastPkgEnergy := leax;
end;

initialization

Ring0 := TWinRing0.Create;

finalization

Ring0.Free;

end.
