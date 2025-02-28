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
    }else{
      if(BlocProvider.of<AuthBloc>(context).userModel!=null) {
        print('auth model !=null');
        print(BlocProvider.of<AuthBloc>(context).userModel);
        final user = BlocProvider
            .of<AuthBloc>(context).userModel;
        nameController.text = user?.fullName??"";
        emailController.text = user?.email??"";
        phoneController.text = user?.phone??"";
        countryController.text = user?.country ?? '';
        gender = user?.gender;
        selectedCountry = user?.country ?? 'SA';
        // context.read<StatisticsBloc>().add(FetchStatistics(teacherId: BlocProvider
        //     .of<AuthBloc>(context)
        //     .userModel
        // !.id));

setState(() {

});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'profile'.trans(context),
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
              SnackBar(content: Text('profile_updated'.trans(context))),
            );
          }
        },
        builder: (context, state) {
          print('state is ');
           print(state);
          if(BlocProvider.of<AuthBloc>(context).userModel!=null) {

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Center(
                    //   child: Stack(
                    //     children: [
                    //       const CircleAvatar(
                    //         radius: 50,
                    //         child: Icon(Icons.person, size: 50),
                    //       ),
                    //       Positioned(
                    //         bottom: 0,
                    //         right: 0,
                    //         child: IconButton(
                    //           icon: Icon(Icons.camera_alt,
                    //               color: Theme.of(context).primaryColor),
                    //           onPressed: () {
                    //             // Handle avatar update
                    //           },
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: deviceHeight * 0.03),
                    CustomTextField(
                      controller: nameController,
                      hintText: 'full_name_hint'.trans(context),
                      labelText: 'full_name'.trans(context),
                      prefixIcon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'full_name_required'.trans(context);
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
                          return 'email_required'.trans(context);
                        }
                        if (!value.contains('@')) {
                          return 'email_invalid'.trans(context);
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: deviceHeight * 0.02),
                    IntlPhoneField(
                      controller: phoneController,
                      searchText: 'search_country'.trans(context),
                      languageCode: 'ar',
                      decoration: InputDecoration(
                        labelText: 'phone'.trans(context),
                        hintText: 'phone_hint'.trans(context),
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
                          return 'phone_required'.trans(context);
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: deviceHeight * 0.02),
                    CustomTextField(
                      controller: countryController,
                      hintText: 'country'.trans(context),
                      labelText: 'country'.trans(context),
                      prefixIcon: Icons.map,
                    ),
                    SizedBox(height: deviceHeight * 0.02),
                    CustomTextField(
                      controller: oldPasswordController,
                      hintText: 'old_password_hint'.trans(context),
                      labelText: 'old_password_label'.trans(context),
                      prefixIcon: Icons.lock,
                      obscureText: true,
                    ),
                    SizedBox(height: deviceHeight * 0.02),
                    CustomTextField(
                      controller: newPasswordController,
                      hintText: 'new_password_hint'.trans(context),
                      labelText: 'new_password_label'.trans(context),
                      prefixIcon: Icons.lock,
                      obscureText: true,
                    ),
                    SizedBox(height: deviceHeight * 0.02),
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
                    if (state is AuthLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      CustomButton(
                        text: 'update_profile_button'.trans(context),
                        icon: Icons.update,
                        onPressed: () {
                          // final updatedUser = User(
                          //     id: state.user.id,
                          //     fullName: nameController.text,
                          //     email: emailController.text,
                          //     password: oldPasswordController.text.trim(),
                          //     phone: phoneController.text,
                          //     country: countryController.text,
                          //     gender: gender ?? 'male',
                          //     role: state.user.role
                          //
                          // );

                          if (_formKey.currentState!.validate()) {

                            // context.read<AuthBloc>().add(
                            //   UpdateProfileEvent(
                            //     user: updatedUser,
                            //     newPassword: newPasswordController.text,
                            //   ),
                            // );
                          }
                        },
                      ),
                  ],
                ),
              ),
            );
          }
          if (state is! AuthAuthenticated) {

            return const Center(child: CircularProgressIndicator());
          }
          if(BlocProvider.of<AuthBloc>(context).userModel!=null) {

            return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Center(
                  //   child: Stack(
                  //     children: [
                  //       const CircleAvatar(
                  //         radius: 50,
                  //         child: Icon(Icons.person, size: 50),
                  //       ),
                  //       Positioned(
                  //         bottom: 0,
                  //         right: 0,
                  //         child: IconButton(
                  //           icon: Icon(Icons.camera_alt,
                  //               color: Theme.of(context).primaryColor),
                  //           onPressed: () {
                  //             // Handle avatar update
                  //           },
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: deviceHeight * 0.03),
                  CustomTextField(
                    controller: nameController,
                    hintText: 'full_name_hint'.trans(context),
                    labelText: 'full_name'.trans(context),
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'full_name_required'.trans(context);
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
                        return 'email_required'.trans(context);
                      }
                      if (!value.contains('@')) {
                        return 'email_invalid'.trans(context);
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: deviceHeight * 0.02),
                  IntlPhoneField(
                    controller: phoneController,
                    searchText: 'search_country'.trans(context),
                    languageCode: 'ar',
                    decoration: InputDecoration(
                      labelText: 'phone'.trans(context),
                      hintText: 'phone_hint'.trans(context),
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
                        return 'phone_required'.trans(context);
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: deviceHeight * 0.02),
                  CustomTextField(
                    controller: countryController,
                    hintText: 'country'.trans(context),
                    labelText: 'country'.trans(context),
                    prefixIcon: Icons.map,
                  ),
                  SizedBox(height: deviceHeight * 0.02),
                  CustomTextField(
                    controller: oldPasswordController,
                    hintText: 'old_password_hint'.trans(context),
                    labelText: 'old_password_label'.trans(context),
                    prefixIcon: Icons.lock,
                    obscureText: true,
                  ),
                  SizedBox(height: deviceHeight * 0.02),
                  CustomTextField(
                    controller: newPasswordController,
                    hintText: 'new_password_hint'.trans(context),
                    labelText: 'new_password_label'.trans(context),
                    prefixIcon: Icons.lock,
                    obscureText: true,
                  ),
                  SizedBox(height: deviceHeight * 0.02),
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
                  if (state is AuthLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    CustomButton(
                      text: 'update_profile_button'.trans(context),
                      icon: Icons.update,
                      onPressed: () {
                        final updatedUser = User(
                            id: state.user.id,
                            fullName: nameController.text,
                            email: emailController.text,
                            password: oldPasswordController.text.trim(),
                            phone: phoneController.text,
                            country: countryController.text,
                            gender: gender ?? 'male',
                            role: state.user.role
                            
                            );

                        if (_formKey.currentState!.validate()) {

                          context.read<AuthBloc>().add(
                                UpdateProfileEvent(
                                  user: updatedUser,
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
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Center(
                  //   child: Stack(
                  //     children: [
                  //       const CircleAvatar(
                  //         radius: 50,
                  //         child: Icon(Icons.person, size: 50),
                  //       ),
                  //       Positioned(
                  //         bottom: 0,
                  //         right: 0,
                  //         child: IconButton(
                  //           icon: Icon(Icons.camera_alt,
                  //               color: Theme.of(context).primaryColor),
                  //           onPressed: () {
                  //             // Handle avatar update
                  //           },
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: deviceHeight * 0.03),
                  CustomTextField(
                    controller: nameController,
                    hintText: 'full_name_hint'.trans(context),
                    labelText: 'full_name'.trans(context),
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'full_name_required'.trans(context);
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
                        return 'email_required'.trans(context);
                      }
                      if (!value.contains('@')) {
                        return 'email_invalid'.trans(context);
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: deviceHeight * 0.02),
                  IntlPhoneField(
                    controller: phoneController,
                    searchText: 'search_country'.trans(context),
                    languageCode: 'ar',
                    decoration: InputDecoration(
                      labelText: 'phone'.trans(context),
                      hintText: 'phone_hint'.trans(context),
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
                        return 'phone_required'.trans(context);
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: deviceHeight * 0.02),
                  CustomTextField(
                    controller: countryController,
                    hintText: 'country'.trans(context),
                    labelText: 'country'.trans(context),
                    prefixIcon: Icons.map,
                  ),
                  SizedBox(height: deviceHeight * 0.02),
                  CustomTextField(
                    controller: oldPasswordController,
                    hintText: 'old_password_hint'.trans(context),
                    labelText: 'old_password_label'.trans(context),
                    prefixIcon: Icons.lock,
                    obscureText: true,
                  ),
                  SizedBox(height: deviceHeight * 0.02),
                  CustomTextField(
                    controller: newPasswordController,
                    hintText: 'new_password_hint'.trans(context),
                    labelText: 'new_password_label'.trans(context),
                    prefixIcon: Icons.lock,
                    obscureText: true,
                  ),
                  SizedBox(height: deviceHeight * 0.02),
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
                  if (state is AuthLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    CustomButton(
                      text: 'update_profile_button'.trans(context),
                      icon: Icons.update,
                      onPressed: () {
                        final updatedUser = User(
                            id: state.user.id,
                            fullName: nameController.text,
                            email: emailController.text,
                            password: oldPasswordController.text.trim(),
                            phone: phoneController.text,
                            country: countryController.text,
                            gender: gender ?? 'male',
                            role: state.user.role

                        );

                        if (_formKey.currentState!.validate()) {

                          context.read<AuthBloc>().add(
                            UpdateProfileEvent(
                              user: updatedUser,
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
