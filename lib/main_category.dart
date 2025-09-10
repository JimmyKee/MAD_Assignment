// lib/category_page.dart
import 'package:flutter/material.dart';
import 'package:assignment/navigation_bar.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int _index = 0;

  final List<_CategoryItem> _categories = const [
    _CategoryItem('Automotive', 'assets/images/automotive.jpeg', imageOnRight: true),
    _CategoryItem('Heavy Machine', 'assets/images/heavy_machine.jpeg', imageOnRight: false, textAlignRight: true),
    _CategoryItem('General Repair Businesses', 'assets/images/general_repair.jpeg', imageOnRight: true),
  ];

  static const _topBar = Color(0xFFEAF2FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Inventory'),
        backgroundColor: _topBar,
        surfaceTintColor: _topBar,
        elevation: 0,
      ),
      body: _index == 0
          ? Center( // centers content vertically and horizontally
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _categories.length; i++) ...[
                  _CategoryCard(item: _categories[i]),
                  const SizedBox(height: 32), // more space between cards
                ]
              ],
            ),
          ),
        ),
      )
          : Center(
        child: Text(
          _index == 1 ? 'Request (coming soon)' : 'Request List (coming soon)',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _CategoryItem {
  final String title;
  final String imagePath;
  final bool imageOnRight;
  final bool textAlignRight;
  const _CategoryItem(
      this.title,
      this.imagePath, {
        this.imageOnRight = true,
        this.textAlignRight = false,
      });
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.item, this.onTap});
  final _CategoryItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final img = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 80, // bigger image
        height: 80,
        child: Image.asset(
          item.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFFE3E6ED),
            child: const Icon(Icons.image_not_supported_rounded, color: Colors.grey),
          ),
        ),
      ),
    );

    final title = Expanded(
      child: Text(
        item.title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        textAlign: item.textAlignRight ? TextAlign.right : TextAlign.left,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      ),
    );

    final rowChildren = item.imageOnRight
        ? [title, const SizedBox(width: 16), img]
        : [img, const SizedBox(width: 16), title];

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap ??
              () {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Open "${item.title}"')));
          },
      child: Container(
        height: 130, // bigger card height
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
          border: Border.all(color: const Color(0x14000000)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: rowChildren,
        ),
      ),
    );
  }
}
