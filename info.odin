package apollo

info_entry :: struct #packed {
    key_offset   : u32, // metadata pool
    key_size     : u32,
    value_offset : u32, // metadata pool
    value_size   : u32,
}