import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/circle_category/circle_category_bloc.dart';
import 'package:muzn/models/circle_category.dart';

class CircleCategorySelector extends StatefulWidget {
  final Function(int) onCategorySelected;

  const CircleCategorySelector({
    Key? key,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  State<CircleCategorySelector> createState() => _CircleCategorySelectorState();
}

class _CircleCategorySelectorState extends State<CircleCategorySelector> {
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    context.read<CircleCategoryBloc>().add(LoadCircleCategories(context));
  }

  void _onCategorySelected(int categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
    });
    widget.onCategorySelected(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CircleCategoryBloc, CircleCategoryState>(
      builder: (context, state) {
        if (state is CircleCategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is CircleCategoryError) {
          return Center(child: Text(state.message));
        }
        
        if (state is CircleCategoriesLoaded) {
          if (state.categories.isEmpty) {
            return Center(
              child: Text('no_categories'.tr(context)),
            );
          }

          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.categories.map((category) {
              return CircleCategoryItem(
                category: category,
                isSelected: selectedCategoryId == category.id,
                onSelected: () => _onCategorySelected(category.id),
              );
            }).toList(),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class CircleCategoryItem extends StatelessWidget {
  final CircleCategory category;
  final bool isSelected;
  final VoidCallback onSelected;

  const CircleCategoryItem({
    Key? key,
    required this.category,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.2) : Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      child: InkWell(
        onTap: onSelected,
        borderRadius: BorderRadius.circular(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => onSelected(),
              activeColor: Theme.of(context).primaryColor,
            ),
            Text(
              category.name,
              style: TextStyle(
                color:  Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}