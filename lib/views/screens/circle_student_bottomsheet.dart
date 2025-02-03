// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:muzn/controllers/auth_controller.dart';
// import 'package:muzn/controllers/student_controller.dart';
// import 'package:muzn/models/student_model.dart';
// import 'package:muzn/models/user_model.dart';
// import 'package:muzn/utils/request_status.dart';
// import 'package:muzn/views/widgets/custom_button.dart';
// import 'package:muzn/views/widgets/custom_text_field.dart';
// import 'package:muzn/app_localization.dart';
// import 'package:muzn/views/widgets/message.dart';

// class AddStudentBottomSheet extends StatefulWidget {
//   final int circleID;
//   AddStudentBottomSheet({required this.circleID});
//   @override
//   _AddStudentBottomSheetState createState() => _AddStudentBottomSheetState();
// }

// class _AddStudentBottomSheetState extends State<AddStudentBottomSheet> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController studentNameController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController countryController = TextEditingController();

//   String? gender = 'male';
//   String? country = 'السعودية';
//   int? _teacherId;
//   final StudentController _studentController = StudentController();
//   Future<void> _getUserId() async {
//     User? user = await AuthController.getCurrentUser();
//     if (user != null && user.id != 0) {
//       setState(() {
//         _teacherId = user.id!;
//       });
//     }
//   }

//   @override
//   void initState() {
//     _getUserId();
//     super.initState();
//   }

//   // Validation function for email
//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'email_required'.tr(context);
//     }
//     String pattern = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b';
//     RegExp regExp = RegExp(pattern);
//     if (!regExp.hasMatch(value)) {
//       return 'email_invalid'.tr(context);
//     }
//     return null;
//   }

//   // Validation function for password
//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'password_required'.tr(context);
//     }
//     if (value.length < 6) {
//       return 'password_short'.tr(context);
//     }
//     return null;
//   }

//   // Validation function for confirm password
//   String? _validateConfirmPassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'confirm_password_required'.tr(context);
//     }
//     if (value != passwordController.text) {
//       return 'password_mismatch'.tr(context);
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: Container(
//           padding: EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Center(
//                     child: Text('new_student'.tr(context),
//                         style: Theme.of(context).textTheme.titleMedium)),
//                 SizedBox(height: 16),

//                 // Full Name Field
//                 CustomTextField(
//                   controller: nameController,
//                   hintText: 'full_name_hint'.tr(context),
//                   labelText: 'full_name'.tr(context),
//                   prefixIcon: Icons.person,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'full_name_required'.tr(context);
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 10),

//                 // Email Field
//                 CustomTextField(
//                   controller: emailController,
//                   hintText: 'email_hint'.tr(context),
//                   labelText: 'email'.tr(context),
//                   prefixIcon: Icons.email,
//                   keyboardType: TextInputType.emailAddress,
//                   validator: _validateEmail,
//                 ),
//                 SizedBox(height: 10),

//                 IntlPhoneField(
//                   controller: phoneController,
//                   searchText: 'search_country'.tr(context),
//                   languageCode: 'ar',
//                   decoration: InputDecoration(
//                     labelText: 'phone'.tr(context),
//                     hintText: 'phone_hint'.tr(context),
//                     prefixIcon: const Icon(Icons.phone),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                   initialCountryCode: 'SA',
//                   textAlign: TextAlign.start,
//                 ),
//                 SizedBox(height: 10),

//                 // Phone Number Field
//                 IntlPhoneField(
//                   controller: countryController,
//                   decoration: InputDecoration(
//                     labelText: 'phone'.tr(context),
//                     hintText: 'phone_hint'.tr(context),
//                     labelStyle:
//                         Theme.of(context).inputDecorationTheme.labelStyle,
//                     hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                   initialCountryCode: 'SA',
//                   textAlign: TextAlign.start,
//                   onChanged: (phone) {
//                     print(phone.completeNumber);
//                   },
//                   validator: (value) {
//                     if (value == null || value.completeNumber.isEmpty) {
//                       return 'phone_required'.tr(context);
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 10),

//                 // Password Field
//                 CustomTextField(
//                   controller: passwordController,
//                   hintText: 'password_hint'.tr(context),
//                   labelText: 'password'.tr(context),
//                   prefixIcon: Icons.lock,
//                   obscureText: true,
//                   validator: _validatePassword,
//                 ),
//                 SizedBox(height: 10),

//                 // Gender Selection
//                 Row(
//                   children: [
//                     Text('gender'.tr(context),
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold)),
//                     SizedBox(width: 20),
//                     Row(
//                       children: [
//                         Radio<String>(
//                           value: 'male',
//                           activeColor: Theme.of(context).primaryColor,
//                           groupValue: gender,
//                           onChanged: (value) => setState(() => gender = value),
//                         ),
//                         Text('male'.tr(context)),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Radio<String>(
//                           value: 'female',
//                           activeColor: Theme.of(context).primaryColor,
//                           groupValue: gender,
//                           onChanged: (value) => setState(() => gender = value),
//                         ),
//                         Text('female'.tr(context)),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),

//                 // Save Button
//                 CustomButton(
//                   text: 'save'.tr(context),
//                   onPressed: () async {
//                     if (_formKey.currentState?.validate()! ?? false) {
//                       User _user = new User(
//                         fullName: nameController.text.trim(),
//                         email: emailController.text.trim(),
//                         phone: phoneController.text.trim(),
//                         password: passwordController.text.trim(),
//                         gender: gender!,
//                         country: countryController.text.trim(),
//                         role: 'student',
//                         status: 'active',
//                       );
//                       Student _student =
//                           new Student(user: _user, teacherId: _teacherId);

//                       RequestStatus result = await _studentController
//                           .addStudent(_student, widget.circleID);
//                       if (result.status == true) {
//                         // SuccessSnackbar.show(
//                         //     context: context, successText: result.message);
//                             Navigator.pop(context);
//                       }
//                       else{
//                         ErrorSnackbar.show(
//                             context: context, errorText: result.message);
//                       }
//                     }
//                   },
//                   icon: Icons.save,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
