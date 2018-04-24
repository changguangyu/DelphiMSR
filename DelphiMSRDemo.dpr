program DelphiMSRDemo;

uses
  Vcl.Forms,
  Unit7 in 'Unit7.pas' {Form7},
  WinRing0 in 'WinRing0.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm7, Form7);
  Application.Run;
end.
