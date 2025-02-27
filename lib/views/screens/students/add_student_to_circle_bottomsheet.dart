import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import 'package:muzn/blocs/circle_student/circle_student_bloc.dart';
import 'package:muzn/services/database_service.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';
import 'package:muzn/views/widgets/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddStudentToCircleBottomSheet extends StatefulWidget {
  final int circleId;

  const AddStudentToCircleBottomSheet({
    Key? key,
    required this.circleId,
  }) : super(key: key);

  @override
  _AddStudentToCircleBottomSheetState createState() =>
      _AddStudentToCircleBottomSheetState();
}

class _AddStudentToCircleBottomSheetState
    extends State<AddStudentToCircleBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  String? gender = 'male';
  String? country = 'السعودية';
  bool _isLoading = false;
  String _phoneNumber = '';

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    countryController.dispose();
    super.dispose();
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;


    setState(() => _isLoading = true);

    try {
      // Get current authenticated user from AuthBloc
      final authState = context.read<AuthBloc>().state;
      if (authState is! AuthAuthenticated) {
        throw Exception('No authenticated user found');
      }


      final teacherId = authState.user.id;
      final db = await DatabaseManager().database;

      // Check if email or phone exists
      final List<Map<String, dynamic>> existingUser = await db.query(
        'User',
        where: '(email = ? OR phone = ?) AND deleted_at IS NULL',
        whereArgs: [emailController.text, _phoneNumber],
      );

      if (existingUser.isNotEmpty) {
        throw Exception('email_or_phone_exists'.tr(context));
      }

      // Begin transaction
      await db.transaction((txn) async {
        // 1. Insert into User table
        final userId = await txn.insert('User', {
          'full_name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'phone': _phoneNumber,
          'country': country,
          'gender': gender,
          'role': 'student',
          'status': 'active',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        // 2. Insert into Student table
       final studentId= await txn.insert('Student', {
          'user_id': userId,
          'teacher_id': teacherId,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        // 3. Insert into CircleStudent table
       await txn.insert('CircleStudent', {
          'circle_id': widget.circleId,
          'student_id': studentId,
          'teacher_id': teacherId,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });

      });

      // First close the bottom sheet
      if (mounted) {
        Navigator.pop(context);
      }

      if (mounted) {
        context.read<CircleStudentBloc>().add(
              LoadCircleStudents(
                context,
                circleId: widget.circleId,
              ),
            );
       SuccessSnackbar.show(context: context, successText: 'inserted_successfully'.tr(context));

      }
    } catch (e) {
      if (mounted) {
        ErrorSnackbar.show(context: context, errorText: e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'add_new_student'.tr(context),
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
      
                // Full Name field
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
      
                // Email field
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
      
                // Country field
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
                  controller: phoneController,
                  searchText: 'search_country'.tr(context),
                  languageCode: 'ar',
                                    showCountryFlag: false,

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
                  onChanged: (phone) {
                    _phoneNumber = phone.completeNumber;
                  },
                  validator: (value) {
                    if (value == null || value.number.isEmpty) {
                      return 'required_field'.tr(context);
                    }
                    return null;
                  },
                ),
                SizedBox(height: deviceHeight * 0.02),
      
                // Password field
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
      
                // Gender selection
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
                SizedBox(height: deviceHeight * 0.02),
      
                // Save button
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  CustomButton(
                    text: 'save'.tr(context),
                    onPressed: _saveStudent,
                    icon: Icons.save,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
