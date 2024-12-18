import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/common/widgets/shared/simple_error_box.dart';
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
    return 
    provider.haveSimpleError && !provider.haveInputErrors ? 
    Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: paddingH),
            child: ListTile(
              tileColor: Colors.red[50],
              leading: Icon(
                Icons.info,
                color: Colors.red[700],
              ),
              
              title: Text(
                provider.errorMessage??"",
                style: const TextStyle(
                  color: Colors.black,

                ),
              ),
              
              subtitle: provider.trackingCode!="" ? Text(
                provider.trackingCode??"Hola",
                style: const TextStyle(
                  color: Colors.black,
                ),
              ) : null
            ),
          )
        // : provider.haveSimpleError && !provider.haveInputErrors
        //     ? SimpleErrorBox(
        //         provider: provider,
        //         paddingH: paddingH,
        //       )
            : const SizedBox();
  }
}
