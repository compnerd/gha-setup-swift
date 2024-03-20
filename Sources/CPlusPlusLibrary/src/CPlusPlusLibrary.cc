#include <memory>
#include "../include/CPlusPlusLibrary.h"
#include "../../CLibrary/include/CLibrary.h"

extern "C" {

  int forty_two() {
    // Exercise some trivial C++ functionality.
    int* x = new int(forty_one() + 1);
    int r = *x;
    delete x;
    return r;  }

}
