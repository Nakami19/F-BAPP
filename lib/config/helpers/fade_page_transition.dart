import 'package:flutter/material.dart';

class FadePageTransition<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  FadePageTransition({required this.builder})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return builder(context);
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              // opacity: animation,
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves
                      .easeInOut, // Personaliza la curva de animación aquí
                ),
              ),
              child: child,
            );
          },
        );
}