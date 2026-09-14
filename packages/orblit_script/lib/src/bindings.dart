// Raw FFI bindings to the shim. Nothing here manages lifetime or converts
// errors — that is [ScriptHost]'s job, and keeping the two apart means the
// generated binding tables in S2 can sit beside this file without tangling.

import 'dart:ffi';

const String kOrblitScriptAsset = 'package:orblit_script/orblit_script';

/// Opaque runtime-plus-context pair owned by the shim.
final class OrblitScriptHostStruct extends Opaque {}

@Native<Pointer<OrblitScriptHostStruct> Function()>(
    symbol: 'orblit_script_new', assetId: kOrblitScriptAsset)
external Pointer<OrblitScriptHostStruct> orblitScriptNew();

@Native<Void Function(Pointer<OrblitScriptHostStruct>)>(
    symbol: 'orblit_script_free', assetId: kOrblitScriptAsset)
external void orblitScriptFree(Pointer<OrblitScriptHostStruct> host);

@Native<
    Int Function(Pointer<OrblitScriptHostStruct>, Pointer<Char>, Pointer<Char>,
        Pointer<Pointer<Char>>)>(
    symbol: 'orblit_script_eval', assetId: kOrblitScriptAsset)
external int orblitScriptEval(
  Pointer<OrblitScriptHostStruct> host,
  Pointer<Char> source,
  Pointer<Char> fileName,
  Pointer<Pointer<Char>> out,
);

@Native<Int Function(Pointer<OrblitScriptHostStruct>, Pointer<Pointer<Char>>)>(
    symbol: 'orblit_script_pump', assetId: kOrblitScriptAsset)
external int orblitScriptPump(
  Pointer<OrblitScriptHostStruct> host,
  Pointer<Pointer<Char>> errorOut,
);

@Native<Void Function(Pointer<Char>)>(
    symbol: 'orblit_script_string_free', assetId: kOrblitScriptAsset)
external void orblitScriptStringFree(Pointer<Char> s);

@Native<Pointer<Char> Function()>(
    symbol: 'orblit_script_engine_version', assetId: kOrblitScriptAsset)
external Pointer<Char> orblitScriptEngineVersion();
