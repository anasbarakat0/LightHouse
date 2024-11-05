import 'package:flutter/material.dart';
import 'package:lighthouse_/common/widget/header.dart';

class EmptyWidget extends StatefulWidget {
  const EmptyWidget({super.key});

  @override
  State<EmptyWidget> createState() => _EmptyWidgetState();
}

class _EmptyWidgetState extends State<EmptyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 18),
        HeaderWidget(),
        SizedBox(height: 18),
      ],
    );
  }
}
