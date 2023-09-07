import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/skeleton.dart';

Decoration myBoxDec(animation, {isCircle = false}) {
  return BoxDecoration(
    shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
    borderRadius: isCircle ? null : const BorderRadius.all(Radius.circular(15)),
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: const [
        Color(0xfff6f7f9),
        Color(0xffe9ebee),
        Color(0xfff6f7f9),
        // Color(0xfff6f7f9),
      ],
      stops: [
        // animation.value * 0.1,
        animation.value - 1,
        animation.value,
        animation.value + 1,
        // animation.value + 5,
        // 1.0,
      ],
    ),
  );
}

class CardSkeleton extends StatefulWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;
  final bool isPaddingActive;
  const CardSkeleton(
      {super.key,
      this.isCircularImage = true,
      this.isBottomLinesActive = true,
      this.isPaddingActive = true});
  @override
  // ignore: library_private_types_in_public_api
  _CardSkeletonState createState() => _CardSkeletonState();
}

class _CardSkeletonState extends State<CardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: widget.isPaddingActive
              ? const EdgeInsets.symmetric(vertical: 16.0)
              : const EdgeInsets.all(0),
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: width * 0.13,
                      width: width * 0.13,
                      decoration:
                          myBoxDec(animation, isCircle: widget.isCircularImage),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      height: width * 0.13,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: height * 0.008,
                            width: width * 0.3,
                            decoration: myBoxDec(animation),
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.2,
                            decoration: myBoxDec(animation),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                widget.isBottomLinesActive
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.7,
                            decoration: myBoxDec(animation),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.8,
                            decoration: myBoxDec(animation),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.5,
                            decoration: myBoxDec(animation),
                          ),
                        ],
                      )
                    : const Offstage()
              ],
            ),
          ),
        );
      },
    );
  }
}

Decoration myDarkBoxDec(animation, {isCircle = false}) {
  return BoxDecoration(
    shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
    borderRadius: isCircle ? null : const BorderRadius.all(Radius.circular(15)),
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.grey[700]!,
        Colors.grey[600]!,
        Colors.grey[700]!,
        // Color(0xfff6f7f9),
      ],
      stops: [
        // animation.value * 0.1,
        animation.value - 1,
        animation.value,
        animation.value + 1,
        // animation.value + 5,
        // 1.0,
      ],
    ),
  );
}

class DarkCardSkeleton extends StatefulWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;
  final bool isPaddingActive;
  const DarkCardSkeleton(
      {super.key,
      this.isCircularImage = true,
      this.isBottomLinesActive = true,
      this.isPaddingActive = true});
  @override
  _DarkCardSkeletonState createState() => _DarkCardSkeletonState();
}

class _DarkCardSkeletonState extends State<DarkCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: widget.isPaddingActive
              ? const EdgeInsets.symmetric(vertical: 16.0)
              : const EdgeInsets.all(0),
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: width * 0.13,
                      width: width * 0.13,
                      decoration: myDarkBoxDec(animation,
                          isCircle: widget.isCircularImage),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      height: width * 0.13,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: height * 0.008,
                            width: width * 0.3,
                            decoration: myDarkBoxDec(animation),
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.2,
                            decoration: myDarkBoxDec(animation),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                widget.isBottomLinesActive
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.7,
                            decoration: myDarkBoxDec(animation),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.8,
                            decoration: myDarkBoxDec(animation),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.5,
                            decoration: myDarkBoxDec(animation),
                          ),
                        ],
                      )
                    : const Offstage()
              ],
            ),
          ),
        );
      },
    );
  }
}

class CardListSkeleton extends StatelessWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;
  final int length;
  const CardListSkeleton({
    super.key,
    this.isCircularImage = true,
    this.length = 10,
    this.isBottomLinesActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: length,
      itemBuilder: (BuildContext context, int index) {
        return CardSkeleton(
          isCircularImage: isCircularImage,
          isBottomLinesActive: isBottomLinesActive,
        );
      },
    );
  }
}

class DarkCardListSkeleton extends StatelessWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;
  final int length;
  const DarkCardListSkeleton({
    super.key,
    this.isCircularImage = true,
    this.length = 10,
    this.isBottomLinesActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: length,
      itemBuilder: (BuildContext context, int index) {
        return DarkCardSkeleton(
          isCircularImage: isCircularImage,
          isBottomLinesActive: isBottomLinesActive,
        );
      },
    );
  }
}

