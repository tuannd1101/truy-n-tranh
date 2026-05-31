import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF13131B), Color(0xFF1F1F28)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: const Border(
            bottom: BorderSide(color: AppColors.primaryContainer, width: 2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryContainer.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Hamburger Menu or Back Button handled automatically by Scaffold?
                // Actually, if we use a custom Container instead of AppBar, 
                // Scaffold doesn't automatically insert the Hamburger/Back button.
                // Since this is a global MainAppBar, it should always have a Hamburger menu.
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                // Logo & Title
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate back to home and clear stack to avoid infinite pushing
                      Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (route) => false);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.background,
                            border: Border.all(color: AppColors.primaryContainer, width: 2),
                            boxShadow: [
                              BoxShadow(color: AppColors.primaryContainer.withOpacity(0.5), blurRadius: 8)
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Center(
                                child: Text(
                                  'N',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'NoruManga',
                          style: TextStyle(
                            fontFamily: 'Anton',
                            fontSize: 22,
                            color: Colors.white,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(color: AppColors.primaryContainer, blurRadius: 4),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Placeholder for balance (removed profile icon as requested)
                const SizedBox(width: 44),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
