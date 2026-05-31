import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../data/models/manga.dart';
import '../../../data/models/chapter.dart';
import '../../../providers/manga_provider.dart';
import '../../../providers/chapter_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/favorite_provider.dart';

class MangaDetailScreen extends StatefulWidget {
  final String mangaId;

  const MangaDetailScreen({super.key, required this.mangaId});

  @override
  State<MangaDetailScreen> createState() => _MangaDetailScreenState();
}

class _MangaDetailScreenState extends State<MangaDetailScreen> {
  Manga? _manga;
  List<Chapter> _chapters = [];
  bool _isLoading = true;
  bool _isFavorite = false;
  bool _favBusy = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    final mangaProvider = context.read<MangaProvider>();
    final chapterProvider = context.read<ChapterProvider>();

    final manga = await mangaProvider.getMangaDetail(widget.mangaId);
    if (manga != null) {
      await chapterProvider.fetchChapters(widget.mangaId);
      // Determine favorite state (best-effort; ignore failures e.g. not logged in)
      bool fav = false;
      try {
        fav = await context.read<FavoriteProvider>().isFavorite(widget.mangaId);
      } catch (_) {}
      if (mounted) {
        setState(() {
          _manga = manga;
          _chapters = chapterProvider.chapters;
          _isFavorite = fav;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    if (_favBusy) return;
    setState(() => _favBusy = true);
    final favProvider = context.read<FavoriteProvider>();
    final auth = context.read<AuthProvider>();

    if (!auth.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đăng nhập để lưu truyện yêu thích.'),
          backgroundColor: AppColors.error,
        ),
      );
      setState(() => _favBusy = false);
      return;
    }

    final newState = !_isFavorite;
    bool ok;
    if (newState) {
      ok = await favProvider.addFavorite(widget.mangaId);
    } else {
      ok = await favProvider.removeFavorite(widget.mangaId);
    }

    if (!mounted) return;
    setState(() {
      if (ok) _isFavorite = newState;
      _favBusy = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? (newState ? 'Đã thêm vào yêu thích' : 'Đã bỏ yêu thích')
              : (favProvider.errorMessage ?? 'Thao tác thất bại'),
        ),
        backgroundColor: ok ? AppColors.tertiaryContainer : AppColors.error,
      ),
    );
  }

  void _onTapChapter(Chapter chapter) {
    if (_manga == null) return;

    // Logic khóa Premium: Khóa nếu Chapter là Premium HOẶC Truyện là Premium
    final isPremium = chapter.isPremium || _manga!.isPremium;
    final auth = context.read<AuthProvider>();

    if (isPremium && !auth.isPremium && !auth.isAdminOrManager) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Chương này yêu cầu tài khoản Premium. Vui lòng nâng cấp!',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      AppRouter.reading,
      arguments: {
        'mangaId': widget.mangaId,
        'chapterNumber': chapter.chapterNumber,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryContainer),
        ),
      );
    }

    if (_manga == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: const Center(
          child: Text(
            'Không tìm thấy truyện',
            style: TextStyle(color: AppColors.onSurfaceVariant),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildMangaInfo()),
          SliverToBoxAdapter(child: _buildActionButtons()),
          SliverToBoxAdapter(child: _buildDescription()),
          SliverToBoxAdapter(child: _buildChapterHeader()),
          _buildChapterList(),
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.8),
            border: Border.all(color: AppColors.outline),
          ),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.onSurface,
            size: 20,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            _manga!.coverUrl.isNotEmpty
                ? Image.network(
                    _manga!.coverUrl,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  )
                : const Center(
                    child: Icon(
                      Icons.image,
                      size: 64,
                      color: AppColors.outline,
                    ),
                  ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.5),
                    AppColors.background,
                  ],
                  stops: const [0.3, 0.7, 1.0],
                ),
              ),
            ),
            // Status Badge
            Positioned(
              top: 80,
              right: -10,
              child: Transform.rotate(
                angle: 0.1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  color: AppColors.secondaryContainer,
                  child: Text(
                    _manga!.status.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Anton',
                      color: AppColors.onSecondaryContainer,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMangaInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  _manga!.title.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Anton',
                    color: AppColors.onSurface,
                    fontSize: 40,
                    height: 1.1,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: AppColors.primaryContainer,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'By ${_manga!.author}',
                style: const TextStyle(
                  fontFamily: 'Syne',
                  color: AppColors.onSurfaceVariant,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.star, color: AppColors.tertiary, size: 16),
                  SizedBox(width: 4),
                  Text(
                    '4.8', // Giả lập rating
                    style: TextStyle(
                      fontFamily: 'Syne',
                      color: AppColors.tertiary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _manga!.tags.map((genre) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.outline),
                  color: AppColors.surfaceContainerHigh,
                ),
                child: Text(
                  genre.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                if (_chapters.isNotEmpty) {
                  _onTapChapter(_chapters.first);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  border: Border.all(color: AppColors.outline, width: 2),
                  boxShadow: const [
                    BoxShadow(color: AppColors.onSurface, offset: Offset(4, 4)),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.menu_book, color: AppColors.onPrimaryContainer),
                    SizedBox(width: 8),
                    Text(
                      'ĐỌC TỪ ĐẦU',
                      style: TextStyle(
                        fontFamily: 'Anton',
                        color: AppColors.onPrimaryContainer,
                        fontSize: 18,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: _toggleFavorite,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _isFavorite
                      ? AppColors.error
                      : AppColors.surfaceContainer,
                  border: Border.all(color: AppColors.error, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.errorContainer,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.white : AppColors.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TÓM TẮT',
            style: TextStyle(
              fontFamily: 'Syne',
              color: AppColors.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _manga!.description,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildChapterHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.list, color: AppColors.primaryContainer),
          SizedBox(width: 8),
          Text(
            'DANH SÁCH CHƯƠNG',
            style: TextStyle(
              fontFamily: 'Anton',
              color: AppColors.onSurface,
              fontSize: 20,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterList() {
    if (_chapters.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text(
              'Chưa có chương nào.',
              style: TextStyle(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final chapter = _chapters[index];
        final isPremium = chapter.isPremium || _manga!.isPremium;

        return InkWell(
          onTap: () => _onTapChapter(chapter),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (isPremium)
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.lock,
                              color: AppColors.error,
                              size: 16,
                            ),
                          ),
                        Text(
                          chapter.displayTitle,
                          style: TextStyle(
                            fontFamily: 'Syne',
                            color: isPremium
                                ? AppColors.error
                                : AppColors.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${chapter.totalPages} pages',
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Icon(
                      Icons.visibility,
                      color: AppColors.onSurfaceVariant,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '0',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }, childCount: _chapters.length),
    );
  }
}
