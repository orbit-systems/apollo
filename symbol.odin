package apollo

symtab_entry :: struct #packed {
    ident_offset : u32,     // string pool
    ident_size   : u32,

    value : u64,
    size  : u32,    // size of the associated data, if necessary

    type          : symbol_type,    // type of associated data
    link          : symbol_link,    // local or global
    reloc_type    : reloc_type,     // how should the symbol's value change during linking
    section_index : u32,            // index of associated section
}

symbol_type :: enum u8 {
    void     = 0,   // no type information available
    function = 1,   // executable code
    object   = 2,   // data/information
    section  = 3,   // associates with a section, usually the base address of a section (for relocation)
}

symbol_link :: enum u8 {
    undefined = 0,  // symbol is referenced within the object but not defined
    global    = 1,  // symbol is defined and visible to other objects
    local     = 2,  // symbol is defined and local to the object
    weak      = 3,  // symbol is defined but may be merged with a symbol of higher precedence
}

reloc_type :: enum u8 {
    absolute = 0,   // symbol value does not change
    location = 1,   // symbol value changes based on where its associated section is placed (label)
}