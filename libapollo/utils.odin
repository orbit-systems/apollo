package libapollo

import "core:bytes"

APHELION_MAJOR :: 0
APHELION_MINOR :: 3
APHELION_PATCH :: 0

APOLLO_MAJOR :: 1
APOLLO_MINOR :: 0
APOLLO_PATCH :: 0

grow  :: bytes.buffer_grow
read  :: bytes.buffer_read_at
write_byte :: bytes.buffer_write_byte
write_bytes :: bytes.buffer_write

write :: proc(buf: ^bytes.Buffer, i: $T) {
    i := i
    bytes.buffer_write_ptr(buf, &i, size_of(i))
}


init :: proc(obj: ^file) {

    // init header
    obj.header.apollo_version   = {APHELION_MAJOR, APHELION_MINOR, APHELION_PATCH}
    obj.header.aphelion_version = {APOLLO_MAJOR, APOLLO_MINOR, APOLLO_PATCH}
}

