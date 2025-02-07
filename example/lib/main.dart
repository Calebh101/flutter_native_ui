import 'package:flutter/material.dart';
import 'package:flutter_native_ui/flutter_native_ui.dart';

FlutterNativeUI flutterNative = FlutterNativeUI(platform: Environment.ios);

void main() {
  flutterNative.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return NativeApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: "Hello"),
      theme: NativeThemeData(primaryColor: Colors.amber, scaffoldBackgroundColor: Colors.amber),
      darkTheme: NativeThemeData(primaryColor: Colors.red, scaffoldBackgroundColor: Colors.red),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Hello, world!"),
      ),
    );
  }
}
