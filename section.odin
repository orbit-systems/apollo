package apollo

section_table_entry :: struct #packed {
    type        : section_type,
    
    name_offset : u32,
    name_size   : u32,

    object_index : u32, // index of associated object in object table

    section_offset : u32,
    section_size   : u32,

}

section :: union {
    section_program,    // code+data
    section_strpool,    // string pool - used throughout the format as a repository for string stuff
    section_symtab,
    section_reftab,
    section_meta,
}

section_type :: enum u8 {
    program = 1,    // program
    symtab  = 2,    // symbol table
    reftab  = 3,    // reference table
    strpool = 4,    // pool of string data
    meta    = 5,    // various metadata
}

section_program :: struct { data    : []byte }
section_symtab  :: struct { symbols : []symtab_entry }
section_reftab  :: struct { refs    : []reftab_entry }
section_strpool :: struct { data    : []byte }
section_meta    :: struct { data    : []meta_entry }