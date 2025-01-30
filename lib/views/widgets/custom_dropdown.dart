import 'package:flutter/material.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
import 'package:muzn/app_localization.dart';
class CustomDropdown extends StatelessWidget {
  final String label; // Label for the dropdown
  final List<String> items; // List of dropdown items
  final String? selectedValue; // Currently selected value
  final ValueChanged<String?> onChanged; // Callback when an item is selected
  final double borderRadius; // Border radius
  final double borderWidth; // Border width

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.borderRadius = 8.0,
    this.borderWidth = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
         decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(width: borderWidth, color: Theme.of(context).primaryColor),
         ),
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        
          SearchableDropdown<String>(
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8,horizontal: 5),
                   decoration: BoxDecoration(
 border: Border(
                bottom: BorderSide(
                  color: Colors.black, // Border color
                  width: 0.2, // Border width
                ),
              )
            ),
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.displayMedium
                  ),
                ),
              );
            }).toList(),
            value: selectedValue,
            onChanged: onChanged,
            hint: Text(label, style: Theme.of(context).textTheme.labelMedium
),
            searchHint: label,
            closeButton:"close".tr(context),
         
            isExpanded: true, 
            underline: Container( 
         
            )
          ),
        ],
      ),
      
    );
  }
}