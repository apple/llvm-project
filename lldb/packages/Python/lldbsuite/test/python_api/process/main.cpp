//===-- main.c --------------------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
#include <stdio.h>
#include <stdint.h>

// This simple program is to test the lldb Python API related to process.

char my_char = 'u';
char my_cstring[] = "lldb.SBProcess.ReadCStringFromMemory() works!";
char *my_char_ptr = (char *)"Does it work?";
uint32_t my_uint32 = 12345;
int my_int = 0;

int main (int argc, char const *argv[])
{
    for (int i = 0; i < 3; ++i) {
        printf("my_char='%c'\n", my_char);
        ++my_char;
    }

    printf("after the loop: my_char='%c'\n", my_char); // 'my_char' should print out as 'x'.

    return 0; // Set break point at this line and check variable 'my_char'.
              // Use lldb Python API to set memory content for my_int and check the result.
}
