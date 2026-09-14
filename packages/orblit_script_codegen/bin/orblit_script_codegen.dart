import 'dart:io';

import 'package:orblit_script_codegen/orblit_script_codegen.dart';

/// Reads every component manifest under a directory and writes the typings a
/// script author develops against.
///
/// Usage: `dart run orblit_script_codegen <workspace> [output.d.ts]`
void main(List<String> arguments) {
  if (arguments.isEmpty) {
    stderr.writeln('Usage: orblit_script_codegen <workspace> [output.d.ts]');
    exit(2);
  }

  final workspace = arguments.first;
  final output = arguments.length > 1 ? arguments[1] : 'orblit.d.ts';

  final List<ManifestComponent> components;
  try {
    components = const ManifestReader().read(workspace);
  } on ManifestError catch (error) {
    stderr.writeln('orblit_script_codegen: $error');
    exit(1);
  }

  File(output)
    ..createSync(recursive: true)
    ..writeAsStringSync(const TypeScriptEmitter().emit(components));

  stdout.writeln('orblit_script_codegen: ${components.length} component(s) '
      'from $workspace');
  for (final component in components) {
    stdout.writeln('  ${component.name.padRight(20)} '
        '${component.kind} x${component.arity}'
        '${component.replicated ? '  replicated' : ''}');
  }
  stdout.writeln('  -> $output');
}
