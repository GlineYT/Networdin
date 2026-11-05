package utils

import "base:runtime"
import "core:log"
import "core:encoding/ini"
import "core:path/filepath"

CONF_FILE := "./config/conf.ini"

load_file::proc() -> (string,bool)  {
	//Returns a map of the file

	abs_path,path_err := filepath.abs(CONF_FILE,context.allocator)
	if path_err != nil {
		log.errorf("Failed to resolve %v",path_err)
		return "",false
	}

	log.infof("Reading configuration file from %s", abs_path)
	conf_map,err,ok := ini.load_map_from_path(abs_path,context.allocator)
	if !ok {
		log.errorf("Failed to read config from %s:%v",abs_path,err)
		return "",false
	}
	log.infof("File map is %v",conf_map)
	log.info("converting to string")
	conf_string := ini.save_map_to_string(conf_map,context.allocator)
	log.infof("Config string is %v",conf_string)
	return conf_string,true
}

read_key :: proc(key: string, conf_string: string) -> (string) {
    log.infof("Reading key %v", key)
    map_iter := ini.iterator_from_string(conf_string)

    for {
        k, v, ok := ini.iterate(&map_iter)
        if !ok { break }
        if k == key { //Sanity check
            return v
        }
    }
    return ""
}
