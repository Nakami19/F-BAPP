import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:flutter/material.dart';

class SimpleErrorBox extends StatelessWidget {
  final GeneralProvider provider;
    final double paddingH;


  const SimpleErrorBox({
    super.key,
    required this.provider,
    this.paddingH=10,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: paddingH),
      child: ListTile(
        tileColor: Colors.red[50],
        leading: Icon(
          Icons.info,
          color: Colors.red[700],
        ),
        title: Text(
          provider.errorMessage!,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}