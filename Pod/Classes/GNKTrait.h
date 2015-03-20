//
//  GNKTrait.h
//  GeneticsKit
//
//  Created by Zach Radke on 3/17/15.
//  Copyright (c) 2015 Zach Radke. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Protocol which conformers adopt to indicate that they can get a specific trait value from an arbitrary object. Note that conformers of this protocol must also conform to NSCopying.
 *
 *  See GNKIndexTrait, GNKKeyTrait, GNKSequenceTrait, GNKAggregateTrait, and GNKIdentity trait for examples of conformers.
 */
@protocol GNKSourceTrait <NSCopying>
@required

/**
 *  Returns the value associated with the receiver from the given object.
 *
 *  @param object An arbitrary object to acquire the trait value from.
 *
 *  @return The value associated with the receiver from the given object.
 */
- (id)traitValueFromObject:(id)object;

@end


/**
 *  Protocol which conformers adopt to indicate that they can set an arbitrary trait value on an arbitrary object. Note that conformers of this protocol must also conform to GNKSourceTrait.
 *
 *  See GNKIndexTrait, GNKKeyTrait, and GNKSequenceTrait for examples of conformers.
 */
@protocol GNKReceivingTrait <GNKSourceTrait>
@required

/**
 *  Sets a value on the given object.
 *
 *  @param traitValue The value to set on the object.
 *  @param object     The object to set the value on.
 */
- (void)setTraitValue:(id)traitValue onObject:(id)object;

@end


/**
 *  Protocol which non GNKSourceTrait conforming objects can adopt to provide a source trait stand-in.
 */
@protocol GNKSourceTraitConvertible
@required

/**
 *  Returns a GNKSourceTrait representation of the receiver.
 *
 *  @return A GNKSourceTrait conforming object which represents the receiver.
 */
- (id<GNKSourceTrait>)GNKSourceTraitValue;

@end


/**
 *  Protocol which non GNKReceivingTrait conforming objects can adopt to provide a receiving trait stand-in.
 */
@protocol GNKReceivingTraitConvertible
@required

/**
 *  Returns a GNKReceivingTrait representation of the receiver. Note that while GNKReceivingTrait objects can also be used as GNKSourceTrait objects, a class may conform to both GNKReceivingTraitConvertible and GNKSourceTraitConvertible to provide different objects for each.
 *
 *  @return A GNKReceivingTrait conforming object which represents the receiver.
 */
- (id<GNKReceivingTrait>)GNKReceivingTraitValue;

@end


#pragma mark - Trait functions

/**
 *  Creates a GNKReceivingTrait conforming object which represents a specific index. This trait can be used to retrieve a value at the given index from an arbitrary object, or set a value at the given index for an arbitrary object.
 *
 *  This trait's implementation of GNKSourceTrait and GNKReceivingTrait attempts "nice" value getting and setting. If the passed object responds to the -count method, that will first be checked to ensure the trait's index is represented, and return `nil` if not. Similarly, while setting, if the passed object responds to -count, the difference between the count and the trait's index will be populated with `[NSNull null]` to avoid throwing exceptions.
 *
 *  Example source object: NSArray
 *  Example receiving object: NSMutableArray
 *
 *  @param index The index that the trait should represent.
 *
 *  @return A GNKReceivingTrait conforming object which represents the given index.
 */
FOUNDATION_EXPORT id<GNKReceivingTrait> GNKIndexTrait(NSInteger index);

/**
 *  Creates a GNKReceivingTrait conforming object which represents a specific key-value coding key-path. This trait can be used to retrieve a value for the given key-path from an arbitrary object, or set a value at the given key-path on an arbitrary object.
 *
 *  Example source object: NSDictionary
 *  Example receiving object: NSMutableDictionary
 *
 *  @param key The key-path that the trait should represent. This must not be nil.
 *
 *  @return A GNKReceivingTrait conforming object which represents the given key-path.
 */
FOUNDATION_EXPORT id<GNKReceivingTrait> GNKKeyTrait(NSString *key);

/**
 *  Creates a GNKReceivingTrait conforming object which follows a sequence of other traits to get and set values.
 *
 *  When getting a trait value, each trait in the traits array is enumerated, with the returned value of one trait becoming the object for the next trait. Similarly, when setting a trait value, all but the last trait in the traits array are enumerated to acquire the an object which is passed to the final trait along with the requested trait value. Because of this, only the final trait must conform to GNKReceivingTrait. All other objects need only conform to GNKSourceTrait.
 *
 *  @param traits An array of trait objects. This must contain at least one object, and the last object must be a GNKReceivingTrait conformer.
 *
 *  @return A GNKReceivingTrait conforming object which represents a sequence of other traits.
 */
FOUNDATION_EXPORT id<GNKReceivingTrait> GNKSequenceTrait(NSArray *traits);

/**
 *  Creates a GNKSourceTrait conforming object which aggregates all trait values into a single dictionary.
 *
 *  Although an array of traits is passed, the order of the traits is irrelevant. When getting a trait value, the trait will query each of its sub-traits to get their trait values from the passed object, then combine them into a dictionary where the keys are the traits and the values their corresponding returned values. Note that because of this, if a sub-trait returns `nil`, it is excluded from the returned aggregate dictionary.
 *
 *  @param traits An array of GNKSourceTrait conforming objects. This must contain at least one object.
 *
 *  @return A GNKSourceTrait conforming object which simultaneously represents all the given traits.
 */
FOUNDATION_EXPORT id<GNKSourceTrait> GNKAggregateTrait(NSArray *traits);

/**
 *  Creates a basic GNKSourceTrait conforming object which will simply echo given objects as trait values.
 *
 *  This can be useful along with a transformer when the other basic traits are not suitable.
 *
 *  @return A GNKSource trait conforming object which represents the identity of any object.
 */
FOUNDATION_EXPORT id<GNKSourceTrait> GNKIdentityTrait();