class CardProfileSkeleton extends StatefulWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;
  const CardProfileSkeleton(
      {super.key,
      this.isCircularImage = true,
      this.isBottomLinesActive = true});
  @override
  _CardProfileSkeletonState createState() => _CardProfileSkeletonState();
}

class _CardProfileSkeletonState extends State<CardProfileSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: width * 0.25,
                  width: width * 0.25,
                  decoration:
                      myBoxDec(animation, isCircle: widget.isCircularImage),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (i) => Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: width * 0.13,
                            width: width * 0.13,
                            decoration: myBoxDec(animation,
                                isCircle: widget.isCircularImage),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            height: width * 0.13,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: height * 0.008,
                                  width: width * 0.3,
                                  decoration: myBoxDec(animation),
                                ),
                                Container(
                                  height: height * 0.007,
                                  width: width * 0.2,
                                  decoration: myBoxDec(animation),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ).toList(),
                  ),
                ),
                widget.isBottomLinesActive
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.7,
                            decoration: myBoxDec(animation),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.8,
                            decoration: myBoxDec(animation),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.5,
                            decoration: myBoxDec(animation),
                          ),
                        ],
                      )
                    : const Offstage()
              ],
            ),
          ),
        );
      },
    );
  }
}

class DarkCardProfileSkeleton extends StatefulWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;
  const DarkCardProfileSkeleton(
      {super.key,
      this.isCircularImage = true,
      this.isBottomLinesActive = true});
  @override
  _DarkCardProfileSkeletonState createState() =>
      _DarkCardProfileSkeletonState();
}

class _DarkCardProfileSkeletonState extends State<DarkCardProfileSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: Colors.grey[800],
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: width * 0.25,
                  width: width * 0.25,
                  decoration:
                      myDarkBoxDec(animation, isCircle: widget.isCircularImage),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (i) => Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: width * 0.13,
                            width: width * 0.13,
                            decoration: myDarkBoxDec(animation,
                                isCircle: widget.isCircularImage),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            height: width * 0.13,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: height * 0.008,
                                  width: width * 0.3,
                                  decoration: myDarkBoxDec(animation),
                                ),
                                Container(
                                  height: height * 0.007,
                                  width: width * 0.2,
                                  decoration: myDarkBoxDec(animation),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ).toList(),
                  ),
                ),
                widget.isBottomLinesActive
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.7,
                            decoration: myDarkBoxDec(animation),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.8,
                            decoration: myDarkBoxDec(animation),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.5,
                            decoration: myDarkBoxDec(animation),
                          ),
                        ],
                      )
                    : const Offstage()
              ],
            ),
          ),
        );
      },
    );
  }
}

class CardPageSkeleton extends StatefulWidget {
  final int totalLines;
  const CardPageSkeleton({super.key, this.totalLines = 5});
  @override
  _CardPageSkeletonState createState() => _CardPageSkeletonState();
}

class _CardPageSkeletonState extends State<CardPageSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                    widget.totalLines,
                    (i) => Column(
                          children: <Widget>[
                            Container(
                              height: height * 0.007,
                              width: width * 0.7,
                              decoration: myBoxDec(animation),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: height * 0.007,
                              width: width * 0.8,
                              decoration: myBoxDec(animation),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: height * 0.007,
                              width: width * 0.5,
                              decoration: myBoxDec(animation),
                            ),
                          ],
                        )).toList(),
              )),
        );
      },
    );
  }
}

class DarkCardPageSkeleton extends StatefulWidget {
  final int totalLines;
  const DarkCardPageSkeleton({super.key, this.totalLines = 5});
  @override
  _DarkCardPageSkeletonState createState() => _DarkCardPageSkeletonState();
}

class _DarkCardPageSkeletonState extends State<DarkCardPageSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                    widget.totalLines,
                    (i) => Column(
                          children: <Widget>[
                            Container(
                              height: height * 0.007,
                              width: width * 0.7,
                              decoration: myDarkBoxDec(animation),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: height * 0.007,
                              width: width * 0.8,
                              decoration: myDarkBoxDec(animation),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: height * 0.007,
                              width: width * 0.5,
                              decoration: myDarkBoxDec(animation),
                            ),
                          ],
                        )).toList(),
              )),
        );
      },
    );
  }
}

