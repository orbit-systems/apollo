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
write :: bytes.buffer_write_at

write_u32_at :: proc(buf: ^bytes.Buffer, i: u32, offset: int) {
    x := (transmute([4]byte)i)
    write(buf, x[:], offset)
}

write_u32 :: proc(buf: ^bytes.Buffer, i: u32) {
    x := (transmute([4]byte)i)
    bytes.buffer_write(buf, x[:])
}

write_byte :: bytes.buffer_write_byte

write_byte_at :: proc(buf: ^bytes.Buffer, i: byte, offset: int) {
    x := (transmute([1]byte)i)
    write(buf, x[:], offset)
}

init :: proc(obj: ^file) {

    // init header
    obj.header.magic = 0x6F_70_61_7A
    obj.header.aphelion_version_major = APHELION_MAJOR
    obj.header.aphelion_version_minor = APHELION_MINOR
    obj.header.aphelion_version_patch = APHELION_PATCH
    obj.header.apollo_version_major = APOLLO_MAJOR
    obj.header.apollo_version_minor = APOLLO_MINOR
    obj.header.apollo_version_patch = APOLLO_PATCH

}

encode :: proc(obj: ^file) -> []byte {

    bin : bytes.Buffer
    
    // write header
    write_u32(&bin, obj.header.magic)
    write_byte(&bin, obj.header.aphelion_version_major)
    write_byte(&bin, obj.header.aphelion_version_minor)
    write_byte(&bin, obj.header.aphelion_version_patch)
    write_byte(&bin, obj.header.apollo_version_major)
    write_byte(&bin, obj.header.apollo_version_minor)
    write_byte(&bin, obj.header.apollo_version_patch)
    write_u32(&bin, cast(u32) len(obj.objects))
    write_u32(&bin, cast(u32) len(obj.sections))

    return bytes.buffer_to_bytes(&bin)
}