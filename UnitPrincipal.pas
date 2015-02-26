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

unit UnitPrincipal;

interface

uses
//Uses Delphi
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxGroupBox, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, Menus, StdCtrls, cxButtons, cxSplitter,
  cxTextEdit, cxMemo, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGrid, uQuantumGrid, cxLabel,
  cxBarEditItem, dxBar, ImgList, atScript, atPascal, AdvMemo, AdvmPS,
  atMemoInterface, DB, cxDBData, cxGridDBTableView, dxRibbon, dxRibbonForm,
//Uses Programa
  UnitEquipe_;


type
  TfrmPrincipal = class(TdxRibbonForm)
    cxGroupBox1: TcxGroupBox;
    qgCampoB: TcxGrid;
    tbFields: TcxGridTableView;
    lvFields: TcxGridLevel;
    tbLinha: TcxGridColumn;
    tbResultado: TcxGridColumn;
    tbPalavra: TcxGridColumn;
    tbReconhecimento: TcxGridColumn;
    dxBarManager1: TdxBarManager;
    dxRibbon1: TdxRibbon;
    cxMCampoA: TcxMemo;
    cxGroupBox2: TcxGroupBox;
    cxbAnalisar: TcxButton;
    cxbLimpar: TcxButton;
    cxEquipe: TcxButton;
    dxBarManager1Bar1: TdxBar;
    dxBarButton1: TdxBarButton;
    procedure cxbAnalisarClick(Sender: TObject);
    procedure cxbLimparClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxEquipeClick(Sender: TObject);

  private
    { Private declarations }
    {Insere valores no Grid da tela}
    procedure plInsereValores;
    {Limpa tela}
    procedure plApagaValores;
    {Aplica algoritmo especifico para linguagem}
    procedure plReconhecePalavra(const csPalavra : String; var vsResultado, vsReconheci : String);
    {Separa palavras para serem analisadas.}
    procedure plAnalisadorGeral;
    {Trata estado de erro e verifica qual mensagens aplicar a palavra.}
    procedure plEstadoDeErro(Const csPalavraErro : String; var viEstado : Integer; var vsResult : String);
  public
    { Public declarations }
  end;

  TClassPalavras = class
    pLinha     : Integer;
    pResult    : String;
    pPalavra   : String;
    pReconheci : String;
  end;
var
  frmPrincipal        : TfrmPrincipal;
  frmEquipe           : TfrmEquipe_;
  FClassPalavras      : TClassPalavras;
  loListaPalavras     : TStringList;
implementation

{$R *.dfm}

procedure TfrmPrincipal.plInsereValores;
var
 liInd,
 liIndAux : integer;
begin
  tbFields.DataController.BeginUpdate;
  liInd  := 0;
  while  (liInd < loListaPalavras.Count) do
          begin
            liIndAux := tbFields.DataController.AppendRecord;
            tbFields.DataController.Values[liIndAux, tbLinha.Index]          := TClassPalavras(loListaPalavras.Objects[liInd]).pLinha;;
            tbFields.DataController.Values[liIndAux, tbResultado.Index]      := TClassPalavras(loListaPalavras.Objects[liInd]).pResult;;
            tbFields.DataController.Values[liIndAux, tbPalavra.Index]        := TClassPalavras(loListaPalavras.Objects[liInd]).pPalavra;;
            tbFields.DataController.Values[liIndAux, tbReconhecimento.Index] := TClassPalavras(loListaPalavras.Objects[liInd]).pReconheci;;
            Inc(liInd)
          end;
  tbFields.DataController.EndUpdate;
end;
procedure TfrmPrincipal.cxbAnalisarClick(Sender: TObject);
begin
  plAnalisadorGeral;
  plInsereValores;
  tbFields.ApplyBestFit;
end;

procedure TfrmPrincipal.plApagaValores;
var
 liInd : integer;
begin
  tbFields.DataController.BeginUpdate;
  for liInd := tbFields.DataController.RecordCount - 1 downto 0 do
      tbFields.DataController.DeleteRecord(liInd);
  tbFields.DataController.EndUpdate;
  cxMCampoA.Clear;
end;

procedure TfrmPrincipal.cxbLimparClick(Sender: TObject);
begin
  plApagaValores;
end;

procedure TfrmPrincipal.plAnalisadorGeral;
var
 liindPlinha,
 liCrtDeleta,
 liIndChave          : Integer;
 lsPLinhacxM,
 lsChave,
 lsPPronta,
 lsResultado,
 lsReconheci         : String;
begin
  liindPlinha     := 0;
  liIndChave      := 1;
  loListaPalavras := TStringList.Create;

//verifica palavras digitadas
  while liindPlinha < cxMCampoA.Lines.Count do
        begin
          lsPLinhacxM := Trim(copy(cxMCampoA.Lines.Strings[liindPlinha],1, Length(cxMCampoA.Lines.Strings[liindPlinha]))); //pega linha e palavras
          while Trim(lsPLinhacxM) <> EmptyStr do
                begin
                  liCrtDeleta := Pos(' ', lsPLinhacxM);

                  Delete(lsPLinhacxM, liCrtDeleta, 1);
                  lsPPronta := copy(lsPLinhacxM ,1, liCrtDeleta-1);

                  If (lsPPronta <> EmptyStr)
                  Or ((lsPLinhacxM <> EmptyStr) and (liCrtDeleta = 0)) then
                      begin
                        //Ultima palavra da linha.
                        If   liCrtDeleta = 0 then
                             begin
                               lsPPronta   := lsPLinhacxM;
                               lsPLinhacxM := EmptyStr;
                             end;

                        FClassPalavras            := TClassPalavras.Create;
                        FClassPalavras.pLinha     := liindPlinha+1;
                        FClassPalavras.pPalavra   := lsPPronta;

                        //Inicio - Faz reconhecimento da palavra.
                        plReconhecePalavra(lsPPronta, lsResultado, lsReconheci);
                        //Fim - Faz reconhecimento da palavra.

                        //Tirar ultima virgula
                        Delete(lsReconheci, Length(lsReconheci), 1);

                        FClassPalavras.pResult    := lsResultado;
                        FClassPalavras.pReconheci := lsReconheci;
                        lsChave := IntToStr(liIndChave);
                        loListaPalavras.AddObject(lsChave, FClassPalavras);
                        Inc(liIndChave);
                      end;
                   lsPLinhacxM :=  copy(lsPLinhacxM, liCrtDeleta, Length(lsPLinhacxM));
                end;
          inc(liindPlinha);
        end;
