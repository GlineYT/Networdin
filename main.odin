package main

import "./tap"
import "./L2"
import "core:os"
import "core:log"

main :: proc() {
    context.logger = log.create_console_logger(.Debug)
    log.debug("Created logger")
    log.info("Initializing stack")
    file, ok := tap.open_tap("/dev/net/tun")
    if !ok {
        return
    }
    defer os.close(file)

    for {
        buf: [1518]u8 //List of u8's
        n, err := os.read(file, buf[:]

        )  // os.read wants ^File! n is the amount of bytes,
        if err != nil {
            log.errorf("Read failed: %v", err)
            break
        }
        frame := buf[:n] //Take the amount of actual bytes and place them in the frame, stripping the 0's
        log.infof("Read %d bytes", n)
        L2.dispatch_frame(frame[:])
    }
}
