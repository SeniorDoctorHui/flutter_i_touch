import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const double _kDefaultSpringHeight = 100; //弹簧默认高度
const double _kRateOfMove = 1.5; //移动距离与形变量比值

class SpringWidget extends StatefulWidget{
  const SpringWidget({Key? key}) : super(key: key);
  @override
  _SpringWidgetState createState() => _SpringWidgetState();

}

class _SpringWidgetState extends State<SpringWidget> with SingleTickerProviderStateMixin {
  ValueNotifier<double> height = ValueNotifier(_kDefaultSpringHeight);
  late AnimationController _ctrl;
  double s = 0; // 移动距离
  double laseMoveLen = 0;
  final Duration animDuration = const Duration(milliseconds: 400);
  late Animation<double> animation;


  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: animDuration)
      ..addListener(_updateHeightByAnim);
    animation = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: _updateHeight,
      onVerticalDragEnd: _animateToDefault,
      child: Container(
        width: 300,
        height: 300,
        color: Colors.grey.withAlpha(11),
        child: CustomPaint(
            painter: SpringPainter(height: height)),
      ),
    );
  }

  double get dx => -s/_kRateOfMove;

  void _updateHeight(DragUpdateDetails details) {
    debugPrint("delta.dy=${details.delta.dy}");
    s += details.delta.dy;
    final newValue = _kDefaultSpringHeight + dx;
    if(newValue <= 300 && newValue >= 20) {
      height.value = newValue;
    }else if(newValue > 300){
      height.value = 300;
      s -= details.delta.dy;
    }else{
      height.value = 20;
      s -= details.delta.dy;
    }
    debugPrint("heightValue=${height.value}");
  }

  void _animateToDefault(DragEndDetails details) {
    laseMoveLen = s;
    _ctrl.forward(from: 0);
  }

  void _updateHeightByAnim() {
    s = laseMoveLen * (1 - animation.value);
    height.value = _kDefaultSpringHeight + dx;
  }

  @override
  void dispose() {
    height.dispose();
    _ctrl.dispose();
    super.dispose();
  }
}

const double _kSpringWidth = 30;

class SpringPainter extends CustomPainter {
  final int count;
  final ValueListenable<double> height;

  SpringPainter({this.count = 20, required this.height}): super(repaint: height);

  final Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  // 绘制逻辑见下...

  @override
  bool shouldRepaint(covariant SpringPainter oldDelegate) =>
      oldDelegate.count != count || oldDelegate.height != height;

  @override
  void paint(Canvas canvas, Size size) {
    // print(size);
    canvas.translate(size.width / 2 + _kSpringWidth / 2, size.height);
    Path springPath = Path();
    springPath.relativeLineTo(-_kSpringWidth, 0);
    double space = height.value / (count - 1);
    for (int i = 1; i < count; i++) {
      if (i % 2 == 1) {
        springPath.relativeLineTo(_kSpringWidth, -space);
      } else {
        springPath.relativeLineTo(-_kSpringWidth, -space);
      }
    }
    springPath.relativeLineTo(count.isOdd?_kSpringWidth:-_kSpringWidth, 0);
    canvas.drawPath(springPath, _paint);
  }
}

class Interpolator extends Curve {
  const Interpolator();

  @override
  double transformInternal(double t) {
    t -= 1.0;
    return t * t * t * t + 1.0;
  }
}

