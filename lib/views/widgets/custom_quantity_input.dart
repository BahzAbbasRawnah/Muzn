import 'package:flutter/material.dart';

class QuantityInput extends StatefulWidget {
  final String label;
  final ValueChanged<int> onQuantityChanged;

  const QuantityInput({
    Key? key,
    required this.label,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  _QuantityInputState createState() => _QuantityInputState();
}

class _QuantityInputState extends State<QuantityInput> {
  int quantity = 0;

  void _increment() {
    if (quantity < 20) {
      setState(() => quantity++);
      widget.onQuantityChanged(quantity);
    }
  }

  void _decrement() {
    if (quantity > 0) {
      setState(() => quantity--);
      widget.onQuantityChanged(quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Text(
            widget.label,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _decrement,
                tooltip: 'Decrement',
              ),
              Text(
                quantity.toString(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _increment,
                tooltip: 'Increment',
              ),
            ],
          ),
        ],
      ),
    );
  }
}