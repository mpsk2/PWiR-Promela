#include "atomic-operations.pml"

#define MAX_QUEUE NUM_PROCESSES
#define NULL_VAL NUM_PROCESSES

typedef qnode {
    bool locked;
    int next;
};

byte _last_item;
qnode nodes[MAX_QUEUE];

inline initialize() {
    _last_item = NULL_VAL;
}

inline acquire_lock(_n, _id) {
    int predecessor;
    nodes[_id].next = NULL_VAL;
    fetch_and_store(predecessor, _last_item, _id);
#ifdef FCFS
    skip;
fcfs_label:
#endif
    // (**)
    if
      :: predecessor != NULL_VAL ->
        nodes[_id].locked = true;
        nodes[predecessor].next = _id;
#ifdef WAITING
waiting:
#endif

#ifdef INEVITABLE_WAITING
    assert(nodes[_id].locked == true)
#endif

        ! nodes[_id].locked
#ifdef WAITING
waited:
#endif
      :: else -> skip
    fi
}