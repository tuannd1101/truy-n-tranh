import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../widgets/manga/manga_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;
  
  bool _isSearching = false;
  bool _hasSearched = false;
  List<String> _searchHistory = [];
  List<String> _selectedGenres = [];
  
  // TODO: Replace with actual genres from API
  final List<String> _genres = [
    'Hành Động',
    'Phiêu Lưu',
    'Hài Hước',
    'Lãng Mạn',
    'Kinh Dị',
    'Trinh Thám',
    'Học Đường',
    'Thể Thao',
  ];
  
  // TODO: Replace with actual search results from API
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _loadSearchHistory() {
    // TODO: Load from SharedPreferences
    setState(() {
      _searchHistory = [
        'One Piece',
        'Naruto',
        'Dragon Ball',
      ];
    });
  }

  void _saveSearchHistory(String query) {
    // TODO: Save to SharedPreferences
    if (query.isNotEmpty && !_searchHistory.contains(query)) {
      setState(() {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 10) {
          _searchHistory = _searchHistory.sublist(0, 10);
        }
      });
    }
  }

  void _removeFromHistory(String query) {
    setState(() {
      _searchHistory.remove(query);
    });
    // TODO: Update SharedPreferences
  }

  void _clearSearchHistory() {
    setState(() {
      _searchHistory.clear();
    });
    // TODO: Clear SharedPreferences
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        _performSearch(query);
      } else {
        setState(() {
          _hasSearched = false;
          _searchResults = [];
        });
      }
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isSearching = true;
      _hasSearched = true;
    });

    // TODO: Call API to search manga
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    
    // Mock search results
    final results = List.generate(
      8,
      (index) => {
        'id': index,
        'title': '$query - Kết quả ${index + 1}',
        'coverUrl': 'https://via.placeholder.com/150x200/FFC107/000000?text=Result+${index + 1}',
        'isPremium': index % 3 == 0,
      },
    );

    if (mounted) {
      setState(() {
        _isSearching = false;
        _searchResults = results;
      });
      _saveSearchHistory(query);
    }
  }

  void _onGenreToggle(String genre) {
    setState(() {
      if (_selectedGenres.contains(genre)) {
        _selectedGenres.remove(genre);
      } else {
        _selectedGenres.add(genre);
      }
    });
    
    // Re-search with selected genres
    if (_searchController.text.isNotEmpty || _selectedGenres.isNotEmpty) {
      _performSearch(_searchController.text);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _hasSearched = false;
      _searchResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm truyện...',
                prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.grey),
                        onPressed: _clearSearch,
                      )
                    : null,
                filled: true,
                fillColor: AppColors.searchBarBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingS,
                ),
              ),
            ),
          ),
          
          // Filter Section
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thể loại:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingS),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _genres.length,
                    itemBuilder: (context, index) {
                      final genre = _genres[index];
                      final isSelected = _selectedGenres.contains(genre);
                      
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < _genres.length - 1
                              ? AppDimensions.paddingS
                              : 0,
                        ),
                        child: FilterChip(
                          label: Text(genre),
                          selected: isSelected,
                          onSelected: (_) => _onGenreToggle(genre),
                          backgroundColor: AppColors.surface,
                          selectedColor: AppColors.primary,
                          labelStyle: AppTextStyles.bodySmall.copyWith(
                            color: isSelected
                                ? AppColors.textPrimary
                                : AppColors.grey,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppDimensions.paddingM),
          
          // Body Content
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    // Initial state - show search history
    if (!_hasSearched) {
      return _buildSearchHistory();
    }
    
    // Searching state
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }
    
    // No results
    if (_searchResults.isEmpty) {
      return _buildNoResults();
    }
    
    // Show results
    return _buildSearchResults();
  }

  Widget _buildSearchHistory() {
    if (_searchHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: AppColors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            Text(
              'Tìm kiếm truyện yêu thích của bạn',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lịch sử tìm kiếm',
                style: AppTextStyles.h4,
              ),
              TextButton(
                onPressed: _clearSearchHistory,
                child: Text(
                  'Xóa tất cả',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchHistory.length,
            itemBuilder: (context, index) {
              final query = _searchHistory[index];
              return ListTile(
                leading: const Icon(Icons.history, color: AppColors.grey),
                title: Text(query, style: AppTextStyles.bodyMedium),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: AppColors.grey),
                  onPressed: () => _removeFromHistory(query),
                ),
                onTap: () {
                  _searchController.text = query;
                  _performSearch(query);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            'Không tìm thấy kết quả cho "${_searchController.text}"',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
          ),
          child: Text(
            'Tìm thấy ${_searchResults.length} truyện',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: AppDimensions.paddingM,
              mainAxisSpacing: AppDimensions.paddingM,
            ),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final manga = _searchResults[index];
              return MangaCard(
                title: manga['title'],
                coverUrl: manga['coverUrl'],
                isPremium: manga['isPremium'],
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/manga-detail',
                    arguments: manga['id'],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
