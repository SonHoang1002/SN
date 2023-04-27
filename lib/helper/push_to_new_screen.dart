import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

pushToNextScreen(BuildContext context, Widget newScreen) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => newScreen));
}

pushAndReplaceToNextScreen(BuildContext context, Widget newScreen) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (_) => newScreen));
}

pushAndReplaceNamedToNextScreen(BuildContext context, String newRouteLink) {
  Navigator.of(context).pushReplacementNamed(newRouteLink);
}

popToPreviousScreen(BuildContext context) {
  Navigator.of(context).pop();
}

pushCustomCupertinoPageRoute(BuildContext context, Widget newScreen,
    {bool opaque = true}) {
  Navigator.push(
    context,
    CustomCupertinoPageRoute(builder: (context) => newScreen,)
  );
}

pushCustomVerticalPageRoute(BuildContext context, Widget newScreen,
    {bool opaque = true}) {
  Navigator.push(
    context,
   
PageRouteBuilder(
      opaque: opaque,
      pageBuilder: (context, animation, secondaryAnimation) => newScreen,
      transitionDuration: const Duration(milliseconds: 200),
      // transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //   var begin = const Offset(0.0, -1.0);
      //   var end = Offset.zero;
      //   var curve = Curves.ease;
      //   var tween =
      //       Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      //   return SlideTransition(
      //     position: animation.drive(tween),
      //     child: child,
      //   );
      // },
    ),

  );
}

class CustomPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  CustomPageRoute({required this.builder});

  @override
  Color? get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final child = builder(context);
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
      child: child,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}



class CustomCupertinoPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  CustomCupertinoPageRoute({
    required this.builder,
  });

  @override
  bool get opaque => false;


  @override
  String get barrierLabel => "";

  @override
  Color? get barrierColor => transparent;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return CupertinoPageTransition(
      primaryRouteAnimation: animation,
      secondaryRouteAnimation: secondaryAnimation,
      linearTransition: true,
      child: builder(context),
    );
  }
 

  @override
  RoutePageBuilder get pageBuilder =>
      (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return CupertinoPageTransition(
          primaryRouteAnimation: animation,
          secondaryRouteAnimation: secondaryAnimation,
          linearTransition: true,
          child: builder(context),
        );
      };
} 