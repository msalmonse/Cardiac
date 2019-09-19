# JSON format for Cardiac programmes

A Cardiac programme has four parts:

1. PC - the first location to execute.
2. memory - an array with the contents of memory. There is a dictionary for every location with the address and data.
3. input - similar to memory but for the input tape
4. comment - just plain text for the user.

## Example
``` json
{
   "PC": 15,
   "memory": [
      { "addr": 15, "data":  39 },
      { "addr": 16, "data": 139 },
      { "addr": 17, "data": 431 },
      { "addr": 18, "data": 640 },
      { "addr": 19, "data": 139 },
      { "addr": 20, "data": 413 },
      { "addr": 21, "data": 240 },
      { "addr": 22, "data": 640 },
      { "addr": 23, "data": 139 },
      { "addr": 24, "data": 423 },
      { "addr": 25, "data": 410 },
      { "addr": 26, "data": 240 },
      { "addr": 27, "data": 640 },
      { "addr": 28, "data": 540 },
      { "addr": 29, "data": 915 },
      { "addr": 39, "data": 123 },
      { "addr": 99, "data": 800 }
   ],
   "input": [
      { "addr":  0, "data": 123 }
   ],
   "comment": [
       "Reverse the number read from the input i.e. 123 becomes 321"
   ]
}
```
