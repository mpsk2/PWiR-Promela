#include "atomic-operations.pml"

#define MAX_QUEUE (NUM_PROCESSES + 1)

typedef qnode {
    bool locked;
    int next;
}

int _last;
qnode nodes[MAX_QUEUE];

inline initialize() {
    printf("MCS lock initialization with number\n");
    _last = 0;
}

inline acquire_lock(_n, _id) {
    int predecessor;

    printf("MCS acquire lock of number: %d, id: %d\n", _n, _id);
    nodes[_id].next = 0;
    fetch_and_store(predecessor, _last, _id);
    // (**)
    if
      :: predecessor == 0 -> skip;
      :: else ->
        nodes[_id].locked = true;
        predecessor.next = _id;
        do
          :: nodes[_id].locked -> skip;
          :: else -> break;
        od
    fi
}