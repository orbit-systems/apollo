package apollo_lib

import "core:bytes"

APHELION_MAJOR :: 0
APHELION_MINOR :: 3
APHELION_PATCH :: 0

APOLLO_MAJOR :: 1
APOLLO_MINOR :: 0
APOLLO_PATCH :: 0

grow  :: bytes.buffer_grow
read  :: bytes.buffer_read_at

write_u32_at :: proc(buf: ^bytes.Buffer, i: u32, offset: int) {
    x := (transmute([4]byte)i)
    bytes.buffer_write_at(buf, x[:], offset)
}


write :: proc(buf: ^bytes.Buffer, i: $T) {
    i := i
    bytes.buffer_write_ptr(buf, &i, size_of(i))
}

write_byte :: bytes.buffer_write_byte

write_byte_at :: proc(buf: ^bytes.Buffer, i: byte, offset: int) {
    x := (transmute([1]byte)i)
    bytes.buffer_write_at(buf, x[:], offset)
}

init :: proc(obj: ^file) {

    // init header
    obj.header.magic            = {0xB2, 'a', 'p', 'o'}
    obj.header.apollo_version   = {1, 0, 0}
    obj.header.aphelion_version = {0, 3, 0}

}

