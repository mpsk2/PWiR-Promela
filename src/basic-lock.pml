#include "atomic-operations.pml"

bool _val;

inline initialize() {
    _val = false;
}

inline acquire_lock(_n, _id) {
    bool value = true;
#ifdef WAITING
waiting:
#endif
    do
      :: value -> test_and_set(value, _val);
    od
#ifdef WAITING
waited:
#endif
}

inline release_lock(_n, _id) {
    _val = false;
}

