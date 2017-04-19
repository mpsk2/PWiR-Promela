#define N 100

inline test_and_set(rv, location) {
    atomic {
        rv = location;
        location = 1;
    }
}

inline fetch_and_increment(rv, location) {
    atomic {
        rv = location;
        location = rv + 1;
    }
}

inline fetch_and_store(rv, location, value) {
    atomic {
        rv = location;
        location = value;
    }
}

inline compare_and_swap(rv, location, val1, val2) {
    atomic {
        if
          :: location == val1 -> { location = val2; rv = 1; }
          :: else -> rv = 0;
        fi
    }
}

