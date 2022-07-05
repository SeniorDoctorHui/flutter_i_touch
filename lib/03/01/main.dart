import 'package:flutter/material.dart';

import 'spring_widget.dart';

void main() {
  runApp(MyApp());
  B b = B();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: Center(
          child: SpringWidget(),
        ),
      ),
    );
  }
}

mixin A {
  var data = Data("你还");

   void testFlutter(){
     debugPrint("printA");
   }
}

class B with A{
  @override
  void testFlutter() {
    debugPrint("printB");
  }
}


class Data {
  final String data;

  Data(this.data){
    debugPrint("data:$data");
  }
}
