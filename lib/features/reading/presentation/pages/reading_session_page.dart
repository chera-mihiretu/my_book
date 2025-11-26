import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../domain/models/reading_model.dart';
import '../bloc/reading_bloc.dart';
import '../bloc/reading_state.dart';

class ReadingSessionPage extends StatelessWidget {
  final ReadingModel reading;
  const ReadingSessionPage({super.key, required this.reading});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Reading Session'),
      body: BlocBuilder<ReadingBloc, ReadingState>(
        builder: (context, state) {
          // TODO: Implement UI
          return const Center(child: Text('Reading Session Page'));
        },
      ),
    );
  }
}
