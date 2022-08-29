unit uClienteController;

interface

uses
   SysUtils, uCliente, UClienteDao;

type

   TClienteController = class
      private

      public
         constructor create;
         function BuscaCliente(pCodCliente: string): TCliente;
      published
         class function get: TClienteController;
   end;

implementation

uses
   uConexao;

var
   _instance: TClienteController;

constructor TClienteController.Create;
begin
   inherited Create;
end;

class function TClienteController.get: TClienteController;
begin
   if _instance = nil then
      _instance := TClienteController.Create;

   Result := _instance;
end;

function TClienteController.BuscaCliente(pCodCliente: string): TCliente;
var
   xClienteDao: TClienteDao;
   xConexao: TConexao;
begin
   try
      try
         Result := nil;
         xClienteDao := nil;
         xConexao := nil;

         xConexao := TConexao.create;

         xClienteDao := TClienteDao.Create(xConexao.getConexao);

         Result := xClienteDao.RetornaCliente('CodCliente = '+ pCodCliente);
      finally
         if xClienteDao <> nil then
            FreeAndNil(xClienteDao);
         if xConexao <> nil then
            FreeAndNil(xConexao);
      end;
   except
      on E : Exception do
      begin
         Raise Exception.Create(
            'Falha ao retornar dados do cliente [Controller]. '+e.Message);
      end;
   end;
end;

end.
