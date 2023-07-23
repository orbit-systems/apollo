package apollo

info_entry :: struct #packed {
    key_offset   : u32,
    key_size     : u32,
    value_offset : u32,
    value_size   : u32,
}