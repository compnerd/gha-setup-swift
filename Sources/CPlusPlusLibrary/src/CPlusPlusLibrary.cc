#include <memory>
#include "../include/CPlusPlusLibrary.h"

extern "C" {

  int forty_two() {
    // Exercise some trivial C++ functionality.
    int* x = new int(42);
    int r = *x;
    delete x;
    return r;  }

}
