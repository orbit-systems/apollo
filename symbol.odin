package apollo

symtab_entry :: struct #packed {
    ident_offset : u32,     // metadata pool
    ident_size   : u32,

    value : u64,
    size  : u32,    // size of the associated data, if necessary

    type          : symbol_type,    // type of associated data
    link          : symbol_link,    // local or global
    reloc_type    : reloc_type,     // how should the symbol's value change during linking
    section_index : u32,            // index of associated section
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
    location = 2,   // symbol value changes based on where its associated section is placed (label)
}