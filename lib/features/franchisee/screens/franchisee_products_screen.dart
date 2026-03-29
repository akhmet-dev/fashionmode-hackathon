import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/product_model.dart';
import '../../../shared/widgets/avishu_motion.dart';
import '../../../shared/widgets/garment_artwork.dart';

class FranchiseeProductsScreen extends ConsumerWidget {
  const FranchiseeProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    final formatter = NumberFormat('#,###', 'ru_RU');

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'КАТАЛОГ',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                      color: AppColors.black,
                    ),
                  ),
                  productsAsync.when(
                    data: (p) => Text(
                      '${p.length} ТОВАРОВ',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        color: AppColors.grey,
                      ),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: 8),
            Expanded(
              child: productsAsync.when(
                data: (products) => products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.inventory_2_outlined,
                                size: 48, color: AppColors.grey),
                            const SizedBox(height: 16),
                            Text(
                              'ТОВАРОВ НЕТ',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                                color: AppColors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Нажмите + чтобы добавить',
                              style: GoogleFonts.inter(
                                  fontSize: 11, color: AppColors.grey),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding:
                            const EdgeInsets.fromLTRB(16, 8, 16, 100),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.62,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, i) => _ProductCard(
                          product: products[i],
                          formatter: formatter,
                        ),
                      ),
                loading: () => const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.black),
                  ),
                ),
                error: (e, _) => Center(
                  child: Text('Ошибка: $e',
                      style: GoogleFonts.inter(color: AppColors.grey)),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AvishuPressable(
        onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: AppColors.white,
          shape:
              const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          builder: (ctx) => const _ProductSheet(),
        ),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          color: AppColors.black,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, color: AppColors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                'ДОБАВИТЬ',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Product Card ─────────────────────────────────────────────────────────────

class _ProductCard extends ConsumerWidget {
  final ProductModel product;
  final NumberFormat formatter;

  const _ProductCard({required this.product, required this.formatter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AvishuPressable(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.white,
        shape:
            const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        builder: (ctx) => _ProductSheet(existing: product),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: _ProductImage(product: product)),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    color: product.isPreorder
                        ? AppColors.black
                        : Colors.transparent,
                    child: Text(
                      product.isPreorder ? 'ПРЕДЗАКАЗ' : 'В НАЛИЧИИ',
                      style: GoogleFonts.inter(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: product.isPreorder
                            ? AppColors.white
                            : AppColors.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: AvishuPressable(
                    onTap: () => _confirmDelete(context, ref),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      color: AppColors.white.withValues(alpha: 0.9),
                      child: const Icon(Icons.delete_outline_sharp,
                          size: 16, color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '₸${formatter.format(product.price)}',
            style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.grey),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        title: Text('УДАЛИТЬ?',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w900, letterSpacing: 2)),
        content: Text('«${product.name}» удалится из каталога.',
            style: GoogleFonts.inter(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('ОТМЕНА',
                style: GoogleFonts.inter(color: AppColors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('УДАЛИТЬ',
                style: GoogleFonts.inter(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(firestoreServiceProvider).deleteProduct(product.id);
    }
  }
}

/// Shows real photo if imageUrl exists, otherwise falls back to artwork
class _ProductImage extends StatelessWidget {
  final ProductModel product;
  const _ProductImage({required this.product});

  @override
  Widget build(BuildContext context) {
    final url = product.imageUrl;
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            GarmentArtworkCard(imageKey: product.imageKey),
      );
    }
    return GarmentArtworkCard(imageKey: product.imageKey);
  }
}

// ── Product Sheet ─────────────────────────────────────────────────────────────

class _ProductSheet extends ConsumerStatefulWidget {
  final ProductModel? existing;
  const _ProductSheet({this.existing});

  @override
  ConsumerState<_ProductSheet> createState() => _ProductSheetState();
}

class _ProductSheetState extends ConsumerState<_ProductSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  late String _imageKey;
  late bool _isPreorder;
  late List<String> _measurementFields;
  File? _pickedImage;
  bool _loading = false;
  String? _error;

  static const _allMeasurementFields = [
    'Ширина груди',
    'Ширина плеч',
    'Длина рукава',
    'Длина изделия',
    'Обхват талии',
    'Обхват бёдер',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.existing;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _priceCtrl =
        TextEditingController(text: p != null ? '${p.price}' : '');
    _imageKey = p?.imageKey ?? 'white_tshirt';
    _isPreorder = p?.isPreorder ?? false;
    _measurementFields = List<String>.from(
      p?.measurementFields ??
          ['Ширина груди', 'Ширина плеч', 'Длина рукава'],
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1080,
    );
    if (xFile != null) {
      setState(() => _pickedImage = File(xFile.path));
    }
  }

  void _showImagePicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape:
          const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text('Галерея',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text('Камера',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            if (widget.existing?.imageUrl != null && _pickedImage == null)
              ListTile(
                leading:
                    const Icon(Icons.delete_outline, color: Colors.red),
                title: Text('Удалить фото',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: Colors.red)),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _pickedImage = null);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    final price = int.tryParse(_priceCtrl.text.trim());
    if (name.isEmpty || price == null || price <= 0) {
      setState(() => _error = 'Заполните название и цену');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });

    final isNew = widget.existing == null;
    final id = isNew
        ? '${DateTime.now().millisecondsSinceEpoch}'
        : widget.existing!.id;

    final svc = ref.read(firestoreServiceProvider);

    // Upload photo if selected
    String? imageUrl = widget.existing?.imageUrl;
    if (_pickedImage != null) {
      imageUrl = await svc.uploadProductImage(id, _pickedImage!);
    }

    final product = ProductModel(
      id: id,
      name: name.toUpperCase(),
      price: price,
      isPreorder: _isPreorder,
      sortOrder: widget.existing?.sortOrder ??
          DateTime.now().millisecondsSinceEpoch,
      imageKey: _imageKey,
      measurementFields: _measurementFields,
      imageUrl: imageUrl,
    );

    if (isNew) {
      await svc.addProduct(product);
    } else {
      await svc.updateProduct(product);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.existing == null;
    final existingUrl = widget.existing?.imageUrl;
    final hasPhoto = _pickedImage != null ||
        (existingUrl != null && existingUrl.isNotEmpty);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isNew ? 'НОВЫЙ ТОВАР' : 'РЕДАКТИРОВАТЬ',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 20),

          // ── Photo picker ───────────────────────────────────────────────
          _label('ФОТО ТОВАРА'),
          const SizedBox(height: 10),
          AvishuPressable(
            onTap: _showImagePicker,
            child: Container(
              height: 180,
              color: AppColors.lightGrey,
              child: hasPhoto
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        _pickedImage != null
                            ? Image.file(_pickedImage!,
                                fit: BoxFit.cover)
                            : Image.network(existingUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    GarmentArtworkCard(
                                        imageKey: _imageKey)),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            color: AppColors.black
                                .withValues(alpha: 0.7),
                            child: Text(
                              'ИЗМЕНИТЬ',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_photo_alternate_outlined,
                            size: 36, color: AppColors.grey),
                        const SizedBox(height: 8),
                        Text(
                          'ДОБАВИТЬ ФОТО',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Галерея или камера',
                          style: GoogleFonts.inter(
                              fontSize: 10, color: AppColors.grey),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Name ─────────────────────────────────────────────────────
          _label('НАЗВАНИЕ'),
          const SizedBox(height: 6),
          TextField(
            controller: _nameCtrl,
            textCapitalization: TextCapitalization.characters,
            style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.black),
            decoration:
                const InputDecoration(hintText: 'WHITE T-SHIRT'),
          ),
          const SizedBox(height: 16),

          // ── Price ─────────────────────────────────────────────────────
          _label('ЦЕНА (₸)'),
          const SizedBox(height: 6),
          TextField(
            controller: _priceCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.black),
            decoration: const InputDecoration(
                hintText: '14000', suffixText: '₸'),
          ),
          const SizedBox(height: 16),

          // ── Preorder toggle ───────────────────────────────────────────
          AvishuPressable(
            onTap: () =>
                setState(() => _isPreorder = !_isPreorder),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              color: _isPreorder
                  ? AppColors.black
                  : AppColors.lightGrey,
              child: Row(
                children: [
                  Icon(
                    _isPreorder
                        ? Icons.check_box_sharp
                        : Icons.check_box_outline_blank_sharp,
                    color: _isPreorder
                        ? AppColors.white
                        : AppColors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'ПРЕДЗАКАЗ',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _isPreorder
                          ? AppColors.white
                          : AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Artwork fallback selector ─────────────────────────────────
          _label('СТИЛЬ (если нет фото)'),
          const SizedBox(height: 10),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: kGarmentImageKeys.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final key = kGarmentImageKeys[i];
                final selected = _imageKey == key;
                return AvishuPressable(
                  onTap: () =>
                      setState(() => _imageKey = key),
                  child: Container(
                    width: 70,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selected
                            ? AppColors.black
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: GarmentArtworkCard(imageKey: key),
                        ),
                        if (selected)
                          Positioned(
                            top: 3,
                            right: 3,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              color: AppColors.black,
                              child: const Icon(Icons.check_sharp,
                                  size: 10,
                                  color: AppColors.white),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // ── Measurement fields ────────────────────────────────────────
          _label('ПОЛЯ ЗАМЕРОВ'),
          const SizedBox(height: 8),
          ..._allMeasurementFields.map((field) {
            final checked = _measurementFields.contains(field);
            return AvishuPressable(
              onTap: () => setState(() => checked
                  ? _measurementFields.remove(field)
                  : _measurementFields.add(field)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      checked
                          ? Icons.check_box_sharp
                          : Icons.check_box_outline_blank_sharp,
                      size: 20,
                      color: checked
                          ? AppColors.black
                          : AppColors.grey,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      field,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: checked
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: checked
                            ? AppColors.black
                            : AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!,
                style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.red,
                    fontWeight: FontWeight.w600)),
          ],

          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: AvishuPressable(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16),
                    color: AppColors.lightGrey,
                    child: Center(
                      child: Text(
                        'ОТМЕНА',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AvishuPressable(
                  onTap: _loading ? null : _submit,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16),
                    color: AppColors.black,
                    child: Center(
                      child: _loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white),
                            )
                          : Text(
                              isNew ? 'ДОБАВИТЬ' : 'СОХРАНИТЬ',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: AppColors.grey,
        ),
      );
}
