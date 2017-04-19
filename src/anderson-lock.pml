#include "atomic-operations.pml"

#define HAS_LOCK 0
#define MUST_WAIT 1

bool slots[NUM_PROCESSES];
byte next_slot = 0;

inline initialize() {
    slots[0] = HAS_LOCK;

    int _i = 1;
    do
      :: _i < NUM_PROCESSES -> { slots[_i] = MUST_WAIT; _i = _i + 1; }
      :: else -> break;
    od
}

inline acquire_lock(_n, _id) {
    int my_place;
    fetch_and_increment(my_place, next_slot);
    my_place = my_place % NUM_PROCESSES;
#ifdef FCFS
    skip;
fcfs_label:
#endif
    // (**)
#ifdef WAITING
waiting:
#endif

#ifdef INEVITABLE_WAITING
    assert(slots[my_place] == MUST_WAIT)
#endif

    slots[my_place] == HAS_LOCK
#ifdef WAITING
waited:
#endif
    slots[my_place] = MUST_WAIT;
    _n = my_place;
}

inline release_lock(_n, _id) {
    slots[(_n + 1) % NUM_PROCESSES] = HAS_LOCK;
}

