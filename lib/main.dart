import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/mochi/bindings/mochi_binding.dart';
import 'app/modules/mochi/views/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mochi Restaurant',
      debugShowCheckedModeBanner: false,
      initialBinding: MochiBinding(), // optional: register at app start
      home: const HomePage(),
      theme: ThemeData(fontFamily: 'Poppins', primarySwatch: Colors.pink),
    );
  }
}
