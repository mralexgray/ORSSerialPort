
//  usbserialquery.h - Created by github.com/mralexgray on 12/1/15.

#ifndef usbserialquery_h
#define usbserialquery_h

@import Foundation;

#import "ORSSerialPort.h"
#import "ORSSerialPortManager.h"


NS_INLINE char* getInfoForSerialUSB(id name) {

  NSString * info = @"", *q = [name lastPathComponent].pathExtension;

  for (ORSSerialPort * obj in ORSSerialPortManager.sharedSerialPortManager.availablePorts) {

    if (![q isEqualToString:obj.name]) continue;

    info = [NSString stringWithFormat:@"%08x_%08x\n", obj.vendorID.intValue, obj.productID.intValue];

    break;
  }
  return (char*)info.UTF8String;
}


#endif /* usbserialquery_h */

