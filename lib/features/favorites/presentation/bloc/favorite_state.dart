import 'package:equatable/equatable.dart';
import '../../domain/models/favorite_model.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();
  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {
  const FavoriteInitial();
}

class FavoriteLoading extends FavoriteState {
  const FavoriteLoading();
}

class FavoritesLoaded extends FavoriteState {
  final List<FavoriteModel> favorites;
  const FavoritesLoaded(this.favorites);
  @override
  List<Object?> get props => [favorites];
}

class FavoriteError extends FavoriteState {
  final String message;
  const FavoriteError(this.message);
  @override
  List<Object?> get props => [message];
}

class FavoriteSuccess extends FavoriteState {
  final String message;
  final bool isFavorite;
  const FavoriteSuccess({required this.message, required this.isFavorite});
  @override
  List<Object?> get props => [message, isFavorite];
}
