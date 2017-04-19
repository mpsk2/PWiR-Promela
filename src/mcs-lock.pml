#include "commons.pml"

inline release_lock(_n, _id) {
    int val;
    if
      :: nodes[_id].next == NULL_VAL ->
        compare_and_swap(val, _last_item, _id, NULL_VAL);
        if
          :: ! val -> { nodes[_id].next != NULL_VAL }
          :: else -> { goto end_release }
        fi
      :: else -> skip
    fi
    nodes[nodes[_id].next].locked = false;
end_release:

}
