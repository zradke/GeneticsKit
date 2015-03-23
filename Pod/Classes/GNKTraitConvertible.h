//
//  GNKTraitConvertible.h
//  GeneticsKit
//
//  Created by Zach Radke on 3/17/15.
//  Copyright (c) 2015 Zach Radke. All rights reserved.
//

#import <GeneticsKit/GNKTrait.h>

/**
 *  Decomposes the receiver into either a GNKKeyTrait, GNKIndexTrait, or GNKSequenceTrait composed of the other two. The `.` character represents a split in the key path, while the format `[<number>]` represents an index. Note that the index format must be complete and must contain a number, or else the conversion will fail and `nil` will be returned.
 *
 *  Examples:
 *
 *  ```
 *  // Equivalent to: GNKKeyTrait(@"keyA")
 *  id trait = [@"keyA" GNKReceivingTraitValue];
 *
 *  // Equivalent to: GNKSequenceTrait(@[GNKKeyTrait(@"keyA"], GNKIndexTrait(0))
 *  trait = [@"keyA[0]" GNKReceivingTraitValue];
 *
 *  // Invalid conversions
 *  trait = [@"" GNKReceivingTraitValue]; // nil
 *  trait = [@"keyA[]" receivingTraitValue]; // nil
 *  ```
 */
@interface NSString (GeneticsKit) <GNKSourceTraitConvertible, GNKReceivingTraitConvertible>
@end

/**
 *  Converts the receiver into a GNKIndexTrait using the -integerValue method.
 *
 *  Example:
 *
 *  ```
 *  // Equivalent to GNKIndexTrait(9)
 *  id trait = [@9 GNKReceivingTraitValue];
 *  ```
 */
@interface NSNumber (GeneticsKit) <GNKSourceTraitConvertible, GNKReceivingTraitConvertible>
@end

/**
 *  Enumerates each index in the receiver into a GNKSequenceTrait of GNKIndexTrait objects. If the receiver has no indexes, it will return `nil`.
 *
 *  Examples:
 *
 *  ```
 *  // Equivalent to GNKSequenceTrait(@[GNKIndexTrait(9), GNKIndexTrait(4)])
 *  NSUInteger indexes[] = {9, 4};
 *  id trait = [[NSIndexPath indexPathWithIndexes:indexes length:2] GNKReceivingTraitValue];
 *
 *  // Invalid
 *  trait = [[NSIndexPath new] GNKReceivingTraitValue]; // nil
 *  ```
 */
@interface NSIndexPath (GeneticsKit) <GNKSourceTraitConvertible, GNKReceivingTraitConvertible>
@end

/**
 *  Enumerates the receiver to compose a GNKSequenceTrait. The receiver is enumerated in reverse to find a GNKReceivingTrait or GNKReceivingTraitConvertible object, then each GNKSourceTrait or GNKSourceTraitConvertible object is added to the resulting GNKSequenceTrait. If the receiver is empty of valid objects, it will return nil.
 *
 *  Examples:
 *
 *  ```
 *  // Equivalent to GNKSequenceTrait(GNKIndexTrait(8), GNKIdentityTrait(), GNKKeyTrait(@"keyA"))
 *  id trait = [@[@8, [NSNull null], @"keyA"] GNKReceivingTraitValue];
 *
 *  // Invalid
 *  trait = [@[] GNKReceivingTraitValue]; // nil
 *  trait = [@[[NSDate date] GNKReceivingTraitValue]; // nil
 *  trait = [@[@9, [NSNull null]] GNKReceivingTraitValue]; // nil
 *  ```
 */
@interface NSArray (GeneticsKit) <GNKSourceTraitConvertible, GNKReceivingTraitConvertible>
@end

/**
 *  Converts the receiver into an array which is used as the basis for a GNKSequenceTrait.
 */
@interface NSOrderedSet (GeneticsKit) <GNKSourceTraitConvertible, GNKReceivingTraitConvertible>
@end

/**
 *  Enumerates the receiver to form a GNKAggregateTrait of GNKIndexTrait objects. If the receiver is empty, it will return `nil`.
 *
 *  Examples:
 *
 *  ```
 *  // Equivalent to GNKAggregateTrait(@[GNKIndexTrait(8), GNKIndexTrait(9)]);
 *  id trait = [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(8,1)] GNKSourceTraitValue];
 *
 *  // Invalid
 *  trait = [[NSIndexSet indexSet] GNKSourceTraitValue]; // nil
 *  ```
 */
@interface NSIndexSet (GeneticsKit) <GNKSourceTraitConvertible>
@end

/**
 *  Enumerates the receiver to form a GNKAggregateTrait of GNKSourceTrait or GNKSourceTraitConvertible objects. If the receiver is empty of valid objects, it will return `nil`.
 *
 *  Examples:
 *
 *  ```
 *  // Equivalent to GNKAggregateTrait(@[GNKKeyTrait(@"keyA"), GNKKeyTrait(@"keyB")]);
 *  id trait = [[NSSet setWithObjects:@"keyA", @"keyB", nil] GNKSourceTraitValue];
 *
 *
 *  // Invalid
 *  trait = [[NSSet set] GNKSourceTraitValue]; // nil
 *  trait = [[NSSet setWithObject:[NSDate date]] GNKSourceTraitValue]; // nil
 *  ```
 */
@interface NSSet (GeneticsKit) <GNKSourceTraitConvertible>
@end

/**
 *  Returns GNKIdentityTrait.
 *
 *  Example:
 *
 *  ```
 *  // Equivalent to GNKIdentityTrait()
 *  id trait = [[NSNull null] GNKSourceTraitValue];
 *  ```
 */
@interface NSNull (GeneticsKit) <GNKSourceTraitConvertible>
@end
