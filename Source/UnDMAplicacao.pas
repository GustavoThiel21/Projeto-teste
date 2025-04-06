Unit UnDMAplicacao;

Interface

Uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, Vcl.Dialogs, UnAplicacaoFuncoes;

Type
  TDMAplicacao = class(TDataModule)
    FDQFuncionarios: TFDQuery;
    FDConexao: TFDConnection;
    FDQFuncionariosCPF: TStringField;
    FDQFuncionariosNOME: TStringField;
    FDQFuncionariosEMAIL: TStringField;
    FDQFuncionariosTAMCAMISA: TStringField;
    FDQFuncionariosTAMCALCADO: TIntegerField;
    FDQFuncionariosOBSERVACAO: TStringField;
    FDQFuncionariosIDFUNCIONARIO: TLargeintField;
    procedure DataModuleDestroy(Sender: TObject);
    procedure FDQFuncionariosNewRecord(DataSet: TDataSet);
    procedure FDQFuncionariosCPFGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure FDQFuncionariosCPFSetText(Sender: TField; const Text: string);
    procedure DataModuleCreate(Sender: TObject);
  Private
    { Private declarations }
    Function BuscarCaminhoBD: String;
    Function BuscarProximoIDFuncionario: Int64;
  Public
    { Public declarations }
    FFuncoes: TFuncoes;
    Function ExisteTabela: Boolean;
    Procedure ConectarBD;
    Procedure CriarBD;
    Procedure CriarEstruturaBD;
    Procedure AlterarCaminhoBD(ACaminho: String = '');
    Procedure BuscarDadosFuncionarios(ACondicao: String = '');
  end;

var
  DMAplicacao: TDMAplicacao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

Uses IniFiles, Forms;

procedure TDMAplicacao.AlterarCaminhoBD(ACaminho: String);
Var
  LIni: TIniFile;
begin
  if not FileExists(ExtractFileDir(Application.ExeName) + '\PrjTeste.ini') then
    FFuncoes.CriarArquivoINI(ACaminho);

  LIni := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    LIni.WriteString('DadosBD', 'CaminhoBD', ACaminho);
  finally
    LIni.Free;
  end;
end;

function TDMAplicacao.BuscarCaminhoBD: string;
Var
  LIni: TIniFile;
begin
  Result := Emptystr;

  if not FileExists(ExtractFileDir(Application.ExeName) + '\PrjTeste.ini') then
    FFuncoes.CriarArquivoINI;

  LIni := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    Result := LIni.ReadString('DadosBD', 'CaminhoBD', Emptystr);
  finally
    LIni.Free;
  end;
end;

procedure TDMAplicacao.BuscarDadosFuncionarios(ACondicao: string);
Var
  LSql: String;
begin
  if not FDConexao.Connected then
    ConectarBD;

  if not FDConexao.Connected then
    exit;

  LSql := 'SELECT * FROM FUNCIONARIOS ';

  if ACondicao <> Emptystr then
    LSql := LSql + 'WHERE ' + ACondicao;

  with FDQFuncionarios do
  begin
    close;
    sql.Clear;
    sql.Add(LSql);
    open;
  end
end;

function TDMAplicacao.BuscarProximoIDFuncionario: Int64;
Var
  LQueryBusca: TFDQuery;
begin
  try
    LQueryBusca := TFDQuery.Create(nil);
    with LQueryBusca do
    begin
      Connection := FDConexao;
      sql.Clear;
      sql.Add('SELECT FIRST 1 GEN_ID(GN_FUNCIONARIOS,1) AS ID FROM RDB$RELATIONS');
      open;
      Result := FieldByName('ID').AsLargeInt;
    end;
  finally
    FreeAndNil(LQueryBusca);
  end;
end;

procedure TDMAplicacao.ConectarBD;
begin
  try
    with FDConexao do
    begin
      if Connected then
        close;
      with Params do
      begin
        Clear;
        Add('DriverID=FB');
        Add('Server=localhost');
        Add('DataBase=' + BuscarCaminhoBD);
        Add('User_Name=sysdba');
        Add('Password=masterkey');
      end;
      open;
    end;
  except
    ShowMessage('Erro ao conectar no banco de dados. Verifique se o mesmo existe.')
  end;

  FDQFuncionarios.Connection := FDConexao;
end;

