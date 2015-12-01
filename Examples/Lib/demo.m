
#import "usbserialquery.h"

/*! YOU: edit arguments (in xcode), or manually pass your serial port,

    ie. /dev/tty.usbmodem935591
 */

int main() {

  @autoreleasepool {

    id args = NSProcessInfo.processInfo.arguments;

    __unused char *x = [args count] > 0 ? getInfoForSerialUSB(args[1]) : NULL;

  }
  return 0;
}
