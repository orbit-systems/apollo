package libapollo

import "core:bytes"
import "core:fmt"
import "core:mem"

encode :: proc(file_in: ^file) -> []byte {

    obj := new(file)
    obj^ = file_in^ // copy struct - i think this should work?? no fucking idea
    defer free(obj)


    bin     := &bytes.Buffer{}
    
    //bytes.buffer_init(bin, []u8{})

    // compile and add metapool
    metapool_buffer : bytes.Buffer
    append(&(obj.sections), section{
        ident        = "",
        obj_index = 0xFFFFFFFF,
    })
    
    {
        running_pos : u64 = 0
        // add and record object identifiers
        for &o in obj.objects {
            bytes.buffer_write_string(&metapool_buffer, o.ident)
            o.ident_offset = running_pos    // record position in metapool
            running_pos += cast(u64) len(o.ident)
        }
        // add and record section identifiers
        for &s in obj.sections {
            bytes.buffer_write_string(&metapool_buffer, s.ident)
            s.ident_offset = running_pos    // record position in metapool
            running_pos += cast(u64) len(s.ident)
        }
        // add and record symbol identifiers
        for &s in obj.sections {
            if get_section_type(s) != .symtab {
                continue
            }
            for &sym in s.section.(symtab) {
                bytes.buffer_write_string(&metapool_buffer, sym.ident)
                sym.ident_offset = running_pos  // record position in metapool
                running_pos += cast(u64) len(sym.ident)
            }
        }
        // add and record info entries
        for &s in obj.sections {
            if get_section_type(s) != .info {
                continue
            }
            for &info in s.section.(info) {
                bytes.buffer_write_string(&metapool_buffer, info.key)
                info.key_offset = running_pos  // record position in metapool
                running_pos += cast(u64) len(info.key)

                bytes.buffer_write_string(&metapool_buffer, info.value)
                info.value_offset = running_pos  // record position in metapool
                running_pos += cast(u64) len(info.value)
            }
        }
    }
    obj.sections[len(obj.sections)-1].section = metapool(bytes.buffer_to_bytes(&metapool_buffer))


    // write header
    write_bytes(bin, []u8{0xB2, 'a', 'p', 'o'})
    write(bin, obj.header.apollo_version)
    write(bin, obj.header.aphelion_version)
    write(bin, cast(u64) len(obj.objects))
    write(bin, cast(u64) len(obj.sections))
    
    // write object info table
    for o in obj.objects {
        write(bin, o.ident_offset)
        write(bin, cast(u64) len(o.ident))
    }

    // write section info table
    {
        running_pos : u64 = 0
        for s in obj.sections {
            write(bin, u8(get_section_type(s)))

            write(bin, s.ident_offset)
            write(bin, cast(u64) len(s.ident))

            write(bin, running_pos)
            write(bin, get_binary_size(s))
            running_pos += get_binary_size(s)
        }
    }

    // write sections
    {
        for s in obj.sections {
            switch sec_type in s.section {
            case program:
                write_bytes(bin, transmute([]u8) s.section.(program))
            case symtab:
                for sym in s.section.(symtab) {
                    write(bin, sym.ident_offset)
                    write(bin, cast(u64) len(sym.ident))
                    write(bin, sym.value)
                    write(bin, sym.size)
                    write(bin, cast(u8) sym.type)
                    write(bin, cast(u8) sym.link)
                    write(bin, cast(u8) sym.reloc_type)
                    write(bin, sym.section_index)
                }
            case reftab:
                for ref in s.section.(reftab) {
                    write(bin, ref.symbol_index)
                    write(bin, ref.symbol_index)
                    write(bin, ref.byte_offset)
                    write(bin, ref.bit_offset)
                    write(bin, ref.size)
                    write(bin, cast(u8) ref.type)
                }
            case metapool:
                write_bytes(bin, transmute([]u8) s.section.(metapool))
            case info:
                for pair in s.section.(info) {
                    write(bin, pair.key_offset)
                    write(bin, cast(u64) len(pair.key))
                    write(bin, pair.value_offset)
                    write(bin, cast(u64) len(pair.value))
                }
            }
        }
    }

    return bytes.buffer_to_bytes(bin)
}

@(private = "file")
get_binary_size :: proc(sec: section) -> (size: u64) {
    
    switch type in sec.section {
    case program:   size += cast(u64) len(sec.section.(program))
    case symtab:    size += cast(u64) len(sec.section.(symtab))   * 27
    case reftab:    size += cast(u64) len(sec.section.(reftab))   * 15
    case metapool:  size += cast(u64) len(sec.section.(metapool))
    case info:      size += cast(u64) len(sec.section.(info))     * 16
    }
    
    return
}

get_section_type :: proc(sec: section) -> section_type {
    switch type in sec.section {
    case program:   return .program
    case symtab:    return .symtab
    case reftab:    return .reftab
    case metapool:  return .metapool
    case info:      return .info
    }
    
    return .invalid
}