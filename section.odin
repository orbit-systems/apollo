package apollo

section_info_table :: []section_info_entry
section_info_entry :: struct #packed {
    type        : section_type,
    
    ident_offset : u32, // metadata pool
    ident_size   : u32,

    object_index : u32, // index of associated object in object table
    // RESERVED 0xFFFF_FFFF for sections not tied to a specific object (sym/reftab, string pool, etc.)

    section_offset : u32,
    section_size   : u32,
}

section_type :: enum u8 {
    program  = 1,    // program
    symtab   = 2,    // symbol table
    reftab   = 3,    // reference table
    metapool = 4,    // pool of various metadata, like strings
    info     = 5,    // key-value array for storing arbitrary information
}

section_table :: []section
section :: union {
    section_program,
    section_metapool,
    section_symtab,
    section_reftab,
    section_info,
}

section_program  :: struct { data    : []byte }
section_symtab   :: struct { symbols : []symtab_entry }
section_reftab   :: struct { refs    : []reftab_entry }
section_metapool :: struct { data    : []byte }
section_info     :: struct { data    : []info_entry }