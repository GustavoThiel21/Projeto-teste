program PrjTeste;

uses
  Vcl.Forms,
  UnDMAplicacao in '..\Source\UnDMAplicacao.pas' {DMAplicacao: TDataModule} ,
  UnFormAplicacao in '..\Source\UnFormAplicacao.pas' {FormAplicação} ,
  UnFormCadastroUsuarios in '..\Source\UnFormCadastroUsuarios.pas' {FormCadastroFuncionarios} ,
  UnAplicacaoFuncoes in '..\Source\UnAplicacaoFuncoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDMAplicacao, DMAplicacao);
  Application.CreateForm(TFormAplicação, FormAplicação);
  Application.Run;

end.
