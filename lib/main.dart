import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_dio_study/view/dio_home.dart';

void main() {
  runApp(const DioMain());
}

class DioMain extends StatelessWidget {
  const DioMain({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: HomeDio(),
      debugShowCheckedModeBanner: false,
    );
  }
}
