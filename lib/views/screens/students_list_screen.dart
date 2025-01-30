import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/views/screens/home_screen.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';

class StudentsListScreen extends StatefulWidget {
  @override
  _StudentsListScreenState createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  final List<Map<String, dynamic>> students = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? gender = 'male'; // Default gender

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("students_list".tr(context)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchInput(),
          _buildStudentList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddStudentBottomSheet(context),
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSearchInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'search_students'.tr(context),
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onChanged: (value) {
          // Implement search functionality if needed
        },
      ),
    );
  }

  Widget _buildStudentList() {
    return Expanded(
      child: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(student['name'][0]),
              ),
              title: Text(student['name']),
              subtitle: Text(student['email']),
            ),
          );
        },
      ),
    );
  }

  void _showAddStudentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                    child: Text('new_student'.tr(context),
                        style: Theme.of(context).textTheme.titleMedium)),
                SizedBox(height: 16),

                // Full Name Field
                CustomTextField(
                  controller: nameController,
                  hintText: 'full_name_hint'.tr(context),
                  labelText: 'full_name'.tr(context),
                  prefixIcon: Icons.person,
                ),
                SizedBox(height: 10),

                // Email Field
                CustomTextField(
                  controller: emailController,
                  hintText: 'email_hint'.tr(context),
                  labelText: 'email'.tr(context),
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10),

                // Phone Number Field
                IntlPhoneField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'phone'.tr(context),
                    hintText: 'phone_hint'.tr(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  initialCountryCode: 'SA',
                  onChanged: (phone) {
                    print(phone.completeNumber);
                  },
                ),
                SizedBox(height: 10),

                // Password Field
                CustomTextField(
                  controller: passwordController,
                  hintText: 'password_hint'.tr(context),
                  labelText: 'password'.tr(context),
                  prefixIcon: Icons.lock,
                  obscureText: true,
                ),
                SizedBox(height: 10),

                // Gender Selection
                Row(
                  children: [
                    Text('gender'.tr(context),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(width: 20),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'male',
                          activeColor: Theme.of(context).primaryColor,
                          groupValue: gender,
                          onChanged: (value) => setState(() => gender = value),
                        ),
                        Text('male'.tr(context)),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'female',
                          activeColor: Theme.of(context).primaryColor,
                          groupValue: gender,
                          onChanged: (value) => setState(() => gender = value),
                        ),
                        Text('female'.tr(context)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Save Button
                CustomButton(
                  text: 'save'.tr(context),
                  onPressed: _saveStudent,
                  icon: Icons.save,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveStudent() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('fill_all_fields'.tr(context))),
      );
      return;
    }

 

    setState(() {
      students.add({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'gender': gender,
      });
    });

    // Clear fields and close bottom sheet
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneController.clear();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('student_added_successfully'.tr(context))),
    );
  }
}
