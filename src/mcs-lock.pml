#include "commons.pml"

inline release_lock(_n, _id) {
    int val;
    if
      :: nodes[_id].next == 0 ->
        compare_and_swap(val, _last, _id, 0);
        if
          :: val -> skip;
          :: else ->
            do
              :: nodes[_id].next == 0 -> skip;
              :: else -> break;
            od
        fi
      :: else -> skip;
    fi
}
