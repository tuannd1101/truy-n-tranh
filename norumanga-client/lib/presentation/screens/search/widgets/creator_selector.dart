import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings_vi.dart';
import '../../../../data/models/creator.dart';
import '../../../../providers/creator_provider.dart';

/// Lets the user search for and select a single creator (Creator_Filter).
class CreatorSelector extends StatelessWidget {
  final Creator? selected;
  final ValueChanged<Creator?> onChanged;

  const CreatorSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStringsVi.searchByCreatorLabel,
          style: TextStyle(
            fontFamily: 'Syne',
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _openPicker(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              border: Border.all(color: AppColors.outline, width: 2),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_outline,
                    color: AppColors.onSurfaceVariant, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selected?.name ?? AppStringsVi.searchByCreatorHint,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Syne',
                      color: selected != null
                          ? AppColors.onSurface
                          : AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (selected != null)
                  GestureDetector(
                    onTap: () => onChanged(null),
                    child: const Icon(Icons.close,
                        color: AppColors.primaryContainer, size: 20),
                  )
                else
                  const Icon(Icons.arrow_drop_down,
                      color: AppColors.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    final provider = context.read<CreatorProvider>();
    if (provider.creators.isEmpty && !provider.isLoading) {
      provider.fetchCreators();
    }

    final result = await showModalBottomSheet<Creator?>(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      isScrollControlled: true,
      builder: (_) => _CreatorPickerSheet(selected: selected),
    );

    // result == null could mean "dismissed" or "cleared"; we only act on a pick.
    if (result != null) {
      onChanged(result.id.isEmpty ? null : result);
    }
  }
}

class _CreatorPickerSheet extends StatefulWidget {
  final Creator? selected;

  const _CreatorPickerSheet({required this.selected});

  @override
  State<_CreatorPickerSheet> createState() => _CreatorPickerSheetState();
}

class _CreatorPickerSheetState extends State<_CreatorPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainer,
            border: Border(
              top: BorderSide(color: AppColors.primaryContainer, width: 3),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppStringsVi.searchSelectCreatorTitle,
                style: TextStyle(
                  fontFamily: 'Anton',
                  color: AppColors.onSurface,
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                autofocus: true,
                style: const TextStyle(color: AppColors.onSurface),
                decoration: InputDecoration(
                  hintText: AppStringsVi.searchByCreatorHint,
                  hintStyle:
                      const TextStyle(color: AppColors.onSurfaceVariant),
                  prefixIcon: const Icon(Icons.search,
                      color: AppColors.onSurfaceVariant),
                  filled: true,
                  fillColor: AppColors.surfaceContainerHigh,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: AppColors.outline, width: 2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                        color: AppColors.primaryContainer, width: 2),
                  ),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Consumer<CreatorProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading && provider.creators.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primaryContainer),
                      );
                    }

                    final filtered = provider.creators
                        .where((c) => c.name
                            .toLowerCase()
                            .contains(_query.toLowerCase()))
                        .toList();

                    if (filtered.isEmpty) {
                      return const Center(
                        child: Text(
                          AppStringsVi.searchNoCreators,
                          style: TextStyle(color: AppColors.onSurfaceVariant),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final creator = filtered[index];
                        final isSelected = creator.id == widget.selected?.id;
                        return ListTile(
                          title: Text(
                            creator.name,
                            style: TextStyle(
                              fontFamily: 'Syne',
                              color: isSelected
                                  ? AppColors.primaryContainer
                                  : AppColors.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check,
                                  color: AppColors.primaryContainer)
                              : null,
                          onTap: () => Navigator.pop(context, creator),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
