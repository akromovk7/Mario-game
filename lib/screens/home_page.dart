import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController? marioController;
  AnimationController? cactusController;
  double? jump = 180;

  @override
  void initState() {
    super.initState();

    marioController = AnimationController(
        vsync: this,
        lowerBound: -25,
        upperBound: 80,
        duration: const Duration(milliseconds: 700));

    cactusController = AnimationController(
        vsync: this,
        lowerBound: -60,
        upperBound: 960,
        duration: const Duration(seconds: 8));

    cactusController!.forward();

    cactusController!.addListener(() {
      debugPrint("${marioController!.value}");
      if (cactusController!.value > 440 &&
          cactusController!.value < 470 &&
          marioController!.value >= -25 &&
          marioController!.value < 50) {
        marioController!.stop();
        cactusController!.stop();
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => RotationTransition(turns: const AlwaysStoppedAnimation(90 / 360),
              child: AlertDialog(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: const Text(
                      'Game over',
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Your score: ${marioController!.value}'),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                cactusController!.reset();
                                cactusController!.forward();
                                // marioController!.forward();
                                // marioController!.reset();
                              },
                              child: const Text('Try again'))
                        ],
                      )
                    ],
                  ),
            ));
      }
      setState(() {});
    });

    marioController!.addListener(() {
      // debugPrint('MARIO CANTROLLER >> ${animationController.value.toString()}');
      setState(() {});
    });

    cactusController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        cactusController!.repeat();
      }
      if (cactusController!.value.toInt() == 600) {
        debugPrint('TEGDI');
      }
    });

    marioController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        marioController!.reverse();
      }

      if (cactusController!.value == marioController!.value) {
        cactusController!.dispose();
      }
      // debugPrint/(status.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0XFF8B3901),
        onPressed: () {marioController!.forward();},
        child: const Icon(Icons.keyboard_double_arrow_right_rounded,color: Color(0XFFE99B5B),),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/desert2.png"),
                      fit: BoxFit.cover)),
            ),
            Positioned(
              left: marioController!.value,
              top: 150,
              child: SizedBox(
                height: 200,
                width: 200,
                child: RotationTransition(
                  turns: const AlwaysStoppedAnimation(90 / 360),
                  child: Image.asset("assets/images/mariogif2.gif"),
                ),
              ),
            ),
            Positioned(
              right: 250,
              bottom: cactusController!.value,
              child: SizedBox(
                height: 100,
                width: 100,
                child: Image.asset("assets/images/cactus.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
