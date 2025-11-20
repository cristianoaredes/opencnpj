import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'company.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Company extends Equatable {
  final String cnpj;
  final String razaoSocial;
  final String? nomeFantasia;
  final String situacaoCadastral;
  final String dataSituacaoCadastral;
  final String matrizFilial;
  final String dataInicioAtividade;
  final String cnaePrincipal;
  @JsonKey(defaultValue: [])
  final List<String> cnaesSecundarios;
  final String naturezaJuridica;
  final String logradouro;
  final String numero;
  final String? complemento;
  final String bairro;
  final String cep;
  final String uf;
  final String municipio;
  final String? email;
  @JsonKey(defaultValue: [])
  final List<Phone> telefones;
  final String capitalSocial;
  final String porteEmpresa;
  final String? opcaoSimples;
  final String? dataOpcaoSimples;
  final String? opcaoMei;
  final String? dataOpcaoMei;
  @JsonKey(defaultValue: [])
  final List<Partner> qsa;

  const Company({
    required this.cnpj,
    required this.razaoSocial,
    this.nomeFantasia,
    required this.situacaoCadastral,
    required this.dataSituacaoCadastral,
    required this.matrizFilial,
    required this.dataInicioAtividade,
    required this.cnaePrincipal,
    required this.cnaesSecundarios,
    required this.naturezaJuridica,
    required this.logradouro,
    required this.numero,
    this.complemento,
    required this.bairro,
    required this.cep,
    required this.uf,
    required this.municipio,
    this.email,
    required this.telefones,
    required this.capitalSocial,
    required this.porteEmpresa,
    this.opcaoSimples,
    this.dataOpcaoSimples,
    this.opcaoMei,
    this.dataOpcaoMei,
    required this.qsa,
  });

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);

  @override
  List<Object?> get props => [
    cnpj,
    razaoSocial,
    nomeFantasia,
    situacaoCadastral,
    dataSituacaoCadastral,
    matrizFilial,
    dataInicioAtividade,
    cnaePrincipal,
    cnaesSecundarios,
    naturezaJuridica,
    logradouro,
    numero,
    complemento,
    bairro,
    cep,
    uf,
    municipio,
    email,
    telefones,
    capitalSocial,
    porteEmpresa,
    opcaoSimples,
    dataOpcaoSimples,
    opcaoMei,
    dataOpcaoMei,
    qsa,
  ];
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Phone extends Equatable {
  final String ddd;
  final String numero;
  @JsonKey(name: 'is_fax')
  final bool isFax;

  const Phone({required this.ddd, required this.numero, required this.isFax});

  factory Phone.fromJson(Map<String, dynamic> json) => _$PhoneFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneToJson(this);

  @override
  List<Object?> get props => [ddd, numero, isFax];
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Partner extends Equatable {
  final String nomeSocio;
  final String cnpjCpfSocio;
  final String qualificacaoSocio;
  final String dataEntradaSociedade;
  final String identificadorSocio;
  final String faixaEtaria;

  const Partner({
    required this.nomeSocio,
    required this.cnpjCpfSocio,
    required this.qualificacaoSocio,
    required this.dataEntradaSociedade,
    required this.identificadorSocio,
    required this.faixaEtaria,
  });

  factory Partner.fromJson(Map<String, dynamic> json) =>
      _$PartnerFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerToJson(this);

  @override
  List<Object?> get props => [
    nomeSocio,
    cnpjCpfSocio,
    qualificacaoSocio,
    dataEntradaSociedade,
    identificadorSocio,
    faixaEtaria,
  ];
}
