import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings_vi.dart';
import '../../../core/routes/app_router.dart';
import '../../../data/models/manga.dart';
import '../../../providers/search_provider.dart';
import '../../widgets/main_app_bar.dart';
import '../../widgets/main_drawer.dart';
import 'widgets/creator_selector.dart';
import 'widgets/tag_selector.dart';
import 'widgets/search_pagination_controls.dart';

/// Manga search screen: title keyword, creator, and tag filters with
/// paginated results in the "Manga Brutalism" dark theme.
class SearchScreen extends StatefulWidget {
  /// Waiting period after the user stops typing before an automatic search
  /// fires. When [Duration.zero], the search fires immediately on each edit.
  final Duration debounceInterval;

  const SearchScreen({
    super.key,
    this.debounceInterval = const Duration(milliseconds: 400),
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _keywordController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _keywordController.dispose();
    super.dispose();
  }

  void _onKeywordChanged(String value) {
    final provider = context.read<SearchProvider>();
    provider.setKeyword(value);

    _debounce?.cancel();
    if (widget.debounceInterval == Duration.zero) {
      provider.submitSearch();
    } else {
      _debounce = Timer(widget.debounceInterval, () {
        provider.submitSearch();
      });
    }
  }

  void _onClear() {
    _debounce?.cancel();
    _keywordController.clear();
    context.read<SearchProvider>().clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const MainAppBar(),
      drawer: const MainDrawer(),
      body: Consumer<SearchProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              _buildControls(context, provider),
              const Divider(color: AppColors.border, thickness: 2, height: 2),
              Expanded(child: _buildResults(context, provider)),
              if (provider.hasMultiplePages)
                SearchPaginationControls(
                  currentPage: provider.currentPage,
                  totalPages: provider.totalPages,
                  hasPrevious: provider.hasPreviousPage,
                  hasNext: provider.hasNextPage,
                  onPrevious: provider.previousPage,
                  onNext: provider.nextPage,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControls(BuildContext context, SearchProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStringsVi.searchByTitleLabel,
            style: TextStyle(
              fontFamily: 'Syne',
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _keywordController,
            style: const TextStyle(color: AppColors.onSurface),
            onChanged: _onKeywordChanged,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => provider.submitSearch(),
            decoration: InputDecoration(
              hintText: AppStringsVi.searchByTitleHint,
              hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.onSurfaceVariant),
              filled: true,
              fillColor: AppColors.surfaceContainerHigh,
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: AppColors.outline, width: 2),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide:
                    BorderSide(color: AppColors.primaryContainer, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          CreatorSelector(
            selected: provider.creator,
            onChanged: provider.setCreator,
          ),
          const SizedBox(height: 12),
          TagSelector(
            selected: provider.tags,
            onChanged: provider.setTags,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _BrutalButton(
                  label: AppStringsVi.searchSubmit,
                  filled: true,
                  onTap: provider.submitSearch,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BrutalButton(
                  label: AppStringsVi.searchClear,
                  filled: false,
                  onTap: _onClear,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResults(BuildContext context, SearchProvider provider) {
    switch (provider.status) {
      case SearchStatus.idle:
        return _buildMessage(
          icon: Icons.search,
          message: AppStringsVi.searchInitialPrompt,
        );
      case SearchStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryContainer),
        );
      case SearchStatus.empty:
        return _buildMessage(
          icon: Icons.sentiment_dissatisfied,
          message: AppStringsVi.noResults,
        );
      case SearchStatus.error:
        return _buildError(context, provider);
      case SearchStatus.success:
        return _buildGrid(context, provider);
    }
  }

  Widget _buildMessage({required IconData icon, required String message}) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.outline),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Syne',
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, SearchProvider provider) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? AppStringsVi.errorGeneric,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Syne',
                color: AppColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _BrutalButton(
              label: AppStringsVi.tryAgain,
              filled: true,
              onTap: provider.retry,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, SearchProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            AppStringsVi.searchResultCount(provider.resultCount),
            style: const TextStyle(
              fontFamily: 'Anton',
              color: AppColors.onSurface,
              fontSize: 18,
              letterSpacing: 1,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
            ),
            itemCount: provider.results.length,
            itemBuilder: (context, index) {
              return _SearchMangaCard(manga: provider.results[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _BrutalButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _BrutalButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? AppColors.primaryContainer : AppColors.surface,
          border: Border.all(
            color: filled ? AppColors.primaryContainer : AppColors.outline,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(color: AppColors.tertiary, offset: Offset(4, 4)),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Anton',
            color: filled ? AppColors.onPrimaryContainer : AppColors.onSurface,
            fontSize: 15,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class _SearchMangaCard extends StatelessWidget {
  final Manga manga;

  const _SearchMangaCard({required this.manga});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.mangaDetail,
            arguments: manga.id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          border: Border.all(color: AppColors.border, width: 2),
          boxShadow: const [
            BoxShadow(color: AppColors.tertiary, offset: Offset(4, 4)),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: AppColors.surfaceVariant,
              child: manga.coverUrl.isNotEmpty
                  ? Image.network(manga.coverUrl, fit: BoxFit.cover,
                      errorBuilder: (_, error, stackTrace) => const Center(
                            child: Icon(Icons.broken_image,
                                color: AppColors.outline, size: 40),
                          ))
                  : const Center(
                      child: Icon(Icons.image,
                          color: AppColors.outline, size: 40)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manga.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Anton',
                      color: AppColors.onSurface,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    manga.contentTag,
                    style: const TextStyle(
                      fontFamily: 'Syne',
                      color: AppColors.primaryContainer,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
