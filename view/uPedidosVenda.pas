unit uPedidosVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB, Datasnap.DBClient,
  Data.DBXMySQL, Data.SqlExpr;

type
  TfrmPedidosVenda = class(TForm)
    pnlFundo: TPanel;
    edtNumPedido: TEdit;
    edtCodCliente: TEdit;
    edtCodProd: TEdit;
    lblNumPedido: TLabel;
    lblCodCliente: TLabel;
    edtNomeCliente: TEdit;
    edtDescricao: TEdit;
    lblProduto: TLabel;
    lblQuantidade: TLabel;
    lblVlrUnitario: TLabel;
    btnAdicionar: TBitBtn;
    dbgProdutos: TDBGrid;
    pnlBotoes: TPanel;
    lblTotalPedido: TLabel;
    btnConsulta: TBitBtn;
    btnCancelar: TBitBtn;
    btnGravar: TBitBtn;
    btnInserir: TBitBtn;
    cdsProdutos: TClientDataSet;
    dsProdutos: TDataSource;
    cdsProdutosCodProd: TIntegerField;
    cdsProdutosDescricao: TStringField;
    cdsProdutosQuantidade: TIntegerField;
    cdsProdutosVlrUnitario: TFloatField;
    cdsProdutosVlrTotal: TFloatField;
    btnDeletar: TBitBtn;
    edtQuantidade: TEdit;
    edtVlrUnitario: TEdit;
    procedure edtNumPedidoKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodClienteKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodProdKeyPress(Sender: TObject; var Key: Char);
    procedure btnInserirClick(Sender: TObject);
    procedure btnConsultaClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtCodClienteExit(Sender: TObject);
    procedure edtCodProdExit(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure dbgProdutosDblClick(Sender: TObject);
    procedure edtNumPedidoExit(Sender: TObject);
    procedure edtCodClienteEnter(Sender: TObject);
    procedure edtCodProdEnter(Sender: TObject);
    procedure edtNumPedidoEnter(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnDeletarClick(Sender: TObject);
    procedure edtQuantidadeKeyPress(Sender: TObject; var Key: Char);
    procedure edtVlrUnitarioKeyPress(Sender: TObject; var Key: Char);
    procedure edtVlrUnitarioExit(Sender: TObject);
  private
     vOpcaoTela: string;
     vKey: Word;
     vAlteracao: Boolean;
     vValorTotal: Double;
     vOnMessageBkp: TMessageEvent;
    function somenteNumeros(pKey: char): Boolean;
    procedure tratamentoTela;
    procedure buscaCliente(pCodCliente: string);
    procedure buscaProduto;
    function validaCampos: Boolean;
    function validaCodCliente: Boolean;
    function validaCodProd: Boolean;
    function validaQuantidade: Boolean;
    function validaVlrUnitario: Boolean;
    procedure adicionaProduto;
    procedure limpaCampos;
    function salvarDados: Boolean;
    procedure consultaPedido;
    function validaNumPedido: Boolean;
    procedure scrollDbGrid(var Msg: TMsg; var Handled: Boolean);
    function buscaNumPedido: Integer;
    procedure deletarPedido;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPedidosVenda: TfrmPedidosVenda;

implementation

uses
   uClienteController, uCliente, uProdutos, uProdutosController, uCabecalhoPedido,
   uItensPedido, uCabecalhoPedidoController, uItensPedidoController;

{$R *.dfm}

procedure TfrmPedidosVenda.btnAdicionarClick(Sender: TObject);
begin
   if validaCampos then
      adicionaProduto;
end;

procedure TfrmPedidosVenda.btnCancelarClick(Sender: TObject);
begin
   vOpcaoTela := 'C';
   tratamentoTela;
end;

procedure TfrmPedidosVenda.btnConsultaClick(Sender: TObject);
begin
   vOpcaoTela := 'P';
   tratamentoTela;
end;

procedure TfrmPedidosVenda.btnDeletarClick(Sender: TObject);
begin
   if vOpcaoTela = 'P' then
      deletarPedido
   else
   begin
      vOpcaoTela := 'E';
      tratamentoTela;
   end;
end;

procedure TfrmPedidosVenda.btnGravarClick(Sender: TObject);
begin
   vOpcaoTela := 'G';
   begin
      if salvarDados then
         tratamentoTela;
   end;
end;

procedure TfrmPedidosVenda.btnInserirClick(Sender: TObject);
begin
   vOpcaoTela := 'I';
   tratamentoTela;
   edtNumPedido.Text := IntToStr(buscaNumPedido + 1);
end;

procedure TfrmPedidosVenda.edtCodClienteEnter(Sender: TObject);
begin
   vKey := 0;
end;

procedure TfrmPedidosVenda.edtCodClienteExit(Sender: TObject);
begin
   if (vKey = 13) and (edtCodCliente.Text <> '') then
      buscaCliente(edtCodCliente.Text);
end;

procedure TfrmPedidosVenda.edtCodClienteKeyPress(Sender: TObject;
  var Key: Char);
begin
   if not SomenteNumeros(Key) then
      Key := #0;
   if edtCodCliente.Text = '' then
      edtNomeCliente.Text := '';
end;

procedure TfrmPedidosVenda.edtCodProdEnter(Sender: TObject);
begin
   vKey := 0;
end;

procedure TfrmPedidosVenda.edtCodProdExit(Sender: TObject);
begin
   if (vKey = 13) and (edtCodProd.Text <> '') then
      buscaProduto;
end;

procedure TfrmPedidosVenda.edtCodProdKeyPress(Sender: TObject; var Key: Char);
begin
   if not SomenteNumeros(Key) then
      Key := #0;
   if edtCodProd.Text = '' then
      edtDescricao.Text := '';
end;

procedure TfrmPedidosVenda.edtNumPedidoEnter(Sender: TObject);
begin
   vKey := 0;
end;

procedure TfrmPedidosVenda.edtNumPedidoExit(Sender: TObject);
begin
   if (vKey = 13) then
      if (vOpcaoTela = 'P') then
         consultaPedido
      else
         deletarPedido;
end;

procedure TfrmPedidosVenda.edtNumPedidoKeyPress(Sender: TObject; var Key: Char);
begin
   if not SomenteNumeros(Key) then
      Key := #0;
end;

procedure TfrmPedidosVenda.edtQuantidadeKeyPress(Sender: TObject;
  var Key: Char);
begin
   if not SomenteNumeros(Key) then
      Key := #0;
end;

procedure TfrmPedidosVenda.edtVlrUnitarioExit(Sender: TObject);
begin
   if edtVlrUnitario.Text <> '' then
      edtVlrUnitario.Text := FormatFloat('###,##0.00', StrToFloat(edtVlrUnitario.Text));
end;

procedure TfrmPedidosVenda.edtVlrUnitarioKeyPress(Sender: TObject;
  var Key: Char);
begin
   if not SomenteNumeros(Key) then
      Key := #0;
end;

function TfrmPedidosVenda.SomenteNumeros(pKey: char): Boolean;
begin
   Result := True;

   if (pKey in ['0'..'9'] = false) and
      (Word(pKey) <> VK_Back) and
      (Word(pKey) <> VK_Return) and
      (pKey in [','] = False) then
      Result := False;
end;

procedure TfrmPedidosVenda.tratamentoTela;
begin
   if vOpcaoTela = 'I' then
   begin
      btnConsulta.Enabled := False;
      pnlFundo.Enabled := True;
      edtNumPedido.Enabled := False;
      edtNomeCliente.Enabled := False;
      edtDescricao.Enabled := False;
      btnCancelar.Enabled := True;
      btnGravar.Enabled := True;
      edtCodProd.Enabled := True;
      edtCodCliente.Enabled := True;
      edtQuantidade.Enabled := True;
      edtVlrUnitario.Enabled := True;
      btnAdicionar.Enabled := True;
      btnInserir.Enabled := False;
      btnDeletar.Enabled := False;
      dbgProdutos.Enabled := True;

      if edtCodCliente.CanFocus then
         edtCodCliente.SetFocus;
   end
   else
   if vOpcaoTela = 'P' then
   begin
      pnlFundo.Enabled := True;
      btnGravar.Enabled := False;
      btnInserir.Enabled := False;
      edtNumPedido.Enabled := True;
      btnCancelar.Enabled := True;
      btnConsulta.Enabled := False;
      dbgProdutos.Enabled := False;
      btnDeletar.Enabled := True;

      if edtNumPedido.CanFocus then
         edtNumPedido.SetFocus;
   end
   else
   if vOpcaoTela = 'E' then
   begin
      pnlFundo.Enabled := True;
      btnGravar.Enabled := False;
      btnCancelar.Enabled := True;
      btnInserir.Enabled := False;
      edtNumPedido.Enabled := True;
      btnConsulta.Enabled := False;
      dbgProdutos.Enabled := False;
      btnDeletar.Enabled := False;

      if edtNumPedido.CanFocus then
         edtNumPedido.SetFocus;
   end
   else
   begin
      limpaCampos;
      edtNomeCliente.Enabled := False;
      edtDescricao.Enabled := False;
      pnlFundo.Enabled := False;
      btnGravar.Enabled := False;
      btnCancelar.Enabled := False;
      btnInserir.Enabled := True;
      btnConsulta.Enabled := True;
      edtCodProd.Enabled := False;
      edtCodCliente.Enabled := False;
      edtQuantidade.Enabled := False;
      edtVlrUnitario.Enabled := False;
      btnAdicionar.Enabled := False;
      edtNumPedido.Enabled := False;
      dbgProdutos.Enabled := False;
      btnDeletar.Enabled := True;
   end;
end;

procedure TfrmPedidosVenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Application.OnMessage := vOnMessageBkp;
end;

procedure TfrmPedidosVenda.FormCreate(Sender: TObject);
begin
   vOpcaoTela := '';
   vValorTotal := 0;
   tratamentoTela;
   vOnMessageBkp := Application.OnMessage;
   Application.OnMessage := scrollDbGrid;
end;

procedure TfrmPedidosVenda.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := Key;

   case vKey of
      VK_RETURN:
      begin
         if (ActiveControl <> dbgProdutos) then
            Perform(WM_NextDlgCtl, 0, 0)
         else
            dbgProdutosDblClick(dbgProdutos);
      end;

      VK_ESCAPE:
         if MessageDlg('Deseja fechar a tela?', mtConfirmation,
            [mbYes, mbNo], 0) = mrYes then
            Close;

      VK_UP :
      begin
         vKey := VK_CLEAR;
         if (ActiveControl <> dbgProdutos)then
            Perform(WM_NextDlgCTL,1,0);
      end;

      VK_DELETE:
      begin
         if MessageDlg('Deseja realmente deletar este registro?', mtConfirmation,
            [mbYes, mbNo], 0) = mrYes then
         begin
            vValorTotal := vValorTotal - cdsProdutos.FieldByName('VlrTotal').AsFloat;
            lblTotalPedido.Caption := 'R$ ' + FormatFloat('0.00', vValorTotal);
            dbgProdutos.DataSource.DataSet.Delete;
         end;
      end;
   end;
end;

procedure TfrmPedidosVenda.buscaCliente(pCodCliente: string);
var
   xCliente: TCliente;
begin
   try
      try
         xCliente := nil;
         xCliente := TClienteController.get.buscaCliente(pCodCliente);

         if xCliente <> nil then
            edtNomeCliente.Text := xCliente.Nome
         else
            MessageDlg('Cliente n�o cadastrado!', mtWarning,[mbOk],0);
      finally
         if xCliente <> nil then
            FreeAndNil(xCliente);
      end;
   except
      on E : Exception do
         MessageDlg(e.Message, mtError,[mbOk],0);
   end;
end;

procedure TfrmPedidosVenda.buscaProduto;
var
   xProdutos: TProdutos;
begin
   try
      try
         xProdutos := nil;
         xProdutos := TProdutosController.get.buscaProduto(edtCodProd.Text);

         if xProdutos <> nil then
         begin
            edtDescricao.Text := xProdutos.Descricao;
            edtVlrUnitario.Text := FormatFloat('###,##0.00', xProdutos.PrecoVenda);
         end
         else
            MessageDlg('Produto n�o cadastrado!', mtWarning,[mbOk],0);
      finally
         if xProdutos <> nil then
            FreeAndNil(xProdutos);
      end;
   except
      on E : Exception do
         MessageDlg(e.Message, mtError,[mbOk],0);
   end;
end;

procedure TfrmPedidosVenda.dbgProdutosDblClick(Sender: TObject);
begin
   vAlteracao := True;
   edtCodProd.Text := IntToStr(cdsProdutos.FieldByName('CodProd').AsInteger);
   edtDescricao.Text := cdsProdutos.FieldByName('Descricao').AsString;
   edtQuantidade.Text := cdsProdutos.FieldByName('Quantidade').AsString;
   edtVlrUnitario.Text := FormatFloat('###,##0.00', cdsProdutos.FieldByName('VlrUnitario').AsFloat);
   edtCodProd.Enabled := False;
   vValorTotal := vValorTotal - cdsProdutos.FieldByName('VlrTotal').AsFloat;
end;

function TfrmPedidosVenda.validaCampos: Boolean;
var
   xMsgmCampoVazio: string;
begin
   Result := False;

   if (not validaCodCliente) or
      (not validaCodProd) or
      (not validaQuantidade) or
      (not validaVlrUnitario) then
      Exit;

   Result := True;
end;

function TfrmPedidosVenda.validaCodProd: Boolean;
begin
   Result := False;

   if (edtCodProd.Text = '') or (edtDescricao.Text = '') then
   begin
      MessageDlg('Digite um c�digo de produto v�lido!', mtWarning,[mbOk],0);
      if edtCodProd.CanFocus then
         edtCodProd.SetFocus;
      Exit;
   end;

   Result := True;
end;

function TfrmPedidosVenda.validaCodCliente: Boolean;
begin
   Result := False;

   if (edtCodCliente.Text = '') or (edtNomeCliente.Text = '') then
   begin
      MessageDlg('Digite um c�digo de cliente v�lido!', mtWarning,[mbOk],0);
      if edtCodCliente.CanFocus then
         edtCodCliente.SetFocus;
      Exit;
   end;

   Result := True;
end;

function TfrmPedidosVenda.validaQuantidade: Boolean;
begin
   Result := False;

   if (edtQuantidade.Text = '') or (edtQuantidade.Text = '0') then
   begin
      MessageDlg('Quantidade deve ser maior que 0.', mtWarning,[mbOk],0);
      if edtQuantidade.CanFocus then
         edtQuantidade.SetFocus;
      Exit;
   end;

   Result := True;
end;

function TfrmPedidosVenda.validaVlrUnitario: Boolean;
begin
   Result := False;

   if (edtVlrUnitario.Text = '') or (edtVlrUnitario.Text = '0,00') then
   begin
      MessageDlg('Valor unit�rio deve ser maior que 0.', mtWarning,[mbOk],0);
      if edtVlrUnitario.CanFocus then
         edtVlrUnitario.SetFocus;
      Exit;
   end;

   Result := True;
end;

function TfrmPedidosVenda.validaNumPedido: Boolean;
begin
   Result := False;

   if (edtNumPedido.Text = '') then
   begin
      MessageDlg('Digite o n�mero do pedido para consulta.', mtWarning,[mbOk],0);
      if edtNumPedido.CanFocus then
         edtNumPedido.SetFocus;
      Exit;
   end;

   Result := True;
end;

procedure TfrmPedidosVenda.adicionaProduto;
begin
   cdsProdutos.DisableControls;

   if vAlteracao then
      cdsProdutos.Edit
   else
      cdsProdutos.Append;

   cdsProdutos.FieldByName('CodProd').AsInteger := StrToInt(edtCodProd.Text);
   cdsProdutos.FieldByName('Descricao').AsString := edtDescricao.Text;
   cdsProdutos.FieldByName('Quantidade').AsInteger := StrToInt(edtQuantidade.Text);
   cdsProdutos.FieldByName('VlrUnitario').AsFloat := StrToFloat(edtVlrUnitario.Text);
   cdsProdutos.FieldByName('VlrTotal').AsFloat := StrToFloat(edtQuantidade.Text) * StrToFloat(edtVlrUnitario.Text);
   cdsProdutos.Post;
   cdsProdutos.EnableControls;

   vValorTotal := vValorTotal + cdsProdutos.FieldByName('VlrTotal').AsFloat;
   lblTotalPedido.Caption := 'R$ ' + FormatFloat('0.00',vValorTotal);
   vAlteracao := False;
   edtCodProd.Enabled := True;
   edtCodProd.Text := '';
   edtDescricao.Text := '';
   edtQuantidade.Text := '';
   edtVlrUnitario.Text := '';
end;

procedure TfrmPedidosVenda.limpaCampos;
begin
   edtNumPedido.Text := '';
   edtCodCliente.Text := '';
   edtNomeCliente.Text := '';
   edtCodProd.Text := '';
   edtDescricao.Text := '';
   edtQuantidade.Text := '';
   edtVlrUnitario.Text := '';
   lblTotalPedido.Caption := '';
   vValorTotal := 0;

   cdsProdutos.DisableControls;
   cdsProdutos.EmptyDataSet;
   cdsProdutos.EnableControls;
end;

function TfrmPedidosVenda.salvarDados: Boolean;
begin
   try
      Result := False;

      if cdsProdutos.IsEmpty then
      begin
         MessageDlg('Insira ao menos um produto para prosseguir.', mtWarning,[mbOk],0);
         Exit;
      end
      else
      if not validaCodCliente then
         Exit;

      if TCabecalhoPedidoController.get.GravaPedido(StrToInt(edtCodCliente.Text),
         vValorTotal) then
         if not TItensPedidoController.get.GravaItensPedido(buscaNumPedido, cdsProdutos) then
            Exit;

      MessageDlg('Pedido gravado com sucesso.', mtInformation,[mbOk],0);
      Result := True;
   except
      on E : Exception do
         MessageDlg(e.Message, mtError,[mbOk],0);
   end;
end;

procedure TfrmPedidosVenda.consultaPedido;
var
   xCabecalhoPedido: TCabecalhoPedido;
begin
   try
      try
         xCabecalhoPedido := nil;

         if not validaNumPedido then
            Exit;

         xCabecalhoPedido := TCabecalhoPedido.Create;
         xCabecalhoPedido := TCabecalhoPedidoController.get.BuscaPedido(edtNumPedido.Text);

         if xCabecalhoPedido = nil then
         begin
            MessageDlg('Pedido n�o cadastrado.', mtWarning,[mbOk],0);
            Exit;
         end;

         edtNumPedido.Text := IntToStr(xCabecalhoPedido.NumPedido);
         buscaCliente(IntToStr(xCabecalhoPedido.CodCliente));
         edtCodCliente.Text := IntToStr(xCabecalhoPedido.CodCliente);
         lblTotalPedido.Caption := 'R$ ' + FormatFloat('0.00', xCabecalhoPedido.ValorTotal);
         TItensPedidoController.get.BuscaItensPedido(IntToStr(xCabecalhoPedido.NumPedido), cdsProdutos);
      finally
         if xCabecalhoPedido <> nil then
            FreeAndNil(xCabecalhoPedido);
      end;
   except
      on E : Exception do
         MessageDlg(e.Message, mtError,[mbOk],0);
   end;
end;

//procedure para permitir utilizar o scroll do mouse no DBGrid
procedure TfrmPedidosVenda.scrollDbGrid(var Msg: TMsg; var Handled: Boolean);
var
   i: SmallInt;
begin
   if Msg.message = WM_MOUSEWHEEL then
   begin
      Msg.message := WM_KEYDOWN;
      Msg.lParam := 0;
      i := HiWord(Msg.wParam) ;
      if i > 0 then
         Msg.wParam := VK_UP
      else
         Msg.wParam := VK_DOWN;

      Handled := False;
   end;
end;

function TfrmPedidosVenda.buscaNumPedido: Integer;
begin
   Result := TCabecalhoPedidoController.get.BuscaUltimoPedido;
end;

procedure TfrmPedidosVenda.deletarPedido;
var
   xCabecalhoPedido: TCabecalhoPedido;
begin
   try
      try
         xCabecalhoPedido := nil;

         if not validaNumPedido then
            Exit;

         xCabecalhoPedido := TCabecalhoPedido.Create;
         xCabecalhoPedido := TCabecalhoPedidoController.get.BuscaPedido(edtNumPedido.Text);

         if xCabecalhoPedido = nil then
         begin
            MessageDlg('Pedido n�o cadastrado.', mtWarning,[mbOk],0);
            Exit;
         end;

         if MessageDlg('Confirma exclus�o do pedido ' + edtNumPedido.Text + '?',
            mtConfirmation, [mbYes, mbNo], 0) = mrYes then
         begin
            TItensPedidoController.get.DeletarItensPedido(edtNumPedido.Text);
            TCabecalhoPedidoController.get.DeletarCabecalhoPedido(edtNumPedido.Text);
            MessageDlg('Pedido deletado com sucesso.', mtInformation,[mbOk],0);
            vOpcaoTela := '';
            tratamentoTela;
         end;
      finally
         if xCabecalhoPedido <> nil then
            FreeAndNil(xCabecalhoPedido);
      end;
   except
      on E : Exception do
         MessageDlg(e.Message, mtError,[mbOk],0);
   end;
end;

end.
