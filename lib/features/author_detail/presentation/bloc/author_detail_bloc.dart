import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/models/author_detail_model.dart';
import '../../domain/usecases/get_author_detail_usecase.dart';

// Events
abstract class AuthorDetailEvent extends Equatable {
  const AuthorDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadAuthorDetail extends AuthorDetailEvent {
  final String authorKey;

  const LoadAuthorDetail(this.authorKey);

  @override
  List<Object> get props => [authorKey];
}

// States
abstract class AuthorDetailState extends Equatable {
  const AuthorDetailState();

  @override
  List<Object> get props => [];
}

class AuthorDetailInitial extends AuthorDetailState {}

class AuthorDetailLoading extends AuthorDetailState {}

class AuthorDetailLoaded extends AuthorDetailState {
  final AuthorDetailModel authorDetail;

  const AuthorDetailLoaded(this.authorDetail);

  @override
  List<Object> get props => [authorDetail];
}

class AuthorDetailError extends AuthorDetailState {
  final String message;

  const AuthorDetailError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class AuthorDetailBloc extends Bloc<AuthorDetailEvent, AuthorDetailState> {
  final GetAuthorDetailUseCase getAuthorDetailUseCase;

  AuthorDetailBloc({required this.getAuthorDetailUseCase})
    : super(AuthorDetailInitial()) {
    on<LoadAuthorDetail>(_onLoadAuthorDetail);
  }

  Future<void> _onLoadAuthorDetail(
    LoadAuthorDetail event,
    Emitter<AuthorDetailState> emit,
  ) async {
    emit(AuthorDetailLoading());

    final result = await getAuthorDetailUseCase(event.authorKey);

    result.fold(
      (failure) => emit(AuthorDetailError(failure.message)),
      (authorDetail) => emit(AuthorDetailLoaded(authorDetail)),
    );
  }
}
