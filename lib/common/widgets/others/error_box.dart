import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/common/widgets/others/simple_error_box.dart';
import 'package:flutter/material.dart';

class ErrorBox extends StatelessWidget {
  final GeneralProvider provider;
  final double paddingH;


  const ErrorBox({
    super.key,
    required this.provider,
    this.paddingH=10
  });

  @override
  Widget build(BuildContext context) {
    return provider.haveErrors && !provider.haveInputErrors
        ? Padding(
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
              subtitle: Text(
                provider.trackingCode!,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          )
        : provider.haveSimpleError && !provider.haveInputErrors
            ? SimpleErrorBox(
                provider: provider,
                paddingH: paddingH,
              )
            : const SizedBox();
  }
}
