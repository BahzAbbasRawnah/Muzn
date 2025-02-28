import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app/core/get_user_id.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import 'package:muzn/blocs/school/school_bloc.dart';
import 'package:muzn/models/school.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';
import 'package:muzn/views/widgets/message.dart';

import '../../../app/core/check_if_login.dart';

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
      final authState = context
          .read<AuthBloc>()
          .state;

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


        context.read<SchoolBloc>().add(UpdateSchool(updatedSchool));
      } else {
        if (BlocProvider
            .of<AuthBloc>(context)
            .userModel != null) {
          final teacherId = BlocProvider
              .of<AuthBloc>(context)
              .userModel!
              .id;

          final updatedSchool = School(
            id: widget.schoolId,
            name: _nameController.text,
            address: _addressController.text,
            type: _selectedType,
            teacherId: teacherId,
          );


          context.read<SchoolBloc>().add(UpdateSchool(updatedSchool));
        }
        print("User not authenticated.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery
        .of(context)
        .size
        .height;

    return BlocListener<SchoolBloc, SchoolState>(
        listener: (context, state) async {
          print("EditSchoolBottomSheet listener triggered with state: $state");

          // if (state is SchoolsLoaded && mounted) {
          //   print("Closing EditSchoolBottomSheet"); // Debugging log
          //   print("SchoolsLoaded state emitted"); // Added log
          //
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('edit_successfully'.tr(context))),
          //   );
          //
          //   final authState = context.read<AuthBloc>().state;
          //   if (authState is AuthAuthenticated) {
          //     BlocProvider.of<SchoolBloc>(context).add(LoadSchools(authState.user.id));
          //     Navigator.of(context).pop();
          //   } else {
          //     if (BlocProvider.of<AuthBloc>(context).userModel != null) {
          //       BlocProvider.of<SchoolBloc>(context).add(
          //         LoadSchools(BlocProvider.of<AuthBloc>(context).userModel!.id),
          //       );
          //       // Navigator.of(context).pop();
          //     }
          //   }
          //
          //   // **Fix: Delay closing the bottom sheet**
          //   // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   //   if (mounted) {
          //   //     // Navigator.of(context).pop();
          //   //   }
          //   // });
          // }



          // if (state is SchoolError) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text(state.message.tr(context))),
          //   );
          // } else if (state is SchoolsLoaded && mounted) {
          //   print("Closing EditSchoolBottomSheet"); // Debugging log
          //   print("SchoolsLoaded state emitted"); // Added log
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('edit_successfully'.tr(context))),
          //   );
          //   // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   //   showSuccessMessage(context, 'edit_successfully'.tr(context));
          //   // });
          //
          //   // Close the bottom sheet after showing the message
          //   // if (await checkIfLogin()) {
          //
          //   final authState = context
          //       .read<AuthBloc>()
          //       .state;
          //   if (authState is AuthAuthenticated) {
          //     BlocProvider.of<SchoolBloc>(context).add(
          //         LoadSchools(authState.user.id));
          //   } else {
          //     if (BlocProvider
          //         .of<AuthBloc>(context)
          //         .userModel != null) {
          //       BlocProvider.of<SchoolBloc>(context).add(
          //           LoadSchools(BlocProvider
          //               .of<AuthBloc>(context)
          //               .userModel!
          //               .id));
          //     }}
          //     Navigator.of(context).pop();
          //     // if(await checkIfLogin()){
          //     //   BlocProvider.of<SchoolBloc>(context).add(LoadSchools(await getUserId()));
          //     //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     //     showSuccessMessage(context,'edit_successfully'.tr(context));
          //     //   });
          //     //
          //     // }
          //     // Navigator.of(context).pop(); // Close the bottom sheet
          //   }
          },
          // ,
          child: BlocBuilder<SchoolBloc, SchoolState>(
  builder: (context, state) {
    if (state is SchoolLoading) {
      Navigator.of(context).pop(); // Close the bottom sheet
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSuccessMessage(context, 'added_successfully'.trans(context));
      });
    }
    return Container(
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
          BlocBuilder<SchoolBloc, SchoolState>(
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
          );
  },
)
          ,
          );
        }
        void showSuccessMessage(BuildContext context, String message)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green, // Customize the color
          behavior: SnackBarBehavior.floating, // Optional: Make it floating
        ),
      );
    }
  }
