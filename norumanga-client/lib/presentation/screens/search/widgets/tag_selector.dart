import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings_vi.dart';
import '../../../../data/models/tag.dart';
import '../../../../providers/tag_provider.dart';

/// Lets the user select one or more tags (Tag_Filter).
class TagSelector extends StatelessWidget {
  final List<Tag> selected;
  final ValueChanged<List<Tag>> onChanged;

  const TagSelector({
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
          AppStringsVi.searchByTagLabel,
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
                const Icon(Icons.local_offer_outlined,
                    color: AppColors.onSurfaceVariant, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selected.isEmpty
                        ? AppStringsVi.searchByTagHint
                        : selected.map((t) => t.name).join(', '),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Syne',
                      color: selected.isNotEmpty
                          ? AppColors.onSurface
                          : AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (selected.isNotEmpty)
                  GestureDetector(
                    onTap: () => onChanged([]),
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
    final provider = context.read<TagProvider>();
    if (provider.tags.isEmpty && !provider.isLoading) {
      provider.fetchTags();
    }

    final result = await showModalBottomSheet<List<Tag>>(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      isScrollControlled: true,
      builder: (_) => _TagPickerSheet(selected: selected),
    );

    if (result != null) {
      onChanged(result);
    }
  }
}

class _TagPickerSheet extends StatefulWidget {
  final List<Tag> selected;

  const _TagPickerSheet({required this.selected});

  @override
  State<_TagPickerSheet> createState() => _TagPickerSheetState();
}

class _TagPickerSheetState extends State<_TagPickerSheet> {
  late List<Tag> _working;

  @override
  void initState() {
    super.initState();
    _working = List.of(widget.selected);
  }

  bool _isSelected(Tag tag) => _working.any((t) => t.id == tag.id);

  void _toggle(Tag tag) {
    setState(() {
      if (_isSelected(tag)) {
        _working.removeWhere((t) => t.id == tag.id);
      } else {
        _working.add(tag);
      }
    });
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    AppStringsVi.searchSelectTagTitle,
                    style: TextStyle(
                      fontFamily: 'Anton',
                      color: AppColors.onSurface,
                      fontSize: 18,
                      letterSpacing: 1,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, _working),
                    child: const Text(
                      AppStringsVi.confirm,
                      style: TextStyle(
                        fontFamily: 'Syne',
                        color: AppColors.primaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Consumer<TagProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading && provider.tags.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primaryContainer),
                      );
                    }

                    if (provider.tags.isEmpty) {
                      return const Center(
                        child: Text(
                          AppStringsVi.searchNoTags,
                          style: TextStyle(color: AppColors.onSurfaceVariant),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: provider.tags.map((tag) {
                          final isSelected = _isSelected(tag);
                          return GestureDetector(
                            onTap: () => _toggle(tag),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryContainer
                                    : AppColors.surfaceContainerHigh,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryContainer
                                      : AppColors.outline,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                tag.name.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'Syne',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? AppColors.onPrimaryContainer
                                      : AppColors.onSurface,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
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
