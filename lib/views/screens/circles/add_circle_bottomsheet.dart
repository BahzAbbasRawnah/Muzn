import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import 'package:muzn/blocs/circle/circle_bloc.dart';
import 'package:muzn/models/enums.dart';
import 'package:muzn/services/database_service.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_dropdown.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';

class AddCircleBottomSheet extends StatefulWidget {
  final int schoolId;

  const AddCircleBottomSheet({Key? key, required this.schoolId}) : super(key: key);

  @override
  AddCircleBottomSheetState createState() => AddCircleBottomSheetState();
}

class AddCircleBottomSheetState extends State<AddCircleBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  CircleType? _selectedType;
  CircleTime? _selectedTime;
  List<Map<String, dynamic>> _categories = [];
  Map<String, int> _categoryNameToId = {};

  @override
  void initState() {
    super.initState();
    _loadCategories();
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
        for (var cat in results) 
        cat['name'].toString(): cat['id'] as int
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
        context.read<CircleBloc>().add(
          AddCircle(
            context: context,
            name: _nameController.text,
            schoolId: widget.schoolId,
            teacherId: authState.user.id,
            description: _descriptionController.text,
            circleCategoryId: _selectedCategory != null ? _categoryNameToId[_selectedCategory] : null,
            circleType: _selectedType?.name,
            circleTime: _selectedTime?.name,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CircleBloc, CircleState>(
      listener: (context, state) {
        if (state is CircleError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message.tr(context))),
          );
        } else if (state is CirclesLoaded) {
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
                  'new_circle'.tr(context),
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _nameController,
                  labelText: 'circle_name'.tr(context),
                  hintText: 'circle_name_hint'.tr(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required_field'.tr(context);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomDropdown(
                  label: 'circle_category'.tr(context),
                  selectedValue: _selectedCategory,
                  items: _categories.map((cat) => cat['name'].toString()).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomDropdown(
                  label: 'circle_type'.tr(context),
                  selectedValue: _selectedType?.toLocalizedTypeString(context),
                  items: CircleType.values
                    .map((type) => type.toLocalizedTypeString(context))
                    .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = CircleType.values.firstWhere(
                        (type) => type.toLocalizedTypeString(context) == value
                      );
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomDropdown(
                  label: 'circle_time'.tr(context),
                  selectedValue: _selectedTime?.toLocalizeTimedString(context),
                  items: CircleTime.values
                    .map((time) => time.toLocalizeTimedString(context))
                    .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTime = CircleTime.values.firstWhere(
                        (time) => time.toLocalizeTimedString(context) == value
                      );
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _descriptionController,
                  labelText: 'circle_description_label'.tr(context),
                  hintText: 'circle_description_hint'.tr(context),
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
                      text: 'save'.tr(context),
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