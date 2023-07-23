package apollo

/*
                           888 888          
                           888 888          
                           888 888          
 8888b.  88888b.   .d88b.  888 888  .d88b.  
    "88b 888 "88b d88""88b 888 888 d88""88b 
.d888888 888  888 888  888 888 888 888  888 
888  888 888 d88P Y88..88P 888 888 Y88..88P 
"Y888888 88888P"   "Y88P"  888 888  "Y88P"  
         888                                
         888                                
         888                                

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