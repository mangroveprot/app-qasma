import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/button/custom_app_button.dart';
import '../../../../theme/theme_extensions.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
