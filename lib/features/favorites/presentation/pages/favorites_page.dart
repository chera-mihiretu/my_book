import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../bloc/favorite_bloc.dart';
import '../bloc/favorite_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Favorites', showBackButton: false),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          // TODO: Implement UI
          return const Center(child: Text('Favorites Page'));
        },
      ),
    );
  }
}
