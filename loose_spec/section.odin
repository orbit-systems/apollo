package apollo

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