class DarkCardSkeletonInList extends StatefulWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;
  const DarkCardSkeletonInList(
      {super.key,
      this.isCircularImage = true,
      this.isBottomLinesActive = true});
  @override
  _DarkCardSkeletonInListState createState() => _DarkCardSkeletonInListState();
}

class _DarkCardSkeletonInListState extends State<DarkCardSkeletonInList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: width * 0.10,
                    width: width * 0.10,
                    decoration: myDarkBoxDec(animation,
                        isCircle: widget.isCircularImage),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: width * 0.13,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: height * 0.008,
                          width: width * 0.3,
                          decoration: myDarkBoxDec(animation),
                        ),
                        Container(
                          height: height * 0.007,
                          width: width * 0.2,
                          decoration: myDarkBoxDec(animation),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              widget.isBottomLinesActive
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: height * 0.007,
                          width: width * 0.7,
                          decoration: myDarkBoxDec(animation),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: height * 0.007,
                          width: width * 0.8,
                          decoration: myDarkBoxDec(animation),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: height * 0.007,
                          width: width * 0.5,
                          decoration: myDarkBoxDec(animation),
                        ),
                      ],
                    )
                  : const Offstage()
            ],
          ),
        );
      },
    );
  }
}

class CardSkeletonInList extends StatefulWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;
  const CardSkeletonInList(
      {super.key,
      this.isCircularImage = true,
      this.isBottomLinesActive = true});
  @override
  // ignore: library_private_types_in_public_api
  _CardSkeletonInListState createState() => _CardSkeletonInListState();
}

class _CardSkeletonInListState extends State<CardSkeletonInList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: width * 0.10,
                    width: width * 0.10,
                    decoration:
                        myBoxDec(animation, isCircle: widget.isCircularImage),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: width * 0.13,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: height * 0.008,
                          width: width * 0.3,
                          decoration: myBoxDec(animation),
                        ),
                        Container(
                          height: height * 0.007,
                          width: width * 0.2,
                          decoration: myBoxDec(animation),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              widget.isBottomLinesActive
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: height * 0.007,
                          width: width * 0.7,
                          decoration: myBoxDec(animation),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: height * 0.007,
                          width: width * 0.8,
                          decoration: myBoxDec(animation),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: height * 0.007,
                          width: width * 0.5,
                          decoration: myBoxDec(animation),
                        ),
                      ],
                    )
                  : const Offstage()
            ],
          ),
        );
      },
    );
  }
}

class EventSkeleton extends StatefulWidget {
  final bool isBottomLinesActive;
  final bool isPaddingActive;
  const EventSkeleton(
      {super.key,
      this.isBottomLinesActive = true,
      this.isPaddingActive = true});
  @override
  // ignore: library_private_types_in_public_api
  _EventSkeletonState createState() => _EventSkeletonState();
}

class _EventSkeletonState extends State<EventSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: widget.isPaddingActive
              ? const EdgeInsets.symmetric(vertical: 16.0)
              : const EdgeInsets.all(0),
          child: Container(
            width: width * 1,
            height: height * 0.395,
            color: Colors.transparent,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: height * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: height * 0.28,
                        width: width * 0.9,
                        decoration: myBoxDec(animation),
                      ),
                    ],
                  ),
                ),
                widget.isBottomLinesActive
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: height * 0.01,
                            width: width * 0.5,
                            decoration: myBoxDec(animation),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.01,
                            width: width * 0.3,
                            decoration: myBoxDec(animation),
                          ),
                        ],
                      )
                    : const Offstage()
              ],
            ),
          ),
        );
      },
    );
  }
}

class DarkEventSkeleton extends StatefulWidget {
  final bool isBottomLinesActive;
  final bool isPaddingActive;
  const DarkEventSkeleton(
      {super.key,
      this.isBottomLinesActive = true,
      this.isPaddingActive = true});
  @override
  // ignore: library_private_types_in_public_api
  _DarkEventSkeletonState createState() => _DarkEventSkeletonState();
}

