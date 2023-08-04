package libapollo

// abstract structure of an apollo file for easier manipulation / construction
apollo_file :: struct {
    header             : header,
    objects            : object_table,
    sections           : section_table,
}

header :: struct {
    apollo_version   : [3]u8,
    aphelion_version : [3]u8,
}

object_table :: [dynamic]object
object :: struct {
    ident : string,
}

section_table :: [dynamic]section
section :: struct { 
    ident     : string,
    obj_index : u64,
    section   : section_data,
}

section_type :: enum u8 {
    program  = 1,
    blank    = 2,
    info     = 3,
    symtab   = 4,
    reftab   = 5,
    metapool = 6,
}

section_data :: union {
    program,
    blank,
    info,
    symtab,
    reftab,
    metapool,
}

program  :: distinct []byte
blank    :: distinct []byte
symtab   :: []symbol
reftab   :: []reference
info     :: []info_entry
metapool :: distinct []byte

symbol :: struct {
    ident : string,

    value : u64,
    size  : u64,

    type          : symbol_type,
    link          : symbol_link,
    reloc_type    : reloc_type,
    section_index : u64,
}

symbol_type :: enum u8 {
    void     = 1,
    function = 2,
    object   = 3,
    section  = 4,
}

symbol_link :: enum u8 {
    undefined = 1,
    global    = 2,
    local     = 3,
    weak      = 4,
}

reloc_type :: enum u8 {
    absolute = 1,
    location = 2,
}

reference :: struct {
    symbol_index  : u64,

    section       : u64,
    byte_offset   : u64,
    bit_offset    : u8,
    size          : u8,

    type : reference_type,
}

reference_type :: enum u8 {
    pc_offset      = 1,
    pc_offset_div4 = 2,
    absolute       = 3,
}

info_entry :: struct {
    key : string,
    value : string,
}