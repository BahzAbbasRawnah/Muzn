import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import 'package:muzn/blocs/school/school_bloc.dart';
import 'package:muzn/models/school.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';
import 'package:muzn/views/widgets/message.dart';

class EditSchoolBottomSheet extends StatefulWidget {
  final int schoolId;
  final String initialName;
  final String initialAddress;
  final String? initialType;

  EditSchoolBottomSheet({
    required this.schoolId,
    required this.initialName,
    required this.initialAddress,
    this.initialType,
  });

  @override
  State<EditSchoolBottomSheet> createState() => _EditSchoolBottomSheetState();
}

class _EditSchoolBottomSheetState extends State<EditSchoolBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _addressController = TextEditingController(text: widget.initialAddress);
    _selectedType = widget.initialType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleSave(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;

      if (authState is AuthAuthenticated) {
        final teacherId = authState.user.id;
        if (teacherId == null) {
          print("Error: teacherId is null");
          return;
        }

        final updatedSchool = School(
          id: widget.schoolId,
          name: _nameController.text,
          address: _addressController.text,
          type: _selectedType,
          teacherId: teacherId,
        );


   context.read<SchoolBloc>().add(UpdateSchool( updatedSchool));

      } else {
        print("User not authenticated.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return BlocListener<SchoolBloc, SchoolState>(
      listener: (context, state) {
        print("EditSchoolBottomSheet listener triggered with state: $state");
        if (state is SchoolError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message.tr(context))),
          );
        } else if (state is SchoolsLoaded && mounted) {
          print("Closing EditSchoolBottomSheet"); // Debugging log
          print("SchoolsLoaded state emitted"); // Added log
          Navigator.of(context).pop(); // Close the bottom sheet
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'edit_school'.tr(context),
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: deviceHeight * 0.02),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'school_name_label'.tr(context),
                    hintText: 'school_name_hint'.tr(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required_field'.tr(context);
                    }
                    return null;
                  },
                ),
                SizedBox(height: deviceHeight * 0.02),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: InputDecoration(
                    labelText: 'school_type'.tr(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: ['mosque', 'school', 'center', 'virtual'].map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(
                        type.tr(context),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                SizedBox(height: deviceHeight * 0.02),
                CustomTextField(
                  controller: _addressController,
                  labelText: 'address_label'.tr(context),
                  hintText: 'address_hint'.tr(context),
                ),
                SizedBox(height: deviceHeight * 0.03),
                BlocBuilder<SchoolBloc, SchoolState>(
                  builder: (context, state) {
                    if (state is SchoolLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return CustomButton(
                      text: 'save'.tr(context),
                      icon: Icons.update,
                      onPressed: () => _handleSave(context),
                    );
                  },
                ),
                SizedBox(height: deviceHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
