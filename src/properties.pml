#define ftry user[1]@want
#define fcs  user[1]@critical_section
#define stry user[2]@want
#define scs  user[2]@critical_section

ltl mutual_exclusion {[] ( ncrit < 2)}gcc
ltl liveness {[] (ftry -> <>fcs)}
ltl bounded_overtaking {[] ftry -> ( !scs U ( scs U ( !scs U fcs )))}