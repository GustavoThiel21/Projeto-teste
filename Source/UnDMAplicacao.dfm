object DMAplicacao: TDMAplicacao
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 253
  Width = 414
  object FDQFuncionarios: TFDQuery
    OnNewRecord = FDQFuncionariosNewRecord
    Connection = FDConexao
    Left = 72
    Top = 104
    object FDQFuncionariosCPF: TStringField
      DisplayWidth = 14
      FieldName = 'CPF'
      OnGetText = FDQFuncionarioscpfGetText
      OnSetText = FDQFuncionarioscpfSetText
      EditMask = '999.999.999-99;1;_'
      Size = 14
    end
    object FDQFuncionariosNOME: TStringField
      FieldName = 'NOME'
      Size = 200
    end
    object FDQFuncionariosEMAIL: TStringField
      FieldName = 'EMAIL'
      Size = 100
    end
    object FDQFuncionariosTAMCAMISA: TStringField
      FieldName = 'TAMCAMISA'
      Size = 10
    end
    object FDQFuncionariosTAMCALCADO: TIntegerField
      Alignment = taLeftJustify
      FieldName = 'TAMCALCADO'
    end
    object FDQFuncionariosOBSERVACAO: TStringField
      FieldName = 'OBSERVACAO'
      Size = 300
    end
    object FDQFuncionariosIDFUNCIONARIO: TLargeintField
      FieldName = 'IDFUNCIONARIO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
  end
  object FDConexao: TFDConnection
    Params.Strings = (
      'DriverID=FB'
      'User_Name=sysdba'
      'Password=masterkey')
    Left = 72
    Top = 32
  end
end
