import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../bloc/reading_bloc.dart';
import '../bloc/reading_state.dart';

class ReadingListPage extends StatelessWidget {
  const ReadingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Reading List', showBackButton: false),
      body: BlocBuilder<ReadingBloc, ReadingState>(
        builder: (context, state) {
          // TODO: Implement UI
          return const Center(child: Text('Reading List Page'));
        },
      ),
    );
  }
}
