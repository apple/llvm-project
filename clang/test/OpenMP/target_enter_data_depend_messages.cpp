// RUN: %clang_cc1 -verify=expected,omp4 -fopenmp -fopenmp-version=45 -ferror-limit 100 -o - -std=c++11 %s -Wuninitialized
// RUN: %clang_cc1 -verify=expected,omp5 -fopenmp -fopenmp-version=50 -ferror-limit 100 -o - -std=c++11 %s -Wuninitialized

// RUN: %clang_cc1 -verify=expected,omp4 -fopenmp-simd -fopenmp-version=45 -ferror-limit 100 -o - -std=c++11 %s -Wuninitialized
// RUN: %clang_cc1 -verify=expected,omp5 -fopenmp-simd -fopenmp-version=50 -ferror-limit 100 -o - -std=c++11 %s -Wuninitialized

void foo() {
}

bool foobool(int argc) {
  return argc;
}

struct S1; // expected-note {{declared here}} expected-note {{declared here}}

class vector {
  public:
    int operator[](int index) { return 0; }
};

template <class T, class S, class R>
int tmain(T argc, S **argv, R *env[]) {
  vector vec;
  typedef float V __attribute__((vector_size(16)));
  V a;
  char *arr;

  int i;
  #pragma omp target enter data map(to: i) depend // expected-error {{expected '(' after 'depend'}}
  foo();
#pragma omp target enter data map(to : i) depend( // omp4-error {{expected 'in', 'out', 'inout' or 'mutexinoutset' in OpenMP clause 'depend'}} expected-error {{expected ')'}} expected-note {{to match this '('}} expected-warning {{missing ':' after dependency type - ignoring}} omp5-error {{expected depend modifier(iterator) or 'in', 'out', 'inout', 'mutexinoutset' or 'depobj' in OpenMP clause 'depend'}}
  foo();
#pragma omp target enter data map(to : i) depend() // omp4-error {{expected 'in', 'out', 'inout' or 'mutexinoutset' in OpenMP clause 'depend'}} expected-warning {{missing ':' after dependency type - ignoring}} omp5-error {{expected depend modifier(iterator) or 'in', 'out', 'inout', 'mutexinoutset' or 'depobj' in OpenMP clause 'depend'}}
  foo();
#pragma omp target enter data map(to : i) depend(argc // omp4-error {{expected 'in', 'out', 'inout' or 'mutexinoutset' in OpenMP clause 'depend'}} expected-warning {{missing ':' after dependency type - ignoring}} expected-error {{expected ')'}} expected-note {{to match this '('}} omp5-error {{expected depend modifier(iterator) or 'in', 'out', 'inout', 'mutexinoutset' or 'depobj' in OpenMP clause 'depend'}}
  foo();
#pragma omp target enter data map(to : i) depend(source : argc) // omp4-error {{expected 'in', 'out', 'inout' or 'mutexinoutset' in OpenMP clause 'depend'}} omp5-error {{expected depend modifier(iterator) or 'in', 'out', 'inout', 'mutexinoutset' or 'depobj' in OpenMP clause 'depend'}}
  foo();
#pragma omp target enter data map(to : i) depend(source) // expected-error {{expected expression}} expected-warning {{missing ':' after dependency type - ignoring}} omp4-error {{expected 'in', 'out', 'inout' or 'mutexinoutset' in OpenMP clause 'depend'}} omp5-error {{expected depend modifier(iterator) or 'in', 'out', 'inout', 'mutexinoutset' or 'depobj' in OpenMP clause 'depend'}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : argc)) // expected-warning {{extra tokens at the end of '#pragma omp target enter data' are ignored}}
  foo();
#pragma omp target enter data map(to : i) depend(out:) // expected-error {{expected expression}}
  foo();
#pragma omp target enter data map(to : i) depend(inout : foobool(argc)), depend(in, argc) // omp4-error {{expected addressable lvalue expression, array element or array section}} expected-warning {{missing ':' after dependency type - ignoring}} expected-error {{expected expression}} omp5-error {{expected addressable lvalue expression, array element, array section or array shaping expression of non 'omp_depend_t' type}}
  foo();
  #pragma omp target enter data map(to: i) depend (out :S1) // expected-error {{'S1' does not refer to a value}}
  foo();
#pragma omp target enter data map(to : i) depend(in : argv[1][1] = '2') // omp4-error {{expected addressable lvalue expression, array element or array section}} omp5-error {{expected addressable lvalue expression, array element, array section or array shaping expression of non 'omp_depend_t' type}}
  foo();
#pragma omp target enter data map(to : i) depend(in : vec[1]) // omp4-error {{expected addressable lvalue expression, array element or array section}} omp5-error {{expected addressable lvalue expression, array element, array section or array shaping expression of non 'omp_depend_t' type}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : argv[0])
  foo();
  #pragma omp target enter data map(to: i) depend (in : ) // expected-error {{expected expression}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : tmain)
  foo();
#pragma omp target enter data map(to : i) depend(in : a[0]) // omp4-error{{expected addressable lvalue expression, array element or array section}} omp5-error {{expected addressable lvalue expression, array element, array section or array shaping expression of non 'omp_depend_t' type}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : vec[1:2]) // expected-error {{ value is not an array or pointer}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : argv[ // expected-error {{expected expression}} expected-error {{expected ']'}} expected-error {{expected ')'}} expected-note {{to match this '['}} expected-note {{to match this '('}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : argv[: // expected-error {{expected expression}} expected-error {{expected ']'}} expected-error {{expected ')'}} expected-note {{to match this '['}} expected-note {{to match this '('}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : argv[:] // expected-error {{section length is unspecified and cannot be inferred because subscripted value is not an array}} expected-error {{expected ')'}} expected-note {{to match this '('}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : argv[argc: // expected-error {{expected expression}} expected-error {{expected ']'}} expected-error {{expected ')'}} expected-note {{to match this '['}} expected-note {{to match this '('}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : argv[argc:argc] // expected-error {{expected ')'}} expected-note {{to match this '('}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : argv[0:-1]) // expected-error {{section length is evaluated to a negative value -1}}
  foo();
#pragma omp target enter data map(to : i) depend(in : argv [-1:0]) // expected-error {{zero-length array section is not allowed in 'depend' clause}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : argv[:]) // expected-error {{section length is unspecified and cannot be inferred because subscripted value is not an array}}
  foo();
#pragma omp target enter data map(to : i) depend(in : argv [3:4:1]) // expected-error {{expected ']'}} expected-note {{to match this '['}}
  foo();
  #pragma omp target enter data map(to: i) depend(in:a[0:1]) // expected-error {{subscripted value is not an array or pointer}}
  foo();
  #pragma omp target enter data map(to: i) depend(in:argv[argv[:2]:1]) // expected-error {{OpenMP array section is not allowed here}}
  foo();
  #pragma omp target enter data map(to: i) depend(in:argv[0:][:]) // expected-error {{section length is unspecified and cannot be inferred because subscripted value is not an array}}
  foo();
  #pragma omp target enter data map(to: i) depend(in:env[0:][:]) // expected-error {{section length is unspecified and cannot be inferred because subscripted value is an array of unknown bound}}
  foo();
  #pragma omp target enter data map(to: i) depend(in : argv[ : argc][1 : argc - 1])
  foo();
#pragma omp target enter data map(to : i) depend(in : arr[0])
  foo();

  return 0;
}

