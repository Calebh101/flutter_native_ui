import 'package:flutter/material.dart';
import 'package:flutter_native_ui/flutter_native_ui.dart';
import 'package:flutter_native_ui/bases.dart';
import 'package:flutter_native_ui/themes.dart';

FlutterNativeUI flutterNative = FlutterNativeUI(platform: Environment.macos);

Future<void> main() async {
  await flutterNative.init();
  if (flutterNative.platform == Environment.ios || flutterNative.platform == Environment.android) {
    runApp(const MyApp());
  } else {
    runApp(const UnimplementedApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return NativeApp(
      debugShowCheckedModeBanner: false,
      home: TestPage(),
      theme: NativeThemeData(primaryColor: Colors.amber, context: context),
      darkTheme: NativeThemeData(primaryColor: Colors.red, context: context),
    );
  }
}

class UnimplementedApp extends StatelessWidget {
  const UnimplementedApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: "SFPro.bold");
    Widget text = Text("Running: UNIMPLEMENTED\nCurrent platform: ${flutterNative.platform}", style: style);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              text,
              Text("Font: ${style.fontFamily},${getFont()}")
            ],
          ),
        ),
      ),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return NativeScaffold(
      backgroundColor: MediaQuery.platformBrightnessOf(context) == Brightness.dark ? Colors.black : Colors.white,
      body: Center(
        child: NativeText("Running: TESTPAGE\nCurrent platform: ${flutterNative.platform}\nFont: ${getFont()}"),
      ),
    );
  }
}
