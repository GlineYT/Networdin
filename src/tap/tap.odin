package tap

import "core:sys/linux"
import "core:os"
import "core:log"
import "core:fmt"

Ifreq :: struct {
    name: [16]u8,
}

dev_fd: ^os.File

open_tap :: proc(dev_name: string) -> (file: ^os.File, ok: bool) {
    IFF_TAP :: 0x0002
    IFF_NO_PI :: 0x1000
    TUNSETIFF :: 0x400454CA

    fmt.println(">>> open_tap: starting")
    log.info("Opening /dev/net/tun...")

    f, err := os.open(dev_name, os.O_RDWR)
    if err != nil {
        log.errorf(">>> os.open failed: %v", err)
        fmt.println(">>> os.open FAILED")
        return nil, false
    }

    fmt.println(">>> os.open succeeded")
    raw_fd := os.fd(f)
    fmt.printfln(">>> raw_fd = %v", raw_fd)

    fmt.println(">>> Building ifreq...")
    ifr: Ifreq
    copy(ifr.name[:], "tap0")
    fmt.printfln(">>> ifr.name = %s", string(ifr.name[:]))

    flags_ptr := cast(^u16)(uintptr(&ifr) + 16)
    flags_ptr^ = IFF_TAP | IFF_NO_PI
    fmt.printfln(">>> flags written: 0x%X", flags_ptr^)

    linux_fd := linux.Fd(raw_fd)
    fmt.printfln(">>> linux_fd = %v", linux_fd)
    fmt.printfln(">>> TUNSETIFF = 0x%X", TUNSETIFF)
    fmt.printfln(">>> calling ioctl...")

    result := linux.ioctl(linux_fd, TUNSETIFF, uintptr(&ifr))

    fmt.printfln(">>> ioctl returned: %v", result)
    log.infof("ioctl result: %v", result)

    if result < 0 {
        log.errorf(">>> ioctl failed with %v", result)
        os.close(f)
        return nil, false
    }

    fmt.println(">>> TAP device configured successfully!")
    log.infof("TAP device opened: fd=%v", raw_fd)
    dev_fd = f
    return f, true
}

write_tap:: proc(payload:[]u8,strict:bool) -> (error:string) {
	//Writes arbitrary data through the provided file descriptor
	//May or may not pad, append src+destination mac, etc. depending on wether or not "strict" is set
	log.infof("Writing payload to device file descriptor",dev_fd,"with strict mode set to ",strict)
	error = "INF_WRT_OK"
	log.infof("Written",len(payload),"bytes")
	bytes_written,wrt_err := os.write(dev_fd,payload)
	return error

}