class _DarkEventSkeletonState extends State<DarkEventSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: widget.isPaddingActive
              ? const EdgeInsets.symmetric(vertical: 16.0)
              : const EdgeInsets.all(0),
          child: Container(
            width: width * 1,
            height: height * 0.395,
            color: Colors.transparent,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: height * 0.3,
                  child: Container(
                    height: height * 0.28,
                    width: width * 0.9,
                    decoration: myDarkBoxDec(animation),
                  ),
                ),
                widget.isBottomLinesActive
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: height * 0.01,
                            width: width * 0.5,
                            decoration: myDarkBoxDec(animation),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.01,
                            width: width * 0.3,
                            decoration: myDarkBoxDec(animation),
                          ),
                        ],
                      )
                    : const Offstage()
              ],
            ),
          ),
        );
      },
    );
  }
}

class GrowSkeleton extends StatefulWidget {
  final bool isBottomLinesActive;
  final bool isPaddingActive;
  const GrowSkeleton(
      {super.key,
      this.isBottomLinesActive = true,
      this.isPaddingActive = true});
  @override
  // ignore: library_private_types_in_public_api
  _GrowSkeletonState createState() => _GrowSkeletonState();
}

class _GrowSkeletonState extends State<GrowSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: widget.isPaddingActive
              ? const EdgeInsets.symmetric(vertical: 16.0)
              : const EdgeInsets.all(0),
          child: Container(
            width: width * 1,
            height: height * 0.45,
            color: Colors.transparent,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: height * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: height * 0.28,
                        width: width * 0.9,
                        decoration: myBoxDec(animation),
                      ),
                    ],
                  ),
                ),
                widget.isBottomLinesActive
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: height * 0.01,
                            width: width * 0.5,
                            decoration: myBoxDec(animation),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.01,
                            width: width * 0.3,
                            decoration: myBoxDec(animation),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.015,
                            width: width * 0.85,
                            decoration: myBoxDec(animation),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.5,
                            decoration: myBoxDec(animation),
                          ),
                        ],
                      )
                    : const Offstage()
              ],
            ),
          ),
        );
      },
    );
  }
}

class DarkGrowSkeleton extends StatefulWidget {
  final bool isBottomLinesActive;
  final bool isPaddingActive;
  const DarkGrowSkeleton(
      {super.key,
      this.isBottomLinesActive = true,
      this.isPaddingActive = true});
  @override
  // ignore: library_private_types_in_public_api
  _DarkGrowSkeletonState createState() => _DarkGrowSkeletonState();
}

class _DarkGrowSkeletonState extends State<DarkGrowSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: widget.isPaddingActive
              ? const EdgeInsets.symmetric(vertical: 16.0)
              : const EdgeInsets.all(0),
          child: Container(
            width: width * 1,
            height: height * 0.45,
            color: Colors.transparent,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: height * 0.3,
                  child: Container(
                    height: height * 0.28,
                    width: width * 0.9,
                    decoration: myDarkBoxDec(animation),
                  ),
                ),
                widget.isBottomLinesActive
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: height * 0.01,
                            width: width * 0.5,
                            decoration: myDarkBoxDec(animation),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.01,
                            width: width * 0.3,
                            decoration: myDarkBoxDec(animation),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.015,
                            width: width * 0.85,
                            decoration: myDarkBoxDec(animation),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.5,
                            decoration: myDarkBoxDec(animation),
                          ),
                        ],
                      )
                    : const Offstage()
              ],
            ),
          ),
        );
      },
    );
  }
}

class UserInformationSkeleton extends StatefulWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;
  final bool isPaddingActive;
  const UserInformationSkeleton(
      {super.key,
      this.isCircularImage = true,
      this.isBottomLinesActive = true,
      this.isPaddingActive = true});
  @override
  // ignore: library_private_types_in_public_api
  _UserInformationSkeletonState createState() =>
      _UserInformationSkeletonState();
}

