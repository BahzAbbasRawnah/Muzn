import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/bloc/CircleBloc/circle_bloc.dart';
import 'package:muzn/bloc/CircleBloc/circle_event.dart';
import 'package:muzn/bloc/CircleBloc/circle_state.dart';
import 'package:muzn/controllers/user_controller.dart';
import 'package:muzn/models/circle_model.dart';
import 'package:muzn/models/circle_category_model.dart';
import 'package:muzn/models/school_model.dart';
import 'package:muzn/repository/user_repository.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_dropdown.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';
import 'package:muzn/app_localization.dart';

class AddCircleBottomSheet extends StatefulWidget {
  @override
  _AddCircleBottomSheetState createState() => _AddCircleBottomSheetState();
}

class _AddCircleBottomSheetState extends State<AddCircleBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController circleNameController = TextEditingController();
  int? selectedCategoryId;
  int? selectedSchoolId;
  CircleType? selectedCircleType;
  CircleTime? selectedTiming;
  int _teacherId = 0;
  late UserController _userController;

  @override
  void initState() {
    super.initState();
    _userController = UserController();
    _fetchCurrentUser();

    // Dispatch events to fetch categories and schools
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<CircleBloc>(context).add(GetCategoriesEvent());
      BlocProvider.of<CircleBloc>(context).add(GetSchoolsEvent());
    });
  }

  // Fetch the current user and set the teacherId
  Future<void> _fetchCurrentUser() async {
    await _userController.init(); // Initialize SharedPreferences
    final currentUser = await _userController.getCurrentUser();
    if (currentUser != null) {
      setState(() {
        _teacherId = currentUser.id!; // Set the teacherId
      });
    }
  }

  void _addCircle(BuildContext context) {
    if (_formKey.currentState!.validate() &&
        selectedSchoolId != null &&
        selectedCategoryId != null &&
        selectedCircleType != null &&
        selectedTiming != null) {
      final Circle circle = Circle(
        name: circleNameController.text,
        teacherId: _teacherId,
        schoolId: selectedSchoolId!,
        categoryId: selectedCategoryId!,
        circleType: selectedCircleType!,
        circleTime: selectedTiming!,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Dispatch the AddCircleEvent
      BlocProvider.of<CircleBloc>(context).add(AddCircleEvent(circle));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CircleBloc, CircleState>(
      listener: (context, state) {
        if (state is CircleAdded) {
          // Close the bottom sheet after successfully adding the circle
          Navigator.pop(context, true);
        } else if (state is CircleError) {
          // Show an error message if something goes wrong
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'new_circle'.tr(context),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: 'circle_name'.tr(context),
                    labelText: 'circle_name'.tr(context),
                    controller: circleNameController,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'circle_name_required'.tr(context)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<CircleBloc, CircleState>(
                    builder: (context, state) {
                      if (state is CategoriesLoaded) {
                        print('CategoriesLoaded state received with ${state.categories.length} categories');
                        return CustomDropdown(
                          label: 'circle_category'.tr(context),
                          items: state.categories.map((e) => e.name).toList(),
                          selectedValue: selectedCategoryId != null
                              ? state.categories
                                  .firstWhere((e) => e.id == selectedCategoryId,
                                      orElse: () => state.categories.first)
                                  .name
                              : state.categories.first.name,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCategoryId = state.categories
                                  .firstWhere((e) => e.name == newValue)
                                  .id;
                            });
                          },
                        );
                      } else if (state is CircleLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is CircleError) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox.shrink(); // Default fallback
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomDropdown(
                    label: 'circle_category_type'.tr(context),
                    items: CircleType.values
                        .map((e) => e.toLocalizedTypeString(context))
                        .toList(),
                    selectedValue: selectedCircleType?.name ?? '',
                    onChanged: (newValue) => setState(() => selectedCircleType =
                        CircleType.values.firstWhere((e) => e.name == newValue)),
                  ),
                  const SizedBox(height: 10),
                  CustomDropdown(
                    label: 'circle_timing'.tr(context),
                    items: CircleTime.values
                        .map((e) => e.toLocalizeTimedString(context))
                        .toList(),
                    selectedValue: selectedTiming?.name ?? '',
                    onChanged: (newValue) => setState(() => selectedTiming =
                        CircleTime.values.firstWhere((e) => e.name == newValue)),
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<CircleBloc, CircleState>(
                    builder: (context, state) {
                      if (state is SchoolsLoaded) {
                        return CustomDropdown(
                          label: 'school_name'.tr(context),
                          items: state.schools.map((e) => e.name).toList(),
                          selectedValue: selectedSchoolId != null
                              ? state.schools
                                  .firstWhere((e) => e.id == selectedSchoolId,
                                      orElse: () => state.schools.first)
                                  .name
                              : state.schools.first.name,
                          onChanged: (newValue) {
                            setState(() {
                              selectedSchoolId = state.schools
                                  .firstWhere((e) => e.name == newValue)
                                  .id;
                            });
                          },
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'save'.tr(context),
                    icon: Icons.save,
                    onPressed: () => _addCircle(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}