import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SmallCard extends StatefulWidget {
  const SmallCard({
    super.key,
    required this.image,
    required this.title,
    this.placeholder,
    this.height,
    this.width,
    this.imageHeight,
    this.textStyle,
    this.onTap
    });
  final String image;
  final String? placeholder;
  final String title;
  final double? height;
  final double? width;
  final double? imageHeight;
  final TextStyle? textStyle;
  final VoidCallback? onTap;

  @override
  State<SmallCard> createState() => _SmallCardState();
}

class _SmallCardState extends State<SmallCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap ?? ()=>{},
      child: Container(
        // height: widget.height ?? double.infinity,
        width: widget.width ?? double.infinity,
        padding: EdgeInsets.all(13),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BorderRadiusValue),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            widget.image,
            height: widget.imageHeight ?? 50,
            placeholderBuilder: (context) => 
            SvgPicture.asset(
              widget.placeholder??"",
              height: widget.imageHeight ?? 50,
              ),
            // color: primaryColor,
            ),
            SizedBox(height: 5,),
          Text(
            widget.title,
            style: widget.textStyle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            )
        ],
      ),
      ),
    );
  }
}