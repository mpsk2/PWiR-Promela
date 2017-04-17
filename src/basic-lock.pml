#include "commons.pml"

int rv;

inline initialize() {
    get_next(rv);
    printf("Basic lock initialization with number: %d\n", rv);    
}

inline acquire_lock(lock, _) {
    printf("Acquire lock of number: %d\n", lock);
    byte value = 1;
    do 
      :: value == 1 -> test_and_set(value, lock);
      :: value == 0 -> break;
    od 
}

inline release_lock(lock, _) {
    printf("Release lock of number: %d\n", lock);
    fetch_and_store(rv, lock, 0);
}

