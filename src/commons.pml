#define N 100

int next_number = 0;
byte state[N];

inline test_and_set(rv, location) {
    atomic {
        rv = state[location];
        state[location] = 1;
    }
}

inline fetch_and_increment(rv, location) {
    atomic {
        rv = state[location];
        state[location] = rv + 1;
    }
}

inline fetch_and_store(rv, location, value) {
    atomic {
        rv = state[location];
        state[location] = value;
    }
}

inline compare_and_swap(rv, location, val1, val2) {
    atomic {
        if
          :: state[location] == val1 -> rv = 1;
          :: else -> rv = 2;
        fi 
    }
}

inline get_next(rv) {
    atomic {
        rv = next_number;
        next_number = next_number + 1;
    }
}
