# Tape format for Cardiac Programmes

The tape format follows the Cardiac bootstrap format (see the Cardiac Manual Section 13).

The first value is `002` (`inp 2`) and the second is `800` (`jmp 0`). These are combined 
with the fixed value at location 0 of `001` (`inp 1`) to creat a loop that reads the rest of the tape into memory.

Data is stored onto the tape as a location followed by a value. The value is stored at the location.

The final value on the tape should be `9xx` (`hrs start`) unless there is data defined with tape statements,
in that case the tape data is appended after the `hrs`.

## Tape file format

The data is stored on disk as pairs of characters. The Cardiac data is between 0 and 999 and this is encoded in base 32
before being written as two characters to disk. The value 0 become 0x3030 or "00" etc. using the following characters:
"0123456789ABCDEFHJKLMNPRSTUVWXYZ", "G", "I", "O" and "Q" are excluded as it is easy to mistake them for numbers.
Illegal values are stored as 0x3f3f or "??".

### Comments on tape

The data portion of a tape file ends with 0x7e0a or "\~\\n", everything after that is a comment.
