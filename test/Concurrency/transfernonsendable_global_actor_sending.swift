// RUN: %target-swift-frontend -emit-sil -swift-version 6 -target %target-swift-5.1-abi-triple -verify %s -o /dev/null -parse-as-library
// RUN: %target-swift-frontend -emit-sil -swift-version 6 -target %target-swift-5.1-abi-triple -verify %s -o /dev/null -parse-as-library -enable-upcoming-feature NonisolatedNonsendingByDefault


// README: Once we loosen the parser so that sending is rejected in Sema
// instead of the parser, move into the normal
// transfernonsendable_global_actor.swift

// REQUIRES: swift_feature_NonisolatedNonsendingByDefault

////////////////////////
// MARK: Declarations //
////////////////////////

class NonSendableKlass {}

extension Task where Failure == Never {
  public static func fakeInit(
    @_implicitSelfCapture operation: sending @escaping () async -> Success
  ) {}

  // This matches the current impl
  public static func fakeInit2(
    @_implicitSelfCapture @_inheritActorContext operation: sending @escaping @isolated(any) () async -> Success
  ) {}
}

func useValue<T>(_ t: T) {}

/////////////////
// MARK: Tests //
/////////////////

@MainActor func testGlobalFakeInit() {
  let ns = NonSendableKlass()

  Task.fakeInit { @MainActor in
    print(ns)
  }

  useValue(ns)
}

@MainActor func testGlobalFakeInit2() {
  let ns = NonSendableKlass()

  // We shouldn't error here.
  Task.fakeInit2 { @MainActor in
    print(ns)
  }

  useValue(ns)
}
