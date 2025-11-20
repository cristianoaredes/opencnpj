// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
  cnpj: json['cnpj'] as String,
  razaoSocial: json['razao_social'] as String,
  nomeFantasia: json['nome_fantasia'] as String?,
  situacaoCadastral: json['situacao_cadastral'] as String,
  dataSituacaoCadastral: json['data_situacao_cadastral'] as String,
  matrizFilial: json['matriz_filial'] as String,
  dataInicioAtividade: json['data_inicio_atividade'] as String,
  cnaePrincipal: json['cnae_principal'] as String,
  cnaesSecundarios: (json['cnaes_secundarios'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  naturezaJuridica: json['natureza_juridica'] as String,
  logradouro: json['logradouro'] as String,
  numero: json['numero'] as String,
  complemento: json['complemento'] as String?,
  bairro: json['bairro'] as String,
  cep: json['cep'] as String,
  uf: json['uf'] as String,
  municipio: json['municipio'] as String,
  email: json['email'] as String?,
  telefones: (json['telefones'] as List<dynamic>)
      .map((e) => Phone.fromJson(e as Map<String, dynamic>))
      .toList(),
  capitalSocial: json['capital_social'] as String,
  porteEmpresa: json['porte_empresa'] as String,
  opcaoSimples: json['opcao_simples'] as String?,
  dataOpcaoSimples: json['data_opcao_simples'] as String?,
  opcaoMei: json['opcao_mei'] as String?,
  dataOpcaoMei: json['data_opcao_mei'] as String?,
  qsa: (json['qsa'] as List<dynamic>)
      .map((e) => Partner.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
  'cnpj': instance.cnpj,
  'razao_social': instance.razaoSocial,
  'nome_fantasia': instance.nomeFantasia,
  'situacao_cadastral': instance.situacaoCadastral,
  'data_situacao_cadastral': instance.dataSituacaoCadastral,
  'matriz_filial': instance.matrizFilial,
  'data_inicio_atividade': instance.dataInicioAtividade,
  'cnae_principal': instance.cnaePrincipal,
  'cnaes_secundarios': instance.cnaesSecundarios,
  'natureza_juridica': instance.naturezaJuridica,
  'logradouro': instance.logradouro,
  'numero': instance.numero,
  'complemento': instance.complemento,
  'bairro': instance.bairro,
  'cep': instance.cep,
  'uf': instance.uf,
  'municipio': instance.municipio,
  'email': instance.email,
  'telefones': instance.telefones,
  'capital_social': instance.capitalSocial,
  'porte_empresa': instance.porteEmpresa,
  'opcao_simples': instance.opcaoSimples,
  'data_opcao_simples': instance.dataOpcaoSimples,
  'opcao_mei': instance.opcaoMei,
  'data_opcao_mei': instance.dataOpcaoMei,
  'qsa': instance.qsa,
};

Phone _$PhoneFromJson(Map<String, dynamic> json) => Phone(
  ddd: json['ddd'] as String,
  numero: json['numero'] as String,
  isFax: json['is_fax'] as bool,
);

Map<String, dynamic> _$PhoneToJson(Phone instance) => <String, dynamic>{
  'ddd': instance.ddd,
  'numero': instance.numero,
  'is_fax': instance.isFax,
};

Partner _$PartnerFromJson(Map<String, dynamic> json) => Partner(
  nomeSocio: json['nome_socio'] as String,
  cnpjCpfSocio: json['cnpj_cpf_socio'] as String,
  qualificacaoSocio: json['qualificacao_socio'] as String,
  dataEntradaSociedade: json['data_entrada_sociedade'] as String,
  identificadorSocio: json['identificador_socio'] as String,
  faixaEtaria: json['faixa_etaria'] as String,
);

Map<String, dynamic> _$PartnerToJson(Partner instance) => <String, dynamic>{
  'nome_socio': instance.nomeSocio,
  'cnpj_cpf_socio': instance.cnpjCpfSocio,
  'qualificacao_socio': instance.qualificacaoSocio,
  'data_entrada_sociedade': instance.dataEntradaSociedade,
  'identificador_socio': instance.identificadorSocio,
  'faixa_etaria': instance.faixaEtaria,
};
