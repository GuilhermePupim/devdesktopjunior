object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Consulta de CEP'
  ClientHeight = 543
  ClientWidth = 500
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 13
  object LabelEndereco: TLabel
    Left = 17
    Top = 277
    Width = 122
    Height = 13
    Caption = 'Endereco / Logradouro:'
  end
  object LabelBairro: TLabel
    Left = 17
    Top = 323
    Width = 33
    Height = 13
    Caption = 'Bairro:'
  end
  object LabelCidade: TLabel
    Left = 18
    Top = 415
    Width = 63
    Height = 13
    Caption = 'Cidade / UF:'
  end
  object LabelComplemento: TLabel
    Left = 280
    Top = 277
    Width = 75
    Height = 13
    Caption = 'Complemento:'
  end
  object LabelIBGE: TLabel
    Left = 280
    Top = 323
    Width = 26
    Height = 13
    Caption = 'IBGE:'
  end
  object LabelDDD: TLabel
    Left = 229
    Top = 415
    Width = 27
    Height = 13
    Caption = 'DDD:'
  end
  object LabelGIA: TLabel
    Left = 17
    Top = 369
    Width = 21
    Height = 13
    Caption = 'GIA:'
  end
  object LabelSIAF: TLabel
    Left = 280
    Top = 369
    Width = 28
    Height = 13
    Caption = 'SIAFI:'
  end
  object LabelCEP: TLabel
    Left = 17
    Top = 13
    Width = 22
    Height = 13
    Caption = 'CEP:'
  end
  object EditCep: TEdit
    Left = 16
    Top = 32
    Width = 150
    Height = 21
    Hint = 'Digite o CEP (apenas n'#195#186'meros)'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    TextHint = 'Digite o CEP'
  end
  object btnConsultar: TButton
    Left = 279
    Top = 32
    Width = 90
    Height = 25
    Caption = 'Consultar'
    TabOrder = 1
    OnClick = btnConsultarClick
  end
  object btnSalvar: TButton
    Left = 375
    Top = 32
    Width = 90
    Height = 25
    Caption = 'Salvar'
    TabOrder = 2
    OnClick = btnSalvarClick
  end
  object EditEndereco: TEdit
    Left = 17
    Top = 296
    Width = 239
    Height = 21
    TabOrder = 3
  end
  object EditBairro: TEdit
    Left = 17
    Top = 342
    Width = 239
    Height = 21
    TabOrder = 4
  end
  object EditCidade: TEdit
    Left = 18
    Top = 434
    Width = 150
    Height = 21
    TabOrder = 5
  end
  object EditUF: TEdit
    Left = 174
    Top = 434
    Width = 29
    Height = 21
    TabOrder = 6
  end
  object EditComplemento: TEdit
    Left = 280
    Top = 296
    Width = 186
    Height = 21
    TabOrder = 7
  end
  object EditIBGE: TEdit
    Left = 280
    Top = 342
    Width = 186
    Height = 21
    TabOrder = 8
  end
  object EditDDD: TEdit
    Left = 229
    Top = 434
    Width = 33
    Height = 21
    TabOrder = 9
  end
  object EditGIA: TEdit
    Left = 18
    Top = 388
    Width = 238
    Height = 21
    TabOrder = 10
  end
  object EditSIAFI: TEdit
    Left = 280
    Top = 388
    Width = 186
    Height = 21
    TabOrder = 11
  end
  object RetornoJson: TMemo
    Left = 17
    Top = 63
    Width = 448
    Height = 208
    Hint = 'O resultado ser'#225' apresentado aqui'
    Ctl3D = True
    Lines.Strings = (
      'RetornoJson')
    ParentCtl3D = False
    TabOrder = 12
  end
  object btnConsUF: TButton
    Left = 280
    Top = 432
    Width = 75
    Height = 25
    Caption = 'Consultar UF'
    TabOrder = 13
    OnClick = btnConsUFClick
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=devjunior'
      'User_Name=postgres'
      'Password=tecno@123'
      'Server=localhost'
      'DriverID=PG')
    Left = 576
    Top = 96
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 616
    Top = 136
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    Dataset = FDQuery1
    FieldDefs = <>
    Left = 616
    Top = 176
  end
  object RESTResponse1: TRESTResponse
    Left = 616
    Top = 232
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorHome = 
      'C:\Users\Carotan\Documents\Embarcadero\Studio\Projects\ConsultaC' +
      'ep\lib'
    Left = 616
    Top = 288
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 576
    Top = 136
  end
  object FDMemTable1: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 576
    Top = 176
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 576
    Top = 232
  end
  object RESTClient1: TRESTClient
    Params = <>
    SynchronizedEvents = False
    Left = 576
    Top = 288
  end
end
