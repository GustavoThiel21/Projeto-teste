unit UnFormCadastroUsuarios;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons, System.Actions, Vcl.ActnList, Vcl.Mask, Vcl.DBCtrls, Data.DB, UnAplicacaoFuncoes,
  Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids, System.ImageList, Vcl.ImgList;

type
  THackWinControl = class(TWinControl);

type
  TFormCadastroFuncionarios = class(TForm)
    Acoes: TActionList;
    ActNovo: TAction;
    ActSalvar: TAction;
    ActCancelar: TAction;
    ActExcluir: TAction;
    DSFuncionarios: TDataSource;
    PGGeral: TPageControl;
    TsListagem: TTabSheet;
    TSCadastro: TTabSheet;
    PnlCadastro: TPanel;
    LblCPF: TLabel;
    LblNome: TLabel;
    LblEmail: TLabel;
    LblTamCalcado: TLabel;
    LblTamCamiseta: TLabel;
    LblObservacao: TLabel;
    LblStatus: TLabel;
    EdtCPF: TDBEdit;
    EdtNome: TDBEdit;
    EdtEmail: TDBEdit;
    EdtTamCalcado: TDBEdit;
    CbTamCamiseta: TDBComboBox;
    EdtObservacao: TDBEdit;
    Panel2: TPanel;
    BtnNovo: TSpeedButton;
    BtnSalvar: TSpeedButton;
    BtnCancelar: TSpeedButton;
    BtnExcluir: TSpeedButton;
    DBGFuncionarios: TDBGrid;
    PnlNavegacao: TPanel;
    BtnPrimeiro: TSpeedButton;
    BtnAnterior: TSpeedButton;
    BtnProximo: TSpeedButton;
    BtnUltimo: TSpeedButton;
    ChkInsercaoSequencial: TCheckBox;
    ActPrimeiro: TAction;
    ActAnterior: TAction;
    ActProximo: TAction;
    ActUltimo: TAction;
    ILImagensBotoes: TImageList;
    GBFiltros: TGroupBox;
    CBFiltros: TComboBox;
    Label1: TLabel;
    EdtInformacao: TEdit;
    BtnPesquisar: TButton;
    Label2: TLabel;
    ActPesquisar: TAction;
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
    procedure EdtTamCalcadoKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure ActUltimoExecute(Sender: TObject);
    procedure ActProximoExecute(Sender: TObject);
    procedure ActAnteriorExecute(Sender: TObject);
    procedure ActPrimeiroExecute(Sender: TObject);
    procedure ActPesquisarExecute(Sender: TObject);
    procedure EdtInformacaoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CBFiltrosKeyPress(Sender: TObject; var Key: Char);
    procedure CbTamCamisetaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FFuncoes: TFuncoes;
    { Private declarations }
    Procedure AlterarStatusVisual;
    Procedure HabilitarBotoes;
    Procedure ValidarCampos;
    Procedure VerificarInsercaoSequencial;
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
    if PGGeral.ActivePage = TsListagem then
      PGGeral.ActivePage := TSCadastro;

    DSFuncionarios.DataSet.Insert;
    EdtCPF.SetFocus;
  end;
end;

procedure TFormCadastroFuncionarios.ActPesquisarExecute(Sender: TObject);
begin
  DMAplicacao.BuscarDadosFuncionarios(FFuncoes.MontarCondicaoFiltro(CBFiltros.Text, Trim(EdtInformacao.Text)));
end;

procedure TFormCadastroFuncionarios.ActPrimeiroExecute(Sender: TObject);
begin
  DSFuncionarios.DataSet.First;
end;

procedure TFormCadastroFuncionarios.ActAnteriorExecute(Sender: TObject);
begin
  DSFuncionarios.DataSet.Prior;
end;

procedure TFormCadastroFuncionarios.ActProximoExecute(Sender: TObject);
begin
  DSFuncionarios.DataSet.Next;
end;

procedure TFormCadastroFuncionarios.ActUltimoExecute(Sender: TObject);
begin
  DSFuncionarios.DataSet.Last;
end;

procedure TFormCadastroFuncionarios.ActSalvarExecute(Sender: TObject);
begin
  if DSFuncionarios.DataSet.State in [dsEdit, dsinsert] then
  begin
    ValidarCampos;
    DSFuncionarios.DataSet.Post;

    VerificarInsercaoSequencial;
    if (not ChkInsercaoSequencial.Checked) and (DSFuncionarios.DataSet.State = dsinsert) then
      ShowMessage('Funcionário inserido com sucesso.')
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

procedure TFormCadastroFuncionarios.CBFiltrosKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    Perform(CM_Dialogkey, VK_TAB, 0);
end;

procedure TFormCadastroFuncionarios.CbTamCamisetaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = vk_return then
    Perform(CM_Dialogkey, VK_TAB, 0)
end;

procedure TFormCadastroFuncionarios.DSFuncionariosStateChange(Sender: TObject);
begin
  AlterarStatusVisual;
  HabilitarBotoes;
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

procedure TFormCadastroFuncionarios.EdtInformacaoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key in [vk_return, vk_down] then
    ActPesquisar.Execute;
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

  FFuncoes := TFuncoes.Create;
end;

procedure TFormCadastroFuncionarios.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FFuncoes);
end;

procedure TFormCadastroFuncionarios.HabilitarBotoes;
begin
  BtnNovo.Enabled := DSFuncionarios.State = dsBrowse;
  BtnSalvar.Enabled := DSFuncionarios.State in [dsEdit, dsinsert];
  BtnCancelar.Enabled := DSFuncionarios.State in [dsEdit, dsinsert];;
  BtnExcluir.Enabled := DSFuncionarios.State = dsBrowse;
end;

procedure TFormCadastroFuncionarios.VerificarInsercaoSequencial;
begin
  if ChkInsercaoSequencial.Checked then
  begin
    DSFuncionarios.DataSet.Insert;
    EdtCPF.SetFocus;
  end;
end;

procedure TFormCadastroFuncionarios.ValidarCampos;
begin
  if not FFuncoes.ValidouCPF(EdtCPF.Text) then
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

end.
