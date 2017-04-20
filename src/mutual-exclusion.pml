/*
  template for SPIN assignment 2017
*/

#ifndef NUM_PROCESSES
#define NUM_PROCESSES 2
#endif
    
#ifdef BASIC 
#include "basic-lock.pml"
#endif

#ifdef ANDERSON
#include "anderson-lock.pml"
#endif

#ifdef MCS 
#include "mcs-lock.pml"
#endif

#ifdef MCSWO 
#include "mcs-wo-lock.pml"
#endif

byte ncrit;        	
    
proctype user(byte id)
{
    assert(_pid == id + 1 && id >= 0 && id < NUM_PROCESSES)

    byte n;

    do 
      :: true ->

local_section:
      if
        :: true -> skip;
        :: true -> false;
      fi

want:
      acquire_lock(n, id);
      ncrit++;

critical_section:
      ncrit--;      
      release_lock(n, id);
   od
}


init
{
  atomic
  {
    byte i;
    initialize();
    i = 0;
    do
      :: i < NUM_PROCESSES ->
         run user(i);
         i++;
      :: else -> break
    od;
    i = 0;
  }
}

#include "properties.pml"

