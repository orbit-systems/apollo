package lmao

import apo "libapollo"
import "core:fmt"
import "core:os"

main :: proc() {
    using fmt

    mod : apo.apollo_file

    apo.init(&mod)

    apo.add_object(&mod, "object1")

    os.write_entire_file("out.bin", apo.encode(&mod))
}