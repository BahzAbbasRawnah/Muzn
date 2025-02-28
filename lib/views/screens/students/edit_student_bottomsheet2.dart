import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/circle_student/circle_student_bloc.dart';
import 'package:muzn/models/circle_student.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';

import '../../../blocs/circle_student/edit_student_cubit.dart';
// import 'edit_student_cubit.dart'; // Import the cubit

class EditStudentBottomSheet2 extends StatefulWidget {
  final CircleStudent circleStudent;
  final int circleId;

  const EditStudentBottomSheet2({
    super.key,
    required this.circleStudent,
    required this.circleId,
  });

  @override
  _EditStudentBottomSheetState createState() => _EditStudentBottomSheetState();
}

class _EditStudentBottomSheetState extends State<EditStudentBottomSheet2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? gender;
  String? country;
  String _phoneNumber = '';

  @override
  void initState() {
    super.initState();

    // Pre-fill the form with the student's current data
    nameController.text = widget.circleStudent.student.user!.fullName;
    emailController.text = widget.circleStudent.student.user!.email;
    phoneController.text = widget.circleStudent.student.user!.phone;
    gender = widget.circleStudent.student.user!.gender ?? 'male';
    country = widget.circleStudent.student.user!.country ?? 'السعودية';
    _phoneNumber = widget.circleStudent.student.user!.phone ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditStudentCubit(),
      child: BlocListener<EditStudentCubit, EditStudentState>(
        listener: (context, state) {
          if (state is EditStudentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('edit_successfully'.trans(context)),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                margin: EdgeInsets.only(bottom: 80, left: 16, right: 16), // Adjust margin
              ),
            );

            // Reload the student list
            context.read<CircleStudentBloc>().add(
              LoadCircleStudents(
                // context,
                circleId: widget.circleId,
              ),
            );

            // Close the bottom sheet
            Navigator.pop(context);
          } else if (state is EditStudentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
                margin: EdgeInsets.only(bottom: 80, left: 16, right: 16), // Adjust margin
              ),
            );
          }
        },
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
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
                        'edit_student'.trans(context),
                        style: Theme.of(context).textTheme.headlineSmall,
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
                      SizedBox(height: 16),

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
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'invalid_email'.trans(context);
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Phone field
                      IntlPhoneField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: 'phone'.trans(context),
                          hintText: 'phone_hint'.trans(context),
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        initialCountryCode: 'SA',
                        onChanged: (phone) {
                          _phoneNumber = phone.completeNumber;
                        },
                        validator: (value) {
                          if (value == null || value.number.isEmpty) {
                            return 'required_field'.trans(context);
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

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
                      SizedBox(height: 16),

                      // Save button
                      BlocBuilder<EditStudentCubit, EditStudentState>(
                        builder: (context, state) {
                          if (state is EditStudentLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else {
                            return CustomButton(
                              text: 'update'.trans(context),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<EditStudentCubit>().updateStudent(
                                    studentId: widget.circleStudent.id,
                                    fullName: nameController.text,
                                    email: emailController.text,
                                    phone: _phoneNumber,
                                    country: country!,
                                    gender: gender!,
                                  );
                                }
                              },
                              icon: Icons.save,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
