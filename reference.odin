package apollo

reftab_entry :: struct #packed {
    symbol_index : u32,         // index of associated symbol

    section_index : u32,        // index of section the reference is in
    offset        : u64,        // offset of the reference from the start of the section
    size          : u8,         // bit width of the reference (bit width of value to replace)

    ref_type : reference_type,  // how to resolve references
}

reference_type :: enum u8 {
    invalid        = 0,         // should never happen
    pc_offset      = 1,         // signed offset from program counter
    pc_offset_div4 = 2,         // signed offset from program counter, divided by 4 (used in branches and jumps)
    absolute       = 3,         // absolute address / value of symbol
}