class _UserInformationSkeletonState extends State<UserInformationSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: widget.isPaddingActive
              ? const EdgeInsets.symmetric(vertical: 5.0)
              : const EdgeInsets.all(0),
          child: Container(
            width: width * 1,
            height: height * 0.24,
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                widget.isBottomLinesActive
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Container(
                                height: width * 0.07,
                                width: width * 0.07,
                                decoration: myBoxDec(animation,
                                    isCircle: widget.isCircularImage),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                height: height * 0.01,
                                width: width * 0.5,
                                decoration: myBoxDec(animation),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                height: width * 0.07,
                                width: width * 0.07,
                                decoration: myBoxDec(animation,
                                    isCircle: widget.isCircularImage),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                height: height * 0.01,
                                width: width * 0.3,
                                decoration: myBoxDec(animation),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                height: width * 0.07,
                                width: width * 0.07,
                                decoration: myBoxDec(animation,
                                    isCircle: widget.isCircularImage),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                height: height * 0.01,
                                width: width * 0.7,
                                decoration: myBoxDec(animation),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                height: width * 0.07,
                                width: width * 0.07,
                                decoration: myBoxDec(animation,
                                    isCircle: widget.isCircularImage),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                height: height * 0.01,
                                width: width * 0.5,
                                decoration: myBoxDec(animation),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                height: width * 0.07,
                                width: width * 0.07,
                                decoration: myBoxDec(animation,
                                    isCircle: widget.isCircularImage),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                height: height * 0.01,
                                width: width * 0.6,
                                decoration: myBoxDec(animation),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const Offstage()
              ],
            ),
          ),
        );
      },
    );
  }
}

class DarkUserInformationSkeleton extends StatefulWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;
  final bool isPaddingActive;
  const DarkUserInformationSkeleton(
      {super.key,
      this.isCircularImage = true,
      this.isBottomLinesActive = true,
      this.isPaddingActive = true});
  @override
  // ignore: library_private_types_in_public_api
  _DarkUserInformationSkeletonState createState() =>
      _DarkUserInformationSkeletonState();
}

class _DarkUserInformationSkeletonState
    extends State<DarkUserInformationSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: widget.isPaddingActive
              ? const EdgeInsets.symmetric(vertical: 5.0)
              : const EdgeInsets.all(0),
          child: Container(
            width: width * 1,
            height: height * 0.24,
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                widget.isBottomLinesActive
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Container(
                                height: width * 0.07,
                                width: width * 0.07,
                                decoration: myDarkBoxDec(animation,
                                    isCircle: widget.isCircularImage),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                height: height * 0.01,
                                width: width * 0.5,
                                decoration: myDarkBoxDec(animation),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                height: width * 0.07,
                                width: width * 0.07,
                                decoration: myDarkBoxDec(animation,
                                    isCircle: widget.isCircularImage),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                height: height * 0.01,
                                width: width * 0.3,
                                decoration: myDarkBoxDec(animation),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                height: width * 0.07,
                                width: width * 0.07,
                                decoration: myDarkBoxDec(animation,
                                    isCircle: widget.isCircularImage),
                              ),
                              SizedBox(width: 10),
                              Container(
                                height: height * 0.01,
                                width: width * 0.7,
                                decoration: myDarkBoxDec(animation),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                height: width * 0.07,
                                width: width * 0.07,
                                decoration: myDarkBoxDec(animation,
                                    isCircle: widget.isCircularImage),
                              ),
                              SizedBox(width: 10),
                              Container(
                                height: height * 0.01,
                                width: width * 0.5,
                                decoration: myDarkBoxDec(animation),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                height: width * 0.07,
                                width: width * 0.07,
                                decoration: myDarkBoxDec(animation,
                                    isCircle: widget.isCircularImage),
                              ),
                              SizedBox(width: 10),
                              Container(
                                height: height * 0.01,
                                width: width * 0.6,
                                decoration: myDarkBoxDec(animation),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const Offstage()
              ],
            ),
          ),
        );
      },
    );
  }
}

class UserFriendSkeleton extends StatefulWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;
  final bool isPaddingActive;
  const UserFriendSkeleton(
      {super.key,
      this.isCircularImage = true,
      this.isBottomLinesActive = true,
      this.isPaddingActive = true});
  @override
  // ignore: library_private_types_in_public_api
  _UserFriendSkeletonState createState() => _UserFriendSkeletonState();
}

