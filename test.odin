package lmao

import apo "lib"
import "core:fmt"
import "core:os"

main :: proc() {
    obj : apo.file

    apo.init(&obj)
    
    append(&(obj.sections), apo.section{})

    fmt.printf("%#v\n", obj)

    os.write_entire_file("out.bin", apo.encode(&obj))
}