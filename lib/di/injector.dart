import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:new_project/features/notification_settings/domain/usecases/save_notification_token_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/network/api_client.dart';
import '../core/network/network_info.dart';
import '../core/utils/constants.dart';

// Auth
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/reset_password_usecase.dart';
import '../features/auth/domain/usecases/update_password_usecase.dart';
import '../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../features/auth/domain/usecases/verify_email_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

// Books
import '../features/books/data/datasources/book_remote_data_source.dart';
import '../features/books/data/repositories/book_repository_impl.dart';
import '../features/books/domain/repositories/book_repository.dart';
import '../features/books/presentation/bloc/book_bloc.dart';

// Favorites
import '../features/favorites/data/datasources/favorite_local_data_source.dart';
import '../features/favorites/data/datasources/favorite_remote_data_source.dart';
import '../features/favorites/data/repositories/favorite_repository_impl.dart';
import '../features/favorites/domain/repositories/favorite_repository.dart';
import '../features/favorites/domain/usecases/get_favorites_usecase.dart';
import '../features/favorites/presentation/bloc/favorite_bloc.dart';

// Completed
import '../features/completed/data/datasources/completed_local_data_source.dart';
import '../features/completed/data/datasources/completed_remote_data_source.dart';
import '../features/completed/data/repositories/completed_repository_impl.dart';
import '../features/completed/domain/repositories/completed_repository.dart';
import '../features/completed/domain/usecases/get_completed_books_usecase.dart';
import '../features/completed/presentation/bloc/completed_bloc.dart';

// Notification Settings
import '../features/notification_settings/data/datasources/notification_remote_data_source.dart';
import '../features/notification_settings/data/repositories/notification_repository_impl.dart';
import '../features/notification_settings/domain/repositories/notification_repository.dart';
import '../features/notification_settings/domain/usecases/get_notification_settings_usecase.dart';
import '../features/notification_settings/domain/usecases/update_notification_settings_usecase.dart';
import '../features/notification_settings/presentation/bloc/notification_bloc.dart';

// Reading List
import '../features/reading_list/data/datasources/reading_list_remote_data_source.dart';
import '../features/reading_list/data/datasources/reading_list_local_data_source.dart';
import '../features/reading_list/data/repositories/reading_list_repository_impl.dart';
import '../features/reading_list/domain/repositories/reading_list_repository.dart';
import '../features/reading_list/domain/usecases/add_to_reading_list_usecase.dart';
import '../features/reading_list/domain/usecases/get_reading_list_usecase.dart';
import '../features/reading_list/domain/usecases/update_current_page_usecase.dart';
import '../features/reading_list/presentation/bloc/reading_list_bloc.dart';

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
import '../features/author_detail/domain/usecases/get_author_works_usecase.dart';
import '../features/author_detail/presentation/bloc/author_detail_bloc.dart';
import '../features/author_detail/presentation/bloc/author_works_bloc.dart';

// Book Detail
import '../features/books/data/datasources/book_detail_remote_data_source.dart';
import '../features/books/data/repositories/book_detail_repository_impl.dart';
import '../features/books/domain/repositories/book_detail_repository.dart';
import '../features/books/domain/usecases/get_book_detail_usecase.dart';
import '../features/books/presentation/bloc/book_detail_bloc.dart';

