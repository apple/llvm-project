! RUN: %f18 -fparse-only %s
! RUN: rm -rf %t && mkdir %t
! RUN: touch %t/empty.f90
! RUN: %f18 -fparse-only %t/empty.f90
