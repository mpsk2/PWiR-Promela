#define ftry (user[1]@want)
#define fcs  (user[1]@critical_section)
#define stry (user[2]@want)
#define scs  (user[2]@critical_section)


#ifdef WAITING
#define fwait user[1]@waiting
#define fpass user[1]@waited
#define swait user[2]@waiting
#define spass user[2]@waited
// ltl bounded_overtaking {[] (ftry -> ( !scs U ( scs U ( !scs U fcs ))))}
ltl bounded_overtaking { [] (fwait -> ( !scs U ( scs U ( !scs U fcs ) ) ) ) }
#else
#ifdef FCFS
#define ffcfs (user[1]@fcfs_label)
#define sfcfs (user[2]@fcfs_label)

ltl fcfs {[] ( (ffcfs && (!sfcfs) ) -> ( (!sfcfs) U ( (!scs) U fcs ) ) ) }
#else
ltl mutual_exclusion {[] ( ncrit < 2)}
ltl liveness {[] (ftry -> <>fcs)}
#endif
#endif

