# Upvalue

## Lua

``` Lua
local a, b = 1, 2
local f1 = function ()
  local c, d = 1, 2
  local f2 = function ()
    local e, f = 1, 2
    local f3 = function ()
      return a + b + c + d + e + f
    end
  end
end
```

## Chunk

```
main <stdin:0,0> (4 instructions at 0x7fe0a1c04be0)
0+ params, 3 slots, 1 upvalue, 3 locals, 2 constants, 1 function
        1       [1]     LOADK           0 -1    ; 1
        2       [1]     LOADK           1 -2    ; 2
        3       [10]    CLOSURE         2 0     ; 0x7fe0a1d00110
        4       [10]    RETURN          0 1
constants (2) for 0x7fe0a1c04be0:
        1       1
        2       2
locals (3) for 0x7fe0a1c04be0:
        0       a       3       5
        1       b       3       5
        2       f1      4       5
upvalues (1) for 0x7fe0a1c04be0:
        0       _ENV    1       0

function <stdin:2,10> (4 instructions at 0x7fe0a1d00110)
0 params, 3 slots, 2 upvalues, 3 locals, 2 constants, 1 function
        1       [3]     LOADK           0 -1    ; 1
        2       [3]     LOADK           1 -2    ; 2
        3       [9]     CLOSURE         2 0     ; 0x7fe0a1d00580
        4       [10]    RETURN          0 1
constants (2) for 0x7fe0a1d00110:
        1       1
        2       2
locals (3) for 0x7fe0a1d00110:
        0       c       3       5
        1       d       3       5
        2       f2      4       5
upvalues (2) for 0x7fe0a1d00110:
        0       a       1       0
        1       b       1       1

function <stdin:4,9> (4 instructions at 0x7fe0a1d00580)
0 params, 3 slots, 4 upvalues, 3 locals, 2 constants, 1 function
        1       [5]     LOADK           0 -1    ; 1
        2       [5]     LOADK           1 -2    ; 2
        3       [8]     CLOSURE         2 0     ; 0x7fe0a1d00710
        4       [9]     RETURN          0 1
constants (2) for 0x7fe0a1d00580:
        1       1
        2       2
locals (3) for 0x7fe0a1d00580:
        0       e       3       5
        1       f       3       5
        2       f3      4       5
upvalues (4) for 0x7fe0a1d00580:
        0       a       0       0
        1       b       0       1
        2       c       1       0
        3       d       1       1

function <stdin:6,8> (13 instructions at 0x7fe0a1d00710)
0 params, 2 slots, 6 upvalues, 0 locals, 0 constants, 0 functions
        1       [7]     GETUPVAL        0 0     ; a
        2       [7]     GETUPVAL        1 1     ; b
        3       [7]     ADD             0 0 1
        4       [7]     GETUPVAL        1 2     ; c
        5       [7]     ADD             0 0 1
        6       [7]     GETUPVAL        1 3     ; d
        7       [7]     ADD             0 0 1
        8       [7]     GETUPVAL        1 4     ; e
        9       [7]     ADD             0 0 1
        10      [7]     GETUPVAL        1 5     ; f
        11      [7]     ADD             0 0 1
        12      [7]     RETURN          0 2
        13      [8]     RETURN          0 1
constants (0) for 0x7fe0a1d00710:
locals (0) for 0x7fe0a1d00710:
upvalues (6) for 0x7fe0a1d00710:
        0       a       0       0
        1       b       0       1
        2       c       0       2
        3       d       0       3
        4       e       1       0
        5       f       1       1
```
