import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Customappbar extends StatefulWidget {
  const Customappbar({
    super.key,
    required this.screenkey
    });

  final screenkey;

  @override
  State<Customappbar> createState() => _CustomappbarState();
}

class _CustomappbarState extends State<Customappbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: Stack(
        children: [
          // Imagen de fondo
          Image.asset(
            '${DataConstant.images}/background.png',
            // fit: BoxFit.cover,
          ),
          Positioned(
      left: 0,
      right: 0,
      top: 50, 
      child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16), // Separación lateral
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(
          '${DataConstant.images_chinchin}/chinchin-logo-business-base.svg',
          height: 40, 
          fit: BoxFit.contain,
        ),
        IconButton(
          tooltip: 'Menú',
          icon: Icon(
            Icons.menu, color: Colors.black,
            size: 30,
            ),
          onPressed: () {
            widget.screenkey.currentState!.openDrawer();            
          },
        ),
      ],
    ),
      ),
    ),
        ],
      ),
    );
  }
}