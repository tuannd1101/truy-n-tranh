import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/bundle.dart';
import '../../../../providers/bundle_provider.dart';
import '../admin_dashboard_screen.dart';

class AdminBundleTab extends StatefulWidget {
  const AdminBundleTab({super.key});

  @override
  State<AdminBundleTab> createState() => _AdminBundleTabState();
}

class _AdminBundleTabState extends State<AdminBundleTab> {
  static const _cycles = ['MONTHLY', 'QUARTERLY', 'YEARLY'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Admin view: include inactive bundles too.
      context.read<BundleProvider>().fetchBundles(all: true);
    });
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BundleProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'BUNDLE MANAGEMENT',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 24,
                      color: AdminColors.onSurface,
                      letterSpacing: 1.5,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showBundleDialog(context, provider),
                    icon: const Icon(Icons.add, color: Colors.black),
                    label: const Text('ADD BUNDLE',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminColors.warningYellow,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (provider.isLoading && provider.bundles.isEmpty)
                const Center(
                    child: CircularProgressIndicator(
                        color: AdminColors.warningYellow))
              else if (provider.errorMessage != null && provider.bundles.isEmpty)
                Center(
                    child: Text(provider.errorMessage!,
                        style: const TextStyle(color: AdminColors.errorRed)))
              else if (provider.bundles.isEmpty)
                const Center(
                    child: Text('No bundles found.',
                        style: TextStyle(color: AdminColors.onSurfaceVariant)))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.bundles.length,
                  itemBuilder: (context, index) {
                    final bundle = provider.bundles[index];
                    return _buildBundleCard(context, provider, bundle);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBundleCard(
      BuildContext context, BundleProvider provider, Bundle bundle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        border: Border.all(color: AdminColors.outlineVariant),
        boxShadow: const [
          BoxShadow(color: AdminColors.warningYellow, offset: Offset(2, 2))
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium, color: AdminColors.warningYellow),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(bundle.name,
                          style: GoogleFonts.bebasNeue(
                              fontSize: 18, color: AdminColors.onSurface)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: bundle.active
                            ? AdminColors.green.withValues(alpha: 0.15)
                            : AdminColors.errorRedDark.withValues(alpha: 0.3),
                        border: Border.all(
                            color: bundle.active
                                ? AdminColors.green
                                : AdminColors.errorRed),
                      ),
                      child: Text(bundle.active ? 'ACTIVE' : 'INACTIVE',
                          style: TextStyle(
                              fontSize: 9,
                              color: bundle.active
                                  ? AdminColors.green
                                  : AdminColors.errorRed,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${_formatPrice(bundle.price)} VNĐ • ${bundle.billingCycle} • ${bundle.durationDays} ngày',
                  style: const TextStyle(
                      color: AdminColors.onSurfaceVariant, fontSize: 12),
                ),
                Text('Role: ${bundle.roleName}',
                    style: const TextStyle(
                        color: AdminColors.cyberCyan, fontSize: 11)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: AdminColors.cyberCyan),
            onPressed: () =>
                _showBundleDialog(context, provider, existingBundle: bundle),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: AdminColors.errorRed),
            onPressed: () => _confirmDelete(context, provider, bundle),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, BundleProvider provider, Bundle bundle) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AdminColors.surface,
        title: Text('DELETE BUNDLE',
            style: GoogleFonts.bebasNeue(
                color: AdminColors.errorRed, letterSpacing: 1)),
        content: Text('Bạn có chắc muốn xóa gói "${bundle.name}"?',
            style: const TextStyle(color: AdminColors.onSurface)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL',
                style: TextStyle(color: AdminColors.onSurfaceVariant)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await provider.deleteBundle(bundle.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(success
                      ? 'Đã xóa gói!'
                      : provider.errorMessage ?? 'Xóa thất bại'),
                  backgroundColor:
                      success ? AdminColors.green : AdminColors.errorRed,
                ));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AdminColors.errorRed),
            child: const Text('DELETE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showBundleDialog(BuildContext context, BundleProvider provider,
      {Bundle? existingBundle}) {
    final isEdit = existingBundle != null;
    final nameController =
        TextEditingController(text: existingBundle?.name ?? '');
    final descController =
        TextEditingController(text: existingBundle?.description ?? '');
    final priceController =
        TextEditingController(text: existingBundle?.price.toString() ?? '');
    final roleController =
        TextEditingController(text: existingBundle?.roleName ?? 'Premium');
    final featuresController = TextEditingController(
        text: existingBundle?.features.join('\n') ?? '');
    String selectedCycle = existingBundle?.billingCycle ?? 'MONTHLY';
    bool active = existingBundle?.active ?? true;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AdminColors.surface,
              title: Text(
                isEdit ? 'EDIT BUNDLE' : 'ADD BUNDLE',
                style: GoogleFonts.bebasNeue(
                    color: AdminColors.warningYellow, letterSpacing: 1),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _field(nameController, 'Tên gói'),
                    _field(descController, 'Mô tả', maxLines: 2),
                    _field(priceController, 'Giá (VNĐ)',
                        keyboardType: TextInputType.number),
                    _field(roleController, 'Role cấp khi mua'),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DropdownButtonFormField<String>(
                        value: selectedCycle,
                        decoration: _decoration('Chu kỳ'),
                        dropdownColor: AdminColors.surfaceHigh,
                        style: const TextStyle(color: AdminColors.onSurface),
                        items: _cycles
                            .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedCycle = val);
                        },
                      ),
                    ),
                    _field(featuresController, 'Tính năng (mỗi dòng 1 mục)',
                        maxLines: 4),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Đang kích hoạt',
                          style: TextStyle(color: AdminColors.onSurface)),
                      value: active,
                      activeThumbColor: AdminColors.green,
                      onChanged: (val) => setState(() => active = val),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('CANCEL',
                      style: TextStyle(color: AdminColors.onSurfaceVariant)),
                ),
                ElevatedButton(
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                          if (nameController.text.isEmpty ||
                              priceController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Vui lòng nhập tên và giá')));
                            return;
                          }

                          final features = featuresController.text
                              .split('\n')
                              .map((s) => s.trim())
                              .where((s) => s.isNotEmpty)
                              .toList();

                          final data = {
                            'name': nameController.text.trim(),
                            'description': descController.text.trim(),
                            'price':
                                int.tryParse(priceController.text.trim()) ?? 0,
                            'billingCycle': selectedCycle,
                            'roleName': roleController.text.trim().isEmpty
                                ? 'Premium'
                                : roleController.text.trim(),
                            'features': features,
                            'active': active,
                          };

                          Navigator.pop(ctx);

                          final success = isEdit
                              ? await provider.updateBundle(
                                  existingBundle.id, data)
                              : await provider.addBundle(data);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(success
                                  ? (isEdit ? 'Đã cập nhật gói!' : 'Đã thêm gói!')
                                  : provider.errorMessage ?? 'Thao tác thất bại'),
                              backgroundColor: success
                                  ? AdminColors.green
                                  : AdminColors.errorRed,
                            ));
                          }
                        },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AdminColors.warningYellow),
                  child: provider.isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              color: Colors.black, strokeWidth: 2))
                      : const Text('SAVE',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _field(TextEditingController controller, String label,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(color: AdminColors.onSurface),
        decoration: _decoration(label),
      ),
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AdminColors.onSurfaceVariant),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AdminColors.outlineVariant)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AdminColors.warningYellow)),
    );
  }
}
