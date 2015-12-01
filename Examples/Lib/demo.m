
#import "usbserialquery.h"

/*! YOU: edit arguments (in xcode), or manually pass your serial port,

    ie. /dev/tty.usbmodem935591
 */

int main() {

  @autoreleasepool {

    id args = NSProcessInfo.processInfo.arguments, tty;

    if (!(tty = [args count] > 0 ? args[1] : nil)) return 1;

    char *x = getInfoForSerialUSB(tty) ?: NULL;

    printf("%s has info %s",[tty UTF8String], x);

  }

  return 0;
}
