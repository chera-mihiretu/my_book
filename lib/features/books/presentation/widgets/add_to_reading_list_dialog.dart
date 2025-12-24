import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/book_model.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../reading_list/presentation/bloc/reading_list_bloc.dart';
import '../../../reading_list/presentation/bloc/reading_list_event.dart';
import '../../../reading_list/presentation/bloc/reading_list_state.dart';
import 'date_picker_field.dart';
import 'duration_input_field.dart';
import 'day_selector_widget.dart';

class AddToReadingListDialog extends StatefulWidget {
  final BookModel book;

  const AddToReadingListDialog({super.key, required this.book});

  @override
  State<AddToReadingListDialog> createState() => _AddToReadingListDialogState();
}

class _AddToReadingListDialogState extends State<AddToReadingListDialog> {
  final _formKey = GlobalKey<FormState>();
  final _daySelectorKey = GlobalKey<DaySelectorWidgetState>();
  final _durationController = TextEditingController();
  final _currentPageController = TextEditingController();
  DateTime? _startedTime;
  Map<String, TimeOfDay> _selectedTimes = {};

  @override
  void dispose() {
    _durationController.dispose();
    _currentPageController.dispose();
    super.dispose();
  }

  String? _validateStartDay(DateTime? date) {
    if (date == null) {
      return 'Please select a start day';
    }
    return null;
  }

  String? _validateDuration(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter duration';
    }

    // Validate hh:mm format
    final regex = RegExp(r'^\d{1,2}:\d{2}$');
    if (!regex.hasMatch(value)) {
      return 'Invalid format. Use hh:mm';
    }

    // Validate hours and minutes are valid
    final parts = value.split(':');
    final hours = int.tryParse(parts[0]);
    final minutes = int.tryParse(parts[1]);

    if (hours == null || minutes == null) {
      return 'Invalid time values';
    }

    if (minutes > 59) {
      return 'Minutes must be 0-59';
    }

    if (hours == 0 && minutes == 0) {
      return 'Duration must be greater than 0';
    }

    return null;
  }

  String? _validateCurrentPage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter current page';
    }

    final page = int.tryParse(value);
    if (page == null || page < 0) {
      return 'Please enter a valid page number';
    }

    return null;
  }

  String? _validateDaySelection() {
    if (_selectedTimes.isEmpty) {
      return 'Please select at least one day';
    }
    return null;
  }

  int _durationToMinutes(String duration) {
    final parts = duration.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  void _handleSave() {
    // Validate day selection manually
    _daySelectorKey.currentState?.validate();

    if (_formKey.currentState!.validate() && _selectedTimes.isNotEmpty) {
      // Convert selected times map to list of TimeOfDay? with nulls for unselected days
      final daysOfWeek = ['M', 'Tu', 'W', 'Th', 'F', 'Sa', 'Su'];
      final whenToReadList = daysOfWeek.map((day) {
        return _selectedTimes[day];
      }).toList();

      // Prepare book with reading list data
      final bookWithReadingData = widget.book.copyWith(
        startedTime: _startedTime,
        whenToRead: whenToReadList,
        durationToRead: _durationToMinutes(_durationController.text),
        currentPage: int.parse(_currentPageController.text),
        completed: false,
        endDate: null,
      );

      // Dispatch event
      context.read<ReadingListBloc>().add(
        AddToReadingListEvent(bookWithReadingData),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReadingListBloc, ReadingListState>(
      listener: (context, state) {
        if (state is ReadingListLoading) {
          CustomLoading.show(context);
        } else {
          CustomLoading.hide();

          if (state is ReadingListSuccess) {
            CustomSnackBar.show(
              context,
              message: state.message,
              type: SnackBarType.success,
            );
            Navigator.of(context).pop();
          } else if (state is ReadingListError) {
            CustomSnackBar.show(
              context,
              message: state.message,
              type: SnackBarType.error,
            );
          }
        }
      },
      child: AlertDialog(
        title: const Text('Add to Reading List'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Start Day
                DatePickerField(
                  selectedDate: _startedTime,
                  onDateSelected: (date) {
                    setState(() {
                      _startedTime = date;
                    });
                  },
                  validator: _validateStartDay,
                  labelText: 'Start Day',
                ),
                const SizedBox(height: 16),

                // Duration
                DurationInputField(
                  controller: _durationController,
                  validator: _validateDuration,
                ),
                const SizedBox(height: 16),

                // Current Page
                TextFormField(
                  controller: _currentPageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Current Page',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateCurrentPage,
                ),
                const SizedBox(height: 16),

                // When to Read
                DaySelectorWidget(
                  key: _daySelectorKey,
                  onSelectionChanged: (times) {
                    setState(() {
                      _selectedTimes = times;
                    });
                  },
                  validator: _validateDaySelection,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(onPressed: _handleSave, child: const Text('Save')),
        ],
      ),
    );
  }
}
