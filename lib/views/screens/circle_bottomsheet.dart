import 'package:flutter/material.dart';
import 'package:muzn/controllers/auth_controller.dart';
import 'package:muzn/controllers/circle_controller.dart';
import 'package:muzn/controllers/school_controller.dart';
import 'package:muzn/models/circle_model.dart';
import 'package:muzn/models/circle_category_model.dart';
import 'package:muzn/models/school_model.dart';
import 'package:muzn/models/user_model.dart';
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
  String selectedCircleType = '';
  String selectedTiming = '';
  int _teacherId = 0;

  final CircleController _circleController = CircleController();
  final SchoolController _schoolController = SchoolController();

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  Future<void> _getUserId() async {
    User? user = await AuthController.getCurrentUser();
    if (user != null && user.id != 0) {
      setState(() {
        _teacherId = user.id!;
      });
    }
  }

  Future<List<CirclesCategory>> _fetchCategories() async {
    return await _circleController.fetchAllCircleCategories();
  }

  Future<List<SchoolMosque>> _fetchSchools() async {
    return await _schoolController.fetchAllSchoolMosques(_teacherId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('new_circle'.tr(context), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 20),
                
                CustomTextField(
                  hintText: 'circle_name'.tr(context),
                  labelText: 'circle_name'.tr(context),
                  controller: circleNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'circle_name_required'.tr(context);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
      
                FutureBuilder<List<CirclesCategory>>(
                  future: _fetchCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No categories available'.tr(context));
                    }
                    return CustomDropdown(
                      label: 'circle_category'.tr(context),
                      items: snapshot.data!.map((e) => e.name).toList(),
                      selectedValue: snapshot.data!.firstWhere((e) => e.id == selectedCategoryId, orElse: () => CirclesCategory(id: 0, name: '')).name,
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategoryId = snapshot.data!.firstWhere((e) => e.name == newValue).id;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
      
                CustomDropdown(
                  label: 'circle_category_type'.tr(context),
                  items: CircleType.values.map((e) => e.toLocalizedTypeString(context)).toList(),
                  selectedValue: selectedCircleType,
                  onChanged: (newValue) => setState(() => selectedCircleType = newValue ?? ''),
                ),
                const SizedBox(height: 10),
      
                CustomDropdown(
                  label: 'circle_timing'.tr(context),
                  items: CircleTime.values.map((e) => e.toLocalizeTimedString(context)).toList(),
                  selectedValue: selectedTiming,
                  onChanged: (newValue) => setState(() => selectedTiming = newValue ?? ''),
                ),
                const SizedBox(height: 10),
      
                FutureBuilder<List<SchoolMosque>>(
                  future: _fetchSchools(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No schools available'.tr(context));
                    }
                    return CustomDropdown(
                      label: 'school_name'.tr(context),
                      items: snapshot.data!.map((e) => e.name).toList(),
                      selectedValue: snapshot.data!.firstWhere((e) => e.id == selectedSchoolId, orElse: () => SchoolMosque(id: 0, name: '')).name,
                      onChanged: (newValue) {
                        setState(() {
                          selectedSchoolId = snapshot.data!.firstWhere((e) => e.name == newValue).id;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
      
                CustomButton(
                  text: 'save'.tr(context),
                  icon: Icons.save,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Circle circle = Circle(
                        name: circleNameController.text,
                        teacherId: _teacherId,
                        schoolMosqueId: selectedSchoolId!,
                        circleCategoryId: selectedCategoryId!,
                        circleType: selectedCircleType,
                        circleTime: selectedTiming,
                        createdAt: DateTime.now(),
                      );
                      _circleController.addCircle(circle.toMap());
                      Navigator.pop(context, true);
                    }
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
