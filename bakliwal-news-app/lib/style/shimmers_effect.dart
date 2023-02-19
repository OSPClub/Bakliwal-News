import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerEffect extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  CustomShimmerEffect.rectangular(
      {super.key, this.width = double.infinity, required this.height})
      // ignore: unnecessary_this
      : this.shapeBorder = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        );

  const CustomShimmerEffect.circular(
      {super.key,
      this.width = double.infinity,
      required this.height,
      this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.white70,
        period: const Duration(seconds: 1),
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: Colors.grey[400]!,
            shape: shapeBorder,
          ),
        ),
      );
}
