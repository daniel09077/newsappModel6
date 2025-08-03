import 'package:flutter/material.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final ValueChanged<bool> onSelected;
  final IconData? icon; // Optional icon for the chip

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onSelected,
    this.icon, // Initialize optional icon
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.black), // Use provided icon
          if (icon != null) const SizedBox(width: 5),
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 5),
            Text('($count)'),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: Colors.blue,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
