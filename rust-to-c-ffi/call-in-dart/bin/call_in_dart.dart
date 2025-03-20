import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

typedef CCallback = ffi.Void Function(ffi.Pointer<Utf8>, ffi.UnsignedLong);

typedef DartCallback = void Function(ffi.Pointer<Utf8>, int);

typedef FunctionWithCallbackC =
    ffi.Void Function(
      ffi.Pointer<Utf8>,
      ffi.UnsignedLong,
      ffi.Pointer<ffi.NativeFunction<CCallback>>,
    );

typedef FunctionWithCallbackDart =
    void Function(
      ffi.Pointer<Utf8>,
      int,
      ffi.Pointer<ffi.NativeFunction<CCallback>>,
    );

void dartCallback(ffi.Pointer<Utf8> keyPtr, int val) {
  final key = keyPtr.cast<Utf8>().toDartString();
  print('Call in Dart: Key=$key, Val=$val');
}

void main() {
  final lib = ffi.DynamicLibrary.open('./libcallback.so');
  final functionWithCallback = lib
      .lookupFunction<FunctionWithCallbackC, FunctionWithCallbackDart>(
        'function_with_callback',
      );

  final callable = ffi.NativeCallable<CCallback>.isolateLocal(
    (ffi.Pointer<Utf8> keyPtr, int val) => dartCallback(keyPtr, val),
  );

  final key = '123'.toNativeUtf8();
  functionWithCallback(key, 456, callable.nativeFunction);

  calloc.free(key);
  callable.close();
}
