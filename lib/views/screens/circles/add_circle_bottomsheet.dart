import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import 'package:muzn/blocs/circle/circle_bloc.dart';
import 'package:muzn/blocs/school/school_bloc.dart';
import 'package:muzn/models/circle.dart';
import 'package:muzn/models/enums.dart';
import 'package:muzn/models/school.dart';
import 'package:muzn/services/database_service.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_dropdown.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';

import '../../../app/core/show_success_message.dart';

class AddCircleBottomSheet extends StatefulWidget {
   int schoolId;
   String schoolUuid;

   AddCircleBottomSheet({super.key, required this.schoolId,required this.schoolUuid});

  @override
  AddCircleBottomSheetState createState() => AddCircleBottomSheetState();
}

class AddCircleBottomSheetState extends State<AddCircleBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _schoolController = TextEditingController();
  String? _selectedCategory;
  String? _selectedSchool;
  CircleType? _selectedType;
  CircleTime? _selectedTime;
  List<Map<String, dynamic>> _categories = [];
  List<School>? _schools=[];
  Map<String, int> _categoryNameToId = {};

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _schools=BlocProvider.of<SchoolBloc>(context).schoolsList;
  }

  Future<void> _loadCategories() async {
    final db = await DatabaseManager().database;
    final List<Map<String, dynamic>> results = await db.query(
      'CirclesCategory',
      where: 'deleted_at IS NULL',
      orderBy: 'id ASC',
    );
    setState(() {
      _categories = results;
      // Create a mapping of names to IDs
      _categoryNameToId = {
        for (var cat in results) cat['name'].toString(): cat['id'] as int
      };
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        Circle circle = Circle(
          name: _nameController.text,
          schoolId: widget.schoolId,
          schoolUuid: widget.schoolUuid,
          teacherId: authState.user.id,
          teacherUuid: authState.user.uuid,
          description: _descriptionController.text,
          circleCategoryId: _selectedCategory != null
              ? _categoryNameToId[_selectedCategory]
              : null,
          circleType: _selectedType?.name,
          circleTime: _selectedTime?.name,
        );
        context.read<CircleBloc>().add(AddCircle(circle: circle));
      }else{
        if(BlocProvider.of<AuthBloc>(context).userModel!=null){
          Circle circle = Circle(
            name: _nameController.text,
            schoolId: widget.schoolId,
            schoolUuid: widget.schoolUuid,
            teacherId: BlocProvider.of<AuthBloc>(context).userModel!.id,
            teacherUuid: BlocProvider.of<AuthBloc>(context).userModel!.uuid,
            description: _descriptionController.text,
            circleCategoryId: _selectedCategory != null
                ? _categoryNameToId[_selectedCategory]
                : null,
            circleType: _selectedType?.name,
            circleTime: _selectedTime?.name,
          );
          context.read<CircleBloc>().add(AddCircle(circle: circle));

        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CircleBloc, CircleState>(
      listener: (context, state) {
        if (state is CircleError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message.trans(context))),
          );
        } else if (state is CirclesLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSuccessMessage(context, 'added_successfully'.trans(context));
          });
          Navigator.of(context).pop();
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
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
                  'new_circle'.trans(context),
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _nameController,
                  labelText: 'circle_name_label'.trans(context),
                  hintText: 'circle_name_hint'.trans(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required_field'.trans(context);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if(widget.schoolId==-1)
                  CustomDropdown(
                    label: 'school'.trans(context),
                    selectedValue: _selectedSchool, // Show the name in dropdown
                    items: _schools!
                        .map((cat) => cat.name.toString())
                        .toList(),
                    onChanged: (value) {
                      final selectedSchool = _schools!.firstWhere((cat) => cat.name == value);
                      print('Selected School ID: ${selectedSchool.id}');
                      print('Selected School Name: ${selectedSchool.name}');
                      setState(() {
                        _selectedSchool = selectedSchool.name;

                        widget.schoolId=selectedSchool.id;// Store the entire school object
                      });
                    },
                  ),

                // CustomDropdown(
                  //   label: 'circle_school'.tr(context),
                  //   selectedValue: _selectedSchool,
                  //   items:
                  //   _schools!.map((cat) => cat.name.toString()).toList(),
                  //   onChanged: (value) {
                  //     print('selected school');
                  //     print(value);
                  //     setState(() {
                  //       _selectedSchool = value;
                  //     });
                  //   },
                  // ),
                const SizedBox(height: 16),
                CustomDropdown(
                  label: 'circle_category'.trans(context),
                  selectedValue: _selectedCategory,
                  items:
                      _categories.map((cat) => cat['name'].toString()).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomDropdown(
                  label: 'circle_type'.trans(context),
                  selectedValue: _selectedType?.toLocalizedTypeString(context),
                  items: CircleType.values
                      .map((type) => type.toLocalizedTypeString(context))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = CircleType.values.firstWhere((type) =>
                          type.toLocalizedTypeString(context) == value);
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomDropdown(
                  label: 'circle_time'.trans(context),
                  selectedValue: _selectedTime?.toLocalizeTimedString(context),
                  items: CircleTime.values
                      .map((time) => time.toLocalizeTimedString(context))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTime = CircleTime.values.firstWhere((time) =>
                          time.toLocalizeTimedString(context) == value);
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _descriptionController,
                  labelText: 'circle_description_label'.trans(context),
                  hintText: 'circle_description_hint'.trans(context),
                  line: 3,
                ),
                const SizedBox(height: 24),
                BlocBuilder<CircleBloc, CircleState>(
                  builder: (context, state) {
                    if (state is CircleLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return CustomButton(
                      text: 'save'.trans(context),
                      icon: Icons.save,
                      onPressed: () => _handleSave(context),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
