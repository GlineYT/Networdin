package L2

import "core:slice"
import "core:log"


ethertypeIPv4 := []u8{0x8,0x0} //IPv4 ethertype
ethertypeIPv6 := []u8{0x86,0xdd} //IPv6 ethertype
ethertypeARP := []u8{0x8,0x6} //ARP ethertype

dispatch_frame :: proc(frame:[]u8){
    ethertype := frame[12:14]
    log.infof("Ethertype is %x ",ethertype)

    if slice.equal(ethertypeIPv4,ethertype){ //Slice.equal for comparison
        log.infof("This is an IPv4 packet")
    } else if slice.equal(ethertypeIPv6,ethertype){
        log.infof("This is an IPv6 packet")
    } else if slice.equal(ethertypeARP,ethertype){
        log.infof("This is an ARP request/reply")
        handle_arp(frame)
    }else{
        log.infof("Unknown packet for ethertype %x",ethertype)
    }
}
