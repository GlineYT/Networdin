# A (Educational) TAP TCP/IP stack written in ODIN

This is an experimental TCP/IP stack written in odin, though it's scope is not limited to just IPv4 or TCP.

It's primary goal is education/learning in using the odin programming language, and learning of concepts and protocols in the OSI/TCP/IP stack. As it is mainly targeted towards userspace use with a tap device on a desktop-class computer running a modern (6 and up) linux kernel, however it is not a hard requirement.Additionally, no particular effort nor guarantee will be made for portability, backward compatibility, or suitability for use with embedded, freestanding or other constained or otherwise minimal enviroments. You are otherwise free to contribute in whatever manner you see fit, as there are no constraints for protocols, scope or features. Basically, there are no constraints, add whatever, even if it's deprecated, ancient or unheard of.

## How to get started?

Simple: Create a TAP device and run the executable (or compile the source via ```odin build ./main -file```) from the ```/src``` directory. Make sure the TAP device you create isn't already used. 
### Configuration
There is a ```conf.ini``` file under ```/src/config``` it stores a pre-set ip and mac address for the stack, aswell as other configuration. Leave it as-is or change as needed.Additionally a small utility shell script under ```/src/utils/bring_up_devices``` which should bootstrap a tap device. You might need to modify it as you see fit for your specific situation

### Logging

If you find logs to be disruptive, flooding the command line, or otherwise unwanted, run the executable with the "-nl" option.

### Note to contributors

**PRs with the intent to remove or "optimize away" logs will not be accepted.Documentation however, is**

## WARNING

> This software and its authors/developers make no particular effort, nor give any guarantee, to be stable, of good quality, or suitable for production environments or deployments where correctness, stability, quality, or speed are of importance.