end;

procedure TfrmPrincipal.plReconhecePalavra(const csPalavra : String; var vsResultado, vsReconheci : String);
var
 CrtEstado,
 liAux      : Integer;
begin
  CrtEstado   := 0;
  liAux       := 1;
  vsReconheci := 'e0,';
  vsResultado := 'palavra válida';

  Repeat//Algoritmo especifico mostrado em sala!
  while (CrtEstado = 0) And (csPalavra[liAux] <> '') do
        begin
         case csPalavra[liAux] of
           'a' : begin
                   CrtEstado := 1;
                   vsReconheci := vsReconheci+'e'+IntToStr(CrtEstado)+',';
                 end;
           'b' : begin
                   CrtEstado := 2;
                   vsReconheci := vsReconheci+'e'+IntToStr(CrtEstado)+',';
                 end;
         else
           begin
             plEstadoDeErro(csPalavra, CrtEstado, vsResultado);
             vsReconheci := vsReconheci+'e(erro),';
           end;
         end;
         if liAux <= Length(csPalavra) then
            inc(liAux)
       end;

  while (CrtEstado = 1) And (csPalavra[liAux] <> '') do
        begin
         case csPalavra[liAux] of
           'a' : begin
                   CrtEstado := 4;
                   vsReconheci := vsReconheci+'e'+IntToStr(CrtEstado)+',';
                 end;
           'b' : begin
                   CrtEstado := 2;
                   vsReconheci := vsReconheci+'e'+IntToStr(CrtEstado)+',';
                 end;
         else
           begin
             plEstadoDeErro(csPalavra, CrtEstado, vsResultado);
             vsReconheci := vsReconheci+'e(erro),';
           end;
         end;
         if liAux <= Length(csPalavra) then
            inc(liAux)
       end;

  while (CrtEstado = 2) And (csPalavra[liAux] <> '') do
        begin
         case csPalavra[liAux] of
           'a' : begin
                  CrtEstado := 1;
                  vsReconheci := vsReconheci+'e'+IntToStr(CrtEstado)+',';
                 end;
           'b' : begin
                   CrtEstado := 3;
                   vsReconheci := vsReconheci+'e'+IntToStr(CrtEstado)+',';
                 end;
         else
           begin
             plEstadoDeErro(csPalavra, CrtEstado, vsResultado);
             vsReconheci := vsReconheci+'e(erro),';
           end;
         end;
         if liAux <= Length(csPalavra) then
            inc(liAux)
       end;

  while (CrtEstado = 3) And (csPalavra[liAux] <> '') do
        begin
         case csPalavra[liAux] of
           'a' : begin
                   CrtEstado := 1;
                   vsReconheci := vsReconheci+'e'+IntToStr(CrtEstado)+',';
                 end;
         //'b' : CrtEstado := Não tem transação de reconhecimento!;
         else
           begin
             plEstadoDeErro(csPalavra, CrtEstado, vsResultado);
             vsReconheci := vsReconheci+'e(erro),';
           end;
         end;
         if liAux <= Length(csPalavra) then
            inc(liAux)
       end;

  while (CrtEstado = 4) And (csPalavra[liAux] <> '') do
        begin
         case csPalavra[liAux] of
           'a' : begin
                   CrtEstado := 4;
                   vsReconheci := vsReconheci+'e'+IntToStr(CrtEstado)+',';
                 end;
           'b' : begin
                   CrtEstado := 2;
                   vsReconheci := vsReconheci+'e'+IntToStr(CrtEstado)+',';
                 end;
         else
           begin
             plEstadoDeErro(csPalavra, CrtEstado, vsResultado);
             vsReconheci := vsReconheci+'e(erro),';
           end;

         end;
         if liAux <= Length(csPalavra) then
            inc(liAux)
       end;

  If   (CrtEstado = 99) and (csPalavra[liAux] <> '') then
       begin
        vsReconheci := vsReconheci+'e(erro),';
        inc(liAux);
       end;
  until csPalavra[liAux] = '';
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FClassPalavras);
  FreeAndNil(loListaPalavras);
  FreeAndNil(frmEquipe_);
end;

procedure TfrmPrincipal.cxEquipeClick(Sender: TObject);
begin
  frmEquipe := TfrmEquipe_.Create(Self);
  frmEquipe.ShowModal;
end;

procedure TfrmPrincipal.plEstadoDeErro(const csPalavraErro: String; var viEstado: Integer; var vsResult: String);
begin
  If   csPalavraErro[1] in ['a','b'] then
       vsResult := 'erro: palavra inválida'
  else
    vsResult := 'erro: simbolo(s) invalido(s)';
  viEstado := 99; //erro
end;

end.



