import 'package:flutter/material.dart';
import '../widgets/cat.dart';
import 'dart:math';

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;

  Animation<double> boxAnimation;
  AnimationController boxController;

  initState() {
    //Se llama automaticamente para instancias solo para las State class
    super.initState();

    catController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    catAnimation = Tween(begin: -35.0, end: -80.0).animate(CurvedAnimation(
      parent: catController,
      curve: Curves.easeIn,
    ));

    boxController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    boxAnimation =
        Tween(begin: pi * 0.6, end: pi * 0.65).animate(CurvedAnimation(
      parent: boxController,
      curve: Curves.easeInOut,
    ));

    boxController.forward();
    
    boxAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController.forward();
      }
    });
  }

  onTap() {
    if (catController.status == AnimationStatus.completed) {
      catController.reverse();
      boxController.forward();
    } else if (catController.status == AnimationStatus.dismissed) {
      catController.forward();
      boxController.stop();
    } else if (catController.status == AnimationStatus.forward) {
      catController.reverse();
    } else if (catController.status == AnimationStatus.reverse) {
      catController.forward();
    }
  }

  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Animation!'),
        ),
        body: GestureDetector(
          child: Center(
            child: Stack(
              overflow: Overflow.visible, // puede ver mas alla del Stack
              children: <Widget>[
                buildCat(),
                buildBox(),
                buildLeftFlap(),
                buildRightFlap(),
              ],
            ),
          ),
          onTap: onTap,
        ));
  }

  Widget buildCat() {
    return AnimatedBuilder(
      animation: catAnimation,
      child: Cat(),
      builder: (context, child) {
        return Positioned(
          child: child,
          top: catAnimation
              .value, //no cambia el tama;o solo intenta ajustarse al tama;o actual del stack
          right: 0.0,
          left: 0.0, //los dos lados causan que se encoja la imagen
        );
      },
    );
  }

  Widget buildBox() {
    return Container(
      height: 200,
      width: 200,
      color: Colors.brown[200],
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3.0,
      top: 1.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          height: 10.0,
          width: 125.0,
          color: Colors.brown[200],
        ),
        builder: (context, child) {
          return Transform.rotate(
            child: child,
            angle: boxAnimation.value, //Radianes (pi)
            alignment: Alignment.topLeft,
          );
        },
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 3.0,
      top: 1.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          height: 10.0,
          width: 125.0,
          color: Colors.brown[200],
        ),
        builder: (context, child) {
          return Transform.rotate(
            child: child,
            angle: -boxAnimation.value, //Radianes (pi)
            alignment: Alignment.topRight,
          );
        },
      ),
    );
  }
}
