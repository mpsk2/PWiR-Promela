#include "atomic-operations.pml"

#define HAS_LOCK 0
#define MUST_WAIT 1

int slots[NUM_PROCESSES];
int next_slot = 0;

inline initialize() {
    printf("Anderson lock initialization with number\n");
    slots[0] = HAS_LOCK;

    int i = 1;
    do
      :: i < NUM_PROCESSES -> { slots[i] = MUST_WAIT; i = i + 1; }
      :: else -> break;
    od
}

inline acquire_lock(_n, _id) {
    printf("Anderson acquire lock of number: %d, id: %d\n", _n, _id);
    int my_place;
    fetch_and_increment(my_place, next_slot);
    my_place = my_place % NUM_PROCESSES;
    // (**)
    do
      :: slots[my_place] == MUST_WAIT -> skip;
      :: else -> break;
    od
    slots[my_place] = MUST_WAIT;
    _n = my_place;
}

inline release_lock(_n, _id) {
    printf("Anderson release lock of number: %d, id: %d\n", _n, _id);
    slots[(_n + 1) % NUM_PROCESSES] = HAS_LOCK;
}