procedure TDMAplicacao.CriarBD;
Var
  LDiretorio: String;
  LCriar: Boolean;
begin
  LDiretorio := ExtractFileDir(Application.ExeName) + '\DBTESTE.FDB';;

  try
    LCriar := not FileExists(Trim(LDiretorio));
    FDConexao.Params.Values['CreateDatabase'] := BoolToStr(LCriar, True);
    FDConexao.Params.Values['Database'] := Trim(LDiretorio);
    FDConexao.Params.Values['DriverID'] := 'FB';
    FDConexao.Params.Values['User_Name'] := 'SYSDBA';
    FDConexao.Params.Values['Password'] := 'masterkey';
    FDConexao.Params.Values['CharacterSet'] := 'WIN1252';
    FDConexao.Params.Values['Dialect'] := '3';
    FDConexao.Commit;

    if LCriar then
      AlterarCaminhoBD(LDiretorio);

    if not ExisteTabela then
    begin
      CriarEstruturaBD;
      ShowMessage('Banco de dados criado com sucesso.')
    end;
  Except
    ShowMessage('Erro ao criar o banco de dados.')
  end;
end;

procedure TDMAplicacao.CriarEstruturaBD;
Const
  CTabela = 'CREATE TABLE FUNCIONARIOS ( ' + sLineBreak + '    IDFUNCIONARIO  NUMERIC(18,0) NOT NULL,' + sLineBreak +
    '    CPF            VARCHAR(11) NOT NULL,' + sLineBreak + '    NOME           VARCHAR(200),' + sLineBreak +
    '    EMAIL          VARCHAR(100),' + sLineBreak + '    TAMCAMISA      VARCHAR(10) NOT NULL,' + sLineBreak +
    '    TAMCALCADO     NUMERIC(2,0) NOT NULL,' + sLineBreak + '    OBSERVACAO     VARCHAR(300));' + sLineBreak;

  CTabelaPK = ' ALTER TABLE FUNCIONARIOS ADD PRIMARY KEY (IDFUNCIONARIO);';

  CGenerator = ' CREATE SEQUENCE GN_FUNCIONARIOS;';
begin

  with FDQFuncionarios do
  begin
    close;
    sql.Clear;
    sql.Add(CTabela);
    ExecSQL;
    sql.Clear;
    sql.Add(CGenerator);
    ExecSQL;
    sql.Clear;
    sql.Add(CTabelaPK);
    ExecSQL;
  end;
end;

procedure TDMAplicacao.DataModuleCreate(Sender: TObject);
begin
  FFuncoes := TFuncoes.Create;
end;

procedure TDMAplicacao.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FDQFuncionarios);
  FDConexao.close;
  FreeAndNil(FDConexao);
  FreeAndNil(FFuncoes);
end;

function TDMAplicacao.ExisteTabela: Boolean;
Var
  LQueryBusca: TFDQuery;
begin
  try
    LQueryBusca := TFDQuery.Create(nil);
    with LQueryBusca do
    begin
      Connection := FDConexao;
      sql.Clear;
      sql.Add('SELECT 1 FROM RDB$RELATIONS WHERE RDB$RELATION_NAME = ''FUNCIONARIOS''');
      open;
      Result := RecordCount > 0;
    end;
  finally
    FreeAndNil(LQueryBusca);
  end;
end;

procedure TDMAplicacao.FDQFuncionariosCPFGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := Format('%s.%s.%s-%s', [Copy(TStringField(Sender).Value, 1, 3), Copy(TStringField(Sender).Value, 4, 3),
    Copy(TStringField(Sender).Value, 7, 3), Copy(TStringField(Sender).Value, 10, 2)]);
end;

procedure TDMAplicacao.FDQFuncionariosCPFSetText(Sender: TField; const Text: string);
Var
  LTexto: string;
begin
  LTexto := Text;
  LTexto := StringReplace(LTexto, '.', '', [rfReplaceAll]);
  LTexto := StringReplace(LTexto, '-', '', [rfReplaceAll]);
  TStringField(Sender).Value := ansistring(LTexto);
end;

procedure TDMAplicacao.FDQFuncionariosNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('IDFUNCIONARIO').AsLargeInt := BuscarProximoIDFuncionario;
  DataSet.FieldByName('TAMCAMISA').AsString := 'M';
end;

end.
