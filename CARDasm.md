# CARDasm - The assembler and disassembler for Cardiac

CARDasm is a macOS app that takes a text file and creates a 
[JSON](CardiacJSON.md "JSON format for Cardiac Programmes")
or [Tape](CardiacTape.md "Tape format for Cardiac Programmes")
file suitable for loading into Cardiac.

## CARDasm file format

### Comments
All text from `#` until the end of line is ignored

Lines between `comment` and `endcomment` are added to the JSON output.

### Labels
If the first word on a line end in a colon it is treated a a label for that line. 
Locations 0 and 99 are predefined as `one` and `return` respectively.
If it exists the label `start` is executed first, if not then it is the first executable location.

### Operations
The Cardiac operations are:

* `add <location>` -  
Add the contents of location to the result.  
Location can refer to a label or it can be a number
* `cla <location>` -  
clear the accumulator and add, essentially load the location into the accumulator.
* `hrs <location>` -  
Halt Cardiac and continue at location if Cardiac is restarted.
* `inp <location>` -  
Read a number from the tape and store it in location.
* `jmp <location>` -  
Continue execution at location.
* `out <location>`-  
Write the value at location to the output tape.
* `slr <left> <right>` -  
Shift the accumulator left then right.
* `sto <location>` -  
Store the value in the accumulator in location.  
The accumulator is 4 digits wide while memory is only 3 digits so some truncation can occur.
* `sub <location>` -  
Subtract the contents of location from the accumulator.
* `tac <location>` -  
Jump to location if the accumulator is negative.

### Pseudo-operations

There are three pseudo-operations:

* `bss <count>` -  
Reserve memory, the location is advanced by count
* `data <value>` -  
The value is written at the current location
* `loc <value>` -  
The current location is set to value.
