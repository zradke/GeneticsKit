//
//  GNKTraitConvertible.h
//  GeneticsKit
//
//  Created by Zach Radke on 3/17/15.
//  Copyright (c) 2015 Zach Radke. All rights reserved.
//

#import <GeneticsKit/GNKTrait.h>

/**
 *  Decomposes the receiver into either a GNKKeyTrait, GNKIndexTrait, or GNKSequenceTrait composed of the other two. The '.' character represents a split in the key path, while the format '[<number>]' represents an index. Note that the index format must be complete and must contain a number, or else the conversion will fail and `nil` will be returned.
 */
@interface NSString (GeneticsKit) <GNKSourceTraitConvertible, GNKReceivingTraitConvertible>
@end

/**
 *  Converts the receiver into a GNKIndexTrait using the -integerValue method.
 */
@interface NSNumber (GeneticsKit) <GNKSourceTraitConvertible, GNKReceivingTraitConvertible>
@end

/**
 *  Enumerates each index in the receiver into a GNKSequenceTrait of GNKIndexTrait objects.
 */
@interface NSIndexPath (GeneticsKit) <GNKSourceTraitConvertible, GNKReceivingTraitConvertible>
@end

/**
 *  Enumerates the receiver to compose a GNKSequenceTrait. The receiver is enumerated in reverse to find a GNKReceivingTrait or GNKReceivingTraitConvertible object, then each GNKSourceTrait or GNKSourceTraitConvertible object is added to the resulting GNKSequenceTrait.
 */
@interface NSArray (GeneticsKit) <GNKSourceTraitConvertible, GNKReceivingTraitConvertible>
@end

/**
 *  Converts the receiver into an array which is used as the basis for a GNKSequenceTrait.
 */
@interface NSOrderedSet (GeneticsKit) <GNKSourceTraitConvertible, GNKReceivingTraitConvertible>
@end

/**
 *  Enumerates the receiver to form a GNKAggregateTrait of GNKIndexTrait objects.
 */
@interface NSIndexSet (GeneticsKit) <GNKSourceTraitConvertible>
@end

/**
 *  Enumerates the receiver to form a GNKAggregateTrait of GNKSourceTrait or GNKSourceTraitConvertible objects.
 */
@interface NSSet (GeneticsKit) <GNKSourceTraitConvertible>
@end

/**
 *  Returns GNKIdentityTrait.
 */
@interface NSNull (GeneticsKit) <GNKSourceTraitConvertible>
@end