// Reading Progress
import '../features/reading_progress/data/datasources/reading_progress_local_data_source.dart';
import '../features/reading_progress/data/repositories/reading_progress_repository_impl.dart';
import '../features/reading_progress/domain/repositories/reading_progress_repository.dart';
import '../features/reading_progress/domain/usecases/clear_reading_progress_usecase.dart';
import '../features/reading_progress/domain/usecases/get_dialog_preference_usecase.dart';
import '../features/reading_progress/domain/usecases/get_reading_progress_usecase.dart';
import '../features/reading_progress/domain/usecases/save_reading_progress_usecase.dart';
import '../features/reading_progress/domain/usecases/update_dialog_preference_usecase.dart';
import '../features/reading_progress/presentation/bloc/reading_progress_bloc.dart';

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

  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePasswordUseCase(sl()));

  sl.registerFactory(
    () => AuthBloc(
      authRepository: sl(),
      resetPasswordUseCase: sl(),
      verifyOtpUseCase: sl(),
      verifyEmailUseCase: sl(),
      updatePasswordUseCase: sl(),
    ),
  );

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

  sl.registerLazySingleton<FavoriteLocalDataSource>(
    () => FavoriteLocalDataSourceImpl(hive: sl()),
  );

  sl.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<GetFavoritesUseCase>(
    () => GetFavoritesUseCase(sl()),
  );

  sl.registerFactory(
    () => FavoriteBloc(favoriteRepository: sl(), getFavoritesUseCase: sl()),
  );

  // Completed
  sl.registerLazySingleton<CompletedRemoteDataSource>(
    () => CompletedRemoteDataSourceImpl(supabase: sl()),
  );

  sl.registerLazySingleton<CompletedLocalDataSource>(
    () => CompletedLocalDataSourceImpl(hive: sl()),
  );

  sl.registerLazySingleton<CompletedRepository>(
    () => CompletedRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<GetCompletedBooksUseCase>(
    () => GetCompletedBooksUseCase(sl()),
  );

  sl.registerFactory(() => CompletedBloc(getCompletedBooksUseCase: sl()));

  // Notification Settings
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(supabase: sl()),
  );

  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<GetNotificationSettingsUseCase>(
    () => GetNotificationSettingsUseCase(sl()),
  );

  sl.registerLazySingleton<UpdateNotificationSettingsUseCase>(
    () => UpdateNotificationSettingsUseCase(sl()),
  );

  sl.registerLazySingleton<SaveNotificationTokenUseCase>(
    () => SaveNotificationTokenUseCase(sl()),
  );

  sl.registerFactory(
    () => NotificationBloc(
      getNotificationSettingsUseCase: sl(),
      updateNotificationSettingsUseCase: sl(),
      saveNotificationTokenUseCase: sl(),
    ),
  );

  // Reading List
  sl.registerLazySingleton<ReadingListRemoteDataSource>(
    () => ReadingListRemoteDataSourceImpl(supabase: sl()),
  );

  sl.registerLazySingleton<ReadingListLocalDataSource>(
    () => ReadingListLocalDataSourceImpl(hive: sl()),
  );

  sl.registerLazySingleton<ReadingListRepository>(
    () => ReadingListRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<AddToReadingListUseCase>(
    () => AddToReadingListUseCase(sl()),
  );

  sl.registerLazySingleton<GetReadingListUseCase>(
    () => GetReadingListUseCase(sl()),
  );

  sl.registerLazySingleton(() => UpdateCurrentPageUseCase(sl()));

  sl.registerFactory(
    () => ReadingListBloc(
      addToReadingListUseCase: sl(),
      getReadingListUseCase: sl(),
      updateCurrentPageUseCase: sl(),
    ),
  );

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
  sl.registerLazySingleton(() => GetAuthorWorksUseCase(sl()));

  sl.registerFactory(() => AuthorDetailBloc(getAuthorDetailUseCase: sl()));
  sl.registerFactory(() => AuthorWorksBloc(sl()));

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

  // Reading Progress
  sl.registerLazySingleton<ReadingProgressLocalDataSource>(
    () => ReadingProgressLocalDataSourceImpl(hive: sl()),
  );

  sl.registerLazySingleton<ReadingProgressRepository>(
    () => ReadingProgressRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton(() => SaveReadingProgressUseCase(sl()));
  sl.registerLazySingleton(() => GetReadingProgressUseCase(sl()));
  sl.registerLazySingleton(() => ClearReadingProgressUseCase(sl()));
  sl.registerLazySingleton(() => GetDialogPreferenceUseCase(sl()));
  sl.registerLazySingleton(() => UpdateDialogPreferenceUseCase(sl()));

  sl.registerFactory(
    () => ReadingProgressBloc(
      getReadingProgressUseCase: sl(),
      saveReadingProgressUseCase: sl(),
      clearReadingProgressUseCase: sl(),
      getDialogPreferenceUseCase: sl(),
      updateDialogPreferenceUseCase: sl(),
    ),
  );
}
