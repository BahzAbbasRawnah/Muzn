import 'package:flutter/material.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/models/enums.dart';

class RatingSelector extends StatefulWidget {
  final Rating initialRating;
  final ValueChanged<Rating?> onChanged;

  const RatingSelector({
    Key? key,
    this.initialRating = Rating.good,
    required this.onChanged,
  }) : super(key: key);

  @override
  _RatingSelectorState createState() => _RatingSelectorState();
}

class _RatingSelectorState extends State<RatingSelector> {
  late Rating _selectedRating;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, 
      runSpacing: 8.0, 
      children: Rating.values.map((rating) {
        bool isSelected = _selectedRating == rating;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedRating = rating;
            });
            widget.onChanged(rating);
          },
          child: Container(
            width: (MediaQuery.of(context).size.width / 2) -30,
                
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor.withOpacity(0.2)
                  : Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300]!,
              ),
            ),
            child: Row(
              children: [
                Radio<Rating>(
                  value: rating,
                  groupValue: _selectedRating,
                  onChanged: (Rating? value) {
                    setState(() {
                      _selectedRating = value!;
                    });
                    widget.onChanged(value);
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
                Expanded(
                  child: Text(
                    rating.translate(context),
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
