import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          color: quantity > 1
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
          onPressed: quantity > 1 ? onDecrement : null,
        ),

        Text(
          quantity.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),

        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          color: Theme.of(context).colorScheme.primary,
          onPressed: onIncrement,
        ),
      ],
    );
  }
}
