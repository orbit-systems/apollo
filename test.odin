package lmao

import apo "libapollo"
import "core:fmt"
import "core:os"

main :: proc() {
    using fmt

    obj : apo.apollo_file

    apo.init(&obj)

    //os.write_entire_file("out.bin", apo.encode(&obj))
}