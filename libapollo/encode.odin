package libapollo


import "core:bytes"
import "core:fmt"
import "core:mem"

encode :: proc(file_in: ^apollo_file) -> []byte {
    mod := new(apollo_file)
    mod^ = file_in^ // copy struct - i think this should work?? no fucking idea
    defer free(mod)

    bin := &bytes.Buffer{}

    // construct optimized metapool - there is a better way to do this!
    metapool_buffer := &bytes.Buffer{}
    defer bytes.buffer_destroy(metapool_buffer)
    {
        // add object identifiers
        for &o in mod.objects {
            write_string_if_not_exists(metapool_buffer, o.ident)
        }
        // add section identifiers
        for &s in mod.sections {
            write_string_if_not_exists(metapool_buffer, s.ident)
        }
        // add symbol identifiers
        for &s in mod.sections {
            if get_section_type(s) != .symtab { continue }
            for &sym in s.section.(symtab) {
                write_string_if_not_exists(metapool_buffer, sym.ident)
            }
        }
        // add info keys and values
        for &s in mod.sections {
            if get_section_type(s) != .info { continue }
            for &e in s.section.(info) {
                write_string_if_not_exists(metapool_buffer, e.key)
                write_string_if_not_exists(metapool_buffer, e.value)
            }
        }
    }
    

    add_section(mod, {
        "",
        0xFFFF_FFFF,
        metapool(bytes.buffer_to_bytes(metapool_buffer)),
    })




    return bytes.buffer_to_bytes(bin)

}

write_string_if_not_exists :: proc(b: ^bytes.Buffer, s: string) {
    if bytes.index(bytes.buffer_to_bytes(b), transmute([]u8) s) == -1 {
        bytes.buffer_write_string(b, s)
    }
}

@(private = "file")
get_binary_size :: proc(sec: section) -> (size: u64) {
    
    switch type in sec.section {
    case program:   size = cast(u64) len(sec.section.(program))
    case blank:     size = 0
    case info:      size = cast(u64) len(sec.section.(info))     * 32
    case symtab:    size = cast(u64) len(sec.section.(symtab))   * 43
    case reftab:    size = cast(u64) len(sec.section.(reftab))   * 27
    case metapool:  size = cast(u64) len(sec.section.(metapool))
    }
    
    return
}

get_section_type :: proc(sec: section) -> section_type {
    switch type in sec.section {
    case program:   return .program
    case blank:     return .blank
    case symtab:    return .symtab
    case reftab:    return .reftab
    case metapool:  return .metapool
    case info:      return .info
    }
    
    return section_type(0);
}