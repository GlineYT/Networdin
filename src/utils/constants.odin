package utils

import "core:log"
import "core:os"

CONF_STRING : string
MY_IP : [4]u8
MY_MAC : [6]u8


set_constants :: proc (){
	log.info("Loading config file")
    ok_load : bool
    CONF_STRING,ok_load = load_file()
    if !ok_load {
    	log.fatal("Cannot load config file, exiting")
        os.exit(1)
    }


    ip := read_key("IP",CONF_STRING)
    mac := read_key("MAC",CONF_STRING)

    log.infof("ip adress as configured is %s",ip)
    log.infof("mac adress as configured is %s",mac)

    conv_ok : bool
    MY_IP,conv_ok = convert_dd(ip)
    log.infof("converted ip address is %v",MY_IP)

    MY_MAC,conv_ok = convert_mac(mac)
    log.infof("converted mac address is %v",MY_MAC)
}
