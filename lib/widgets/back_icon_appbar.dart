import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BackIconAppbar extends StatelessWidget {
  final Color? iconColor;
  const BackIconAppbar({Key? key, this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        FontAwesomeIcons.chevronLeft,
        color: iconColor ?? Theme.of(context).textTheme.displayLarge!.color,
        size: 18,
      ),
    );
  }
}

class CloseIconAppbar extends StatelessWidget {
  const CloseIconAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        FontAwesomeIcons.close,
        color: Theme.of(context).textTheme.displayLarge!.color,
      ),
    );
  }
}

class MenuIconAppbar extends StatelessWidget {
  const MenuIconAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        FontAwesomeIcons.ellipsis,
        color: Theme.of(context).textTheme.displayLarge!.color,
      ),
    );
  }
}