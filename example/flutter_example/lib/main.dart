import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:opencnpj/opencnpj.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo de Cadastro OpenCNPJ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6200EE),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.interTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6200EE), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red[400]!, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _cnpjController = TextEditingController();
  final _nameController = TextEditingController();
  final _tradeNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _districtController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();

  final _cnpjFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  bool _isLoading = false;
  String? _errorMessage;
  final _openCnpj = OpenCNPJ();

  @override
  void initState() {
    super.initState();
    _cnpjController.addListener(_onCnpjChanged);
  }

  void _onCnpjChanged() {
    final unmasked = _cnpjFormatter.getUnmaskedText();
    if (unmasked.isEmpty) {
      _clearFields();
      if (_errorMessage != null) {
        setState(() {
          _errorMessage = null;
        });
      }
    }
  }

  void _clearFields() {
    _nameController.clear();
    _tradeNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _streetController.clear();
    _numberController.clear();
    _complementController.clear();
    _districtController.clear();
    _cityController.clear();
    _stateController.clear();
    _zipController.clear();
  }

  Future<void> _searchCnpj() async {
    final cnpj = _cnpjFormatter.getUnmaskedText();
    if (cnpj.length != 14) {
      setState(() {
        _errorMessage = 'Por favor, insira um CNPJ válido com 14 dígitos.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final company = await _openCnpj.search(cnpj);
      _populateFields(company);
    } on NotFoundException {
      setState(() {
        _errorMessage = 'Empresa não encontrada.';
      });
    } on InvalidCNPJException {
      setState(() {
        _errorMessage = 'Formato de CNPJ inválido.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ocorreu um erro: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _populateFields(Company company) {
    _nameController.text = company.razaoSocial;
    _tradeNameController.text = company.nomeFantasia ?? '';
    _emailController.text = company.email ?? '';

    if (company.telefones.isNotEmpty) {
      final phone = company.telefones.first;
      _phoneController.text = '(${phone.ddd}) ${phone.numero}';
    }

    _streetController.text = company.logradouro;
    _numberController.text = company.numero;
    _complementController.text = company.complemento ?? '';
    _districtController.text = company.bairro;
    _cityController.text = company.municipio;
    _stateController.text = company.uf;
    _zipController.text = company.cep;
  }

  @override
  void dispose() {
    _cnpjController.dispose();
    _nameController.dispose();
    _tradeNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _districtController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            final padding = isMobile ? 16.0 : 24.0;

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Header(),
                      Gap(isMobile ? 24 : 32),
                      if (_errorMessage != null) ...[
                        _ErrorBanner(message: _errorMessage!),
                        Gap(isMobile ? 16 : 24),
                      ],
                      _RegistrationForm(
                        formKey: _formKey,
                        cnpjController: _cnpjController,
                        cnpjFormatter: _cnpjFormatter,
                        nameController: _nameController,
                        tradeNameController: _tradeNameController,
                        emailController: _emailController,
                        phoneController: _phoneController,
                        streetController: _streetController,
                        numberController: _numberController,
                        complementController: _complementController,
                        districtController: _districtController,
                        cityController: _cityController,
                        stateController: _stateController,
                        zipController: _zipController,
                        isLoading: _isLoading,
                        onSearch: _searchCnpj,
                      ),
                    ]
                        .animate(interval: 50.ms)
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0, duration: 400.ms),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Criar Conta',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A1A),
              ),
        ),
        const Gap(8),
        Text(
          'Insira os dados da sua empresa abaixo. Use a busca por CNPJ para preenchimento automático.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
                height: 1.5,
              ),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700]),
          const Gap(12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.red[900],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final double gap;
  final CrossAxisAlignment crossAxisAlignment;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.gap = 16,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile: Column
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < children.length; i++) ...[
                if (i > 0) Gap(gap),
                children[i],
              ]
            ],
          );
        } else {
          // Tablet/Desktop: Row
          return Row(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              for (int i = 0; i < children.length; i++) ...[
                if (i > 0) Gap(gap),
                Expanded(child: children[i]),
              ]
            ],
          );
        }
      },
    );
  }
}

