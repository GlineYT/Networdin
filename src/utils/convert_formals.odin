package utils

import "core:log"
import "core:strings"

//Some utility functions to convert formats

convert_dd :: proc(raw:string) -> (converted:[]u8) {
	log.info("Converting a dotted decimal string")
	split,err := strings.split(raw,".")

	if err != nil{
		log.infof("Failed to split dotted decimal string with error %v",err)
	}
	log.infof("Split strings are %s:%v",split)
	return converted
}
