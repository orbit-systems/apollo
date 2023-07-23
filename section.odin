package apollo

section_table_entry :: struct #packed {
    type        : section_type,
    
    name_offset : u32,
    name_size   : u32,

    object_index : u32, // index of associated object in object table
    // RESERVED 0xFFFF_FFFF for sections not tied to a specific object (sym/reftab, string pool, etc.)

    section_offset : u32,
    section_size   : u32,
}

section_type :: enum u8 {
    program = 1,    // program
    symtab  = 2,    // symbol table
    reftab  = 3,    // reference table
    strpool = 4,    // pool of string data
    meta    = 5,    // key-value array metadata
}

section :: union {
    section_program,
    section_strpool,
    section_symtab,
    section_reftab,
    section_meta,
}

section_program :: struct { data    : []byte }
section_symtab  :: struct { symbols : []symtab_entry }
section_reftab  :: struct { refs    : []reftab_entry }
section_strpool :: struct { data    : []byte }
section_meta    :: struct { data    : []meta_entry }