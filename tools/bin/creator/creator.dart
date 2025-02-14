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

  print("\nStarting generation");
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
  String dir = File.fromUri(Platform.script).parent.path;
  String text = File('$dir/input.txt').readAsStringSync();
  RegExp regExp = RegExp(r"[a-zA-Z0-9_?.]+");
  List fields = [];
  int i = 0;
  String name = "Native$className";

  print('Generating class $name with $extender');
  for (var line in text.replaceAll('\n', '').split(',')) {
    Iterable<Match> matches = regExp.allMatches(line);
    List<String> words = matches.map((m) => m.group(0)!).toList();

    if (i == 0) {
      words.remove(className);
    }

    Map value = {
      "name": words[1],
      "type": words[0],
      "value": words.length >= 3 ? words[2] : null,
      "final": true,
    };

    fields.add(value);
    print("${value["final"] ? "final" : "variable"} ${value["type"]} ${value["name"]} = ${value["value"]}");
    i++;
  }

  List constructor = [];
  List arguments = [];

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
    arguments.add("$name: $name");
  }


  if (mode == 1) {
    result = '''class $name extends NativeStatefulWidget {
${tab}/// Constructor for $name
${tab}const $name({super.key, super.type = $className, ${constructor.join(', ')}});

$declarations

${tab}@override
${tab}NativeState<$name> createState() => _${name}State();
}

class _${name}State extends NativeState<$name> {
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

${tab}@override
${tab}dynamic build(BuildContext context) {
${tab}${tab}return;
${tab}}
}''';
  } else {
    result = 'Error: unknown mode';
  }

  String example = '''$className(
${tab}${arguments.join(',\n$tab')}
)''';

  String output = "$dir/class.txt";
  print("Overwriting output file at $output");
  File(output).writeAsString("$result\n\n$example");
  print("Process complete");
}
