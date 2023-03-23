import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BackIconAppbar extends StatelessWidget {
  const BackIconAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        FontAwesomeIcons.chevronLeft,
        color: Theme.of(context).textTheme.displayLarge!.color,
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
