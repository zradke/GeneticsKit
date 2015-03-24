//
//  GNKTraitConvertible.h
//  GeneticsKit
//
//  Created by Zach Radke on 3/17/15.
//  Copyright (c) 2015 Zach Radke. All rights reserved.
//

#import <GeneticsKit/GNKTrait.h>

/**
 *  Decomposes the receiver into either a key trait, index trait, or a sequence trait composed of the other two. The `.` character represents a split in the key path, while the format `[<number>]` represents an index. Note that the index format must be complete and must contain a number, or else the conversion will fail and `nil` will be returned.
 *
 *  Examples:
 *
 *  ```
 *  // Equivalent to: [GNKTrait traitWithKey:@"keyA"]
 *  id trait = [@"keyA" GNKReceivingTraitValue];
 *
 *  // Equivalent to: [GNKTrait sequenceOfTraits:@[[GNKTrait traitWithKey:@"keyA"], [GNKTrait traitWithIndex:0]]]
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
 *  Converts the receiver into an index trait using the -integerValue method.
 *
 *  Example:
 *
 *  ```
 *  // Equivalent to [GNKTrait traitWithIndex:9]
 *  id trait = [@9 GNKReceivingTraitValue];
 *  ```
 */
@interface NSNumber (GeneticsKit) <GNKSourceTraitConvertible, GNKReceivingTraitConvertible>
@end


/**
 *  Enumerates each index in the receiver into a sequence of index traits. If the receiver has no indexes, it will return `nil`.
 *
 *  Examples:
 *
 *  ```
 *  // Equivalent to [GNKTrait sequenceOfTraits:@[[GNKTrait traitWithIndex:9], [GNKTrait traitWithIndex:4]]]
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
 *  Enumerates the receiver to compose a sequence of traits. The receiver is enumerated in reverse to find a GNKReceivingTrait or GNKReceivingTraitConvertible object, then each GNKSourceTrait or GNKSourceTraitConvertible object is added to the resulting sequence. If the receiver is empty of valid objects, it will return nil.
 *
 *  Examples:
 *
 *  ```
 *  // Equivalent to [GNKTrait sequenceOfTraits:@[[GNKTrait traitWithIndex:8], [GNKTrait identityTrait], [GNKTrait traitWithKey:@"keyA"]]]
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
 *  Converts the receiver into an array which is used as the basis of a sequence of traits.
 */
@interface NSOrderedSet (GeneticsKit) <GNKSourceTraitConvertible, GNKReceivingTraitConvertible>
@end


/**
 *  Enumerates the receiver to form an aggregate of index traits. If the receiver is empty, it will return `nil`.
 *
 *  Examples:
 *
 *  ```
 *  // Equivalent to [GNKTrait aggregateOfTraits:@[[GNKTrait traitWithIndex:8], [GNKTrait traitWithIndex:9]]]
 *  id trait = [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(8,1)] GNKSourceTraitValue];
 *
 *  // Invalid
 *  trait = [[NSIndexSet indexSet] GNKSourceTraitValue]; // nil
 *  ```
 */
@interface NSIndexSet (GeneticsKit) <GNKSourceTraitConvertible>
@end


/**
 *  Enumerates the receiver to form an aggregate of GNKSourceTrait or GNKSourceTraitConvertible objects. If the receiver is empty of valid objects, it will return `nil`.
 *
 *  Examples:
 *
 *  ```
 *  // Equivalent to [GNKTrait aggregateOfTraits:@[[GNKTrait traitWithKey:@"keyA"], [GNKTrait traitWithKey:@"keyB"]]]
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
 *  Returns the identity trait.
 *
 *  Example:
 *
 *  ```
 *  // Equivalent to [GNKTrait identityTrait]
 *  id trait = [[NSNull null] GNKSourceTraitValue];
 *  ```
 */
@interface NSNull (GeneticsKit) <GNKSourceTraitConvertible>
@end
