Unit UnDMAplicacao;

Interface

Uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, Vcl.Dialogs;

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
    Procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure FDQFuncionariosNewRecord(DataSet: TDataSet);
    procedure FDQFuncionariosCPFGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure FDQFuncionariosCPFSetText(Sender: TField; const Text: string);
  Private
    { Private declarations }
    Function BuscarCaminhoBD: String;
    Function BuscarProximoIDFuncionario: Int64;
  Public
    { Public declarations }
    Procedure ConectarBD;
    Procedure AlterarCaminhoBD(ACaminho: String = '');
    Procedure BuscarDadosFuncionarios;
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
  LIni := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    Result := LIni.ReadString('DadosBD', 'CaminhoBD', Emptystr);
  finally
    LIni.Free;
  end;
end;

procedure TDMAplicacao.BuscarDadosFuncionarios;
begin
  with FDQFuncionarios do
  begin
    close;
    sql.Clear;
    sql.Add('SELECT * FROM FUNCIONARIOS');
    open;
  end;
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
      sql.Add('SELECT GEN_ID(GN_FUNCIONARIOS,1) AS ID FROM RDB$RELATIONS');
      open;
      Result := FieldByName('ID').AsLargeInt;
    end;
  finally
    FreeAndNil(LQueryBusca);
  end;
end;

procedure TDMAplicacao.ConectarBD;
begin
  with FDConexao do
  begin
    with Params do
    begin
      Add('DriverID=FB');
      Add('Server=localhost');
      Add('DataBase=' + BuscarCaminhoBD);
      Add('User_Name=sysdba');
      Add('Password=masterkey');
    end;
  end;
end;

procedure TDMAplicacao.DataModuleCreate(Sender: TObject);
begin
  try
    ConectarBD;
  except
    ShowMessage('Ocorreu um erro ao conectar no banco de dados. Acione o suporte');
  end;
end;

procedure TDMAplicacao.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FDQFuncionarios);
  FDConexao.close;
  FreeAndNil(FDConexao);
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
end;

end.
