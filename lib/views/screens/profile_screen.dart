import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart'; // For phone number with country code and flag
import 'package:muzn/app_localization.dart';
import 'package:muzn/controllers/user_controller.dart';
import 'package:muzn/models/user_model.dart';
import 'package:muzn/repository/user_repository.dart';
import 'package:muzn/views/widgets/app_drawer.dart';
import 'package:muzn/views/widgets/custom_app_bar.dart';
import 'package:muzn/views/widgets/custom_button.dart'; // Assuming you have this widget
import 'package:muzn/views/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  late UserController _userController; // Declare UserController
  String? selectedCountry = 'SA'; // Default country code
  String? gender = 'male'; // Default gender
  User? currentUser;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _userController = UserController();
    _fetchCurrentUser(); // Fetch current user data
  }

  // Fetch the current user and set the teacherId
  Future<void> _fetchCurrentUser() async {
    await _userController.init(); // Initialize SharedPreferences
    final fetchedUser = await _userController.getCurrentUser();
    if (fetchedUser != null) {
      setState(() {
        currentUser = fetchedUser;
        _initializeControllers(fetchedUser); // Initialize controllers with user data
      });
    }
  }

  // Initialize text controllers with user data
  void _initializeControllers(User user) {
    nameController.text = user.fullName ?? '';
    emailController.text = user.email ?? '';
    phoneController.text = user.phone ?? '';
    countryController.text = user.country ?? '';
    gender = user.gender ?? 'male';
    selectedCountry = user.country ?? 'SA';
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'profile'.tr(context),
        scaffoldKey: _scaffoldKey,
      ),
      drawer: AppDrawer(userController: _userController),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Avatar
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
                        onPressed: () {
                          // Handle avatar update
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: deviceHeight * 0.03),

              // Full Name Field
              CustomTextField(
                controller: nameController,
                hintText: 'full_name_hint'.tr(context),
                labelText: 'full_name'.tr(context),
                prefixIcon: Icons.person,
              ),
              SizedBox(height: deviceHeight * 0.02),

              // Email Field
              CustomTextField(
                controller: emailController,
                hintText: 'email_hint'.tr(context),
                labelText: 'email'.tr(context),
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: deviceHeight * 0.02),

              // Phone Number Field
              IntlPhoneField(
                controller: phoneController,
                searchText: 'search_country'.tr(context),
                languageCode: 'ar',
                decoration: InputDecoration(
                  labelText: 'phone'.tr(context),
                  hintText: 'phone_hint'.tr(context),
                  prefixIcon: const Icon(Icons.phone),
                ),
                textAlign: TextAlign.start,
                initialCountryCode: selectedCountry,
                onChanged: (phone) {
                  // Handle phone number changes
                },
              ),
              SizedBox(height: deviceHeight * 0.02),

              // Country Selection Dropdown
              CustomTextField(
                controller: countryController,
                hintText: 'country'.tr(context),
                labelText: 'country'.tr(context),
                prefixIcon: Icons.map,
              ),
              SizedBox(height: deviceHeight * 0.02),

              // Old Password Field
              CustomTextField(
                controller: oldPasswordController,
                hintText: 'old_password_hint'.tr(context),
                labelText: 'old_password_label'.tr(context),
                prefixIcon: Icons.lock,
                obscureText: true,
                suffixIcon: Icons.visibility,
              ),
              SizedBox(height: deviceHeight * 0.02),

              // New Password Field
              CustomTextField(
                controller: newPasswordController,
                hintText: 'new_password_hint'.tr(context),
                labelText: 'new_password_label'.tr(context),
                prefixIcon: Icons.lock,
                obscureText: true,
                suffixIcon: Icons.visibility,
              ),
              SizedBox(height: deviceHeight * 0.02),

              // Gender Selection
              Row(
                children: [
                  Text(
                    'gender'.tr(context),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Row(
                    children: [
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
                    ],
                  ),
                  Row(
                    children: [
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
                ],
              ),

              // Update Button
              CustomButton(
                text: 'update_profile_button'.tr(context),
                onPressed: () {
                  // Handle profile update logic
                },
                icon: Icons.update,
              ),
            ],
          ),
        ),
      ),
    );
  }
}