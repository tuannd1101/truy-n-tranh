import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings_vi.dart';

/// Previous / next controls and a current-page indicator.
class SearchPaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool hasPrevious;
  final bool hasNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const SearchPaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.hasPrevious,
    required this.hasNext,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _PageButton(
            icon: Icons.chevron_left,
            label: AppStringsVi.previous,
            enabled: hasPrevious,
            onTap: onPrevious,
          ),
          Text(
            AppStringsVi.searchPageIndicator(currentPage, totalPages),
            style: const TextStyle(
              fontFamily: 'Anton',
              color: AppColors.onSurface,
              fontSize: 16,
              letterSpacing: 1,
            ),
          ),
          _PageButton(
            icon: Icons.chevron_right,
            label: AppStringsVi.next,
            enabled: hasNext,
            iconAfter: true,
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final bool iconAfter;
  final VoidCallback onTap;

  const _PageButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
    this.iconAfter = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = enabled ? AppColors.onSurface : AppColors.outline;
    final children = <Widget>[
      Icon(icon, color: color, size: 20),
      const SizedBox(width: 4),
      Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Syne',
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    ];

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.surfaceContainerHigh
              : AppColors.surfaceContainerLow,
          border: Border.all(
            color: enabled ? AppColors.primaryContainer : AppColors.outline,
            width: 2,
          ),
          boxShadow: enabled
              ? const [BoxShadow(color: AppColors.tertiary, offset: Offset(3, 3))]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: iconAfter ? children.reversed.toList() : children,
        ),
      ),
    );
  }
}
