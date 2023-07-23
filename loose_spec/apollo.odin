package apollo

/*

Apollo is Aphelion's native object code format, heavliy inspired by ELF and specialized for Aphelion code.

*/

file :: struct #packed {
    header             : apollo_header,
    object_info_table  : object_info_table,
    section_info_table : section_info_table,
    section_table      : section_table,
}

apollo_header :: struct #packed {
    magic : u32,                    // 0x6F_70_61_7A   (0x7A a p o)

    apollo_version_major : u8,      // 1
    apollo_version_minor : u8,      // 0
    apollo_version_patch : u8,      // 0

    aphelion_version_major : u8,
    aphelion_version_minor : u8,
    aphelion_version_patch : u8,

    object_count  : u32,    // number of object entries
    section_count : u32,    // number of section entries
}

object_info_table :: []object_info_entry
object_info_entry :: struct #packed {
    ident_offset : u32,  // metadata pool
    ident_size   : u32,
}

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