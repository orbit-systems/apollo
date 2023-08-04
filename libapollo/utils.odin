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

init :: proc{init_noargs, init_versions}

init_noargs :: proc(mod: ^apollo_file) {

    // init header
    mod.header.apollo_version   = {APHELION_MAJOR, APHELION_MINOR, APHELION_PATCH}
    mod.header.aphelion_version = {APOLLO_MAJOR, APOLLO_MINOR, APOLLO_PATCH}

}

init_versions :: proc(mod: ^apollo_file, apollo_version, aphelion_version: [3]u8) {

    // init header
    mod.header.apollo_version   = apollo_version
    mod.header.aphelion_version = aphelion_version

}

add_object :: proc(mod: ^apollo_file, identifier: string) -> u64 {
    append(&(mod.objects), object{identifier})
    return u64(len(mod.objects)) - 1
}

add_section :: proc(mod: ^apollo_file, s: section) -> u64 {
    append(&(mod.sections), s)
    return u64(len(mod.sections)) - 1
}