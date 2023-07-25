package lmao

import apo "libapollo"
import "core:fmt"
import "core:os"

main :: proc() {
    obj : apo.file

    apo.init(&obj)

    append(&(obj.objects), apo.object{ident = "bruh"})

    append(&(obj.sections), apo.section{
        ident        = "_meta_",
        object_index = 0,
        section = apo.info({
            {key="_key1",value="_value1"},
            {key="_key2",value="_value2"},
            {key="_key3",value="_value3"},
            {key="_key4",value="_value4"},
            {key="_key5",value="_value5"},
            {key="_key6",value="_value6"},
            {key="_key7",value="_value7"},
        }),
    })

    append(&(obj.sections), apo.section{
        ident        = ".data",
        object_index = 0,
        section = apo.program({'p', 'r', 'o', 'g', 'r', 'a', 'm'}),
    })

    os.write_entire_file("out.bin", apo.encode(&obj))
}