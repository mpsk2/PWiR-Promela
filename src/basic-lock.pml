#include "atomic-operations.pml"

int _val;

inline initialize() {
    _val = 0;
    printf("Basic lock initialization with number\n");
}

inline acquire_lock(_n, _id) {
    printf("Acquire lock of number: %d, id: %d\n", _n, _id);
    byte value = 1;
    do
      :: value == 1 -> { test_and_set(value, _val); }
      :: else -> break;
    od
    _n = _val;
}

inline release_lock(_n, _id) {
    printf("Release lock of number: %d, id: %d\n", _n, _id);
    _n = 0;
    _val = n;
}

