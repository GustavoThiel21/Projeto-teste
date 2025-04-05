unit UnFormAplicacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.StdCtrls, Vcl.ExtCtrls, UnFormCadastroUsuarios,
  UnDMAplicacao, Vcl.Menus, System.Actions, Vcl.ActnList;

type
  TFormAplica��o = class(TForm)
    MMGeral: TMainMenu;
    Cadastrofuncionrio1: TMenuItem;
    Acoes: TActionList;
    ActCadastrar: TAction;
    ActConsultar: TAction;
    ActAtribuirBanco: TAction;
    Conexao: TMenuItem;
    MiAtribuirBanco: TMenuItem;
    ODCaminhoBD: TOpenDialog;
    procedure FormDestroy(Sender: TObject);
    procedure ActCadastrarExecute(Sender: TObject);
    procedure ActAtribuirBancoExecute(Sender: TObject);
  private
    FFormCadastroFuncionarios: TFormCadastroFuncionarios;
    function GetFormCadastroFuncionarios: TFormCadastroFuncionarios;
    procedure SetFormCadastroFuncionarios(const Value: TFormCadastroFuncionarios);
    { Private declarations }
    property FormCadastroFuncionarios: TFormCadastroFuncionarios read GetFormCadastroFuncionarios
      write SetFormCadastroFuncionarios;
  public
    { Public declarations }
  end;

var
  FormAplica��o: TFormAplica��o;

implementation

{$R *.dfm}
{ TFormAplica��o }

procedure TFormAplica��o.ActAtribuirBancoExecute(Sender: TObject);
begin
  if ODCaminhoBD.Execute then
    DMAplicacao.AlterarCaminhoBD(ODCaminhoBD.FileName);
end;

procedure TFormAplica��o.ActCadastrarExecute(Sender: TObject);
begin
  FormCadastroFuncionarios.Show;
end;

procedure TFormAplica��o.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FormCadastroFuncionarios);
  inherited;
end;

function TFormAplica��o.GetFormCadastroFuncionarios: TFormCadastroFuncionarios;
begin
  if not Assigned(FFormCadastroFuncionarios) then
    Result := TFormCadastroFuncionarios.Create(nil)
  else
    Result := FFormCadastroFuncionarios;
end;

procedure TFormAplica��o.SetFormCadastroFuncionarios(const Value: TFormCadastroFuncionarios);
begin
  FormCadastroFuncionarios := FFormCadastroFuncionarios;
end;

end.
