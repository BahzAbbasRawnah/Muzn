import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/bloc/LocaleBloc/locale_bloc.dart';
import 'package:muzn/controllers/auth_controller.dart';
import 'package:muzn/models/user_model.dart';
import 'package:muzn/utils/request_status.dart';
import 'package:muzn/views/screens/home_screen.dart';
import 'package:muzn/views/screens/login_screen.dart';
import 'package:muzn/views/screens/quraan_screen.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_text_button.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';
import 'package:muzn/views/widgets/message.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthController _authController = new AuthController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? gender = 'male'; // Default gender
  String? countryName = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton<String>(
          onSelected: (String value) {
            // Dispatch a ChangeLocaleEvent to the LocaleBloc
            if (value == 'en') {
              context.read<LocaleBloc>().add(ChangeLocaleEvent('en'));
            } else if (value == 'ar') {
              context.read<LocaleBloc>().add(ChangeLocaleEvent('ar'));
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 'en',
              child: Text('English'),
            ),
            const PopupMenuItem(
              value: 'ar',
              child: Text('العربية'),
            ),
          ],
          child: const Icon(Icons.language),
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
                validator: (value) => value!.isEmpty
                    ? 'auth_error.full_name_required'.tr(context)
                    : null,
              ),
              SizedBox(height: deviceHeight * 0.02),
              CustomTextField(
                controller: emailController,
                hintText: 'email_hint'.tr(context),
                labelText: 'email'.tr(context),
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty
                    ? 'auth_error.email_required'.tr(context)
                    : null,
              ),
              SizedBox(height: deviceHeight * 0.02),
              IntlPhoneField(
                controller: phoneController,
                searchText: 'search_country'.tr(context),
                languageCode: 'ar',
                decoration: InputDecoration(
                  labelText: 'phone'.tr(context),
                  hintText: 'phone_hint'.tr(context),
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                initialCountryCode: 'SA',
                onCountryChanged: (country) => countryName = country.name,
                // validator: (value) => value!.number.isEmpty
                //     ? 'Please enter a valid phone number'.tr(context)
                //     : null,
              ),
              SizedBox(height: deviceHeight * 0.02),
              CustomTextField(
                controller: passwordController,
                hintText: 'password_hint'.tr(context),
                labelText: 'password'.tr(context),
                prefixIcon: Icons.lock,
                obscureText: true,
                suffixIcon: Icons.visibility,
                validator: (value) => value!.isEmpty
                    ? 'auth_error.password_required'.tr(context)
                    : null,
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
                  if (value!.isEmpty)
                    return 'auth_error.confirm_password_required'.tr(context);
                  if (value != passwordController.text)
                    return 'auth_error.passwords_do_not_match'.tr(context);
                  return null;
                },
              ),
              Row(
                children: [
                  Text('gender'.tr(context),
                      style: Theme.of(context).textTheme.labelMedium),
                  Radio<String>(
                    value: 'male',
                    groupValue: gender,
                    onChanged: (value) => setState(() => gender = value),
                  ),
                  Text('male'.tr(context),
                      style: Theme.of(context).textTheme.labelMedium),
                  Radio<String>(
                    value: 'female',
                    groupValue: gender,
                    onChanged: (value) => setState(() => gender = value),
                  ),
                  Text('female'.tr(context),
                      style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
              SizedBox(height: deviceHeight * 0.03),
              CustomButton(
                text: 'register_button'.tr(context),
             onPressed: () async {
  if (_formKey.currentState!.validate()) {
    // Create a User object with the entered data
    final User user = User(
      fullName: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text.trim(),
      gender: gender.toString(),
      country: phoneController.text.trim(),
      role: "teacher",
      status: "active",
    );

    RequestStatus result = await _authController.registerUser(user);

    if (result.status) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      ErrorSnackbar.show(context: context, errorText: result.message);
    }
  }
},

                icon: Icons.touch_app,
              ),
              CustomTextButton(
                text:
                    '${'have_account'.tr(context)} ${'login_button'.tr(context)}',
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
