# orbit systems c language style guide

## indentation
indentation should use 4 spaces per level.

control flow statements with a single statement body should reside on the same line, or inside of a block (preferably the latter if the line is too long):
```c
if (x == y) return 1;

if (x == y) {
    return 1;
}
```

`case`s should match the level of their enclosing `switch`:
```c
switch (x) {
case 1:
    x = 100;
    break;
case 2:
    return bar;
}
```

## case
- use `snake_case` for variables, functions, and structure fields.
- use `PascalCase` for new types.
- use `SCREAMING_SNAKE_CASE` for `#define`'d constants and enums.
- macros should also use this case, but some exceptions are made for utilities like `for_range`.

## comments
prefer line comments (`// this`) in almost every case, except when a large
multi-line description is needed.


## types
use `orbit.h` defined base types whenever possible, especially in data structures.
```rs
i8, i16, i32, i64, isize // integers
u8, u16, u32, u64, usize // unsigned integers
f16, f32, f64 // floating point
bool // boolean
```
when the size of an integer doesn't matter, prefer `isize` and `usize` over `int`.

### structs
when declaring a struct type, use typedef and include the name in the struct definition:
```c
typedef struct MyStructType {
    // ...
} MyStructType;
```

if it's necessary to refer to that type before the definition is available/complete, use a predeclaration:
```c
typedef struct MyStructType MyStructType;
```

### enums
only use `enum` to declare constants, never a type to go with them. To store the enum, use a defined-size integer type, especially in data structures.
```c
enum {
    TOKEN_PLUS,
    TOKEN_MINUS,
    TOKEN_NUMBER,
};

typedef struct Token {
    u8 kind;
    // ...
} Token;
```

### pointers
pointer types, in declarations and parameters, should have the `*` attached to the subtype:
```c
int* xptr = &x;

void modify(int* ptr);
```

## declarations & assignments
never declare or set more than one variable in a declaration statement.
```c
// nuh uh
int x, y, z = 1;

// better
int x;
int y;
int z = 1;
```

extract long expressions out to variables when possible, especially if they're re-used.
```c
// bad
if (expr.as_binop->rhs.type == expr.as_binop->lhs.type) {
    e = expr.as_binop->rhs;
    t = expr.as_binop->rhs.type;
}

// good
Expr rhs = expr.as_binop->rhs;
Expr lhs = expr.as_binop->lhs;
if (rhs.type == lhs.type) {
    e = rhs;
    t = rhs.type;
}
```

## headers
headers should use `#pragma once` instead of `#ifdef` guards.