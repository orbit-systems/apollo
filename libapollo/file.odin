package libapollo

// this is an ABSTRACTED view of an apollo file, for easy manipulation
file :: struct {
    header             : header,
    objects            : object_table,
    sections           : section_table,
}

header :: struct {
    apollo_version   : [3]u8,
    aphelion_version : [3]u8,
}

object_table :: [dynamic]object
object :: struct {
    ident : string,
    ident_offset : u32, // offset in metapool - only used in encoding
}

section_table :: [dynamic]section
section :: struct {
    type         : section_type,    
    ident        : string,
    ident_offset : u32, // offset in metapool - only used in encoding
    object_index : u32, // index of associated object in object table
                        // RESERVED 0xFFFFFFFF for sections not tied to a specific object (sym/reftab, string pool, etc.)
    section      : section_data,
}

section_type :: enum u8 {
    program  = 1,    // program
    symtab   = 2,    // symbol table
    reftab   = 3,    // reference table
    metapool = 4,    // pool of various metadata, like strings
    info     = 5,    // key-value array for storing arbitrary information
}

section_data :: union {
    program,
    symtab,
    reftab,
    metapool,
    info,
}

program  :: []byte
symtab   :: []symbol
reftab   :: []reference
info     :: []info_entry
metapool :: distinct []byte

symbol :: struct {
    ident : string,
    ident_offset : u32, // offset in metapool - don't set (overwritten by encoder anyways)

    value : u64,
    size  : u32,    // size of the associated data, if necessary

    type          : symbol_type,    // type of associated data
    link          : symbol_link,    // local or global
    reloc_type    : reloc_type,     // how should the symbol's value change during linking
    section_index : u32,            // associated section index
}

symbol_type :: enum u8 {
    void     = 1,   // no type information available
    function = 2,   // executable code
    object   = 3,   // data/information
    section  = 4,   // associates with a section, usually the base address of a section (for relocation)
}

symbol_link :: enum u8 {
    undefined = 1,  // symbol is referenced within the object but not defined
    global    = 2,  // symbol is defined and visible to other objects
    local     = 3,  // symbol is defined and local to the object
    weak      = 4,  // symbol is defined and local to the object but may be overridden
}

reloc_type :: enum u8 {
    absolute = 1,   // symbol value does not change
    location = 2,   // symbol value is an offset from the base address of its section
}

reference :: struct {
    symbol_index  : u32,        // associated symbol index

    section       : u32,        // index of section the reference is in
    byte_offset   : u32,        // offset of the reference from the start of the section
    bit_offset    : u8,         // offset from the byte_offset
    size          : u8,         // bit width of the reference (bit width of value to replace)

    ref_type : reference_type,  // how to resolve references
}

reference_type :: enum u8 {
    pc_offset      = 1,         // signed offset from program counter
    pc_offset_div4 = 2,         // signed offset from program counter, divided by 4 (used in branches and jumps)
    absolute       = 3,         // absolute address / value of symbol
}

info_entry :: struct {
    key : string,
    value : string,
    key_offset : u32, // offset in metapool - only used in encoding
    value_offset : u32, // offset in metapool - only used in encoding
}