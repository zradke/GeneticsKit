//
//  GNKLab.h
//  GeneticsKit
//
//  Created by Zach Radke on 3/20/15.
//  Copyright (c) 2015 Zach Radke. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A bitmask of possible options when transfering or comparing objects.
 */
typedef NS_OPTIONS(NSInteger, GNKLabOptions)
{
    /**
     *  The default options.
     */
    GNKLabDefaultOptions = 0,
    /**
     *  Indicates that `nil` raw source values should be allowed to participate in transformation, and after transformation in setting on receiving objects.
     */
    GNKLabUseNilValues = 1 << 0,
    /**
     *  Indicates that `[NSNull null]` raw source values should not be converted to `nil` prior to being fed into the gene transformer.
     */
    GNKLabSkipPreTranformationNilConversion = 1 << 1,
    /**
     *  Indicates that `nil` transformed source values should not be converted into `[NSNull null]` afterwards. Note that this option is has influence on the GNKLabUseNilValues and GNKLabSkipPreSettingNilConversion options.
     */
    GNKLabSkipPostTranformationNullConversion = 1 << 2,
    /**
     *  Indicates that `[NSNull null]` source values should not be converted into `nil` immediately prior to setting them on the receiver.
     */
    GNKLabSkipPreSettingNilConversion = 1 << 3
};

/**
 *  Function which transfers traits from the source object to the receiver object using the GNKGene instances that make up the genome.
 *
 *  Each GNKGene in the genome is undergoes a sequence to transfer its trait value. The exact steps vary depending on the options passed, but by default:
 *
 *  1. The value is retrieved from the source object using the [GNKGene sourceTrait].
 *      a. If the value is `nil`, or there is no transformer, it is immediately returned.
 *      b. If there is a transformer and the value is `[NSNull null]`, it is converted into `nil` before being fed into the transformer.
 *      c. If the transformed value is `nil`, it is converted into `[NSNull null]` before being returned.
 *  2. If the retrieved value was `nil`, the gene is skipped, and the next gene begins the sequence.
 *  3. If the retrieved value was `[NSNull null]`, it is converted into `nil`.
 *  4. The retrieved value is set on the receiver object using the [GNKGene receivingTrait].
 *
 *  Note that almost every step in the default flow can be altered using the various GNKLabOptions which can be bitmasked together.
 *
 *  @param source   The source object which will provide trait values. Depending on the genome provided, some of these values may be transformed. This must not be nil.
 *  @param receiver The receiving object which will have values set on it. This must not be nil.
 *  @param genome   An array of GNKGene objects to follow for retrieving and setting values from the source to the receiver. This must contain at least one gene.
 *  @param options  A bitmask of options to use when transfering traits.
 */
OBJC_EXPORT void GNKLabTransferTraits(id source, id receiver, NSArray *genome, GNKLabOptions options);

/**
 *  Function which compares trait values between objects and finds the genes which do not share common values.
 *
 *  Each GNKGene in the genome is enumerated in a sequence to find and compare the trait values. The exact steps vary depending on the options passed, but by default:
 *
 *  1. The source value is retrieved from the source object using the [GNKGene sourceTrait].
 *      a. If the value is `nil`, or there is no transformer, it is immediately returned.
 *      b. If there is a transformer and the value is `[NSNull null]`, it is converted into `nil` before being fed into the transformer.
 *      c. If the transformed value is `nil`, it is converted into `[NSNull null]` before being returned.
 *  2. The receiving value is retrieved from the receiving object using the [GNKGene receivingTrait].
 *  3. The source and receiving values are compared using -isEqual:. If they are not equal, the gene is added to the returned set.
 *
 *  @param source   The source object which will provide trait values to compare with. Depending on the genome provided, some of these values may be transformed. This must not be nil.
 *  @param receiver The receiving object which will have its trait values compared against. This must not be nil.
 *  @param genome   An array of GNKGene objects to follow for retrieving values from the source and receiver. This must contain at least one gene.
 *  @param options  A bitmask of options to use when retrieving traits. Note that the GNKLabPreSettingNilConversion option is ignored.
 *
 *  @return A set of GNKGene objects which have traits that did not represent equivalent values between the source and receiver.
 */
OBJC_EXPORT NSSet *GNKLabGenesWithDifferentTraits(id source, id receiver, NSArray *genome, GNKLabOptions options);
