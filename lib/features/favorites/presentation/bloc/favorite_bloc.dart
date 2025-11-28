import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/favorites/domain/repositories/favorite_repository.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository favoriteRepository;

  FavoriteBloc({required this.favoriteRepository})
    : super(const FavoriteInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    // TODO: Implement
  }

  Future<void> _onAddFavorite(
    AddFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(const FavoriteLoading());
    final result = await favoriteRepository.addFavorite(event.book);
    result.fold(
      (failure) => emit(FavoriteError(failure.message)),
      (book) => emit(const FavoriteInitial()), // Could emit success state
    );
  }

  Future<void> _onRemoveFavorite(
    RemoveFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    // TODO: Implement
  }
}
