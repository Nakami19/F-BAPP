import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SmallCard extends StatefulWidget {
  const SmallCard({
    super.key,
    required this.image,
    required this.title,
    required this.height,
    required this.width,
    this.imageHeight
    });
  final String image;
  final String title;
  final double height;
  final double width;
  final double? imageHeight;

  @override
  State<SmallCard> createState() => _SmallCardState();
}

class _SmallCardState extends State<SmallCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      padding: EdgeInsets.all(13),
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(BorderRadiusValue),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 3,
          blurRadius: 5,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          widget.image,
          height: widget.imageHeight!,
          color: primaryColor,
          ),
        Text(widget.title)
      ],
    ),
    );
  }
}