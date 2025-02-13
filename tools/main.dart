import 'dart:io';

bool repeat = false;

Future<void> main() async {
  print("Starting flutter_native_ui tools...");
  while (true) {
    print("\nSelect an action:");
    print("1. creator");
    print("0. exit");

    stdout.write("\n>> ");
    String? input = stdin.readLineSync();

    switch (input) {
      case '1':
        await run('creator/creator.dart');
        break;
      case '0' || 'exit' || 'quit' || 'e' || 'q':
        print("Exiting...");
        exit(0);
      default:
        print("Invalid option");
    }

    if (repeat == false) {
      print("Tool complete");
      break;
    }
  }
}

Future<void> run(String script) async {
  Process process = await Process.start('dart', [script], mode: ProcessStartMode.inheritStdio);
  await process.exitCode;
}