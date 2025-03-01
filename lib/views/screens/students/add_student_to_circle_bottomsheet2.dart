import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart' ;
// import 'package:get/get.dart' as get; // Import with an alias

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/circle_student/add_student_cubit.dart';
import '../../../blocs/circle_student/circle_student_bloc.dart';
import '../../widgets/custom_button.dart';
import 'package:muzn/app_localization.dart';

import '../../widgets/custom_text_field.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class AddStudentToCircleBottomSheet2 extends StatefulWidget {
  final int circleId;

  const AddStudentToCircleBottomSheet2({super.key, required this.circleId});

  @override
  _AddStudentToCircleBottomSheetState createState() =>
      _AddStudentToCircleBottomSheetState();
}

class _AddStudentToCircleBottomSheetState
    extends State<AddStudentToCircleBottomSheet2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  String? gender = 'male';
  String? country = 'السعودية';
  String _phoneNumber = '';

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    countryCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
          ),
          child: BlocConsumer<AddStudentCubit, AddStudentState>(
            listener: (context, state) async {
              if (state is AddStudentSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('added_successfully'.trans(context)),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
                // Load the circle students again
                context.read<CircleStudentBloc>().add(
                      LoadCircleStudents(
                        context,
                        circleId: widget.circleId,
                      ),
                    );
              } else if (state is AddStudentError) {
                print("state.message: ${state.message}");
                Get.snackbar(
                  '', // Title of the snackbar
                  state.message ?? 'An unknown error occurred', // Message of the snackbar
                  backgroundColor: Colors.red, // Background color of the snackbar
                  colorText: Colors.white, // Text color of the snackbar
                  borderRadius: 8.0, // Border radius of the snackbar
                  margin: EdgeInsets.all(16), // Margin around the snackbar
                  snackPosition: SnackPosition.BOTTOM, // Position of the snackbar (TOP or BOTTOM)
                  duration: Duration(seconds: 3), // Duration the snackbar is shown
                  icon: Icon(Icons.error, color: Colors.white), // Optional icon
                );
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text(state.message ?? 'An unknown error occurred'),
                //     backgroundColor: Colors.red,
                //   ),
                // );

                // Optionally add a delay before navigating or performing another action
                await Future.delayed(Duration(seconds: 2)); // Adjust duration as needed
              }

            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'add_new_student'.trans(context),
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Full Name field
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

                    // Email field
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

                    // Country field
                    // IntlPhoneField(
                    //   decoration: InputDecoration(
                    //     labelText: 'country'.tr(context),
                    //     hintText: 'country'.tr(context),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(8.0),
                    //     ),
                    //   ),
                    //   initialCountryCode: 'SA',
                    //   onCountryChanged: (country) {
                    //     setState(() {
                    //       this.country = country.name;
                    //     });
                    //   },
                    // ),
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

                    // Phone field
                    IntlPhoneField(
                      invalidNumberMessage: 'phone_min_length'.trans(context),
                      decoration: InputDecoration(
                        labelText: 'phone'.trans(context),
                        hintText: 'phone_hint'.trans(context),
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      searchText: 'search_country'.trans(context),
                      languageCode: 'ar',
                      initialCountryCode: 'SA',
                      onChanged: (phone) {
                        print('phone.countryCode');
                        print(phone.countryCode);
                        print('phone.number');
                        print(phone.number);
                        _phoneNumber = phone.number;
                        countryCodeController.text=phone.countryCode;
                      },
                      validator: (value) {
                        if (value == null || value.number.isEmpty) {
                          return 'required_field'.trans(context);
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: deviceHeight * 0.02),

                    // Password field
                    CustomTextField(
                      controller: passwordController,
                      hintText: 'password_hint'.trans(context),
                      labelText: 'password'.trans(context),
                      prefixIcon: Icons.lock,
                      obscureText: true,
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

                    // Gender selection
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
                    SizedBox(height: deviceHeight * 0.02),

                    // Save button
                    if (state is AddStudentLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      CustomButton(
                        text: 'save'.trans(context),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            var user=BlocProvider.of<AuthBloc>(context).userModel;
                            final teacherId =user!.id;
                            final cubit = context.read<AddStudentCubit>();
                            cubit.saveStudent(
                              fullName: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              phone: _phoneNumber,
                              countryCode: countryCodeController.text,
                              country: country!,
                              gender: gender!,
                              teacherId: teacherId,
                              circleId: widget.circleId,
                            );
                          }
                        },
                        icon: Icons.save,
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
