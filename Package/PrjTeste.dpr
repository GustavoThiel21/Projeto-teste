program PrjTeste;

uses
  Vcl.Forms,
  UnDMAplicacao in '..\Source\UnDMAplicacao.pas' {DMAplicacao: TDataModule} ,
  UnFormAplicacao in '..\Source\UnFormAplicacao.pas' {FormAplicação} ,
  UnFormCadastroUsuarios in '..\Source\UnFormCadastroUsuarios.pas' {FormCadastroFuncionarios} ,
  UnFormConsultarUsuarios in '..\Source\UnFormConsultarUsuarios.pas' {FormConsultarFuncionarios};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDMAplicacao, DMAplicacao);
  Application.CreateForm(TFormAplicação, FormAplicação);
  // Application.CreateForm(TFormConsultarFuncionarios, FormConsultarFuncionarios);
  // Application.CreateForm(TFormCadastroFuncionarios, FormCadastroFuncionarios);
  Application.Run;

end.
