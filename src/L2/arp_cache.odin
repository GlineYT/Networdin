package L2

import "core:log"

ARP_CACHE : map[[4]u8][6]u8 //IP -> MAC


arp_cache_lookup :: proc(ip: [4]u8) -> (mac: [6]u8, ok: bool) {
	log.infof("Looking up mac for ip %v",ip)
    return ARP_CACHE[ip]
}

arp_cache_insert :: proc(ip: [4]u8, mac: [6]u8) {
    if existing, ok := arp_cache_lookup(ip); ok {
        if existing == mac {
            log.infof("ARP cache: %v → %v already present, no change", ip, mac)
            return
        }
        ARP_CACHE[ip] = mac
        log.infof("ARP cache: %v updated %v → %v (cache: %v)", ip, existing, mac, ARP_CACHE)
        return
    }
    ARP_CACHE[ip] = mac
    log.infof("ARP cache: %v → %v inserted (cache: %v)", ip, mac, ARP_CACHE)
}

arp_cache_remove :: proc(ip: [4]u8) {
	log.infof("Removing %v ip from cache",ip)
    delete_key(&ARP_CACHE, ip)
    log.info("ARP cache is now %v",ARP_CACHE)
}

arp_cache_clear :: proc() {
	log.info("Clearing the ARP cache")
    delete(ARP_CACHE)
    ARP_CACHE = nil
}
