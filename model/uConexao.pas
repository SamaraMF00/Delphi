unit uConexao;

interface

uses SysUtils, SqlExpr, IniFiles, Forms, Classes, Windows, FireDAC.Comp.Client,
   FireDAC.Phys.MySQL, FireDAC.Stan.Def, FireDAC.Stan.Intf, FireDAC.Stan.Option,
   FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Pool,
   FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait,
   FireDAC.Comp.UI, Data.DB, Data.DBXMySQL, FireDAC.Stan.Param,
   FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
   TConexao = class
      private
         vConexao: TFDConnection;
         vDvrMySQL: TFDPhysMySQLDriverLink;
         function createConnection: TFDConnection;
      public
         constructor create;
         function getConexao: TFDConnection;
   end;

implementation

var
   _Conexao : TConexao = nil;

{ TConexao }

constructor TConexao.create;
begin
   inherited create;
   vDvrMySQL := nil;
   vConexao := nil;
end;

function TConexao.getConexao: TFDConnection;
begin
   if not Assigned(vConexao) then
      vConexao := createConnection;

   if not vConexao.Connected then
      vConexao.Connected := True;

   Result := vConexao;
end;

function TConexao.createConnection: TFDConnection;
var
   xCaminho: string;
begin
   try
      xCaminho := '';

      Result := TFDConnection.Create(nil);

      Result.LoginPrompt := False;
      Result.Params.Values['Database'     ] := 'bdvendas';
      Result.Params.Values['User_Name'    ] := 'root';
      Result.Params.Values['Password'     ] := '070802@Sa';
      Result.Params.Values['Server'       ] := 'localhost';
      Result.Params.Values['DriverID'     ] := 'MySQL';

      xCaminho := UpperCase(Trim(ExtractFilePath(Application.ExeName)));

      if (xCaminho <> '') and
         (Copy(xCaminho,Length(xCaminho),1) <> '\') then
         xCaminho := xCaminho + '\';

      vDvrMySQL := TFDPhysMySQLDriverLink.create(nil);
      vDvrMySQL.VendorLib := xCaminho + 'libmysql.dll'; //caminho do .exe

      Result.Connected := True;
   except
      on e: Exception do
      begin
         raise Exception.Create('Ocorreu um erro ao ao tentar comunicar com o '+
            'banco de dados.'+ #13 +'Motivo: ' + e.Message);
      end;
   end;
end;

end.
