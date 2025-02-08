import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/LocaleBloc/locale_bloc.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import 'package:muzn/services/database_service.dart';
import 'package:muzn/views/screens/home_screen.dart';

import 'package:muzn/views/screens/quraan_screen.dart';

import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_button.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
              content: Text(state.message.tr(context)),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is AuthAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('registration_success'.tr(context)),
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
          title: Text('register_title'.tr(context)),
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
                      builder: (context) => QuranScreen(),
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
                  hintText: 'full_name_hint'.tr(context),
                  labelText: 'full_name'.tr(context),
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required_field'.tr(context);
                    }
                    return null;
                  },
                ),
                SizedBox(height: deviceHeight * 0.02),
                CustomTextField(
                  controller: emailController,
                  hintText: 'email_hint'.tr(context),
                  labelText: 'email'.tr(context),
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required_field'.tr(context);
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'invalid_email'.tr(context);
                    }
                    return null;
                  },
                ),
                SizedBox(height: deviceHeight * 0.02),
                IntlPhoneField(
                  controller: countryController,
                  decoration: InputDecoration(
                    labelText: 'country'.tr(context),
                    hintText: 'country'.tr(context),
                    labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                    hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  showCountryFlag: false,
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
                  searchText: 'search_country'.tr(context),
                  languageCode: 'ar',
                  invalidNumberMessage: 'phone_min_length'.tr(context),
                  decoration: InputDecoration(
                    labelText: 'phone'.tr(context),
                    hintText: 'phone_hint'.tr(context),
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onCountryChanged: (country) {
                    phoneController.text = '';
                  },
                  initialCountryCode: 'SA',
                  textAlign: TextAlign.start,
                  validator: (value) {
                    if (value == null || value.number.isEmpty) {
                      return 'required_field'.tr(context);
                    }
                    return null;
                  },
                ),
                SizedBox(height: deviceHeight * 0.02),
                CustomTextField(
                  controller: passwordController,
                  hintText: 'password_hint'.tr(context),
                  labelText: 'password'.tr(context),
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  suffixIcon: Icons.visibility,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required_field'.tr(context);
                    }
                    if (value.length < 6) {
                      return 'invalid_password'.tr(context);
                    }
                    return null;
                  },
                ),
                SizedBox(height: deviceHeight * 0.02),
                CustomTextField(
                  controller: confirmPasswordController,
                  hintText: 'confirm_password_hint'.tr(context),
                  labelText: 'confirm_password_label'.tr(context),
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  suffixIcon: Icons.visibility,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required_field'.tr(context);
                    }
                    if (value != passwordController.text) {
                      return 'passwords_not_match'.tr(context);
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('gender'.tr(context)),
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
                    Text('male'.tr(context)),
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
                    Text('female'.tr(context)),
                  ],
                ),
                SizedBox(height: deviceHeight * 0.03),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return state is AuthLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            text: 'register_button'.tr(context),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // Check if email exists before registration
                                final dbHelper = DatabaseManager();
                                final db = await dbHelper.database;

                                final List<Map<String, dynamic>> existingUser =
                                    await db.query(
                                  'User',
                                  where: 'email = ? AND deleted_at IS NULL',
                                  whereArgs: [emailController.text],
                                );

                                if (existingUser.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('email_exists'.tr(context)),
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
                  text: '${'have_account'.tr(context)} ${'login_button'.tr(context)}',
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