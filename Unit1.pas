unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait, REST.Types, REST.Client, FireDAC.Comp.Client,
  FireDAC.Comp.UI, FireDAC.Phys.MySQL, Data.Bind.Components,
  Data.Bind.ObjectScope, REST.Response.Adapter, Data.DB, FireDAC.Comp.DataSet,
  Vcl.StdCtrls, FireDAC.Phys.PG, FireDAC.Phys.PGDef, uCep, System.JSON, IdHTTP;

type
  TForm1 = class(TForm)
    btnConsultar: TButton;
    btnSalvar: TButton;
    EditCep: TEdit;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    RESTResponse1: TRESTResponse;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDMemTable1: TFDMemTable;
    RESTRequest1: TRESTRequest;
    RESTClient1: TRESTClient;
    EditEndereco: TEdit;
    LabelEndereco: TLabel;
    LabelBairro: TLabel;
    EditBairro: TEdit;
    LabelCidade: TLabel;
    EditCidade: TEdit;
    EditUF: TEdit;
    LabelComplemento: TLabel;
    EditComplemento: TEdit;
    LabelIBGE: TLabel;
    EditIBGE: TEdit;
    LabelDDD: TLabel;
    EditDDD: TEdit;
    LabelGIA: TLabel;
    EditGIA: TEdit;
    LabelSIAF: TLabel;
    EditSIAFI: TEdit;
    btnConsUF: TButton;
    RetornoJson: TMemo;
    LabelCEP: TLabel;
    procedure btnConsultarClick(Sender: TObject);
    procedure btnConsDDDClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnConsUFClick(Sender: TObject);
  private
    cepResult: TCep;
    function ConsultarCEP(const ICep: string): TCep;
    procedure SalvarCEP(const CEP: TCep);
    function ValidarCEP(const ICep: string): Boolean;
    function RemoverMascaraCEP(const ICep: string): string;
  public
  end;

var
  Form1: TForm1;
  FDQuery1: TFDQuery;
  Http : TidHTTP;
  JsonResponse : String;
  ErroJson: String;
  RESTClient1: TRESTClient;
  RESTRequest1: TRESTRequest;
  RESTResponse1: TRESTResponse;
  RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
  JSONValue: TJSONValue;

implementation
{$R *.dfm}

function TForm1.ValidarCEP(const ICep: string): Boolean;
var
  CepSemMascara: string;
begin
  CepSemMascara := RemoverMascaraCEP(ICep);
  Result := (Length(CepSemMascara) = 8);
end;


function TForm1.ConsultarCEP(const ICep: string): TCep;
begin
  Result := nil;

  RESTClient1.BaseURL := 'https://viacep.com.br/ws/' + EditCep.Text + '/json/';
  RESTRequest1.Execute;
  JSONValue := TJSONObject.ParseJSONValue(RESTResponse1.Content);

  ErroJson := JSONValue.GetValue<string>('erro', 'false');

  if (ErroJson = 'true') then
  begin
    ShowMessage('CEP não encontrado na API do ViaCEP');
    JSONValue.Free;
    Exit;
  end;

  try
    Result := TCep.Create;
    Result.Cep := JSONValue.GetValue<string>('cep', '');
    Result.Logradouro := JSONValue.GetValue<string>('logradouro', '');
    Result.Complemento := JSONValue.GetValue<string>('complemento', '');
    Result.Bairro := JSONValue.GetValue<string>('bairro', '');
    Result.Localidade := JSONValue.GetValue<string>('localidade', '');
    Result.Uf := JSONValue.GetValue<string>('uf', '');
    Result.Ibge := JSONValue.GetValue<string>('ibge', '');
    Result.Gia := JSONValue.GetValue<string>('gia', '');
    Result.Ddd := JSONValue.GetValue<string>('ddd', '');
    Result.Siafi := JSONValue.GetValue<string>('siafi', '');
    Result.Json := RESTResponse1.Content;
  finally
    JSONValue.Free;
  end;
end;


