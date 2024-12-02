import 'package:f_bapp/presentation/providers/shared/home_provider.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:f_bapp/presentation/providers/user/privileges_provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'auth/login_provider.dart';
import '../../common/providers/general_provider.dart';
import 'shared/session_provider.dart';


class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => SessionProvider()),
    ChangeNotifierProvider(create: (_) => GeneralProvider()),
    ChangeNotifierProvider(create: (_) => LoginProvider()),
    ChangeNotifierProvider(create: (_) => PrivilegesProvider()),
    ChangeNotifierProvider(create: (_) => UtilsProvider()),
    ChangeNotifierProvider(create: (_) => HomeProvider())
  ];

  static List<GeneralProvider> getDisposableProviders(BuildContext context) {
    return [
      context.read<GeneralProvider>(),
      context.read<LoginProvider>(),
    ];
  }

  static void disposeAllProviders(BuildContext context) {
    getDisposableProviders(context).forEach((disposableProvider) {
      disposableProvider
        ..disposeValues()
        ..resetValues();
    });
  }
}