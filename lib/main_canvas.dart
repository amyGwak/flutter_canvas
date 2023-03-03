import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';


class MainCanvas extends StatefulWidget {
  const MainCanvas({super.key});

  @override
  State<MainCanvas> createState() => _MainCanvas();
}

class _MainCanvas extends State<MainCanvas> {

  bool isClick = false;

  double xPos = 80;
  double yPos = 100;
  Size textLength = Size(0,0);


  setTextLength (textPainter) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState((){
        textLength = textPainter.size;
      });
    });
  }


  bool isMyNameRegion(double checkX, double checkY) {
    // print('textLength.width ${textLength.width}'); //텍스트 길이
    // print('textLength.height ${textLength.height}'); //텍스트 높이
    // print('checkX ${checkX}'); //현재 클릭한 x위치
    // print('checkY ${checkY}'); //현재 클릭한 y위치
    // print('xPos ${xPos}'); // 현재 텍스트 x위치
    // print('yPos ${yPos}'); // 현재 텍스트 y위치

    bool isXinRegion = checkX >= xPos && (checkX <= xPos + textLength.width);
    bool isYinRegion = checkY >= yPos && (checkY <= yPos + textLength.height);

    if(isXinRegion && isYinRegion){
      return true;
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Stack(
            children: <Widget>[
              CustomPaint(
                painter: BackgroundPainter(),
                child: Container(
                    width: double.infinity,
                    height: 500
                ),
              ),
              GestureDetector(
                onHorizontalDragDown: (details) {
                  setState((){
                      if(isMyNameRegion(details.localPosition.dx, details.localPosition.dy)) {
                        isClick = true;
                      }
                  });
                },
                onHorizontalDragEnd: (details) {
                  //drag 끝날 때(drop)

                  setState((){
                    isClick = false;
                  });
                },
                onHorizontalDragUpdate: (details) {
                  //drag 진행 중

                  if(isClick){
                    setState(() {
                      xPos= details.localPosition.dx;
                      yPos= details.localPosition.dy;
                    });
                  }

                },
                child: CustomPaint(
                    painter: NamePainter(xPos: xPos, yPos: yPos, setTextLength: setTextLength),
                    child: Container()
                ),
              )
            ]
        )
    );
  }
}




class NamePainter extends CustomPainter {

  NamePainter({
    required this.xPos,
    required this.yPos,
    required this.setTextLength});

  double xPos;
  double yPos;

  dynamic setTextLength;


  final textSpan = const TextSpan(style: TextStyle(
      color: Colors.lime,
      fontSize: 20,
      fontWeight: FontWeight.bold
  ),
    text: 'Amy is hungry! jokbal');

  @override
  void paint(Canvas canvas, Size size) {

    final drawText = TextPainter()
      ..text = textSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();

    drawText.paint(canvas, Offset(xPos, yPos));
    setTextLength(drawText);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var background = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.lightBlueAccent
      ..isAntiAlias = true;

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}