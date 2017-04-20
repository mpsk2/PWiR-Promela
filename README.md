# RAPORT

## Author

Michał Piotr Stankiewicz, 335789

## Properties

### Mutual exclusion

[] ( ncrit < 2)

Always number of processes in critical section is lower than 2. 
It is hold by every algorithm presented.

### Liveness

[] (ftry -> <>fcs)

Always if process is waits to enter critical section,
it will eventually enter it. It is only hold by Anderson, MCS and 
MCS-WO for up to 2 processes.

It is symetrical for all processes

### Inevitable waiting

That property is described in task description.
None of processes should hold it, as they always enter
critical section when they are first. It is being tested using assestions.

### Bounded overtaking

[] (fwait -> ( !scs U ( scs U ( !scs U fcs ) ) ) )

Always when first process waits to enter critical section, other process
will enter it at maximum one time. 
It is simetrical for all processes.
It is hold by anderson, MCS and MCS-WO for 2 processes

### First come first served

[] ( (ffcfs && !sfcfs ) -> ( !(sfcfs) U ( !(scs) U fcs ) ) ) 

Always if first process is queued and second not implies second is not queue 
and first will be in critical section and second not.

It is of course symetrical

It is hold by MCS and MCS-WO for 2 processes.

### Sumary

|          | Mutual exclusion | Liveness   | Inevitable waiting | Bounded overtaking | First come first served |
|----------|------------------|------------|--------------------|--------------------|-------------------------|
| Basic    | PASS             | FAIL       | NULL               | FAIL               | NULL                    |
| Anderson | PASS             | PASS       | FAIL               | PASS               | FAIL                    |
| MCS      | PASS             | PASS       | FAIL               | PASS               | PASS                    |
| MCS-WO   | PASS             | PASS for 2 | FAIL               | PASS for 2         | PASS for 2              |