function TForm1.RemoverMascaraCEP(const ICep: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(ICep) do
    if CharInSet(ICep[I], ['0'..'9']) then
      Result := Result + ICep[I];
end;


procedure TForm1.SalvarCEP(const CEP: TCep);
begin
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Text := 'SELECT * FROM public."TspdCep" WHERE cep = :cep';
  FDQuery1.ParamByName('cep').AsString := CEP.Cep;
  FDQuery1.Open;

  if FDQuery1.RecordCount > 0 then
  begin
    try
      FDQuery1.SQL.Text := 'UPDATE public."TspdCep" SET logradouro = :logradouro, complemento = :complemento, bairro = :bairro, localidade = :localidade, ' +
                           'uf = :uf, ibge = :ibge, ddd = :ddd WHERE cep = :cep;';
      FDQuery1.ParamByName('logradouro').AsString := CEP.Logradouro;
      FDQuery1.ParamByName('complemento').AsString := CEP.Complemento;
      FDQuery1.ParamByName('bairro').AsString := CEP.Bairro;
      FDQuery1.ParamByName('localidade').AsString := CEP.Localidade;
      FDQuery1.ParamByName('uf').AsString := CEP.Uf;
      FDQuery1.ParamByName('ibge').AsString := CEP.Ibge;
      FDQuery1.ParamByName('ddd').AsString := CEP.Ddd;
      FDQuery1.ParamByName('cep').AsString := CEP.Cep;

      FDQuery1.ExecSQL;
      ShowMessage('CEP atualizado no banco!');
    except
      on e: Exception do
        ShowMessage('Erro ao salvar CEP no banco: ' + e.Message);
    end;
  end
  else
  begin
    try
      FDQuery1.SQL.Text := 'INSERT INTO public."TspdCep"(cep, logradouro, complemento, bairro, localidade, uf, ibge, ddd) ' +
                           'VALUES (:cep, :logradouro, :complemento, :bairro, :localidade, :uf, :ibge, :ddd)';
      FDQuery1.ParamByName('cep').AsString := CEP.Cep;
      FDQuery1.ParamByName('logradouro').AsString := CEP.Logradouro;
      FDQuery1.ParamByName('complemento').AsString := CEP.Complemento;
      FDQuery1.ParamByName('bairro').AsString := CEP.Bairro;
      FDQuery1.ParamByName('localidade').AsString := CEP.Localidade;
      FDQuery1.ParamByName('uf').AsString := CEP.Uf;
      FDQuery1.ParamByName('ibge').AsString := CEP.Ibge;
      FDQuery1.ParamByName('ddd').AsString := CEP.Ddd;
      FDQuery1.ExecSQL;

      ShowMessage('CEP inserido no banco!');
    except
      on e: Exception do
        ShowMessage('Erro ao inserir CEP no banco: ' + e.Message);
    end;
  end;
end;

procedure TForm1.btnSalvarClick(Sender: TObject);
begin
  if (cepResult = nil) or (EditBairro.Text = '') then
  begin
    ShowMessage('Consulte o CEP antes de salvar.');
    Exit;
  end;

  try
    SalvarCEP(cepResult);
  except
    on E: Exception do
      ShowMessage('Erro ao salvar o CEP: ' + E.Message);
  end;
end;

procedure TForm1.btnConsUFClick(Sender: TObject);
begin
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Text := 'SELECT * FROM public."TspdCep" WHERE uf = :uf';

  FDQuery1.ParamByName('uf').AsString := EditUF.Text;
  FDQuery1.Open;

  if FDQuery1.RecordCount > 0 then
  begin
  try
    FDQuery1.First;
    RetornoJson.Lines.text := '';

    while not FDQuery1.Eof do
    begin
      RetornoJson.Lines.Add(FDQuery1.FieldByName('cep').AsString + ' - ' + FDQuery1.FieldByName('localidade').AsString + ' - ' + FDQuery1.FieldByName('uf').AsString);

      FDQuery1.Next;
    end;
  except
    on e:Exception do
      ShowMessage('Erro ao verificar UF no banco: ' + e.Message);
  end;
  end
  else
  begin
    ShowMessage('Nenhuma UF encontrada.');
  end;

  FDQuery1.Close;
end;

procedure TForm1.btnConsultarClick(Sender: TObject);
var
  CepSemMascara: string;
  JSONResponse: TJSONObject;
  ErroCep: Boolean;
begin
  RetornoJson.Clear;
  CepSemMascara := RemoverMascaraCEP(EditCep.Text);
  JSONResponse := nil;
  ErroCep := False;

  if not ValidarCEP(CepSemMascara) then
  begin
    ShowMessage('CEP inválido! Digite apenas 8 números.');
    EditCep.Clear;
    Exit;
  end;

  try
    cepResult := ConsultarCEP(CepSemMascara);


    JSONResponse := TJSONObject.ParseJSONValue(RESTResponse1.Content) as TJSONObject;

    if Assigned(JSONResponse) and
       JSONResponse.TryGetValue<Boolean>('erro', ErroCep) and ErroCep then
    begin
      Exit;
    end;

    if Assigned(cepResult) then
    begin
      EditCep.Text := cepResult.Cep;
      EditEndereco.Text := cepResult.Logradouro;
      EditBairro.Text := cepResult.Bairro;
      EditCidade.Text := cepResult.Localidade;
      EditUF.Text := cepResult.Uf;
      EditDDD.Text := cepResult.Ddd;
      EditIBGE.Text := cepResult.Ibge;
      EditSIAFI.Text := cepResult.Siafi;
      EditGIA.Text := cepResult.Gia;
      EditComplemento.Text := cepResult.Complemento;
      RetornoJson.Lines.Text := cepResult.Json;



    end;
  except
    on E: Exception do
      ShowMessage('Erro ao consultar CEP: ' + E.Message);
  end;

  if Assigned(JSONResponse) then
    JSONResponse.Free;
end;


procedure TForm1.btnConsDDDClick(Sender: TObject);
begin
  EditCep.Clear;
  EditCidade.Clear;
  EditSIAFI.Clear;
  EditComplemento.Clear;
  EditEndereco.Clear;
  EditBairro.Clear;
  EditIBGE.Clear;
  EditGIA.Clear;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Text := 'SELECT * FROM public."TspdCep" WHERE uf = :uf';
  FDQuery1.ParamByName('uf').AsString := EditUF.Text;
  FDQuery1.Open;


  if FDQuery1.RecordCount > 0 then
  begin
    try
      FDQuery1.First;
      RetornoJson.Lines.Text := '';

      while not FDQuery1.Eof do
      begin
        RetornoJson.Lines.Add(FDQuery1.FieldByName('Cep').AsString + ' : ' +
                              FDQuery1.FieldByName('localidade').AsString + ' - ' +
                              FDQuery1.FieldByName('uf').AsString);
        FDQuery1.Next;
      end;
    except
      on e: Exception do
        ShowMessage('Erro ao verificar UF no banco: ' + e.Message);
    end;
  end
  else
    ShowMessage('Nenhuma UF encontrada.');

  FDQuery1.Close;
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(cepResult);
end;

end.

