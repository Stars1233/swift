// RUN: not %target-swift-frontend -typecheck %s

// Just don't crash.
extension () : Comparable {}

