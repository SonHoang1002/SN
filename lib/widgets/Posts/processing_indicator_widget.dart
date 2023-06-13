import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class CustomLinearProgressIndicator extends StatefulWidget {
  const CustomLinearProgressIndicator({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomLinearProgressIndicatorState createState() =>
      _CustomLinearProgressIndicatorState();
}

class _CustomLinearProgressIndicatorState
    extends State<CustomLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _colorAnimation = _animationController.drive(
      ColorTween(
        begin: Colors.grey,
        end: secondaryColor,
      ),
    );
    _animationController.addListener(() {
      if (_animationController.value >= 0.8) {
        _animationController.stop();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return LinearProgressIndicator(
          value: _animationController.value,
          minHeight: 5,
          backgroundColor: Colors.grey,
          valueColor: _colorAnimation,
        );
      },
    );
  }
}
