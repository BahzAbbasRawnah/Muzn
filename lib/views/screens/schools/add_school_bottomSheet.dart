import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import 'package:muzn/blocs/school/school_bloc.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/message.dart';


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
          name: _nameController.text,
          type: _selectedType,
          address: _addressController.text,
          teacherId: authState.user.id,
        ),
      );
    } else{
      if(BlocProvider.of<AuthBloc>(context).userModel!=null){
        context.read<SchoolBloc>().add(
          AddSchool(
            name: _nameController.text,
            type: _selectedType,
            address: _addressController.text,
            teacherId: BlocProvider.of<AuthBloc>(context).userModel!.id,
          ),
        );
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    
return Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: BlocBuilder<SchoolBloc, SchoolState>(
          builder: (context, state) {
            if (state is SchoolLoading) {
              Navigator.of(context).pop(); // Close the bottom sheet
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showSuccessMessage(context, 'added_successfully'.trans(context));
              });
              // showSuccessMessage(context, 'school_added_successfully'.tr(context)); /
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'new_school'.trans(context),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'required_field'.trans(context);
                        }
                        return null;
                      },
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
                      items: [
                        'mosque',
                        'school',
                        'center',
                        'virtual'
                      ].map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.trans(context),style: Theme.of(context).textTheme.displayMedium,),
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
                        labelText: 'address_label'.trans(context),
                        hintText: 'address_hint'.trans(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.03),
                    CustomButton(
                      text: 'save'.trans(context),
                      icon: Icons.save,
                      onPressed: () => _handleSave(context),
                    ),
                    SizedBox(height: deviceHeight * 0.02),
                  ],
                ),
              ),
            );
          },
        ),
      );
  }
  void showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green, // Customize the color
        behavior: SnackBarBehavior.floating, // Optional: Make it floating
      ),
    );
  }
}
