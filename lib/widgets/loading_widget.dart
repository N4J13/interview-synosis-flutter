import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoadingWidget extends StatelessWidget {
  bool loading;
  Widget child;
  LoadingWidget({super.key, required this.loading, required this.child});

  @override
  Widget build(BuildContext context) {
    return loading ? const Center(child: CircularProgressIndicator()) : child;
  }
}
