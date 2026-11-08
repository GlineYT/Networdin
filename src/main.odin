package main

import "./tap"
import "./L2"
import "./utils"
import "core:os"
import "core:log"
import "core:fmt"


main :: proc() {
	logger: log.Logger
    if len(os.args) > 1 && os.args[1] == "-nl" {
        logger = log.nil_logger()
    }else {
        logger = log.create_console_logger(.Debug)
        log.debug("Created logger, logging ENABLED")
    }
    context.logger = logger

  	log.infof("passed args %v",os.args) // Runs after context.logger is set, so respects no_log
    log.info("Initializing stack")

    utils.set_constants()

    file, ok := tap.open_tap("/dev/net/tun")
    if !ok {
    	log.fatal("Cannot open TAP device, exiting")
        os.exit(1)
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
