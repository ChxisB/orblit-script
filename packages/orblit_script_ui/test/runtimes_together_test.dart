import 'package:flutter_test/flutter_test.dart';
import 'package:orblit_script/orblit_script.dart';
import 'package:orblit_script_scene/orblit_script_scene.dart';
import 'package:orblit_script_ui/orblit_script_ui.dart';

/// Both runtimes in one engine, which is what a game with an interface and a
/// world loads.
///
/// Each answers `require` from the modules it defined, and each makes itself
/// `globalThis.require` if nothing has yet — so whichever is evaluated first
/// answers for both, and has to be able to reach what the other registered.
/// That is what the shared registry is for, and why neither may replace it.
///
/// This is the only place either runtime meets the other: the two packages
/// cannot see each other, so without this nothing would notice them treading
/// on one another.
void main() {
  group('two runtimes in one engine', () {
    late ScriptHost host;

    setUp(() => host = ScriptHost());
    tearDown(() => host.dispose());

    /// Everything both runtimes put within reach, by every route a script
    /// has to it.
    void reachesBoth() {
      expect(host.eval('typeof require("orblit").h'), 'function');
      expect(host.eval('typeof require("orblit/jsx-runtime").jsx'), 'function');
      expect(host.eval('typeof require("orblit/scene").spawn'), 'function');
      expect(host.eval('typeof __orblit_ui.render'), 'function');
      expect(host.eval('typeof __orblit_scene.describe'), 'function');

      // A host reads the registry to find what is loaded, and a runtime
      // evaluated later reads it to find what came before, so it has to name
      // everything rather than whatever went in last.
      expect(
        host.eval('Object.keys(globalThis.__orblit_modules).sort().join(",")'),
        'jsx-runtime,orblit,scene,ui',
      );
    }

    test('the interface first, then the scene', () {
      host.eval(UiRuntime.source, fileName: 'orblit/ui.js');
      host.eval(SceneRuntime.source, fileName: 'orblit/scene.js');
      reachesBoth();
    });

    test('the scene first, then the interface', () {
      host.eval(SceneRuntime.source, fileName: 'orblit/scene.js');
      host.eval(UiRuntime.source, fileName: 'orblit/ui.js');
      reachesBoth();
    });

    test('what a host registers, either runtime answers for', () {
      host.eval(UiRuntime.source, fileName: 'orblit/ui.js');
      host.eval(SceneRuntime.source, fileName: 'orblit/scene.js');

      // A script that keeps its state in a module is the ordinary case, and
      // the host has to be able to write into it.
      host.eval('globalThis.__orblit_modules.save = { slot: 3 };');

      expect(host.eval('String(require("save").slot)'), '3');
    });
  });
}
