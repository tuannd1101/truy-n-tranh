import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../widgets/main_drawer.dart';
import '../../widgets/main_app_bar.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const MainAppBar(),
      drawer: const MainDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildFilterRow(),
                const SizedBox(height: 32),
                _buildProjectList(),
                const SizedBox(height: 80), // space for FAB
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: _buildFab(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'LIBRARY',
          style: TextStyle(
            fontFamily: 'sans-serif',
            fontSize: 44,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 2,
            shadows: [
              Shadow(
                color: Colors.cyanAccent,
                offset: Offset(4, 4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Your creative archive. Manage, review, and organize your manga projects.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterRow() {
    return Row(
      children: [
        _buildFilterTab('すべて', 'All', true),
        const SizedBox(width: 12),
        _buildFilterTab('少年', 'Shounen', false),
        const SizedBox(width: 12),
        _buildFilterTab('連載中', 'Ongoing', false),
      ],
    );
  }

  Widget _buildFilterTab(String jp, String en, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isActive ? AppColors.primaryContainer : const Color(0xFF1B1B23),
      child: Column(
        children: [
          Text(
            jp,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            en,
            style: TextStyle(
              fontFamily: 'sans-serif',
              color: isActive ? Colors.black : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectList() {
    return Column(
      children: [
        _buildLibraryCard(
          id: '01',
          title: 'NEON DRIFT',
          desc: 'Cybernetic racing leagues in Neo-Tokyo. Chapter 14 in progress.',
          tag1Jp: '少年',
          tag1En: 'Shounen',
          tag2Jp: '連載中',
          tag2En: 'Serializing',
          time: 'Lost edited 2h ago',
          buttonText: 'EDIT',
          buttonColor: Colors.yellow,
        ),
        const SizedBox(height: 24),
        _buildLibraryCard(
          id: '02',
          title: 'CRIMSON BLADE',
          desc: 'A masterless samurai seeks vengeance across the Edo period.',
          tag1Jp: '青年',
          tag1En: 'Seinen',
          tag2Jp: '完結',
          tag2En: 'Completed',
          time: 'Lost edited 1w ago',
          buttonText: 'VIEW',
          buttonColor: Colors.grey.shade800,
          buttonTextColor: Colors.white,
          tagsAreDark: true,
        ),
        const SizedBox(height: 24),
        _buildLibraryCard(
          id: '03',
          title: 'STARFALL MAGIC',
          desc: 'Middle schoolers protect the galaxy with explosive magic.',
          tag1Jp: '少女',
          tag1En: 'Shoujo',
          tag2Jp: '連載中',
          tag2En: 'Serializing',
          time: 'Lost edited 3d ago',
          buttonText: 'EDIT',
          buttonColor: Colors.yellow,
        ),
      ],
    );
  }

  Widget _buildLibraryCard({
    required String id,
    required String title,
    required String desc,
    required String tag1Jp,
    required String tag1En,
    required String tag2Jp,
    required String tag2En,
    required String time,
    required String buttonText,
    required Color buttonColor,
    Color buttonTextColor = Colors.black,
    bool tagsAreDark = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF1B1B23),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Image Placeholder
              Container(
                width: 100,
                height: 160,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    image: AssetImage('assets/images/hero_artist.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.grey, BlendMode.saturation),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'sans-serif',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        desc,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.history, color: Colors.grey, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                time,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            color: buttonColor,
                            child: Text(
                              buttonText,
                              style: TextStyle(
                                fontFamily: 'sans-serif',
                                color: buttonTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Top Tags Overlapping
          Positioned(
            top: -10,
            left: 110,
            child: Row(
              children: [
                Transform.rotate(
                  angle: -0.05,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    color: tagsAreDark ? Colors.grey.shade800 : AppColors.primaryContainer,
                    child: Column(
                      children: [
                        Text(
                          tag1Jp,
                          style: TextStyle(
                            color: tagsAreDark ? Colors.grey : Colors.black,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          tag1En,
                          style: TextStyle(
                            fontFamily: 'sans-serif',
                            color: tagsAreDark ? Colors.white : Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Transform.rotate(
                  angle: 0.05,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    color: tagsAreDark ? Colors.grey.shade900 : AppColors.secondaryContainer,
                    child: Column(
                      children: [
                        Text(
                          tag2Jp,
                          style: TextStyle(
                            color: tagsAreDark ? Colors.grey : Colors.black,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          tag2En,
                          style: TextStyle(
                            fontFamily: 'sans-serif',
                            color: tagsAreDark ? Colors.white : Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ID tag
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.cyanAccent,
              child: Text(
                id,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFab() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.cyanAccent, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.cyanAccent,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: const Icon(Icons.add, color: Colors.black, size: 28),
    );
  }
}
