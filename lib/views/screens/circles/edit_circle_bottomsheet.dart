import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/circle/circle_bloc.dart';
import 'package:muzn/models/circle.dart';
import 'package:muzn/models/circle_category.dart';
import 'package:muzn/models/enums.dart';
import 'package:muzn/services/database_service.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_dropdown.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';

import '../../../app/core/show_success_message.dart';

class EditCircleBottomSheet extends StatefulWidget {
  final Circle circle;

  const EditCircleBottomSheet({Key? key, required this.circle}) : super(key: key);

  @override
  EditCircleBottomSheetState createState() => EditCircleBottomSheetState();
}

class EditCircleBottomSheetState extends State<EditCircleBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  CircleCategory? _selectedCategory;
  CircleType? _selectedType;
  CircleTime? _selectedTime;
  List<Map<String, dynamic>> _categories = [];
  Map<String, int> _categoryNameToId = {};

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.circle.name;
    _descriptionController.text = widget.circle.description ?? '';
    _selectedType = CircleType.values.firstWhere(
      (type) => type.name == widget.circle.circleType,
      orElse: () => CircleType.offline,
    );
    _selectedTime = CircleTime.values.firstWhere(
      (time) => time.name == widget.circle.circleTime,
      orElse: () => CircleTime.morning,
    );
    _loadCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
      // Initialize selected category
      if (widget.circle.circleCategoryId != null) {
        final category = _categories.firstWhere(
          (cat) => cat['id'] == widget.circle.circleCategoryId,
          orElse: () => _categories.first,
        );
        _selectedCategory = CircleCategory.fromMap(category);
      }
    });
  }

  void _handleSave(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final updatedCircle = Circle(
        id: widget.circle.id,
        name: _nameController.text,
        description: _descriptionController.text,
        schoolId: widget.circle.schoolId,
        teacherId: widget.circle.teacherId,
        circleCategoryId: _selectedCategory?.id,
        circleType: _selectedType?.name,
        circleTime: _selectedTime?.name,
      );
      context.read<CircleBloc>().add(UpdateCircle(circle: updatedCircle));
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
          // SnackBar(content: Text(state.message.tr(context))),
          Navigator.of(context).pop(); // Close the bottom sheet
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSuccessMessage(context, 'edit_successfully'.tr(context));
          });
          // Navigator.of(context).pop();
        // SnackBar(content: Text('success_add'.tr(context)));
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
                  'edit_circle'.tr(context),
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _nameController,
                  labelText: 'circle_name_label'.tr(context),
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
                  selectedValue: _selectedCategory?.name,
                  items: _categories.map((cat) => cat['name'].toString()).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = CircleCategory.fromMap(
                        _categories.firstWhere((cat) => cat['name'] == value),
                      );
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
                        (type) => type.toLocalizedTypeString(context) == value,
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
                        (time) => time.toLocalizeTimedString(context) == value,
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
                      text: 'update'.tr(context),
                      icon: Icons.update,
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