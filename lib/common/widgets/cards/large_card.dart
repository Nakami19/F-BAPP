import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LargeCard extends StatefulWidget {
  const LargeCard(
      {super.key,
      required this.image,
      required this.title,
      required this.placeholder,
      this.height,
      this.width,
      this.imageHeight,
      this.textStyle,
      this.onTap});

  final String image;
  final String placeholder;
  final String title;
  final double? height;
  final double? width;
  final double? imageHeight;
  final TextStyle? textStyle;
  final VoidCallback? onTap;

  @override
  State<LargeCard> createState() => _LargeCardState();
}

class _LargeCardState extends State<LargeCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap ?? ()=>{},
      child: Container(
        height: widget.height ?? double.infinity,
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
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            widget.image,
            height: widget.imageHeight ?? 70,
            placeholderBuilder: (context) => 
            SvgPicture.asset(
              widget.placeholder,
              height: widget.imageHeight ?? 70,
              ),
            // color: primaryColor,
            ),
          SizedBox(width: 20,),
          Expanded(
            child: Text(
              widget.title,
              style: widget.textStyle,
              // textAlign: TextAlign.center,
              ),
          )
        ],
      ),
      ),
    );
  }
}
