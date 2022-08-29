unit uItensPedidoController;

interface

uses
   SysUtils, DBClient, uItensPedido, uItensPedidoDao;

type

   TItensPedidoController = class
      private

      public
         constructor create;
         procedure BuscaItensPedido(pNumPedido: string; var pCdsItens: TClientDataSet);
         function GravaItensPedido(pNumPedido: Integer; pCdsItens: TClientDataSet): Boolean;
         function DeletarItensPedido(pNumPedido: string): Boolean;
      published
         class function get: TItensPedidoController;
   end;

implementation

uses
   uConexao;

var
   _instance: TItensPedidoController;

constructor TItensPedidoController.Create;
begin
   inherited Create;
end;

class function TItensPedidoController.get: TItensPedidoController;
begin
   if _instance = nil then
      _instance := TItensPedidoController.Create;

   Result := _instance;
end;

procedure TItensPedidoController.BuscaItensPedido(pNumPedido: string;
   var pCdsItens: TClientDataSet);
var
   xItensPedidoDao: TItensPedidoDao;
   xConexao: TConexao;
begin
   try
      try
         xItensPedidoDao := nil;
         xConexao := nil;

         xConexao := TConexao.create;

         xItensPedidoDao := TItensPedidoDao.Create(xConexao.getConexao);

         if pCdsItens = nil then
            pCdsItens := TClientDataSet.Create(nil);

         xItensPedidoDao.CarregaLista('NumPedido = '+ pNumPedido, pCdsItens);
      finally
         if xItensPedidoDao <> nil then
            FreeAndNil(xItensPedidoDao);
         if xConexao <> nil then
            FreeAndNil(xConexao);
      end;
   except
      on E : Exception do
      begin
         Raise Exception.Create(
            'Falha ao retornar itens do pedido [Controller]. '+e.Message);
      end;
   end;
end;

function TItensPedidoController.GravaItensPedido(pNumPedido: Integer; pCdsItens: TClientDataSet): Boolean;
var
   xItensPedidoDao: TItensPedidoDao;
   xConexao: TConexao;
   xColItensPedido: TColItensPedido;
   xItensPedido: TItensPedido;
begin
   try
      try
         Result := False;
         xItensPedidoDao := nil;
         xConexao := nil;
         xItensPedido := nil;
         xColItensPedido := nil;

         xColItensPedido := TColItensPedido.Create;
         xConexao := TConexao.create;

         pCdsItens.First;

         while not pCdsItens.eof do
         begin
            xItensPedido := TItensPedido.Create;
            xItensPedido.NumPedido := pNumPedido;
            xItensPedido.CodProd := pCdsItens.FieldByName('CodProd').AsInteger;
            xItensPedido.Quantidade := pCdsItens.FieldByName('Quantidade').AsInteger;
            xItensPedido.VlrUnitario := pCdsItens.FieldByName('VlrUnitario').AsFloat;
            xItensPedido.VlrTotal := pCdsItens.FieldByName('VlrTotal').AsFloat;
            xColItensPedido.Add(xItensPedido);
            pCdsItens.Next;
         end;

         xItensPedidoDao := TItensPedidoDao.Create(xConexao.getConexao);

         Result := xItensPedidoDao.InsereColecaoItensPedido(xColItensPedido);
      finally
         if xColItensPedido <> nil then
            FreeAndNil(xColItensPedido);
         if xItensPedido <> nil then
            FreeAndNil(xItensPedido);
         if xItensPedidoDao <> nil then
            FreeAndNil(xItensPedidoDao);
         if xConexao <> nil then
            FreeAndNil(xConexao);
      end;
   except
      on E : Exception do
      begin
         Raise Exception.Create(
            'Falha ao salvar itens do pedido [Controller]. '+e.Message);
      end;
   end;
end;

function TItensPedidoController.DeletarItensPedido(pNumPedido: String): Boolean;
var
   xItensPedidoDao: TItensPedidoDao;
   xConexao: TConexao;
begin
   try
      try
         Result := False;
         xItensPedidoDao := nil;
         xConexao := nil;

         xConexao := TConexao.create;

         xItensPedidoDao := TItensPedidoDao.Create(xConexao.getConexao);

         Result := xItensPedidoDao.DeletarCabecalhoPedido('NumPedido = ' + pNumPedido);
      finally
         if xItensPedidoDao <> nil then
            FreeAndNil(xItensPedidoDao);
         if xConexao <> nil then
            FreeAndNil(xConexao);
      end;
   except
      on E : Exception do
      begin
         Raise Exception.Create(
            'Falha ao deletar itens do pedido[Controller]. '+e.Message);
      end;
   end;
end;

end.
