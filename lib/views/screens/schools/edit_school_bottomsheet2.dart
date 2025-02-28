import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
// import 'package:muzn/cubits/school/school_cubit.dart';
import 'package:muzn/models/school.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';

import '../../../blocs/school/school_cubit.dart';

class EditSchoolBottomSheet2 extends StatefulWidget {
  final int schoolId;
  final String initialName;
  final String initialAddress;
  final String? initialType;
  final int num2; // ✅ تمت إضافة num2

  EditSchoolBottomSheet2({
    required this.schoolId,
    required this.initialName,
    required this.initialAddress,
    this.initialType,
    required this.num2, // ✅ تمت إضافة num2
  });

  @override
  State<EditSchoolBottomSheet2> createState() => _EditSchoolBottomSheetState();
}

class _EditSchoolBottomSheetState extends State<EditSchoolBottomSheet2> {
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
      // final teacherId = context.read<SchoolCubit>().getTeacherId();
      final teacherId =BlocProvider.of<AuthBloc>(context).userModel!.id;


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

      context.read<SchoolCubit>().updateSchool(updatedSchool);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return BlocListener<SchoolCubit, SchoolState>(
      listener: (context, state) {
        print("EditSchoolBottomSheet listener triggered with state: $state");

        if (state is SchoolError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message.trans(context))),
          );
        } else if (state is SchoolsLoaded) {
          print("SchoolsLoaded state emitted");
          showSuccessMessage(context, 'edit_successfully'.trans(context));

          // إعادة تحميل البيانات وإغلاق BottomSheet
          // context.read<SchoolCubit>().loadSchools();
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
                  'edit_school'.trans(context),
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: deviceHeight * 0.02),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'school_name_label'.trans(context),
                    hintText: 'school_name_hint'.trans(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'required_field'.trans(context) : null,
                ),
                SizedBox(height: deviceHeight * 0.02),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: InputDecoration(
                    labelText: 'school_type'.trans(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: ['mosque', 'school', 'center', 'virtual'].map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(
                        type.trans(context),
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
                  labelText: 'address_label'.trans(context),
                  hintText: 'address_hint'.trans(context),
                ),
                SizedBox(height: deviceHeight * 0.03),
                BlocBuilder<SchoolCubit, SchoolState>(
                  builder: (context, state) {
                    if (state is SchoolLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return CustomButton(
                      text: 'save'.trans(context),
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

  void showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
