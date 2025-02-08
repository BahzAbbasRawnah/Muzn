import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import 'package:muzn/models/user.dart';
import 'package:muzn/views/widgets/app_drawer.dart';
import 'package:muzn/views/widgets/custom_app_bar.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  String? selectedCountry = 'SA';
  String? gender = 'male';

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      nameController.text = user.fullName;
      emailController.text = user.email;
      phoneController.text = user.phone;
      countryController.text = user.country ?? '';
      gender = user.gender;
      selectedCountry = user.country ?? 'SA';
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'profile'.tr(context),
        scaffoldKey: _scaffoldKey,
      ),
      drawer: const AppDrawer(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('profile_updated'.tr(context))),
            );
          }
        },
        builder: (context, state) {
          if (state is! AuthAuthenticated) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person, size: 50),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.camera_alt,
                                color: Theme.of(context).primaryColor),
                            onPressed: () {
                              // Handle avatar update
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.03),

                  CustomTextField(
                    controller: nameController,
                    hintText: 'full_name_hint'.tr(context),
                    labelText: 'full_name'.tr(context),
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'full_name_required'.tr(context);
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
                        return 'email_required'.tr(context);
                      }
                      if (!value.contains('@')) {
                        return 'email_invalid'.tr(context);
                      }
                      return null;
                    },
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
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.start,
                    initialCountryCode: selectedCountry,
                    onCountryChanged: (selectedCountry) {
                      String translatedCountryName =
                          selectedCountry.nameTranslations['ar'] ??
                              selectedCountry.name;
                      countryController.text = translatedCountryName;
                    },
                    validator: (value) {
                      if (value == null || value.number.isEmpty) {
                        return 'phone_required'.tr(context);
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: deviceHeight * 0.02),

                  CustomTextField(
                    controller: countryController,
                    hintText: 'country'.tr(context),
                    labelText: 'country'.tr(context),
                    prefixIcon: Icons.map,
                  ),
                  SizedBox(height: deviceHeight * 0.02),

                  CustomTextField(
                    controller: oldPasswordController,
                    hintText: 'old_password_hint'.tr(context),
                    labelText: 'old_password_label'.tr(context),
                    prefixIcon: Icons.lock,
                    obscureText: true,
                  ),
                  SizedBox(height: deviceHeight * 0.02),

                  CustomTextField(
                    controller: newPasswordController,
                    hintText: 'new_password_hint'.tr(context),
                    labelText: 'new_password_label'.tr(context),
                    prefixIcon: Icons.lock,
                    obscureText: true,
                  ),
                  SizedBox(height: deviceHeight * 0.02),

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

                  if (state is AuthLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    CustomButton(
                      text: 'update_profile'.tr(context),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                UpdateProfileEvent(
                                  fullName: nameController.text,
                                  email: emailController.text,
                                  phone: phoneController.text,
                                  country: countryController.text,
                                  gender: gender ?? 'male',
                                  oldPassword: oldPasswordController.text,
                                  newPassword: newPasswordController.text,
                                ),
                              );
                        }
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    countryController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }
}
