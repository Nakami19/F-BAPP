import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  @override
  Widget build(BuildContext context) {
    final utilsProvider = context.read<UtilsProvider>();

    String userName = '${utilsProvider.personName} ${utilsProvider.personLastName}';
    
    final textStyle = Theme.of(context).textTheme.labelLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.account_circle,
            color: primaryColor,
            size: 40,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            '${userName}\n@${utilsProvider.userName}',
            style: textStyle!.copyWith(
              fontWeight: FontWeight.w700
            ),
          ),
        ],
      ),
    );
  }
}
