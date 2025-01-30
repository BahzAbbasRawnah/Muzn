import 'package:flutter/material.dart';

class LessonCategoryItem extends StatefulWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const LessonCategoryItem({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<LessonCategoryItem> createState() => _LessonCategoryItemState();
}

class _LessonCategoryItemState extends State<LessonCategoryItem> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.amber[100], // Background color of the container
        borderRadius: BorderRadius.circular(18), // Rounded corners
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0), // Padding inside the container
      child: Row(
        children: [
          Checkbox(
            value: _isChecked,
            onChanged: (newValue) {
              setState(() {
                _isChecked = newValue ?? false;
              });
              widget.onChanged(newValue); // Call the callback function
            },
          ),
      
          Text(
            widget.label,
            style: Theme.of(context).textTheme.labelMedium
          ),
        ],
      ),
    );
  }
}