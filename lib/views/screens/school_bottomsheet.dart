import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/bloc/SchoolBloc/schools_bloc.dart';
import 'package:muzn/bloc/SchoolBloc/schools_event.dart';
import 'package:muzn/bloc/SchoolBloc/schools_state.dart';
import 'package:muzn/models/school_model.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';
import 'package:muzn/views/widgets/message.dart';

class SchoolBottomSheet extends StatefulWidget {
  final int userId;

  const SchoolBottomSheet({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<SchoolBottomSheet> createState() => _SchoolBottomSheetState();
}

class _SchoolBottomSheetState extends State<SchoolBottomSheet> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _saveSchool() {
    if (_formKey.currentState!.validate()) {
      final String name = nameController.text.trim();
      final String address = addressController.text.trim();

      // Create a new School object
      final school = School(
        name: name,
        address: address,
        teacherId: widget.userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Dispatch the AddSchoolEvent
      context.read<SchoolBloc>().add(AddSchoolEvent(school));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: BlocListener<SchoolBloc, SchoolState>(
            listener: (context, state) {
              if (state is SchoolAdded) {
 ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Center(child: Text('school_added_successfully'.tr(context))),backgroundColor: Colors.green,));
                Navigator.pop(context, true); // Close bottom sheet
              } else if (state is SchoolError) {
                // Show error message
                 ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Center(child: Text('state.message'.tr(context))),backgroundColor: Colors.red,),
                    );
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    'new_school'.tr(context),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 16),

                // School Name Field
                CustomTextField(
                  controller: nameController,
                  hintText: 'school_name_hint'.tr(context),
                  labelText: 'school_name_label'.tr(context),
                  prefixIcon: Icons.mosque,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'school_name_required'.tr(context);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Address Field
                CustomTextField(
                  controller: addressController,
                  hintText: 'address_hint'.tr(context),
                  labelText: 'address_label'.tr(context),
                  prefixIcon: Icons.location_city,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'address_required'.tr(context);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Save Button
                BlocBuilder<SchoolBloc, SchoolState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: 'save'.tr(context),
                      onPressed: () {
                        if (state is! SchoolLoading) {
                          _saveSchool();
                        }
                      },
                      icon: state is SchoolLoading
                          ? Icons.hourglass_empty
                          : Icons.save,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}