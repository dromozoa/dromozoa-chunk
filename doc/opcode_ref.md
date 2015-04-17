## Contents

* [MOVE](#move)
* [LOADK](#loadk)
* [LOADKX](#loadkx)
* [LOADBOOL](#loadbool)
* [LOADNIL](#loadnil)
* [GETUPVAL](#getupval)
* [GETTABUP](#gettabup)
* [GETTABLE](#gettable)
* [SETTABUP](#settabup)
* [SETUPVAL](#setupval)
* [SETTABLE](#settable)
* [NEWTABLE](#newtable)
* [SELF](#self)
* [ADD](#add)
* [SUB](#sub)
* [MUL](#mul)
* [MOD](#mod)
* [POW](#pow)
* [DIV](#div)
* [IDIV](#idiv)
* [BAND](#band)
* [BOR](#bor)
* [BXOR](#bxor)
* [SHL](#shl)
* [SHR](#shr)
* [UNM](#unm)
* [BNOT](#bnot)
* [NOT](#not)
* [LEN](#len)
* [CONCAT](#concat)
* [JMP](#jmp)
* [EQ](#eq)
* [LT](#lt)
* [LE](#le)
* [TEST](#test)
* [TESTSET](#testset)
* [CALL](#call)
* [TAILCALL](#tailcall)
* [RETURN](#return)
* [FORLOOP](#forloop)
* [FORPREP](#forprep)
* [TFORCALL](#tforcall)
* [TFORLOOP](#tforloop)
* [SETLIST](#setlist)
* [CLOSURE](#closure)
* [VARARG](#vararg)
* [EXTRAARG](#extraarg)
* [GETGLOBAL](#getglobal)
* [SETGLOBAL](#setglobal)
* [CLOSE](#close)

## MOVE

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x00 | 0 | 1 | R | N | ABC  | A B   | `R(A) := R(B)`
| 5.2  | 0x00 | 0 | 1 | R | N | ABC  | A B   | `R(A) := R(B)`
| 5.3  | 0x00 | 0 | 1 | R | N | ABC  | A B   | `R(A) := R(B)`

## LOADK

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x01 | 0 | 1 | K | N | ABx  | A Bx  | `R(A) := Kst(Bx)`
| 5.2  | 0x01 | 0 | 1 | K | N | ABx  | A Bx  | `R(A) := Kst(Bx)`
| 5.3  | 0x01 | 0 | 1 | K | N | ABx  | A Bx  | `R(A) := Kst(Bx)`

## LOADKX

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.2  | 0x02 | 0 | 1 | N | N | ABx  | A     | `R(A) := Kst(extra arg)`
| 5.3  | 0x02 | 0 | 1 | N | N | ABx  | A     | `R(A) := Kst(extra arg)`

## LOADBOOL

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x02 | 0 | 1 | U | U | ABC  | A B C | `R(A) := (Bool)B; if (C) pc++`
| 5.2  | 0x03 | 0 | 1 | U | U | ABC  | A B C | `R(A) := (Bool)B; if (C) pc++`
| 5.3  | 0x03 | 0 | 1 | U | U | ABC  | A B C | `R(A) := (Bool)B; if (C) pc++`

## LOADNIL

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x03 | 0 | 1 | R | N | ABC  | A B   | `R(A) := ... := R(B) := nil`
| 5.2  | 0x04 | 0 | 1 | U | N | ABC  | A B   | `R(A), R(A+1), ..., R(A+B) := nil`
| 5.3  | 0x04 | 0 | 1 | U | N | ABC  | A B   | `R(A), R(A+1), ..., R(A+B) := nil`

## GETUPVAL

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x04 | 0 | 1 | U | N | ABC  | A B   | `R(A) := UpValue[B]`
| 5.2  | 0x05 | 0 | 1 | U | N | ABC  | A B   | `R(A) := UpValue[B]`
| 5.3  | 0x05 | 0 | 1 | U | N | ABC  | A B   | `R(A) := UpValue[B]`

## GETTABUP

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.2  | 0x06 | 0 | 1 | U | K | ABC  | A B C | `R(A) := UpValue[B][RK(C)]`
| 5.3  | 0x06 | 0 | 1 | U | K | ABC  | A B C | `R(A) := UpValue[B][RK(C)]`

## GETTABLE

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x06 | 0 | 1 | R | K | ABC  | A B C | `R(A) := R(B)[RK(C)]`
| 5.2  | 0x07 | 0 | 1 | R | K | ABC  | A B C | `R(A) := R(B)[RK(C)]`
| 5.3  | 0x07 | 0 | 1 | R | K | ABC  | A B C | `R(A) := R(B)[RK(C)]`

## SETTABUP

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.2  | 0x08 | 0 | 0 | K | K | ABC  | A B C | `UpValue[A][RK(B)] := RK(C)`
| 5.3  | 0x08 | 0 | 0 | K | K | ABC  | A B C | `UpValue[A][RK(B)] := RK(C)`

## SETUPVAL

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x08 | 0 | 0 | U | N | ABC  | A B   | `UpValue[B] := R(A)`
| 5.2  | 0x09 | 0 | 0 | U | N | ABC  | A B   | `UpValue[B] := R(A)`
| 5.3  | 0x09 | 0 | 0 | U | N | ABC  | A B   | `UpValue[B] := R(A)`

## SETTABLE

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x09 | 0 | 0 | K | K | ABC  | A B C | `R(A)[RK(B)] := RK(C)`
| 5.2  | 0x0A | 0 | 0 | K | K | ABC  | A B C | `R(A)[RK(B)] := RK(C)`
| 5.3  | 0x0A | 0 | 0 | K | K | ABC  | A B C | `R(A)[RK(B)] := RK(C)`

## NEWTABLE

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x0A | 0 | 1 | U | U | ABC  | A B C | `R(A) := {} (size = B,C)`
| 5.2  | 0x0B | 0 | 1 | U | U | ABC  | A B C | `R(A) := {} (size = B,C)`
| 5.3  | 0x0B | 0 | 1 | U | U | ABC  | A B C | `R(A) := {} (size = B,C)`

## SELF

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x0B | 0 | 1 | R | K | ABC  | A B C | `R(A+1) := R(B); R(A) := R(B)[RK(C)]`
| 5.2  | 0x0C | 0 | 1 | R | K | ABC  | A B C | `R(A+1) := R(B); R(A) := R(B)[RK(C)]`
| 5.3  | 0x0C | 0 | 1 | R | K | ABC  | A B C | `R(A+1) := R(B); R(A) := R(B)[RK(C)]`

## ADD

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x0C | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) + RK(C)`
| 5.2  | 0x0D | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) + RK(C)`
| 5.3  | 0x0D | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) + RK(C)`

## SUB

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x0D | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) - RK(C)`
| 5.2  | 0x0E | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) - RK(C)`
| 5.3  | 0x0E | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) - RK(C)`

## MUL

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x0E | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) * RK(C)`
| 5.2  | 0x0F | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) * RK(C)`
| 5.3  | 0x0F | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) * RK(C)`

## MOD

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x10 | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) % RK(C)`
| 5.2  | 0x11 | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) % RK(C)`
| 5.3  | 0x10 | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) % RK(C)`

## POW

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x11 | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) ^ RK(C)`
| 5.2  | 0x12 | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) ^ RK(C)`
| 5.3  | 0x11 | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) ^ RK(C)`

## DIV

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x0F | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) / RK(C)`
| 5.2  | 0x10 | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) / RK(C)`
| 5.3  | 0x12 | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) / RK(C)`

## IDIV

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.3  | 0x13 | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) // RK(C)`

## BAND

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.3  | 0x14 | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) & RK(C)`

## BOR

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.3  | 0x15 | 0 | 1 | K | K | ABC  | A B C | <code>R(A) := RK(B) &#124; RK(C)</code>

## BXOR

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.3  | 0x16 | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) ~ RK(C)`

## SHL

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.3  | 0x17 | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) << RK(C)`

## SHR

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.3  | 0x18 | 0 | 1 | K | K | ABC  | A B C | `R(A) := RK(B) >> RK(C)`

## UNM

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x12 | 0 | 1 | R | N | ABC  | A B   | `R(A) := -R(B)`
| 5.2  | 0x13 | 0 | 1 | R | N | ABC  | A B   | `R(A) := -R(B)`
| 5.3  | 0x19 | 0 | 1 | R | N | ABC  | A B   | `R(A) := -R(B)`

## BNOT

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.3  | 0x1A | 0 | 1 | R | N | ABC  | A B   | `R(A) := ~R(B)`

## NOT

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x13 | 0 | 1 | R | N | ABC  | A B   | `R(A) := not R(B)`
| 5.2  | 0x14 | 0 | 1 | R | N | ABC  | A B   | `R(A) := not R(B)`
| 5.3  | 0x1B | 0 | 1 | R | N | ABC  | A B   | `R(A) := not R(B)`

## LEN

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x14 | 0 | 1 | R | N | ABC  | A B   | `R(A) := length of R(B)`
| 5.2  | 0x15 | 0 | 1 | R | N | ABC  | A B   | `R(A) := length of R(B)`
| 5.3  | 0x1C | 0 | 1 | R | N | ABC  | A B   | `R(A) := length of R(B)`

## CONCAT

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x15 | 0 | 1 | R | R | ABC  | A B C | `R(A) := R(B) .. ... .. R(C)`
| 5.2  | 0x16 | 0 | 1 | R | R | ABC  | A B C | `R(A) := R(B) .. ... .. R(C)`
| 5.3  | 0x1D | 0 | 1 | R | R | ABC  | A B C | `R(A) := R(B) .. ... .. R(C)`

## JMP

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x16 | 0 | 0 | R | N | AsBx | sBx   | `pc+=sBx`
| 5.2  | 0x17 | 0 | 0 | R | N | AsBx | A sBx | `pc+=sBx; if (A) close all upvalues >= R(A - 1)`
| 5.3  | 0x1E | 0 | 0 | R | N | AsBx | A sBx | `pc+=sBx; if (A) close all upvalues >= R(A - 1)`

## EQ

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x17 | 1 | 0 | K | K | ABC  | A B C | `if ((RK(B) == RK(C)) ~= A) then pc++`
| 5.2  | 0x18 | 1 | 0 | K | K | ABC  | A B C | `if ((RK(B) == RK(C)) ~= A) then pc++`
| 5.3  | 0x1F | 1 | 0 | K | K | ABC  | A B C | `if ((RK(B) == RK(C)) ~= A) then pc++`

## LT

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x18 | 1 | 0 | K | K | ABC  | A B C | `if ((RK(B) < RK(C)) ~= A) then pc++`
| 5.2  | 0x19 | 1 | 0 | K | K | ABC  | A B C | `if ((RK(B) < RK(C)) ~= A) then pc++`
| 5.3  | 0x20 | 1 | 0 | K | K | ABC  | A B C | `if ((RK(B) < RK(C)) ~= A) then pc++`

## LE

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x19 | 1 | 0 | K | K | ABC  | A B C | `if ((RK(B) <= RK(C)) ~= A) then pc++`
| 5.2  | 0x1A | 1 | 0 | K | K | ABC  | A B C | `if ((RK(B) <= RK(C)) ~= A) then pc++`
| 5.3  | 0x21 | 1 | 0 | K | K | ABC  | A B C | `if ((RK(B) <= RK(C)) ~= A) then pc++`

## TEST

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x1A | 1 | 1 | R | U | ABC  | A C   | `if not (R(A) <=> C) then pc++`
| 5.2  | 0x1B | 1 | 0 | N | U | ABC  | A C   | `if not (R(A) <=> C) then pc++`
| 5.3  | 0x22 | 1 | 0 | N | U | ABC  | A C   | `if not (R(A) <=> C) then pc++`

## TESTSET

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x1B | 1 | 1 | R | U | ABC  | A B C | `if (R(B) <=> C) then R(A) := R(B) else pc++`
| 5.2  | 0x1C | 1 | 1 | R | U | ABC  | A B C | `if (R(B) <=> C) then R(A) := R(B) else pc++`
| 5.3  | 0x23 | 1 | 1 | R | U | ABC  | A B C | `if (R(B) <=> C) then R(A) := R(B) else pc++`

## CALL

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x1C | 0 | 1 | U | U | ABC  | A B C | `R(A), ..., R(A+C-2) := R(A)(R(A+1), ..., R(A+B-1))`
| 5.2  | 0x1D | 0 | 1 | U | U | ABC  | A B C | `R(A), ..., R(A+C-2) := R(A)(R(A+1), ..., R(A+B-1))`
| 5.3  | 0x24 | 0 | 1 | U | U | ABC  | A B C | `R(A), ..., R(A+C-2) := R(A)(R(A+1), ..., R(A+B-1))`

## TAILCALL

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x1D | 0 | 1 | U | U | ABC  | A B C | `return R(A)(R(A+1), ..., R(A+B-1))`
| 5.2  | 0x1E | 0 | 1 | U | U | ABC  | A B C | `return R(A)(R(A+1), ..., R(A+B-1))`
| 5.3  | 0x25 | 0 | 1 | U | U | ABC  | A B C | `return R(A)(R(A+1), ..., R(A+B-1))`

## RETURN

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x1E | 0 | 0 | U | N | ABC  | A B   | `return R(A), ... ,R(A+B-2) (see note)`
| 5.2  | 0x1F | 0 | 0 | U | N | ABC  | A B   | `return R(A), ... ,R(A+B-2) (see note)`
| 5.3  | 0x26 | 0 | 0 | U | N | ABC  | A B   | `return R(A), ... ,R(A+B-2) (see note)`

## FORLOOP

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x1F | 0 | 1 | R | N | AsBx | A sBx | `R(A)+=R(A+2); if R(A) <?= R(A+1) then { pc+=sBx; R(A+3)=R(A) }`
| 5.2  | 0x20 | 0 | 1 | R | N | AsBx | A sBx | `R(A)+=R(A+2); if R(A) <?= R(A+1) then { pc+=sBx; R(A+3)=R(A) }`
| 5.3  | 0x27 | 0 | 1 | R | N | AsBx | A sBx | `R(A)+=R(A+2); if R(A) <?= R(A+1) then { pc+=sBx; R(A+3)=R(A) }`

## FORPREP

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x20 | 0 | 1 | R | N | AsBx | A sBx | `R(A)-=R(A+2); pc+=sBx`
| 5.2  | 0x21 | 0 | 1 | R | N | AsBx | A sBx | `R(A)-=R(A+2); pc+=sBx`
| 5.3  | 0x28 | 0 | 1 | R | N | AsBx | A sBx | `R(A)-=R(A+2); pc+=sBx`

## TFORCALL

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.2  | 0x22 | 0 | 0 | N | U | ABC  | A C   | `R(A+3), ..., R(A+2+C) := R(A)(R(A+1), R(A+2));`
| 5.3  | 0x29 | 0 | 0 | N | U | ABC  | A C   | `R(A+3), ..., R(A+2+C) := R(A)(R(A+1), R(A+2));`

## TFORLOOP

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x21 | 1 | 0 | N | U | ABC  | A C   | `R(A+3), ..., R(A+2+C) := R(A)(R(A+1), R(A+2)); if R(A+3) ~= nil then R(A+2)=R(A+3) else pc++`
| 5.2  | 0x23 | 0 | 1 | R | N | AsBx | A sBx | `if R(A+1) ~= nil then { R(A)=R(A+1); pc += sBx }`
| 5.3  | 0x2A | 0 | 1 | R | N | AsBx | A sBx | `if R(A+1) ~= nil then { R(A)=R(A+1); pc += sBx }`

## SETLIST

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x22 | 0 | 0 | U | U | ABC  | A B C | `R(A)[(C-1)*FPF+i] := R(A+i), 1 <= i <= B`
| 5.2  | 0x24 | 0 | 0 | U | U | ABC  | A B C | `R(A)[(C-1)*FPF+i] := R(A+i), 1 <= i <= B`
| 5.3  | 0x2B | 0 | 0 | U | U | ABC  | A B C | `R(A)[(C-1)*FPF+i] := R(A+i), 1 <= i <= B`

## CLOSURE

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x24 | 0 | 1 | U | N | ABx  | A Bx  | `R(A) := closure(KPROTO[Bx], R(A), ..., R(A+n))`
| 5.2  | 0x25 | 0 | 1 | U | N | ABx  | A Bx  | `R(A) := closure(KPROTO[Bx])`
| 5.3  | 0x2C | 0 | 1 | U | N | ABx  | A Bx  | `R(A) := closure(KPROTO[Bx])`

## VARARG

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x25 | 0 | 1 | U | N | ABC  | A B   | `R(A), R(A+1), ..., R(A+B-1) = vararg`
| 5.2  | 0x26 | 0 | 1 | U | N | ABC  | A B   | `R(A), R(A+1), ..., R(A+B-2) = vararg`
| 5.3  | 0x2D | 0 | 1 | U | N | ABC  | A B   | `R(A), R(A+1), ..., R(A+B-2) = vararg`

## EXTRAARG

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.2  | 0x27 | 0 | 0 | U | U | Ax   | Ax    | `extra (larger) argument for previous opcode`
| 5.3  | 0x2E | 0 | 0 | U | U | Ax   | Ax    | `extra (larger) argument for previous opcode`

## GETGLOBAL

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x05 | 0 | 1 | K | N | ABx  | A Bx  | `R(A) := Gbl[Kst(Bx)]`

## SETGLOBAL

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x07 | 0 | 0 | K | N | ABx  | A Bx  | `Gbl[Kst(Bx)] := R(A)`

## CLOSE

| Ver. | Code | T | A | B | C | Mode | Args  | Description
|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------
| 5.1  | 0x23 | 0 | 0 | N | N | ABC  | A     | `close all variables in the stack up to (>=) R(A)`

## Notes

### Mask

| Mask | Description
|:----:|--------------------------------------------
|  N   | argument is not used
|  U   | argument is used
|  R   | argument is a register or a jump offset
|  K   | argument is a constant or register/constant

```
5.1
(*) In OP_CALL, if (B == 0) then B = top. C is the number of returns - 1,
and can be 0: OP_CALL then sets `top'
    to last_result+1, so next open instruction (OP_CALL, OP_RETURN,
OP_SETLIST) may use `top'.

5.2 or 5.3
(*) In OP_CALL, if (B == 0) then B = top. If (C == 0), then 'top' is
set to last_result+1, so next open instruction (OP_CALL, OP_RETURN,
OP_SETLIST) may use 'top'.

(*) In OP_VARARG, if (B == 0) then use actual number of varargs and
set top (like in OP_CALL with C == 0).

(*) In OP_RETURN, if (B == 0) then return up to 'top'.

5.1
(*) In OP_SETLIST, if (B == 0) then B = `top'; if (C == 0) then next
`instruction' is real C

5.2 or 5.3
(*) In OP_SETLIST, if (B == 0) then B = 'top'; if (C == 0) then next
'instruction' is EXTRAARG(real C).

(*) In OP_LOADKX, the next 'instruction' is always EXTRAARG.

(*) For comparisons, A specifies what condition the test should accept
(true or false).

(*) All 'skips' (pc++) assume that next instruction is a jump.
```

### 5.1

```
(*) In OP_CALL, if (B == 0) then B = top. C is the number of returns - 1,
    and can be 0: OP_CALL then sets `top' to last_result+1, so
    next open instruction (OP_CALL, OP_RETURN, OP_SETLIST) may use `top'.

(*) In OP_VARARG, if (B == 0) then use actual number of varargs and
set top (like in OP_CALL with C == 0).

(*) In OP_RETURN, if (B == 0) then return up to `top'

(*) In OP_SETLIST, if (B == 0) then B = `top'; if (C == 0) then next
`instruction' is real C

(*) For comparisons, A specifies what condition the test should accept
(true or false).

(*) All `skips' (pc++) assume that next instruction is a jump
```

### 5.2

```
(*) In OP_CALL, if (B == 0) then B = top. If (C == 0), then `top' is
set to last_result+1, so next open instruction (OP_CALL, OP_RETURN,
OP_SETLIST) may use `top'.

(*) In OP_VARARG, if (B == 0) then use actual number of varargs and
set top (like in OP_CALL with C == 0).

(*) In OP_RETURN, if (B == 0) then return up to `top'.

(*) In OP_SETLIST, if (B == 0) then B = `top'; if (C == 0) then next
'instruction' is EXTRAARG(real C).

(*) In OP_LOADKX, the next 'instruction' is always EXTRAARG.

(*) For comparisons, A specifies what condition the test should accept
(true or false).

(*) All `skips' (pc++) assume that next instruction is a jump.
```

### 5.3

```
(*) In OP_CALL, if (B == 0) then B = top. If (C == 0), then 'top' is
set to last_result+1, so next open instruction (OP_CALL, OP_RETURN,
OP_SETLIST) may use 'top'.

(*) In OP_VARARG, if (B == 0) then use actual number of varargs and
set top (like in OP_CALL with C == 0).

(*) In OP_RETURN, if (B == 0) then return up to 'top'.

(*) In OP_SETLIST, if (B == 0) then B = 'top'; if (C == 0) then next
'instruction' is EXTRAARG(real C).

(*) In OP_LOADKX, the next 'instruction' is always EXTRAARG.

(*) For comparisons, A specifies what condition the test should accept
(true or false).

(*) All 'skips' (pc++) assume that next instruction is a jump.
```



