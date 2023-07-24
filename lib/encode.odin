package apollo_lib

import "core:bytes"

encode :: proc(obj: ^file) -> []byte {

    bin : bytes.Buffer
    
    // write header
    write(&bin, obj.header.magic)
    write(&bin, obj.header.apollo_version)
    write(&bin, obj.header.aphelion_version)
    write(&bin, cast(u32) len(obj.objects))
    write(&bin, cast(u32) len(obj.sections)+1) // +1 to account for metadata pool

    return bytes.buffer_to_bytes(&bin)
}