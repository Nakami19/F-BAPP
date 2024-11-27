import 'dart:io';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/infrastructure/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("HOLAAAAAAAAAAAAAA"),
      ),
    );
  }
}