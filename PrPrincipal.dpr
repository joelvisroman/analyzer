program PrPrincipal;

uses
  Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {frmPrincipal},
  UnitEquipe_ in 'UnitEquipe_.pas' {frmEquipe_};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmEquipe_, frmEquipe_);
  Application.Run;
end.