class _RegistrationForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController cnpjController;
  final MaskTextInputFormatter cnpjFormatter;
  final TextEditingController nameController;
  final TextEditingController tradeNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController streetController;
  final TextEditingController numberController;
  final TextEditingController complementController;
  final TextEditingController districtController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipController;
  final bool isLoading;
  final VoidCallback onSearch;

  const _RegistrationForm({
    required this.formKey,
    required this.cnpjController,
    required this.cnpjFormatter,
    required this.nameController,
    required this.tradeNameController,
    required this.emailController,
    required this.phoneController,
    required this.streetController,
    required this.numberController,
    required this.complementController,
    required this.districtController,
    required this.cityController,
    required this.stateController,
    required this.zipController,
    required this.isLoading,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use the incoming constraints to determine layout mode
        final isMobile = constraints.maxWidth < 600;
        final cardPadding = isMobile ? 20.0 : 32.0;

        return Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionLabel('Identificação da Empresa'),
                const Gap(16),
                
                if (isMobile) ...[
                   TextFormField(
                      controller: cnpjController,
                      inputFormatters: [cnpjFormatter],
                      decoration: const InputDecoration(
                        labelText: 'CNPJ',
                        hintText: '00.000.000/0000-00',
                        prefixIcon: Icon(Icons.business),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const Gap(12),
                    SizedBox(
                      height: 52,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : onSearch,
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.search),
                        label: Text(isLoading ? 'Buscando...' : 'Buscar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: cnpjController,
                          inputFormatters: [cnpjFormatter],
                          decoration: const InputDecoration(
                            labelText: 'CNPJ',
                            hintText: '00.000.000/0000-00',
                            prefixIcon: Icon(Icons.business),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const Gap(16),
                      SizedBox(
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: isLoading ? null : onSearch,
                          icon: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.search),
                          label: Text(isLoading ? 'Buscando...' : 'Buscar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                const Gap(16),
                ResponsiveRow(children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Razão Social',
                      prefixIcon: Icon(Icons.badge),
                    ),
                  ),
                  TextFormField(
                    controller: tradeNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome Fantasia',
                      prefixIcon: Icon(Icons.store),
                    ),
                  ),
                ]),
                const Gap(16),
                ResponsiveRow(children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ]),
                const Gap(32),
                _SectionLabel('Endereço'),
                const Gap(16),
                
                if (isMobile) ...[
                   Column(
                     children: [
                       TextFormField(
                          controller: zipController,
                          decoration: const InputDecoration(
                            labelText: 'CEP',
                            prefixIcon: Icon(Icons.map),
                          ),
                        ),
                        const Gap(16),
                        TextFormField(
                          controller: streetController,
                          decoration: const InputDecoration(
                            labelText: 'Logradouro',
                            prefixIcon: Icon(Icons.location_on),
                          ),
                        ),
                     ],
                   )
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: zipController,
                          decoration: const InputDecoration(
                            labelText: 'CEP',
                            prefixIcon: Icon(Icons.map),
                          ),
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: streetController,
                          decoration: const InputDecoration(
                            labelText: 'Logradouro',
                            prefixIcon: Icon(Icons.location_on),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
                
                const Gap(16),
                ResponsiveRow(children: [
                  TextFormField(
                    controller: numberController,
                    decoration: const InputDecoration(
                      labelText: 'Número',
                      prefixIcon: Icon(Icons.numbers),
                    ),
                  ),
                  TextFormField(
                    controller: complementController,
                    decoration: const InputDecoration(
                      labelText: 'Complemento',
                      prefixIcon: Icon(Icons.info_outline),
                    ),
                  ),
                ]),
                const Gap(16),
                ResponsiveRow(children: [
                  TextFormField(
                    controller: districtController,
                    decoration: const InputDecoration(
                      labelText: 'Bairro',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                  ),
                  TextFormField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      labelText: 'Município',
                      prefixIcon: Icon(Icons.apartment),
                    ),
                  ),
                  TextFormField(
                    controller: stateController,
                    decoration: const InputDecoration(
                      labelText: 'UF',
                      prefixIcon: Icon(Icons.flag),
                    ),
                  ),
                ]),
                const Gap(32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Concluir Cadastro'),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
    );
  }
}
