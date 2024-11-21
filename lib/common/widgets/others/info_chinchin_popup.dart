import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../presentation/providers/shared/theme_provider.dart';
import '../../assets/theme/app_theme.dart';


class InfoChinchinPopup extends StatelessWidget {
  const InfoChinchinPopup({
    super.key,
    // required this.themeProvider,
  });

  // final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return IconButton(
      color: themeProvider.isDarkModeEnabled
          ? primaryScaffoldColor
          : const Color(0xFF35445F),
      iconSize: 20,
      onPressed: () => (),
      icon: const Icon(
        Icons.info_outline,
      ),
    );
  }
}