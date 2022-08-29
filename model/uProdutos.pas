unit uProdutos;

interface

uses
   Classes;

type
   TProdutos = class(TPersistent)
   private
      vCodProd: Integer;
      vDescricao: String;
      vPrecoVenda: Double;
   public
      constructor Create;
   published
      property CodProd: Integer read vCodProd write vCodProd;
      property Descricao: String read vDescricao write vDescricao;
      property PrecoVenda: Double read vPrecoVenda write vPrecoVenda;
   end;

   TColProdutos = Class(TList)
   public
      function  Retorna(pIndex: Integer): TProdutos;
      procedure Adiciona(pObj: TObject);
   end;

implementation

{ TProdutos }

constructor TProdutos.Create;
begin

   Self.vCodProd := 0;
   Self.vDescricao := '';
   Self.vPrecoVenda := 0;
end;

{ TColProdutos }

procedure TColProdutos.Adiciona(pObj: TObject);
begin
   Self.Add(TProdutos(pObj));
end;

function TColProdutos.Retorna(pIndex: Integer): TProdutos;
begin
   Result := TProdutos(Self[pIndex]);
end;

end.

