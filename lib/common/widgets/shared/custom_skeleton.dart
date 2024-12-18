import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CustomSkeleton extends StatelessWidget {
  final double height;
  final double? width;

  const CustomSkeleton({
    super.key,
    required this.height,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();

    return Shimmer.fromColors(
      baseColor: themeProvider.isDarkModeEnabled
          ? containerColor
          : containerColor.withOpacity(0.20),
      highlightColor: containerColor.withOpacity(0.30),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadiusValue)),
          height: height,
          width: width?? double.infinity),
    );
  }
}