class _UserFriendSkeletonState extends State<UserFriendSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: widget.isPaddingActive
              ? const EdgeInsets.symmetric(vertical: 5.0)
              : const EdgeInsets.all(0),
          child: Container(
            width: width * 1,
            height: height * 0.17,
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Container(
                child: widget.isBottomLinesActive
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Số cột trong mỗi hàng
                        ),
                        itemCount: 3, // Tổng số ảnh
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 7,
                              ),
                              Container(
                                height: height * 0.20,
                                width: width * 0.27,
                                decoration: myBoxDec(animation),
                              ),
                            ],
                          );
                        },
                      )
                    : const Offstage()),
          ),
        );
      },
    );
  }
}

class DarkUserFriendSkeleton extends StatefulWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;
  final bool isPaddingActive;
  const DarkUserFriendSkeleton(
      {super.key,
      this.isCircularImage = true,
      this.isBottomLinesActive = true,
      this.isPaddingActive = true});
  @override
  // ignore: library_private_types_in_public_api
  _DarkUserFriendSkeletonState createState() => _DarkUserFriendSkeletonState();
}

class _DarkUserFriendSkeletonState extends State<DarkUserFriendSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: widget.isPaddingActive
              ? const EdgeInsets.symmetric(vertical: 5.0)
              : const EdgeInsets.all(0),
          child: Container(
            width: width * 1,
            height: height * 0.17,
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Container(
                child: widget.isBottomLinesActive
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Số cột trong mỗi hàng
                        ),
                        itemCount: 3, // Tổng số ảnh
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 7,
                              ),
                              Container(
                                height: height * 0.20,
                                width: width * 0.27,
                                decoration: myDarkBoxDec(animation),
                              ),
                            ],
                          );
                        },
                      )
                    : const Offstage()),
          ),
        );
      },
    );
  }
}

class GroupSkeleton extends StatefulWidget {
  final bool isBottomLinesActive;
  const GroupSkeleton({
    super.key,
    this.isBottomLinesActive = true,
  });
  @override
  // ignore: library_private_types_in_public_api
  _GroupSkeletonState createState() => _GroupSkeletonState();
}

class _GroupSkeletonState extends State<GroupSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: height * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: height * 0.25,
                      width: width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: const [
                            Color(0xfff6f7f9),
                            Color(0xffe9ebee),
                            Color(0xfff6f7f9),
                            // Color(0xfff6f7f9),
                          ],
                          stops: [
                            // animation.value * 0.1,
                            animation.value - 1,
                            animation.value,
                            animation.value + 1,
                            // animation.value + 5,
                            // 1.0,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              widget.isBottomLinesActive
                  ? Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: height * 0.02,
                                width: width * 0.5,
                                decoration: myBoxDec(animation),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: height * 0.01,
                                width: width * 0.3,
                                decoration: myBoxDec(animation),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                        const CrossBar(
                          height: 5,
                        ),
                        SkeletonCustom().postSkeleton(context),
                      ],
                    )
                  : const Offstage()
            ],
          ),
        );
      },
    );
  }
}

class DarkGroupSkeleton extends StatefulWidget {
  final bool isBottomLinesActive;
  final bool isPaddingActive;
  const DarkGroupSkeleton(
      {super.key,
      this.isBottomLinesActive = true,
      this.isPaddingActive = true});
  @override
  // ignore: library_private_types_in_public_api
  _DarkGroupSkeletonState createState() => _DarkGroupSkeletonState();
}

class _DarkGroupSkeletonState extends State<DarkGroupSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: width * 1,
          //height: height * 0.395,
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: height * 0.3,
                child: Container(
                  height: height * 0.25,
                  width: width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.grey[700]!,
                        Colors.grey[600]!,
                        Colors.grey[700]!,
                      ],
                      stops: [
                        // animation.value * 0.1,
                        animation.value - 1,
                        animation.value,
                        animation.value + 1,
                        // animation.value + 5,
                        // 1.0,
                      ],
                    ),
                  ),
                ),
              ),
              widget.isBottomLinesActive
                  ? Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: height * 0.02,
                                width: width * 0.5,
                                decoration: myDarkBoxDec(animation),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: height * 0.01,
                                width: width * 0.3,
                                decoration: myDarkBoxDec(animation),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                        const CrossBar(
                          height: 5,
                        ),
                        SkeletonCustom().postSkeleton(context),
                      ],
                    )
                  : const Offstage()
            ],
          ),
        );
      },
    );
  }
}
