import 'package:flutter/material.dart';

class PromoSlider extends StatelessWidget {
  final List<String> images;

  PromoSlider({required this.images});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(images[index], fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}
