# Tape format for Cardiac Programmes

The tape format follows the Cardiac bootstrap format (see the Cardiac Manual Section 13).

The first value is `002` (`inp 2`) and the second is `800` (`jmp 0`). These are combined 
with the fixed value at location 0 of `001` (`inp 1`) to creat a loop that reads the rest of the tape into memory.

Data is stored onto the tape as a location followed by a value. The value is stored at the location.

The final value on the tape should be `9xx` (`hrs start`).
