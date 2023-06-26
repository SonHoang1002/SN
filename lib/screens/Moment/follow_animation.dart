import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class AddToTickAnimation extends StatefulWidget {
  final Function? additionalFunction;
  const AddToTickAnimation({super.key, this.additionalFunction});
  @override
  // ignore: library_private_types_in_public_api
  _AddToTickAnimationState createState() => _AddToTickAnimationState();
}

class _AddToTickAnimationState extends State<AddToTickAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  IconData _currentIcon = FontAwesomeIcons.plus;
  bool _isTicked = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleIcon() {
    widget.additionalFunction != null ? widget.additionalFunction!() : null;
    setState(() {
      if (_isTicked) {
        _currentIcon = FontAwesomeIcons.add;
      } else {
        _currentIcon = FontAwesomeIcons.check;
      }
      _isTicked = !_isTicked;
    });

    if (_isTicked) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleIcon,
      child: Container(
        height: 20,
        width: 20,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: secondaryColor,
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _animation.value <= 0.9
                ? AnimatedIcon(
                    icon: AnimatedIcons.add_event,
                    progress: _animation,
                    size: 15,
                    color: Colors.white,
                  )
                : const SizedBox(),
            Opacity(
              opacity: _animation.value,
              child: const Icon(
                FontAwesomeIcons.check,
                size: 15,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
