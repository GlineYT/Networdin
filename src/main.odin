package main

import "./tap"
import "./L2"
import "./utils"
import "core:os"
import "core:log"

main :: proc() {
    context.logger = log.create_console_logger(.Debug)
    log.debug("Created logger")
    log.info("Initializing stack")
    log.info("Loading config file")
    conf,ok_load := utils.load_file()
    if !ok_load {
    	log.fatal("Cannot load config file, exiting")
        os.exit(1)
    }

    ip := utils.read_key("IP",conf)
    mac := utils.read_key("MAC",conf)

    log.infof("ip adress as configured is %s",ip)
    log.infof("mac adress as configured is %s",mac)

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
