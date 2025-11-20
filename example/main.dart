import 'package:opencnpj/opencnpj.dart';

void main() async {
  final opencnpj = OpenCNPJ();

  // Replace with a valid CNPJ
  const cnpj = '06.990.590/0001-23'; // Example: GOOGLE BRASIL INTERNET LTDA.

  try {
    print('Searching for CNPJ: $cnpj');
    final company = await opencnpj.search(cnpj);
    print('Company Found: ${company.razaoSocial}');
    print('CNPJ: ${company.cnpj}');
    print('Status: ${company.situacaoCadastral}');
    if (company.email != null) {
      print('Email: ${company.email}');
    }
    if (company.telefones.isNotEmpty) {
      print(
        'Phone: (${company.telefones.first.ddd}) ${company.telefones.first.numero}',
      );
    }
    if (company.qsa.isNotEmpty) {
      print('Partners: ');
      for (final partner in company.qsa) {
        print('- ${partner.nomeSocio} (${partner.qualificacaoSocio})');
      }
    }
  } on InvalidCNPJException catch (e) {
    print('Error: ${e.message}');
  } on NotFoundException catch (e) {
    print('Error: ${e.message}');
  } on OpenCNPJException catch (e) {
    print('Error: ${e.message}');
  } catch (e) {
    print('An unexpected error occurred: $e');
  }
}
