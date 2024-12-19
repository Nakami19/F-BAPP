import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/custom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    super.key,
    required this.selectedIndex,
    required this.child,
  });

  final int selectedIndex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    return Scaffold(
      body: child,
      bottomNavigationBar:navProvider.showNavBar? Customnavbar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          navProvider.updateIndex(index);
        },
      ) : null
    );
  }
  }

