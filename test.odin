package lmao

import apo "lib"
import "core:fmt"

main :: proc() {
    obj : apo.file

    apo.init(&obj)
    fmt.printf("%#v\n", obj)

    for b in apo.encode(&obj) {
        fmt.printf("%2X", b) 
    }
}