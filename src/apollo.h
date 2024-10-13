#pragma once

#include <stdalign.h>
#include <stdint.h>

typedef uint8_t  bool;
typedef uint8_t  u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
typedef int8_t   i8;
typedef int16_t  i16;
typedef int32_t  i32;
typedef int64_t  i64;
typedef intptr_t  isize;
typedef uintptr_t usize;

/*

 - HEADER
 - SYMBOL TABLE
 - REFERENCE TABLE
 - SECTION INFO TABLE
 - SECTION POOL
 - STRING POOL

*/

typedef struct ApoHeader {
    u8 magic[4];       // {0xF0, 'A', 'P', 'O'}
    u32 sym_table_len; // offset = HEADER_SIZE
    u32 ref_table_len; // offset = HEADER_SIZE + SYMBOL_SIZE * .symtab_len
    u32 sec_info_len;  // offset = HEADER_SIZE + SYMBOL_SIZE * .symtab_len + SEC
    u32 sec_pool_size;
    u32 str_pool_size;
    u64 exec_symbol;
    u64 _reserved[2]; // reserved for later use
} ApoHeader;

enum {
    APO_SEC_KIND_CODE = 0,  // executable
    APO_SEC_KIND_DATA = 1,  // readable and writeable
    APO_SEC_KIND_BLANK = 2, // like data, except it doesn't actually get stored,
                            // just loaded in filled with zero.
    APO_SEC_KIND_RODATA = 3, // only readable
};

typedef struct ApoSectionInfo {
    u64 address;     // address at which this section should be placed.
    u32 name_offset; // offset into string pool
    u32 kind;
    u32 refs_index;
    u32 refs_len;
    u32 offset; // offset into section pool where this section starts
    u32 size;   // size of section binary
} ApoSectionInfo;

enum {
    APO_SYM_BIND_LOCAL = 0,
    APO_SYM_BIND_GLOBAL = 1,
    APO_SYM_BIND_WEAK = 2,
    // APO_SYM_BIND_DYN_IMPORT,
    // APO_SYM_BIND_DYN_EXPORT,
};

enum {
    APO_SEC_SYM_UNDEFINED = (UINT32_MAX - 0),
    APO_SEC_SYM_ABSOLUTE = (UINT32_MAX - 1),
};

typedef struct ApoSymbol {
    // offset into string pool
    u32 name_offset;
    // which section does this belong to?
    u32 section_index;
    // where in the section is it?
    // final value = sections[.section_index] + .section_offset
    u32 section_offset;
    // when section_index is APO_SEC_SYM_UNDEFINED, this is ignored
    u32 binding;
} ApoSymbol;

enum {
    APO_REF_D8 = 0,
    APO_REF_D16 = 1,
    APO_REF_D32 = 2,
    APO_REF_D64 = 3,

    // offset should point to the start of an instruction, not the byte the
    // immediate begins
    APO_REF_IMM_E = 4,
    APO_REF_IMM_RM = 5,
    APO_REF_IMM_IF = 6,
    APO_REF_IMM_B = 7,
    APO_REF_IMM_U = 8,
};

typedef struct ApoReference {
    u32 symbol_index;
    u32 offset; // offset in current section
    u8 kind;
    u8 shift_left;
    bool ip_relative;
    i8 relative_offset;
} ApoReference;

enum {
    HEADER_SIZE = sizeof(ApoHeader),
    SYMBOL_SIZE = sizeof(ApoSymbol),
    REF_SIZE = sizeof(ApoReference),
    SECINFO_SIZE = sizeof(ApoSectionInfo),

    HEADER_ALIGN = alignof(ApoHeader),
    SYMBOL_ALIGN = alignof(ApoSymbol),
    REF_ALIGN = alignof(ApoReference),
    SECINFO_ALIGN = alignof(ApoSectionInfo),
};