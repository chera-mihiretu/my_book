import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
  @override
  List<Object?> get props => [];
}

class LoadFavoritesEvent extends FavoriteEvent {
  const LoadFavoritesEvent();
}

class AddFavoriteEvent extends FavoriteEvent {
  final String bookId;
  const AddFavoriteEvent(this.bookId);
  @override
  List<Object?> get props => [bookId];
}

class RemoveFavoriteEvent extends FavoriteEvent {
  final String bookId;
  const RemoveFavoriteEvent(this.bookId);
  @override
  List<Object?> get props => [bookId];
}
