import 'package:equatable/equatable.dart';
import '../../../../core/models/book_model.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
  @override
  List<Object?> get props => [];
}

class LoadFavoritesEvent extends FavoriteEvent {
  const LoadFavoritesEvent();
}

class AddFavoriteEvent extends FavoriteEvent {
  final BookModel book;
  const AddFavoriteEvent(this.book);
  @override
  List<Object?> get props => [book];
}

class RemoveFavoriteEvent extends FavoriteEvent {
  final String bookId;
  const RemoveFavoriteEvent(this.bookId);
  @override
  List<Object?> get props => [bookId];
}

class ToggleFavoriteEvent extends FavoriteEvent {
  final BookModel book;
  const ToggleFavoriteEvent(this.book);
  @override
  List<Object?> get props => [book];
}
