import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import 'package:muzn/blocs/circle_student/circle_student_bloc.dart';
import 'package:muzn/models/circle_student.dart';
import 'package:muzn/services/database_service.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';
import 'package:muzn/views/widgets/message.dart';

class EditStudentBottomSheet extends StatefulWidget {
  final CircleStudent circleStudent;
  final int circleId;

  const EditStudentBottomSheet({
    Key? key,
    required this.circleStudent,
    required this.circleId,
  }) : super(key: key);

  @override
  _EditStudentBottomSheetState createState() => _EditStudentBottomSheetState();
}

class _EditStudentBottomSheetState extends State<EditStudentBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  String? gender;
  String? country;
  bool _isLoading = false;
  String _phoneNumber = '';

  @override
  void initState() {
    super.initState();

    // Pre-fill the form with the student's current data
    nameController.text = widget.circleStudent.student.user!.fullName;
    emailController.text = widget.circleStudent.student.user!.email;
    phoneController.text = widget.circleStudent.student.user!.phone;
    countryController.text = widget.circleStudent.student.user!.country ?? 'السعودية';
    gender = widget.circleStudent.student.user!.gender ?? 'male';
    country = widget.circleStudent.student.user!.country ?? 'السعودية';
    _phoneNumber = widget.circleStudent.student.user!.phone ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    countryController.dispose();
    super.dispose();
  }

  Future<void> _updateStudent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final db = await DatabaseManager().database;

      // Step 1: Fetch the user_id from the Student table using student_id
      final List<Map<String, dynamic>> studentResult = await db.query(
        'Student',
        where: 'id = ?',
        whereArgs: [widget.circleStudent.id],
      );

      if (studentResult.isEmpty) {
        throw Exception('Student not found');
      }

      final int userId = studentResult.first['user_id'] as int;

      // Step 2: Check if email or phone exists for another user
      final List<Map<String, dynamic>> existingUser = await db.query(
        'User',
        where: '(email = ? OR phone = ?) AND id != ? AND deleted_at IS NULL',
        whereArgs: [emailController.text, _phoneNumber, userId],
      );

      if (existingUser.isNotEmpty) {
        throw Exception('email_or_phone_exists'.tr(context));
      }

      // Step 3: Update the User table using the fetched user_id
      await db.transaction((txn) async {
        // Update User table
        await txn.update(
          'User',
          {
            'full_name': nameController.text,
            'email': emailController.text,
            'phone': _phoneNumber,
            'country': country,
            'gender': gender,
            'updated_at': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [userId],
        );

        // Update Student table (if needed)
        await txn.update(
          'Student',
          {
            'updated_at': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [widget.circleStudent.id],
        );
      });

      // Close the bottom sheet
      if (mounted) {
        Navigator.pop(context);
      }

      // Reload the student list
      if (mounted) {
        context.read<CircleStudentBloc>().add(
              LoadCircleStudents(
                context,
                circleId: widget.circleId,
              ),
            );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('edit_successfully'.tr(context)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            margin: EdgeInsets.only(bottom: 80, left: 16, right: 16), // Adjust margin
          ),
        );
        // SuccessSnackbar.show(
        //   context: context,
        //   successText: 'updated_successfully'.tr(context),
        // );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            margin: EdgeInsets.only(bottom: 80, left: 16, right: 16), // Adjust margin
          ),
        );
        // ErrorSnackbar.show(context: context, errorText: e.toString());
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
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            // height: 300,
            width: double.infinity,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              left: 16,
              right: 16,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'edit_student'.tr(context),
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
              
                    // Phone field
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
              
                    // Gender selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
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
                        text: 'update'.tr(context),
                        onPressed: _updateStudent,
                        icon: Icons.save,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}