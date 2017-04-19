#include "commons.pml"

inline release_lock(_n, _id) {
    if
      :: nodes[_id].next == NULL_VAL ->
        byte old_tail;
        fetch_and_store(old_tail, _last_item, NULL_VAL);
        if
          :: old_tail == _id -> skip;
          :: else ->
            byte usurper;
            fetch_and_store(usurper, _last_item, old_tail);
            nodes[_id].next != NULL_VAL
            if
              :: usurper != NULL_VAL ->
                nodes[usurper].next = nodes[_id].next;
              :: else ->
                nodes[nodes[_id].next].locked = false;
            fi
        fi
      :: else ->
        nodes[nodes[_id].next].locked = false;
    fi
}