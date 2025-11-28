import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StartDaySelector extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onSelectDate;
  final String? errorText;

  const StartDaySelector({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onSelectDate,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Start Day',
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.calendar_today),
              errorText: errorText,
            ),
            child: Text(
              selectedDate != null
                  ? DateFormat.yMMMd().format(selectedDate!)
                  : 'Select Date',
            ),
          ),
        ),
      ],
    );
  }
}

class DurationInput extends StatelessWidget {
  final TextEditingController controller;

  const DurationInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.datetime,
      decoration: const InputDecoration(
        labelText: 'Duration (hh:mm)',
        border: OutlineInputBorder(),
        hintText: '00:30',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter duration';
        }
        final regex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
        if (!regex.hasMatch(value)) {
          return 'Invalid format (hh:mm)';
        }
        return null;
      },
    );
  }
}

class CurrentPageInput extends StatelessWidget {
  final TextEditingController controller;

  const CurrentPageInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Current Page',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter current page';
        }
        if (int.tryParse(value) == null) {
          return 'Invalid number';
        }
        return null;
      },
    );
  }
}

class DaySelector extends StatelessWidget {
  final Map<String, TimeOfDay> selectedTimes;
  final Function(String, bool) onDaySelected;
  final String? errorText;

  static const List<String> _daysOfWeek = [
    'M',
    'Tu',
    'W',
    'Th',
    'F',
    'Sa',
    'Su',
  ];

  const DaySelector({
    super.key,
    required this.selectedTimes,
    required this.onDaySelected,
    this.errorText,
  });

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
            final isSelected = selectedTimes.containsKey(day);
            return ChoiceChip(
              label: Text(day),
              selected: isSelected,
              showCheckmark: false,
              onSelected: (selected) => onDaySelected(day, selected),
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : null,
              ),
            );
          }).toList(),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 12.0),
            child: Text(
              errorText!,
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
