import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:new_project/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository favoriteRepository;
  final GetFavoritesUseCase getFavoritesUseCase;

  FavoriteBloc({
    required this.favoriteRepository,
    required this.getFavoritesUseCase,
  }) : super(const FavoriteInitial()) {
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<LoadFavoritesEvent>(_onLoadFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(const FavoriteLoading());

    final result = await getFavoritesUseCase();

    result.fold(
      (failure) => emit(FavoriteError(failure.message)),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(const FavoriteLoading());

    if (event.book.favorite) {
      // Remove from favorites
      final result = await favoriteRepository.removeFavoriteByKey(
        event.book.bookKey ?? '',
      );

      result.fold(
        (failure) => emit(FavoriteError(failure.message)),
        (_) => emit(
          const FavoriteSuccess(
            message: 'Removed from favorites',
            isFavorite: false,
          ),
        ),
      );
    } else {
      // Add to favorites
      final result = await favoriteRepository.addFavorite(event.book);

      result.fold(
        (failure) => emit(FavoriteError(failure.message)),
        (book) => emit(
          const FavoriteSuccess(
            message: 'Added to favorites!',
            isFavorite: true,
          ),
        ),
      );
    }
  }
}
