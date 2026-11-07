package utils

import "core:log"
import "core:strings"
import "core:strconv"
import "core:mem"

// Some utility functions to convert formats and do serializing/deserializing work

//Utility to convert ipv4
convert_dd :: proc(raw: string) -> (converted: [4]u8, ok: bool) {
    log.info("Converting a dotted decimal string")

    split, err := strings.split(raw, ".")
    if err != nil {
        log.errorf("Failed to split dotted decimal string: %v", err)
        return {}, false
    }
    defer delete(split)

    if len(split) != 4 {
        log.errorf("Expected 4 octets in %q, got %d", raw, len(split))
        return {}, false
    }

    for part, i in split {
        val, parse_ok := strconv.parse_int(part, 10)
        if !parse_ok {
            log.errorf("Invalid octet %q in %q", part, raw)
            return {}, false
        }
        if val < 0 || val > 255 {
            log.errorf("Octet out of range: %d (must be 0-255)", val)
            return {}, false
        }
        converted[i] = u8(val)
    }

    return converted, true
}

//Utility to convert mac
convert_mac :: proc (raw: string) -> (converted:[6]u8,ok:bool){
 	log.info("Converting a colon seperated mac string")


	split, err := strings.split(raw, ":")
    if err != nil {
        log.errorf("Failed to split colon seperated hexadecimal string: %v", err)
        return {}, false
    }
    defer delete(split)

    if len(split) != 6 {
        log.errorf("Expected 6 sextets in %q, got %d", raw, len(split))
        return {}, false
    }

    for part, i in split {
        val, parse_ok := strconv.parse_int(part, 16)
        if !parse_ok {
            log.errorf("Invalid sextet %q in %q", part, raw)
            return {}, false
        }
        if val < 0 || val > 255 {
            log.errorf("sextet out of range: %d (must be 0-255)", val)
            return {}, false
        }
        converted[i] = u8(val)
    }

    return converted,true
}

//Utility to serialize a struct
serialize_struct :: proc(s: ^$T) -> []u8 {
    bytes := make([]u8, size_of(T), context.allocator)
    mem.copy(raw_data(bytes), s, size_of(T))
    return bytes
}
