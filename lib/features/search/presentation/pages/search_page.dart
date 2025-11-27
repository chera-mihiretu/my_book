import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../bloc/search_bloc.dart';
import '../widgets/search_input_field.dart';
import '../widgets/search_filter_chips.dart';
import '../widgets/search_results_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _selectedFilterIndex = 0; // 0: Books, 1: Authors
  Timer? _debounce;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(() {
      setState(() {}); // Rebuild to show/hide clear button
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final bloc = context.read<SearchBloc>();
      final state = bloc.state;

      if (_selectedFilterIndex == 0 &&
          state is SearchLoaded &&
          !state.hasReachedMax) {
        _currentPage++;
        bloc.add(SearchBooks(_searchController.text, page: _currentPage));
      } else if (_selectedFilterIndex == 1 &&
          state is AuthorSearchLoaded &&
          !state.hasReachedMax) {
        _currentPage++;
        bloc.add(SearchAuthors(_searchController.text, page: _currentPage));
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        _currentPage = 1;
        if (_selectedFilterIndex == 0) {
          context.read<SearchBloc>().add(SearchBooks(query, page: 1));
        } else {
          context.read<SearchBloc>().add(SearchAuthors(query, page: 1));
        }
      }
    });
  }

  void _onFilterChanged(int index) {
    setState(() {
      _selectedFilterIndex = index;
      _currentPage = 1;
      // Re-trigger search if there's text
      if (_searchController.text.isNotEmpty) {
        if (index == 0) {
          context.read<SearchBloc>().add(
            SearchBooks(_searchController.text, page: 1),
          );
        } else {
          context.read<SearchBloc>().add(
            SearchAuthors(_searchController.text, page: 1),
          );
        }
      }
    });
  }

  void _onClearSearch() {
    _searchController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocListener<SearchBloc, SearchState>(
        listener: (context, state) {
          if (state is SearchError) {
            CustomSnackBar.show(
              context,
              message: state.message,
              type: SnackBarType.error,
            );
          }
        },
        child: Column(
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchInputField(
                controller: _searchController,
                hintText: _selectedFilterIndex == 0
                    ? 'Search for books...'
                    : 'Search for authors...',
                onChanged: _onSearchChanged,
                onClear: _onClearSearch,
              ),
            ),

            // Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SearchFilterChips(
                selectedIndex: _selectedFilterIndex,
                onFilterChanged: _onFilterChanged,
              ),
            ),

            const SizedBox(height: 16),

            // Results List
            Expanded(
              child: SearchResultsList(scrollController: _scrollController),
            ),
          ],
        ),
      ),
    );
  }
}
