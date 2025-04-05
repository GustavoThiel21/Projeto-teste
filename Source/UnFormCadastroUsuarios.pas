unit UnFormCadastroUsuarios;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons, System.Actions, Vcl.ActnList, Vcl.Mask, Vcl.DBCtrls, Data.DB;

type
  THackWinControl = class(TWinControl);

type
  TFormCadastroFuncionarios = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Acoes: TActionList;
    ActNovo: TAction;
    ActSalvar: TAction;
    ActCancelar: TAction;
    ActExcluir: TAction;
    EdtCPF: TDBEdit;
    LblCPF: TLabel;
    EdtNome: TDBEdit;
    LblNome: TLabel;
    EdtEmail: TDBEdit;
    LblEmail: TLabel;
    EdtTamCalcado: TDBEdit;
    LblTamCalcado: TLabel;
    CbTamCamiseta: TDBComboBox;
    LblTamCamiseta: TLabel;
    EdtObservacao: TDBEdit;
    LblObservacao: TLabel;
    LblStatus: TLabel;
    DSFuncionarios: TDataSource;
    procedure ActNovoExecute(Sender: TObject);
    procedure ActSalvarExecute(Sender: TObject);
    procedure ActCancelarExecute(Sender: TObject);
    procedure ActExcluirExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EdtObservacaoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DSFuncionariosStateChange(Sender: TObject);
    procedure EdtCPFKeyPress(Sender: TObject; var Key: Char);
    procedure EdtNomeKeyPress(Sender: TObject; var Key: Char);
    procedure EdtEmailKeyPress(Sender: TObject; var Key: Char);
    procedure CbTamCamisetaKeyPress(Sender: TObject; var Key: Char);
    procedure EdtTamCalcadoKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    Function ValidouCPF: Boolean;
    Procedure AlterarStatusVisual;
    Procedure ValidarCampos;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses UnDMAplicacao;

procedure TFormCadastroFuncionarios.ActCancelarExecute(Sender: TObject);
begin
  if DSFuncionarios.DataSet.State in [dsEdit, dsinsert] then
    DSFuncionarios.DataSet.Cancel;
end;

procedure TFormCadastroFuncionarios.ActExcluirExecute(Sender: TObject);
begin
  if DSFuncionarios.DataSet.State = dsBrowse then
  begin
    DSFuncionarios.DataSet.Delete;
    ShowMessage('Funcionário excluído com sucesso.');
  end;
end;

procedure TFormCadastroFuncionarios.ActNovoExecute(Sender: TObject);
begin
  if DSFuncionarios.DataSet.State = dsBrowse then
  begin
    DSFuncionarios.DataSet.Insert;
    EdtCPF.SetFocus;
    // Atribuir default o tamanho M por ser o mais comum
    CbTamCamiseta.ItemIndex := 2;
  end;
end;

procedure TFormCadastroFuncionarios.ActSalvarExecute(Sender: TObject);
begin
  if DSFuncionarios.DataSet.State in [dsEdit, dsinsert] then
  begin
    ValidarCampos;
    DSFuncionarios.DataSet.Post;
    ShowMessage('Dados salvos com sucesso.')
  end;
end;

procedure TFormCadastroFuncionarios.AlterarStatusVisual;
begin
  if DSFuncionarios.State = dsEdit then
    LblStatus.Caption := 'Status: Editando'
  else if DSFuncionarios.State = dsinsert then
    LblStatus.Caption := 'Status: Inserindo'
  else
    LblStatus.Caption := 'Status: Navegando';
end;

procedure TFormCadastroFuncionarios.CbTamCamisetaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    Perform(CM_Dialogkey, VK_TAB, 0)
end;

procedure TFormCadastroFuncionarios.DSFuncionariosStateChange(Sender: TObject);
begin
  AlterarStatusVisual;
end;

procedure TFormCadastroFuncionarios.EdtCPFKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    Perform(CM_Dialogkey, VK_TAB, 0)
end;

procedure TFormCadastroFuncionarios.EdtEmailKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    Perform(CM_Dialogkey, VK_TAB, 0)
end;

procedure TFormCadastroFuncionarios.EdtNomeKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    Perform(CM_Dialogkey, VK_TAB, 0)
end;

procedure TFormCadastroFuncionarios.EdtObservacaoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key in [vk_return, vk_down] then
    ActSalvar.Execute;
end;

procedure TFormCadastroFuncionarios.EdtTamCalcadoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    Perform(CM_Dialogkey, VK_TAB, 0)
end;

procedure TFormCadastroFuncionarios.FormCreate(Sender: TObject);
begin
  DSFuncionarios.DataSet := DMAplicacao.FDQFuncionarios;

  DMAplicacao.BuscarDadosFuncionarios;
end;

procedure TFormCadastroFuncionarios.ValidarCampos;
begin
  if not ValidouCPF then
  begin
    ShowMessage('CPF inválido.');
    EdtCPF.SetFocus;
    abort;
  end;

  if Trim(EdtNome.Text) = EmptyStr then
  begin
    ShowMessage('Deve ser indicado o nome do funcionário.');
    EdtNome.SetFocus;
    abort;
  end;

  if (Pos('@', Trim(EdtEmail.Text)) = 0) or (Pos('.COM', Trim(UpperCase(EdtEmail.Text))) = 0) then
  begin
    ShowMessage('Email inválido. Informe no formato exemplo@dominio.com.');
    EdtEmail.SetFocus;
    abort;
  end;

  if CbTamCamiseta.ItemIndex = -1 then
  begin
    ShowMessage('Deve ser indicado o tamanho da camiseta.');
    CbTamCamiseta.SetFocus;
    abort;
  end;

  if Trim(EdtTamCalcado.Text) = EmptyStr then
  begin
    ShowMessage('Deve ser indicado o tamanho do calçado.');
    EdtTamCalcado.SetFocus;
    abort;
  end;
end;

Function TFormCadastroFuncionarios.ValidouCPF;
var
  LCPF: String;
  dig10, dig11: ShortString;
  s, i, r, peso: integer;
begin
  LCPF := EdtCPF.Text;
  LCPF := StringReplace(LCPF, '.', '', [rfReplaceAll]);
  LCPF := StringReplace(LCPF, '-', '', [rfReplaceAll]);

  if (length(LCPF) <> 11) then
  begin
    result := false;
    abort;
  end;

  try
    { *-- Cálculo do 1o. Digito Verificador --* }
    s := 0;
    peso := 10;
    for i := 1 to 9 do
    begin
      // StrToInt converte o i-ésimo caractere do CPF em um número
      s := s + (StrToInt(LCPF[i]) * peso);
      peso := peso - 1;
    end;
    r := 11 - (s mod 11);
    if ((r = 10) or (r = 11)) then
      dig10 := '0'
    else
      Str(r: 1, dig10);

    { *-- Cálculo do 2o. Digito Verificador --* }
    s := 0;
    peso := 11;
    for i := 1 to 10 do
    begin
      s := s + (StrToInt(LCPF[i]) * peso);
      peso := peso - 1;
    end;
    r := 11 - (s mod 11);
    if ((r = 10) or (r = 11)) then
      dig11 := '0'
    else
      Str(r: 1, dig11);

    { Verifica se os digitos calculados conferem com os digitos informados. }
    if ((string(dig10) = LCPF[10]) and (string(dig11) = LCPF[11])) then
      result := true
    else
      result := false;
  except
    result := false;
  end;
end;

end.
