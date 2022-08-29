unit uCabecalhoPedido;

interface

uses
   Classes;

type
   TCabecalhoPedido = class(TPersistent)
   private
      vNumPedido,
      vCodCliente: Integer;
      vValorTotal: Double;
      vDataEmissao: TDateTime;
   public
      constructor Create;
   published
      property NumPedido: Integer read vNumPedido write vNumPedido;
      property CodCliente: Integer read vCodCliente write vCodCliente;
      property ValorTotal: Double read vValorTotal write vValorTotal;
      property DataEmissao: TDateTime read vDataEmissao write vDataEmissao;
   end;

   TColCabecalhoPedido = Class(TList)
   public
      function  Retorna(pIndex: Integer): TCabecalhoPedido;
      procedure Adiciona(pObj: TObject);
   end;

implementation

{ TCabecalhoPedido }

constructor TCabecalhoPedido.Create;
begin
   Self.vNumPedido := 0;
   Self.vCodCliente := 0;
   Self.vValorTotal := 0;
   Self.vDataEmissao := 0;
end;

{ TColCabecalhoPedido }

procedure TColCabecalhoPedido.Adiciona(pObj: TObject);
begin
   Self.Add(TCabecalhoPedido(pObj));
end;

function TColCabecalhoPedido.Retorna(pIndex: Integer): TCabecalhoPedido;
begin
   Result := TCabecalhoPedido(Self[pIndex]);
end;

end.

