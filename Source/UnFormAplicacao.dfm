object FormAplicação: TFormAplicação
  Left = 0
  Top = 0
  Caption = 'Aplica'#231#227'o teste Dass'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MMGeral
  OnDestroy = FormDestroy
  TextHeight = 15
  object MMGeral: TMainMenu
    Left = 16
    Top = 24
    object Cadastrofuncionrio1: TMenuItem
      Caption = 'Funcion'#225'rios'
      object MiCadastrar: TMenuItem
        Action = ActCadastrar
      end
      object MiConsultar: TMenuItem
        Action = ActConsultar
      end
    end
    object Conexao: TMenuItem
      Caption = 'Conex'#227'o'
      object MiAtribuirBanco: TMenuItem
        Action = ActAtribuirBanco
      end
    end
  end
  object Acoes: TActionList
    Left = 16
    Top = 88
    object ActCadastrar: TAction
      Caption = '&Cadastrar'
      OnExecute = ActCadastrarExecute
    end
    object ActConsultar: TAction
      Caption = '&Consultar'
      OnExecute = ActConsultarExecute
    end
    object ActAtribuirBanco: TAction
      Caption = 'Atribuir banco'
      OnExecute = ActAtribuirBancoExecute
    end
  end
  object ODCaminhoBD: TOpenDialog
    DefaultExt = 'FDB'
    Filter = 'Arquivo banco de dados|*.FDB'
    Left = 288
    Top = 32
  end
end
