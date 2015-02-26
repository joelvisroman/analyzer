{
@abstract(Trabalho 2 de Linguagens Formais)
@author (Joelvis Roman(joelvis.roman@gmail.com)
         André Seiji Kono(andseiji@gmail.com)
@created(28/10/2010)
@lastmod(05/11/2010)
*******************************************************
* Unit Principal do reconhecedor de linguagem regular *
*******************************************************
}
unit UnitEquipe_;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxBar, cxClasses, dxRibbon, Menus, cxButtons,dxRibbonForm;

type
  TfrmEquipe_ = class(TdxRibbonForm)
    dxBarManager1: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    dxBarButton1: TdxBarButton;
    cxbLimpar: TcxButton;
    cxEquipe: TcxButton;
    dxRibbon1: TdxRibbon;
    procedure cxEquipeClick(Sender: TObject);
    procedure cxbLimparClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEquipe_: TfrmEquipe_;

implementation

{$R *.dfm}

procedure TfrmEquipe_.cxEquipeClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEquipe_.cxbLimparClick(Sender: TObject);
begin
  close;
end;

end.
