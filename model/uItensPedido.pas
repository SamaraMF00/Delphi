unit uItensPedido;

interface

uses
   Classes;

type
   TItensPedido = class(TPersistent)
   private
      vIdItem,
      vQuantidade,
      vNumPedido,
      vCodProd: Integer;
      vVlrUnitario,
      vVlrTotal: Double;
   public
      constructor Create;
   published
      property IdItem: Integer read vIdItem write vIdItem;
      property Quantidade: Integer read vQuantidade write vQuantidade;
      property NumPedido: Integer read vNumPedido write vNumPedido;
      property CodProd: Integer read vCodProd write vCodProd;
      property VlrUnitario: Double read vVlrUnitario write vVlrUnitario;
      property VlrTotal: Double read vVlrTotal write vVlrTotal;
   end;

   TColItensPedido = Class(TList)
   public
      function  Retorna(pIndex: Integer): TItensPedido;
      procedure Adiciona(pObj: TObject);
   end;

implementation

{ TItensPedido }

constructor TItensPedido.Create;
begin
   Self.vIdItem := 0;
   Self.vQuantidade := 0;
   Self.vNumPedido := 0;
   Self.vCodProd := 0;
   Self.vVlrUnitario := 0;
   Self.vVlrTotal := 0;
end;

{ TColItensPedido }

procedure TColItensPedido.Adiciona(pObj: TObject);
begin
   Self.Add(TItensPedido(pObj));
end;

function TColItensPedido.Retorna(pIndex: Integer): TItensPedido;
begin
   Result := TItensPedido(Self[pIndex]);
end;

end.
