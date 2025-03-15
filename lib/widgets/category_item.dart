import 'package:flutter/material.dart';
import '../data/models/category.dart';

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          // يمكنك هنا استخدام صورة التصنيف إذا وجد
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(category.imageUrl),

          ),
          SizedBox(height: 4),
          Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
