import 'package:flutter/material.dart';

class DaySelectorWidget extends StatefulWidget {
  final ValueChanged<Map<String, TimeOfDay>> onSelectionChanged;
  final String? Function()? validator;

  const DaySelectorWidget({
    super.key,
    required this.onSelectionChanged,
    this.validator,
  });

  @override
  State<DaySelectorWidget> createState() => DaySelectorWidgetState();
}

class DaySelectorWidgetState extends State<DaySelectorWidget> {
  final Map<String, TimeOfDay> _selectedTimes = {};
  final List<String> _daysOfWeek = ['M', 'Tu', 'W', 'Th', 'F', 'Sa', 'Su'];
  String? _errorText;

  bool get hasSelection => _selectedTimes.isNotEmpty;

  void validate() {
    setState(() {
      _errorText = widget.validator?.call();
    });
  }

  Future<void> _handleDaySelection(String day, bool selected) async {
    if (selected) {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 8, minute: 0),
      );
      if (picked != null) {
        setState(() {
          _selectedTimes[day] = picked;
          _errorText = null;
        });
        widget.onSelectionChanged(_selectedTimes);
      }
    } else {
      setState(() {
        _selectedTimes.remove(day);
      });
      widget.onSelectionChanged(_selectedTimes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('When to Read', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: _daysOfWeek.map((day) {
            final isSelected = _selectedTimes.containsKey(day);
            return ChoiceChip(
              label: Text(day),
              selected: isSelected,
              showCheckmark: false,
              onSelected: (selected) => _handleDaySelection(day, selected),
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : null,
              ),
            );
          }).toList(),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 12.0),
            child: Text(
              _errorText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
