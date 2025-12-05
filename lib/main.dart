import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/author_detail/presentation/bloc/author_detail_bloc.dart';
import 'package:new_project/features/books/presentation/bloc/book_detail_bloc.dart';
import 'package:new_project/features/search/presentation/bloc/search_bloc.dart';
import 'package:new_project/wrapper_page.dart';

import 'di/injector.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/books/presentation/bloc/book_bloc.dart';
import 'features/favorites/presentation/bloc/favorite_bloc.dart';
import 'features/favorites/presentation/pages/favorites_page.dart';
import 'features/reading_list/presentation/bloc/reading_list_bloc.dart';
import 'features/reading_list/presentation/pages/reading_list_page.dart';
import 'features/reading/presentation/bloc/reading_bloc.dart';
import 'features/reading_progress/presentation/bloc/reading_progress_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/design_system/pages/colors_page.dart';
import 'features/completed/presentation/pages/completed_page.dart';
import 'features/account/presentation/pages/account_page.dart';
import 'features/search/presentation/pages/search_page.dart';
import 'core/widgets/custom_bottom_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<BookBloc>()),
        BlocProvider(create: (_) => sl<FavoriteBloc>()),
        BlocProvider(create: (_) => sl<ReadingListBloc>()),
        BlocProvider(create: (_) => sl<ReadingBloc>()),
        BlocProvider(create: (_) => sl<SearchBloc>()),
        BlocProvider(create: (_) => sl<AuthorDetailBloc>()),
        BlocProvider(create: (_) => sl<BookDetailBloc>()),
        BlocProvider(create: (_) => sl<ReadingProgressBloc>()),
      ],
      child: MaterialApp(
        title: 'Book App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const WrapperPage(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/colors': (context) => const ColorsPage(),
        },
      ),
    );
  }
}

/// Home page with bottom navigation
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ReadingListPage(),
    FavoritesPage(),
    CompletedPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: CustomBottomNav(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          onSearchTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SearchPage()));
          },
        ),
      ),
    );
  }
}
