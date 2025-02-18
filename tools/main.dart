import 'dart:io';

bool repeat = false;

Future<void> main() async {
  print("Starting flutter_native_ui tools...");
  while (true) {
    print("\nSelect an action:");
    print("1. creator");
    print("2. fetch");
    print("0. exit");

    stdout.write("\n>> ");
    String? input = stdin.readLineSync();

    switch (input) {
      case '1':
        await run('creator/creator.dart', mode: 1);
        break;
      case '2':
        await run('fetch/fetch.js', mode: 2);
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

Future<void> run(String script, {int mode = 1}) async {
  List<String> args = ['${File.fromUri(Platform.script).parent.path}/$script'];
  if (mode == 1) {
    args.insert(0, 'run');
  }

  Process process = await Process.start(mode == 1 ? 'dart' : 'node', args, mode: ProcessStartMode.inheritStdio);
  await process.exitCode;
}