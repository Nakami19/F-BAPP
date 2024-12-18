import 'package:f_bapp/common/data/constants.dart';
import 'package:f_bapp/flavors.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String environment;
  final String version;
  final String buildNumber;
  final connection = Connection.qa;

  const CustomAppbar({
    super.key,
    required this.environment,
    required this.version,
    required this.buildNumber,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: FlavorConfig.flavorValues.bannerColor,
      title: Center(
        child: Text(
          '$environment $version+$buildNumber',
          style: TextStyle(
             color: () {
              if (FlavorConfig.flavorValues.environmentName == 'PRODUCTION') {
                return Colors.transparent;
              } else {
                return Colors.white;
              }
            }(),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}