int main(int argc, char **argv, char *env[]) {
  vector vec;
  typedef float V __attribute__((vector_size(16)));
  V a;
  char *arr;

  int i;
  #pragma omp target enter data map(to: i) depend // expected-error {{expected '(' after 'depend'}}
  foo();
#pragma omp target enter data map(to : i) depend( // omp4-error {{expected 'in', 'out', 'inout' or 'mutexinoutset' in OpenMP clause 'depend'}} expected-error {{expected ')'}} expected-note {{to match this '('}} expected-warning {{missing ':' after dependency type - ignoring}} omp5-error {{expected depend modifier(iterator) or 'in', 'out', 'inout', 'mutexinoutset' or 'depobj' in OpenMP clause 'depend'}}
  foo();
#pragma omp target enter data map(to : i) depend() // omp4-error {{expected 'in', 'out', 'inout' or 'mutexinoutset' in OpenMP clause 'depend'}} expected-warning {{missing ':' after dependency type - ignoring}} omp5-error {{expected depend modifier(iterator) or 'in', 'out', 'inout', 'mutexinoutset' or 'depobj' in OpenMP clause 'depend'}}
  foo();
#pragma omp target enter data map(to : i) depend(argc // omp4-error {{expected 'in', 'out', 'inout' or 'mutexinoutset' in OpenMP clause 'depend'}} expected-warning {{missing ':' after dependency type - ignoring}} expected-error {{expected ')'}} expected-note {{to match this '('}} omp5-error {{expected depend modifier(iterator) or 'in', 'out', 'inout', 'mutexinoutset' or 'depobj' in OpenMP clause 'depend'}}
  foo();
#pragma omp target enter data map(to : i) depend(source : argc) // omp4-error {{expected 'in', 'out', 'inout' or 'mutexinoutset' in OpenMP clause 'depend'}} omp5-error {{expected depend modifier(iterator) or 'in', 'out', 'inout', 'mutexinoutset' or 'depobj' in OpenMP clause 'depend'}}
  foo();
#pragma omp target enter data map(to : i) depend(source) // expected-error {{expected expression}} expected-warning {{missing ':' after dependency type - ignoring}} omp4-error {{expected 'in', 'out', 'inout' or 'mutexinoutset' in OpenMP clause 'depend'}} omp5-error {{expected depend modifier(iterator) or 'in', 'out', 'inout', 'mutexinoutset' or 'depobj' in OpenMP clause 'depend'}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : argc)) // expected-warning {{extra tokens at the end of '#pragma omp target enter data' are ignored}}
  foo();
  #pragma omp target enter data map(to: i) depend (out: ) // expected-error {{expected expression}}
  foo();
#pragma omp target enter data map(to : i) depend(inout : foobool(argc)), depend(in, argc) // omp4-error {{expected addressable lvalue expression, array element or array section}} expected-warning {{missing ':' after dependency type - ignoring}} expected-error {{expected expression}} omp5-error {{expected addressable lvalue expression, array element, array section or array shaping expression of non 'omp_depend_t' type}}
  foo();
  #pragma omp target enter data map(to: i) depend (out :S1) // expected-error {{'S1' does not refer to a value}}
  foo();
  #pragma omp target enter data map(to: i) depend(in : argv[1][1] = '2')
  foo();
#pragma omp target enter data map(to : i) depend(in : vec[1]) // omp4-error {{expected addressable lvalue expression, array element or array section}} omp5-error {{expected addressable lvalue expression, array element, array section or array shaping expression of non 'omp_depend_t' type}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : argv[0])
  foo();
  #pragma omp target enter data map(to: i) depend (in : ) // expected-error {{expected expression}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : main)
  foo();
#pragma omp target enter data map(to : i) depend(in : a[0]) // omp4-error{{expected addressable lvalue expression, array element or array section}} omp5-error {{expected addressable lvalue expression, array element, array section or array shaping expression of non 'omp_depend_t' type}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : vec[1:2]) // expected-error {{ value is not an array or pointer}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : argv[ // expected-error {{expected expression}} expected-error {{expected ']'}} expected-error {{expected ')'}} expected-note {{to match this '['}} expected-note {{to match this '('}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : argv[: // expected-error {{expected expression}} expected-error {{expected ']'}} expected-error {{expected ')'}} expected-note {{to match this '['}} expected-note {{to match this '('}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : argv[:] // expected-error {{section length is unspecified and cannot be inferred because subscripted value is not an array}} expected-error {{expected ')'}} expected-note {{to match this '('}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : argv[argc: // expected-error {{expected expression}} expected-error {{expected ']'}} expected-error {{expected ')'}} expected-note {{to match this '['}} expected-note {{to match this '('}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : argv[argc:argc] // expected-error {{expected ')'}} expected-note {{to match this '('}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : argv[0:-1]) // expected-error {{section length is evaluated to a negative value -1}}
  foo();
  #pragma omp target enter data map(to: i) depend (in : argv[-1:0]) // expected-error {{zero-length array section is not allowed in 'depend' clause}}
  foo();
  #pragma omp target enter data map(to: i) depend(in : argv[:]) // expected-error {{section length is unspecified and cannot be inferred because subscripted value is not an array}}
  foo();
  #pragma omp target enter data map(to : i) depend(in : argv [3:4:1]) // expected-error {{expected ']'}} expected-note {{to match this '['}}
  foo();
  #pragma omp target enter data map(to: i) depend(in:a[0:1]) // expected-error {{subscripted value is not an array or pointer}}
  foo();
  #pragma omp target enter data map(to: i) depend(in:argv[argv[:2]:1]) // expected-error {{OpenMP array section is not allowed here}}
  foo();
  #pragma omp target enter data map(to: i) depend(in:argv[0:][:]) // expected-error {{section length is unspecified and cannot be inferred because subscripted value is not an array}}
  foo();
  #pragma omp target enter data map(to: i) depend(in:env[0:][:]) // expected-error {{section length is unspecified and cannot be inferred because subscripted value is an array of unknown bound}}
  foo();
  #pragma omp target enter data map(to: i) depend(in : argv[ : argc][1 : argc - 1])
  foo();
  #pragma omp target enter data map(to: i) depend(in : arr[0])
  foo();

  return tmain(argc, argv, env); // expected-note {{in instantiation of function template specialization 'tmain<int, char, char>' requested here}}
}
