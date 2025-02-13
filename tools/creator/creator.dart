import 'dart:core';
import 'dart:io';

void main({String className = "Text", int mode = 0}) {
  print("Loading Creator...");
  stdout.write('Enter class name: ');
  className = stdin.readLineSync() ?? className;

  while (mode == 0) {
    print("\nSelect a class type:");
    print("1. NativeStatefulWidget");
    print("2. NativeStatelessWidget");
    print("3. Native (class)");
    print("0. exit");

    stdout.write("\n>> ");
    String? input = stdin.readLineSync();

    switch (input) {
      case '1':
        mode = 1;
        break;
      case '2':
        mode = 2;
        break;
      case '3':
        mode = 3;
        break;
      case '0' || 'exit' || 'quit' || 'e' || 'q':
        print("Exiting...");
        exit(0);
      default:
        print("Invalid option");
    }
  }

  print("\nLoading...");
  String extender = "Native";

  switch (mode) {
    case 1:
      extender = "NativeStatefulWidget";
      break;
    case 2:
      extender = "NativeStatelessWidget";
      break;
    case 3:
      extender = "Native";
      break;
  }

  String tab = "  ";
  String loading = "Loading...";
  String dir = "${Directory.current.path}/creator";
  String text = File('$dir/input.txt').readAsStringSync();
  RegExp regExp = RegExp(r'\b[\w.?]+\b');
  List fields = [];

  for (var line in text.split('\n')) {
    Iterable<Match> matches = regExp.allMatches(line);
    List<String> words = matches.map((m) => m.group(0)!).toList();

    fields.add({
      "name": words[1],
      "type": words[0],
      "value": words.length >= 3 ? words[2] : null,
      "final": true,
    });
  }

  String name = "Native$className";
  print('Generating class $name with $extender');

  List constructor = [];
  String result = loading;
  String declarations = loading;

  for (var item in fields) {
    String name = item["name"];
    String type = item["type"];
    String? value = item["value"];
    bool finalS = item["final"];
    
    if (name != "key") {
      declarations = "${declarations == loading ? "" : "$declarations\n"}$tab${finalS ? "final " : ""}$type $name;";
    }
    constructor.add("this.$name${value != "" && value != null ? " = $value" : ""}");
  }


  if (mode == 1) {
    result = '''class $name extends NativeStatefulWidget {
${tab}/// Constructor for $name
${tab}const $name({super.key, super.type = $className, ${constructor.join(', ')}});

$declarations

${tab}@override
${tab}State<$name> createState() => _${name}State();
}

class _${name}State extends State<$name> {
${tab}@override
${tab}Widget build(BuildContext context) {
${tab}${tab}return;
${tab}}
}''';
} else if (mode == 2) {
    result = '''class $name extends NativeStatelessWidget {
${tab}/// Constructor for $name
${tab}const $name({super.key, super.type = $className, ${constructor.join(', ')}});

$declarations

${tab}@override
${tab}Widget build(BuildContext context) {
${tab}${tab}return;
${tab}}
}''';
  } else if (mode == 3) {
    result = '''class $name extends Native {
${tab}/// Constructor for $name
${tab}const $name({super.type = $className, ${constructor.join(', ')}});

$declarations
}''';
  } else {
    result = 'Error: unknown mode';
  }

  String output = "$dir/output.txt";
  print("Overwriting output file at $output");
  File(output).writeAsString(result);
  print("Process complete");
}
