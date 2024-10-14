#pragma once

#include <stdalign.h>
#include <stdint.h>

typedef uint8_t bool;
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
typedef int8_t i8;
typedef int16_t i16;
typedef int32_t i32;
typedef int64_t i64;
typedef intptr_t isize;
typedef uintptr_t usize;

/*

 - HEADER
 - SYMBOL TABLE
 - REFERENCE TABLE
 - SECTION INFO TABLE
 - SECTION POOL - 
 - STRING POOL - null-terminated string bytes

*/

typedef struct ApoHeader {
    u8 magic[4];       // {0xF0, 'A', 'P', 'O'}
    u32 version;       // apollo version ID: currently 1
    u64 exec_symbol;   // symbol index to begin execution at, if relevant
    u32 sym_table_len; // offset = HEADER_SIZE
    u32 ref_table_len; // offset = HEADER_SIZE + SYMBOL_SIZE * .sym_table_len
    u32 sec_info_len;  // offset = HEADER_SIZE + SYMBOL_SIZE * .sym_table_len + REF_SIZE * .ref_table_len
    u32 sec_pool_size; // offset = HEADER_SIZE + SYMBOL_SIZE * .sym_table_len + REF_SIZE * .ref_table_len + SEC_INFO_SIZE * .sec_info_len
    u32 str_pool_size; // offset = HEADER_SIZE + SYMBOL_SIZE * .sym_table_len + REF_SIZE * .ref_table_len + SEC_INFO_SIZE * .sec_info_len + sec_pool_size
    u64 _reserved[2]; // reserved for later use
} ApoHeader;

enum ApoSectionKind {
    APO_SEC_KIND_CODE = 0,  // executable
    APO_SEC_KIND_DATA = 1,  // readable and writeable
    APO_SEC_KIND_BLANK = 2, // like data, except it doesn't actually get stored,
                            // just loaded in filled with zero.
    APO_SEC_KIND_RODATA = 3, // only readable
};

typedef struct ApoSectionInfo {
    // address at which this section should be placed.
    u64 address;
    // address alignment requirement for relocating this section.
    u32 address_align;
    // offset into string pool
    u32 name_offset;
    // section kind
    u32 kind;
    // this section's slice of the relocation table
    u32 refs_index;
    u32 refs_len;
    // this section's slice of the section pool
    u32 offset;
    u32 size;
} ApoSectionInfo;

enum ApoSymbolBinding {
    APO_SYM_BIND_LOCAL = 0,
    APO_SYM_BIND_GLOBAL = 1,
    APO_SYM_BIND_WEAK = 2,
};

#define APO_SEC_SYM_UNDEFINED 0xFFFFFFFFull
#define APO_SEC_SYM_ABSOLUTE 0xFFFFFFFEull

/*
    the symbol table should contain a single null entry at index 0.
*/

#define APO_SYM_NULL 0

typedef struct ApoSymbol {
    // offset into string pool
    u32 name_offset;
    // which section does this belong to?
    u32 section_index;
    // where in the section is it defined?
    // symval = sections[.section_index].address + .section_offset
    u32 section_offset;
    // when section_index is APO_SEC_SYM_UNDEFINED, this is ignored
    u32 binding;
} ApoSymbol;

enum ApoReferenceKind {
    APO_REF_D8 = 0,
    APO_REF_D16 = 1,
    APO_REF_D32 = 2,
    APO_REF_D64 = 3,

    // offset should point to the start of an instruction,
    // not the byte the immediate begins.
    APO_REF_IMM_E = 4,
    APO_REF_IMM_RM = 5,
    APO_REF_IMM_IF = 6,
    APO_REF_IMM_B = 7,
    APO_REF_IMM_U = 8,
};

/*
    all references (called relocations in other media) are stored in a large
    table, where all references made in a section are contained in a single
   slice of the table.
*/

// (symbol.value + addend + (ip_relative ? -($ + 4) : 0)) >> shift_left
typedef struct ApoReference {
    // what symbol was referenced?
    u32 symbol_index;
    // offset in current section where the reference must be placed
    u32 offset;
    // what kind of reference is this?
    u8 kind;
    // value computation components
    i8 addend;
    u8 shift_left;
    bool ip_relative;
    u32 addend;
} ApoReference;

enum {
    HEADER_SIZE = sizeof(ApoHeader),
    SYMBOL_SIZE = sizeof(ApoSymbol),
    REF_SIZE = sizeof(ApoReference),
    SEC_INFO_SIZE = sizeof(ApoSectionInfo),

    HEADER_ALIGN = alignof(ApoHeader),
    SYMBOL_ALIGN = alignof(ApoSymbol),
    REF_ALIGN = alignof(ApoReference),
    SECINFO_ALIGN = alignof(ApoSectionInfo),
};