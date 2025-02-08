import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import '../../app_localization.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/school/school_bloc.dart';

class AddSchoolBottomSheet extends StatefulWidget {
  const AddSchoolBottomSheet({Key? key}) : super(key: key);

  @override
  State<AddSchoolBottomSheet> createState() => _AddSchoolBottomSheetState();
}

class _AddSchoolBottomSheetState extends State<AddSchoolBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedType;

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
        context.read<SchoolBloc>().add(
          AddSchool(
            context: context,
            name: _nameController.text,
            type: _selectedType,
            address: _addressController.text,
            teacherId: authState.user.id,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    
    return BlocListener<SchoolBloc, SchoolState>(
      listener: (context, state) {
        if (state is SchoolError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message.tr(context))),
          );
        } else if (state is SchoolsLoaded) {
          Navigator.of(context).pop();
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
                  'new_school'.tr(context),
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
                  items: [
                    'mosque',
                    'school',
                    'center',
                    'virtual'
                  ].map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.tr(context),style: Theme.of(context).textTheme.displayMedium,),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                SizedBox(height: deviceHeight * 0.02),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'address_label'.tr(context),
                    hintText: 'address_hint'.tr(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: deviceHeight * 0.03),
                BlocBuilder<SchoolBloc, SchoolState>(
                  builder: (context, state) {
                    if (state is SchoolLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return CustomButton(
                      text: 'save'.tr(context),
                      icon: Icons.save,
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
