
#import "MM2200087.h"

@XtraPlan(Data,bits)

_ID bits {

  const uint8_t *bytes = self.bytes;
  return [@(self.length) mapTimes:^id(_Numb i) {

    uint8_t byte = bytes[i.iV];
    return [@7 mapTimes:^id(_Numb num) { return ((byte >> [num iV]) & 1) == 0 ? @"0" : @"1"; }].joined;

  }];
}

_TT hexadecimalString {

  const unsigned char *dBuffer = (const unsigned char *)self.bytes;

  return dBuffer ? [@(self.length) mapTimes:^id(_Numb num) {

    return $(@"%02lx", (unsigned long)dBuffer[num.intValue]);

  }].joined : @"";
}

￭

static id segmentD, lastDisplay;

@Plan MM2200087 @synthesize decimalPlace = _decimalPlace, max = _max, display = _display;


_TT description {

  return $(@"display:%@ ... updated:%@ ... flgs:[%@] ... decimal: %lu ... max: %@",
    _display, $B(_updated), _flags.joinedWithSpaces, _decimalPlace, $B(_max)) ___
}

+ _Void_ initialize {

  segmentD = @{ @"0x00001110" : @"L", @"0x00010101" : @"N", @"0x00110000" : @"1",
                @"0x00110011" : @"4", @"0x01000111" : @"F", @"0x01001110" : @"C",
                @"0x01001111" : @"E", @"0x01011011" : @"5", @"0x01011111" : @"6",
                @"0x01100111" : @"P", @"0x01101101" : @"2", @"0x01110000" : @"7",
                @"0x01111001" : @"3", @"0x01111011" : @"9", @"0x01111110" : @"0",
                @"0x01111111" : @"8"};
}

+ _IsIt_ stop __Data_ stuff {


  return [stuff.hexadecimalString isEqualToString:@"e0"];
}

+ packetWithData __Data_ d { return [self.alloc initWithData:d] ___ }

- initWithData __Data_ d { SUPERINIT; _List allBits = d.bits;

  return allBits.count > 14 || allBits.count < 13 ? nil : ({

    _bits = allBits; _data = d.copy;

    _flags = [@{ @"AUTO" : @[@0, @0],           @"CONTINUITY" : @[@1, @3],
                 @"DIODE" : @[@1, @2],          @"LOW BATTERY" : @[@1, @1],
                 @"HOLD" : @[@1, @0],           @"MIN" : @[@10, @0],
                 @"REL DELTA": @[@10, @1],      @"HFE" : @[@10, @2],
                 @"Percent" : @[@10, @3],       @"SECONDS" : @[@11, @0],
                 @"dBm" : @[@11, @1],           @"n (1e-9)" : @[@11, @2],
                 @"u (1e-6)" : @[@11, @3],      @"m (1e-3)" : @[@12, @0],
                 @"VOLTS" : @[@12, @1],         @"AMPS" : @[@12, @2],
                 @"FARADS"  : @[@12, @3],       @"M (1e6)" : @[@13, @0],
                 @"K (1e3)" :@[@13, @1],        @"OHMS" : @[@13, @2],
                 @"Hz" : @[@13, @3],            @"AC" : @[@0, @2] }

                  filter:^BOOL(id x1, id x2) {

                    NSUInteger bit = [x2[0]uIV], setBit = [x2[1]uIV];
                    id bin = [allBits[bit] letters];

                    return [bin[setBit] bV];

                }].allKeys;


  mList digits = [[@4 to:@1] map:^id(id num) {
    return [self processDigit:[num iV]] ?: @"?";
  }].mC;

  if (_decimalPlace) [digits insertObject:@"." atIndex:_decimalPlace];

  _display = digits.joined;

  if (![lastDisplay isEqualToArray:_bits]) {

      lastDisplay = _bits.copy;
      _updated = YES;
    }
    self;
  });
}

- processDigit:(NSUInteger)dig {

   int rangeStart = dig == 4 ? 2 : dig == 3 ? 4 :
                    dig == 2 ? 6 : dig == 1 ? 8 : 0;

  NSAssert(rangeStart != 0, @"eek, range was %i for [digit: %lu", rangeStart, dig);

  id bins = [_bits subarrayWithRange:(NSRange){rangeStart,2}],
      uno = [bins[0] letters], // substringFromIndex:4].letters,
      dos = [bins[1] letters]; //rsubstringFromIndex:4].letters;

  if ([uno[3] bV]) {
    if (dig == 4) _max = YES;
    else _decimalPlace = 4 - dig;
  }

  id d = @[ /* A */ uno[0], /* F */ uno[1], /* E */ uno[2],
            /* B */ dos[0], /* G */ dos[1], /* C */ dos[2], /* D */ dos[3]];

  return segmentD[@[@"0x0", d[0], d[3], d[5], d[6], d[2], d[1], d[4]].joined];

}

@end


