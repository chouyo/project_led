import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'data/constants.dart';

class NotFound extends StatefulWidget {
  const NotFound({super.key});

  @override
  State<NotFound> createState() => _NotFoundState();
}

class _NotFoundState extends State<NotFound> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(getRandomLottieAsset(), fit: BoxFit.cover),
    );
  }
}
