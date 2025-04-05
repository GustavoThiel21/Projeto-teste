unit UnAplicacaoFuncoes;

interface

type
  TFuncoes = class
  public
    Function ValidouCPF(ACPF: string): Boolean;
    Function MontarCondicaoFiltro(ACampo, AInformacao: string): String;
  end;

implementation

{ TFuncoes }

Uses System.SysUtils;

function TFuncoes.MontarCondicaoFiltro(ACampo, AInformacao: string): String;
Const
  CCondicaoTexto = 'FUNCIONARIOS.%0:s CONTAINING ''%1:s''';
  CCondicaoNumerico = 'FUNCIONARIOS.%0:s = %1:s';
begin
  Result := EmptyStr;

  if AInformacao = EmptyStr then
    Exit;

  if ACampo = 'CPF' then
    Result := Format(CCondicaoTexto, ['CPF', AInformacao])
  else if ACampo = 'Nome do funcionário' then
    Result := Format(CCondicaoTexto, ['NOME', AInformacao])
  else if ACampo = 'E-mail' then
    Result := Format(CCondicaoTexto, ['EMAIL', AInformacao])
  else if ACampo = 'Tamanho de camiseta' then
    Result := Format(CCondicaoTexto, ['TAMCAMISA', AInformacao])
  else if ACampo = 'Tamanho de calçado' then
    Result := Format(CCondicaoNumerico, ['TAMCALCADO', AInformacao]);
end;

function TFuncoes.ValidouCPF(ACPF: string): Boolean;
var
  LCPF: String;
  dig10, dig11: ShortString;
  s, i, r, peso: integer;
begin
  LCPF := StringReplace(ACPF, '.', '', [rfReplaceAll]);
  LCPF := StringReplace(LCPF, '-', '', [rfReplaceAll]);

  if (length(LCPF) <> 11) then
  begin
    Result := False;
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
      Result := True
    else
      Result := False;
  except
    Result := False;
  end;
end;

end.
