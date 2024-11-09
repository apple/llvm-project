@_originallyDefinedIn(
     module: "Other", iOS 2.0, macOS 2.0, tvOS 2.0, watchOS 2.0)
@available(iOS 1.0, macOS 1.0, tvOS 1.0, watchOS 1.0, *)
public struct A {
    let i = 10
}

@_originallyDefinedIn(
     module: "Other", iOS 2.0, macOS 2.0, tvOS 2.0, watchOS 2.0)
@available(iOS 1.0, macOS 1.0, tvOS 1.0, watchOS 1.0, *)
public struct B {
    let i = 20
}

typealias Alias = B

@_originallyDefinedIn(
     module: "Other", iOS 2.0, macOS 2.0, tvOS 2.0, watchOS 2.0)
@available(iOS 1.0, macOS 1.0, tvOS 1.0, watchOS 1.0, *)
public enum C {
    public struct D {
        let i = 30
    }
}

@_originallyDefinedIn(
     module: "Other", iOS 2.0, macOS 2.0, tvOS 2.0, watchOS 2.0)
@available(iOS 1.0, macOS 1.0, tvOS 1.0, watchOS 1.0, *)
public enum EEEEE<T> {
    case t(T)
}

public struct Prop {
    let i = 40
}

@_originallyDefinedIn(
     module: "Other", iOS 2.0, macOS 2.0, tvOS 2.0, watchOS 2.0)
@available(iOS 1.0, macOS 1.0, tvOS 1.0, watchOS 1.0, *)
public struct Prop2 {
    let i = 50
}

@_originallyDefinedIn(
     module: "Other", iOS 2.0, macOS 2.0, tvOS 2.0, watchOS 2.0)
@available(iOS 1.0, macOS 1.0, tvOS 1.0, watchOS 1.0, *)
public struct Pair<T, U> {
    let t: T
    let u: U
}

func f() {
    let a = A()
    let b = Alias()
    let d = C.D()
    let e = EEEEE<Prop>.t(Prop())
    let e2 = EEEEE<Prop2>.t(Prop2())
    // Other.Pair<Other.EEEEE<Other.Pair<Other.Prop2, Other.C.D>, Other.EEEEE<a.Prop>>
    let con = Pair(t: EEEEE.t(Pair(t: Prop2(), u: C.D())), u: EEEEE.t(Prop()))
    print("break here")
}

f()
