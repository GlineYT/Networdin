package L2

import "core:log"
import "core:slice"
import "../tap"

arp_request : struct #packed{
	htype : u16be, //Hardware type
	ptype : u16be, //Protocol type
	hlen : u8, //Hardware protocol lenght
	plen : u8, //Internet Protocol lenght
	oper : u16be, //Operation
	shad : [6]u8, //Sender hardware address (MAC)
	spad : [4]u8, //Sender protocol address (IPv4
	thad : [6]u8, //Target hardware address (MAC)
	tpad : [4]u8, //Target protocol address (IPv4)

}


handle_arp :: proc(frame:[]u8){
	log.infof("Handling ARP")
	arp_request.htype = slice.to_type(frame[14:16],u16be)
	arp_request.ptype = slice.to_type(frame[16:18],u16be)
	arp_request.hlen = frame[18]
	arp_request.plen = frame[19]
	arp_request.oper = slice.to_type(frame[20:22],u16be)
	arp_request.shad = slice.to_type(frame[22:28],[6]u8)
	arp_request.spad = slice.to_type(frame[28:32],[4]u8)
	arp_request.thad = slice.to_type(frame[32:38],[6]u8)
	arp_request.tpad = slice.to_type(frame[38:42],[4]u8)
	log.infof("ARP frame struct is now",arp_request)

}
