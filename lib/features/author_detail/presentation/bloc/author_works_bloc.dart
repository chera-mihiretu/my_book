import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/work_model.dart';
import '../../domain/usecases/get_author_works_usecase.dart';

// Events
abstract class AuthorWorksEvent extends Equatable {
  const AuthorWorksEvent();

  @override
  List<Object> get props => [];
}

class GetAuthorWorks extends AuthorWorksEvent {
  final String authorKey;

  const GetAuthorWorks(this.authorKey);

  @override
  List<Object> get props => [authorKey];
}

// States
abstract class AuthorWorksState extends Equatable {
  const AuthorWorksState();

  @override
  List<Object> get props => [];
}

class AuthorWorksInitial extends AuthorWorksState {}

class AuthorWorksLoading extends AuthorWorksState {}

class AuthorWorksLoaded extends AuthorWorksState {
  final List<WorkModel> works;

  const AuthorWorksLoaded({required this.works});

  @override
  List<Object> get props => [works];
}

class AuthorWorksError extends AuthorWorksState {
  final String message;

  const AuthorWorksError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class AuthorWorksBloc extends Bloc<AuthorWorksEvent, AuthorWorksState> {
  final GetAuthorWorksUseCase getAuthorWorksUseCase;

  AuthorWorksBloc(this.getAuthorWorksUseCase) : super(AuthorWorksInitial()) {
    on<GetAuthorWorks>(_onGetAuthorWorks);
  }

  Future<void> _onGetAuthorWorks(
    GetAuthorWorks event,
    Emitter<AuthorWorksState> emit,
  ) async {
    emit(AuthorWorksLoading());

    final result = await getAuthorWorksUseCase(event.authorKey);

    result.fold(
      (failure) => emit(AuthorWorksError(failure.message)),
      (works) => emit(AuthorWorksLoaded(works: works)),
    );
  }
}
