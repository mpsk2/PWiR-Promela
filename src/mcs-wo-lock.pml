#include "commons.pml"

inline release_lock(_n, _id) {
    if
      :: nodes[_id] == 0 ->
        int old_tail;
        fetch_and_store(old_tail, _last, 0);
        if
          :: old_tail == _id -> skip;
          :: else ->
            int usurper;
            fetch_and_store(usurper, _last, old_tail);
            do
              :: nodes[_id] != 0 -> skip;
              :: else -> break;
            od
            if
              :: usurper != 0 ->
                nodes[usurper].next = nodes[_id].next;
              :: else ->
                nodes[nodes[_id].next].locked = false;
            fi
        fi
      :: else ->
        nodes[nodes[_id].next].locked = false;
    fi
}