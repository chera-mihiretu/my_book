import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/network/api_client.dart';
import '../core/network/network_info.dart';
import '../core/utils/constants.dart';

// Auth
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

// Books
import '../features/books/data/datasources/book_remote_data_source.dart';
import '../features/books/data/repositories/book_repository_impl.dart';
import '../features/books/domain/repositories/book_repository.dart';
import '../features/books/presentation/bloc/book_bloc.dart';

// Favorites
import '../features/favorites/data/datasources/favorite_remote_data_source.dart';
import '../features/favorites/data/repositories/favorite_repository_impl.dart';
import '../features/favorites/domain/repositories/favorite_repository.dart';
import '../features/favorites/presentation/bloc/favorite_bloc.dart';

// Reading
import '../features/reading/data/datasources/reading_remote_data_source.dart';
import '../features/reading/data/repositories/reading_repository_impl.dart';
import '../features/reading/domain/repositories/reading_repository.dart';
import '../features/reading/presentation/bloc/reading_bloc.dart';

// Search
import '../features/search/data/datasources/search_remote_data_source.dart';
import '../features/search/data/repositories/search_repository_impl.dart';
import '../features/search/domain/repositories/search_repository.dart';
import '../features/search/domain/usecases/search_books_usecase.dart';
import '../features/search/domain/usecases/search_authors_usecase.dart';
import '../features/search/presentation/bloc/search_bloc.dart';

// Author Detail
import '../features/author_detail/data/datasources/author_detail_remote_data_source.dart';
import '../features/author_detail/data/repositories/author_detail_repository_impl.dart';
import '../features/author_detail/domain/repositories/author_detail_repository.dart';
import '../features/author_detail/domain/usecases/get_author_detail_usecase.dart';
import '../features/author_detail/presentation/bloc/author_detail_bloc.dart';

// Book Detail
import '../features/books/data/datasources/book_detail_remote_data_source.dart';
import '../features/books/data/repositories/book_detail_repository_impl.dart';
import '../features/books/domain/repositories/book_detail_repository.dart';
import '../features/books/domain/usecases/get_book_detail_usecase.dart';
import '../features/books/presentation/bloc/book_detail_bloc.dart';

final sl = GetIt.instance;

/// Initialize dependency injection
Future<void> initializeDependencies() async {
  // dotenv
  await dotenv.load(fileName: ".env");
  log(
    dotenv.env['SUPABASE_URL'] == null
        ? "SUPABASE URL NOT FOUND"
        : "SUPABASE URL FOUND",
  );
  log(
    dotenv.env['SUPABASE_ANON_KEY'] == null
        ? "SUPABASE ANON KEY NOT FOUND"
        : "SUPABASE ANON KEY FOUND",
  );
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  sl.registerLazySingleton(() => Supabase.instance);

  // External dependencies
  await Hive.initFlutter();
  sl.registerLazySingleton(() => Hive);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());

  // Core
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      client: sl(),
      baseUrl: AppConstants.baseUrl,
      timeout: AppConstants.connectionTimeout,
    ),
  );

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabase: sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(() => AuthBloc(authRepository: sl()));

  // Books
  sl.registerLazySingleton<BookRemoteDataSource>(
    () => BookRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<BookRepository>(
    () => BookRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(() => BookBloc(bookRepository: sl()));

  // Favorites
  sl.registerLazySingleton<FavoriteRemoteDataSource>(
    () => FavoriteRemoteDataSourceImpl(supabase: sl()),
  );

  sl.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(() => FavoriteBloc(favoriteRepository: sl()));

  // Reading
  sl.registerLazySingleton<ReadingRemoteDataSource>(
    () => ReadingRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<ReadingRepository>(
    () => ReadingRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(() => ReadingBloc(readingRepository: sl()));

  // Search
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => SearchBooksUseCase(sl()));
  sl.registerLazySingleton(() => SearchAuthorsUseCase(sl()));

  sl.registerFactory(
    () => SearchBloc(searchBooksUseCase: sl(), searchAuthorsUseCase: sl()),
  );

  // Author Detail
  sl.registerLazySingleton<AuthorDetailRemoteDataSource>(
    () => AuthorDetailRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<AuthorDetailRepository>(
    () => AuthorDetailRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetAuthorDetailUseCase(sl()));

  sl.registerFactory(() => AuthorDetailBloc(getAuthorDetailUseCase: sl()));

  // Book Detail
  sl.registerLazySingleton<BookDetailRemoteDataSource>(
    () => BookDetailRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<BookDetailRepository>(
    () => BookDetailRepositoryImpl(
      remoteDataSource: sl(),
      favoriteRemoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetBookDetailUseCase(sl()));

  sl.registerFactory(() => BookDetailBloc(getBookDetailUseCase: sl()));
}
