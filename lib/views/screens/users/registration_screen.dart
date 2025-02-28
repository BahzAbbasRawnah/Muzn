import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/LocaleBloc/locale_bloc.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import 'package:muzn/services/database_service.dart';
import 'package:muzn/views/screens/home_screen.dart';
import 'package:muzn/views/screens/quran_pdf_screen.dart';

import 'package:muzn/views/screens/quran_screen.dart';

import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_button.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();

  String? gender = 'male'; // Default gender
  String? country = 'السعودية';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message.trans(context)),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is AuthAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('registration_success'.trans(context)),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, state) {
              final currentLocale = state is LocaleLoadedState
                  ? state.locale.languageCode
                  : 'ar';

              return PopupMenuButton<String>(
                onSelected: (String value) {
                  context.read<LocaleBloc>().add(ChangeLocaleEvent(value));
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'en',
                    child: Row(
                      children: [
                        Image.asset('assets/flags/us_flag.png', width: 24),
                        const SizedBox(width: 8),
                        const Text('English'),
                        if (currentLocale == 'en')
                          const Icon(Icons.check, color: Color(0xffda9f35)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'ar',
                    child: Row(
                      children: [
                        Image.asset('assets/flags/ar_flag.png', width: 24),
                        const SizedBox(width: 8),
                        const Text('العربية'),
                        if (currentLocale == 'ar')
                          const Icon(Icons.check, color: Color(0xffda9f35)),
                      ],
                    ),
                  ),
                ],
                icon: const Icon(Icons.language),
              );
            },
          ),
          title: Text('register_title'.trans(context)),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                child: Image.asset(
                  'assets/images/quran.png',
                  fit: BoxFit.contain,
                  width: 40,
                  height: 40,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuranPdfScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    height: deviceHeight * 0.15,
                  ),
                ),
                SizedBox(height: deviceHeight * 0.02),
                CustomTextField(
                  controller: nameController,
                  hintText: 'full_name_hint'.trans(context),
                  labelText: 'full_name'.trans(context),
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required_field'.trans(context);
                    }
                    return null;
                  },
                ),
                SizedBox(height: deviceHeight * 0.02),
                CustomTextField(
                  controller: emailController,
                  hintText: 'email_hint'.trans(context),
                  labelText: 'email'.trans(context),
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required_field'.trans(context);
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'invalid_email'.trans(context);
                    }
                    return null;
                  },
                ),
                SizedBox(height: deviceHeight * 0.02),
                
                IntlPhoneField(
                  controller: countryController,
                  decoration: InputDecoration(
                    labelText: 'country'.trans(context),
                    hintText: 'country'.trans(context),
                    labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                    hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  showCountryFlag: true,
                  
                  initialValue: country,
                  initialCountryCode: 'SA',
                  languageCode: 'ar',
                  textAlign: TextAlign.start,
                  disableLengthCheck: true,
                  onCountryChanged: (selectedCountry) {
                    String translatedCountryName =
                        selectedCountry.nameTranslations['ar'] ??
                            selectedCountry.name;
                    setState(() {
                      country = translatedCountryName;
                      countryController.text = country!;
                    });
                  },
                ),
                SizedBox(height: deviceHeight * 0.02),
                IntlPhoneField(
                  controller: phoneController,
                  showCountryFlag: false,
                  showDropdownIcon: false,
                  searchText: 'search_country'.trans(context),
                  languageCode: 'ar',
                  invalidNumberMessage: 'phone_min_length'.trans(context),
                  decoration: InputDecoration(
                    labelText: 'phone'.trans(context),
                    hintText: 'phone_hint'.trans(context),
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onCountryChanged: (country) {
                    countryCodeController.text=country.dialCode;
                    phoneController.text = '';
                  },
                  initialCountryCode: 'SA',
                  textAlign: TextAlign.start,
                  validator: (value) {
                    if (value == null || value.number.isEmpty) {
                      return 'required_field'.trans(context);
                    }
                    return null;
                  },
                ),
                SizedBox(height: deviceHeight * 0.02),
                CustomTextField(
                  controller: passwordController,
                  hintText: 'password_hint'.trans(context),
                  labelText: 'password'.trans(context),
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  suffixIcon: Icons.visibility,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required_field'.trans(context);
                    }
                    if (value.length < 6) {
                      return 'invalid_password'.trans(context);
                    }
                    return null;
                  },
                ),
                SizedBox(height: deviceHeight * 0.02),
                CustomTextField(
                  controller: confirmPasswordController,
                  hintText: 'confirm_password_hint'.trans(context),
                  labelText: 'confirm_password_label'.trans(context),
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  suffixIcon: Icons.visibility,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required_field'.trans(context);
                    }
                    if (value != passwordController.text) {
                      return 'passwords_not_match'.trans(context);
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('gender'.trans(context)),
                    Radio<String>(
                      value: 'male',
                      groupValue: gender,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value) {
                        setState(() {
                          gender = value;
                        });
                      },
                    ),
                    Text('male'.trans(context)),
                    Radio<String>(
                      value: 'female',
                      groupValue: gender,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value) {
                        setState(() {
                          gender = value;
                        });
                      },
                    ),
                    Text('female'.trans(context)),
                  ],
                ),
                SizedBox(height: deviceHeight * 0.03),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return state is AuthLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            text: 'register_button'.trans(context),
                            onPressed: () async {
                              print("phoneController.text");
                              print(phoneController.text);
                              print("countryCodeController.text");
                              print(countryCodeController.text);
                              if (_formKey.currentState!.validate()) {
                                // Check if email exists before registration
                                final dbHelper = DatabaseManager();
                                final db = await dbHelper.database;
print("phoneController.text");
print(phoneController.text);
                                final List<Map<String, dynamic>> existingUser =
                                    await db.query(
                                  'User',
                                  where: 'email = ? AND deleted_at IS NULL',
                                  whereArgs: [emailController.text],
                                );

                                if (existingUser.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('email_exists'.trans(context)),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                // Proceed with registration
                                context.read<AuthBloc>().add(
                                  RegisterEvent(
                                    fullName: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
                                    country: countryController.text,
                                    countryCode: countryCodeController.text,
                                    gender: gender ?? 'male',
                                  ),
                                );
                              }
                            },
                          );
                  },
                ),
                SizedBox(height: deviceHeight * 0.02),
                CustomTextButton(
                  text: '${'have_account'.trans(context)} ${'login_button'.trans(context)}',
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    countryController.dispose();
    super.dispose();
  }
}