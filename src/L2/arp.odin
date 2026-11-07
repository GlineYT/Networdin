package L2

import "core:log"
import "core:slice"
import "../utils"
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
	log.infof("ARP frame struct is now %v",arp_request)

	// gratiutious ARP check
	if arp_request.oper == 0x0001 && arp_request.tpad == utils.MY_IP && arp_request.spad != arp_request.tpad {
		log.info("This is an ARP request, handling")
		send_arp_response()
	}

}

send_arp_response :: proc() -> (ok:bool){
	log.info("building arp response")

	arp_response : struct #packed{
		//ethernet
		dmac : [6]u8, //destination MAC
		smac : [6]u8, //source MAC
		ethtype : u16be, //ethertype

		//ARP
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

	arp_response.dmac = arp_request.shad
	arp_response.smac = utils.MY_MAC
	arp_response.ethtype = 0x0806

	arp_response.htype = 0x0001
	arp_response.ptype = 0x0800
	arp_response.hlen = 0x06
	arp_response.plen = 0x04
	arp_response.oper = 0x0002
	arp_response.shad = utils.MY_MAC
	arp_response.spad = utils.MY_IP
	arp_response.thad = arp_request.shad
	arp_response.tpad = arp_request.spad


	log.infof("ARP response is %v",arp_response)

	arp_response_frame := utils.serialize_struct(&arp_response) //serialize
	write_error := tap.write_tap(arp_response_frame)

	if write_error {
		log.error("failed sending ARP response")
	}


	return true
}
