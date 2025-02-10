import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_ui/flutter_native_ui.dart';
import 'package:flutter_native_ui/private.dart';
import 'package:yaru/yaru.dart' as yaru;
import 'package:fluent_ui/fluent_ui.dart' as fluent;

FlutterNativeUI flutterNative = FlutterNativeUI(platform: Environment.windows);

Future<void> main() async {
  await flutterNative.init();
  if (flutterNative.platform != Environment.macos) {
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
    TextStyle style = TextStyle(fontFamily: "SFPro");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              NativeIcon(NativeIconData(icon: Icons.add, cupertinoIcon: CupertinoIcons.add, fluentIcon: fluent.FluentIcons.add, yaruIcon: yaru.YaruIcons.plus), size: 36),
              NativeText("Running: UNIMPLEMENTED\nCurrent platform: ${flutterNative.platform}\nFont: ${getFont()}"),
              fluent.Text("Test font: ${style.fontFamily}", style: style),
              NativeCircularProgressIndicator(),
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
    TextStyle style = TextStyle(fontFamily: "SFPro");
    return NativeScaffold(
      body: Center(
        child: Column(
          children: [
            NativeIcon(NativeIconData(icon: Icons.add, cupertinoIcon: CupertinoIcons.add, fluentIcon: fluent.FluentIcons.add, yaruIcon: yaru.YaruIcons.plus), size: 72),
            NativeText("Running: TESTPAGE\nCurrent platform: ${flutterNative.platform}\nFont: ${getFont()}"),
            Text("Test font: ${style.fontFamily}", style: style),
            NativeCircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
