package tap

import "core:sys/linux"
import "core:os"
import "core:log"
import "core:fmt"

Ifreq :: struct {
    name: [16]u8,
}


//IMPORTANT dev_fd is set once in open_tap (called from main) and never reassigned.
//IMPORTANT All writes go through this fd. Do not reassign outside of initialization.
dev_fd: ^os.File

open_tap :: proc(dev_name: string) -> (file: ^os.File, ok: bool) {
    IFF_TAP :: 0x0002
    IFF_NO_PI :: 0x1000
    TUNSETIFF :: 0x400454CA

    log.info("Open_tap: starting")
    log.infof("Opening %s",dev_name)

    f, err := os.open(dev_name, os.O_RDWR)
    if err != nil {
        log.errorf("os.open failed: %v", err)
        log.error("os.open FAILED")
        return nil, false
    }

    log.info("os.open succeeded")
    raw_fd := os.fd(f)
    log.infof("raw_fd = %v", raw_fd)

    log.infof("Building ifreq...")
    ifr: Ifreq
    copy(ifr.name[:], "tap0")
    log.infof(">>> ifr.name = %s", string(ifr.name[:]))

    flags_ptr := cast(^u16)(uintptr(&ifr) + 16)
    flags_ptr^ = IFF_TAP | IFF_NO_PI
    log.infof(">>> flags written: 0x%X", flags_ptr^)

    linux_fd := linux.Fd(raw_fd)
    log.infof("linux_fd = %v", linux_fd)
    log.infof("TUNSETIFF = 0x%X", TUNSETIFF)
    log.infof("calling ioctl...")

    result := linux.ioctl(linux_fd, TUNSETIFF, uintptr(&ifr))

    log.infof("ioctl returned: %v", result)
    log.infof("ioctl result: %v", result)

    if result < 0 {
        log.errorf("ioctl failed with %v", result)
        os.close(f)
        return nil, false
    }

    log.infof("TAP device configured successfully!")
    log.infof("TAP device opened: fd=%v", raw_fd)
    dev_fd = f
    return f, true
}

write_tap:: proc(payload:[]u8,strict := true) -> (error:bool) {
	//Writes arbitrary data through the provided file descriptor
	//NOTE May or may not pad, append src+destination mac, etc. depending on wether or not "strict" is set

	error = false

	log.infof("Writing payload to device file descriptor %v with strict mode set to %v", dev_fd, strict)
	log.infof("Written %d bytes", len(payload))
	bytes_written,wrt_err := os.write(dev_fd,payload)

	if wrt_err != nil{
		error = true
	}
	return error

}
