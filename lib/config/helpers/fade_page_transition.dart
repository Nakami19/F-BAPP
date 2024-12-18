import 'package:flutter/material.dart';

//Transición de página personalizada
class FadePageTransition<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  FadePageTransition({required this.builder})
      : super(
        //Constructor donde se define la pantalla destino 
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return builder(context); // regresa el widget a mostrar
          },

          //Define cómo se muestra la transición entre la pantalla actual y la nueva pantalla.
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition( //Efecto de desvanecimiento
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(

                //Aplica una curva a la animación para suavizar inicio y final.
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
              ),
              child: child, //Widget de destino
            );
          },
        );
}