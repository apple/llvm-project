// RUN: %clang_cc1 -triple x86_64-apple-darwin  -fsyntax-only -verify %s

void g() {}

void f() __attribute__((alias("g"))); //expected-error {{aliases are not supported on darwin}}
