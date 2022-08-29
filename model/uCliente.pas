unit uCliente;

interface

uses
   Classes;

type
   TCliente = class(TPersistent)
   private
      vCodCliente: Integer;
      vNome,
      vCidade,
      vUF: String;
   public
      constructor Create;
   published
      property CodCliente: Integer read vCodCliente write vCodCliente;
      property Nome: String read vNome write vNome;
      property Cidade: String read vCidade write vCidade;
      property UF: String read vUF write vUF;
   end;

   TColCliente = Class(TList)
   public
      function  Retorna(pIndex: Integer): TCliente;
      procedure Adiciona(pObj: TObject);
   end;

implementation

{ TCliente }

constructor TCliente.Create;
begin
   Self.vCodCliente := 0;
   Self.vNome := '';
   Self.vCidade := '';
   Self.vUF := '';
end;

{ TColCliente }

procedure TColCliente.Adiciona(pObj: TObject);
begin
   Self.Add(TCliente(pObj));
end;

function TColCliente.Retorna(pIndex: Integer): TCliente;
begin
   Result := TCliente(Self[pIndex]);
end;

end.

