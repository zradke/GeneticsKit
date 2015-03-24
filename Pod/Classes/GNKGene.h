//
//  GNKGene.h
//  GeneticsKit
//
//  Created by Zach Radke on 3/17/15.
//  Copyright (c) 2015 Zach Radke. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GNKSourceTrait, GNKReceivingTrait;


#define GNKMakeGene(...) GNK_DISPATCHER(GNK_GENE_, __VA_ARGS__) (__VA_ARGS__)

/**
 *  A GNKGene represents the mapping of one trait to another. In this sense, a gene signifies that two traits are equivalent, though perhaps interacting with different objects. Values are transfered using the gene from the source trait to the receiver trait. If a transformer is provided, it will be used on the value returned by the source trait before being set using the receiving trait.
 *
 *  Typically, GNKGene instances are initialized using the convenience macro `GNKMakeGene(...)`, which accepts from 1 to 3 arguments. These arguments are processed and used to populate the parameters of GNKGene -initWithSourceTrait:receivingTrait:transformer: based on the argument type. Acceptable arguemnt types include objects, selectors, and primitive numbers. Selectors are converted into NSString instances and primitive numbers to NSNumber instances.
 *
 *  Some examples:
 *  
 *  ```
 *  // Equivalent to [[GNKGene alloc] initWithSourceTrait:[GNKTrait traitWithKey:@"keyA"] receivingTrait:[GNKTrait traitWithKey:@"keyA"] transformer:nil];
 *  GNKGene *gene = GNKMakeGene(@selector(keyA));
 *
 *  // Equivalent to [[GNKGene alloc] initWithSourceTrait:[GNKTrait traitWithKey:@"keyA"] receivingTrait:[GNKTrait traitWithIndex:0] transformer:nil];
 *  gene = GNKMakeGene(@"keyA", 0);
 *
 *  NSValueTransformer *transformer = ...;
 *
 *  // Equivalent to [[GNKGene alloc] initWithSourceTrait:[GNKTrait traitWithKey:@"keyA"] receivingTrait:[GNKTrait traitWithIndex:0] transformer:transformer];
 *  gene = GNKMakeGene(@"keyA", @0, transformer);
 *
 *  // Equivalent to [[GNKGene alloc] initWithSourceTrait:[GNKTrait traitWithKey:@"keyA"] receivingTrait:[GNKTrait traitWithKey:@"keyA"] transformer:transformer];
 *  gene = GNKMakeGene(@selector(keyA), transformer);
 *  ```
 */
@interface GNKGene : NSObject <NSCopying>

/**
 *  Initializes the receiver with the mapping from the source trait to the receiving trait. This is the designated initializer.
 *
 *  @param sourceTrait    The source trait. In terms of transfering trait values, this trait is used to retrieve the trait value that will be set. This trait is the only one whose trait values are transformed by the gene's transformer. This must not be nil.
 *  @param receivingTrait The receiving trait. In terms of transfering trait values, this trait is used to set the source trait's value. This trait is not affected by the transformer. This must not be nil.
 *  @param transformer    An optional transformer which will be applied to source trait values.
 *
 *  @return An initialized instance of the receiver.
 */
- (instancetype)initWithSourceTrait:(id<GNKSourceTrait>)sourceTrait
                     receivingTrait:(id<GNKReceivingTrait>)receivingTrait
                        transformer:(NSValueTransformer *)transformer NS_DESIGNATED_INITIALIZER __attribute((nonnull (1,2)));

/**
 *  The source trait used for retrieving trait values. Source values are transformed by the transformer if available.
 */
@property (copy, nonatomic, readonly) id sourceTrait;

/**
 *  The receiving trait used to both set and retrieve trait values. Receiving values are not transformed by the transformer.
 */
@property (copy, nonatomic, readonly) id receivingTrait;

/**
 *  The transformer applied to the sourceTrait.
 */
@property (strong, nonatomic, readonly) NSValueTransformer *transformer;

/**
 *  Checks if the receiver has the same properties as the passed gene.
 *
 *  @param gene The gene to compare against.
 *
 *  @return YES if the genes have equivalent properties. NO if they do not.
 */
- (BOOL)isEqualToGene:(GNKGene *)gene;

/**
 *  Checks if the receiver can be inverted.
 *
 *  @see invertedGene
 *
 *  @return YES if the receiver can be inverted, NO if it cannot be.
 */
- (BOOL)canInvertGene;

/**
 *  Creates an inverted gene from the receiver by swapping the source and receiving traits and reversing the transformer if set.
 *
 *  @note This method will return nil if the receiver cannot be inverted.
 *
 *  @see canInvertGene
 *
 *  @return An inverted copy of the receiver.
 */
- (instancetype)invertedGene;

@end


#define _GNK_NARGS(unused, _1, _2, _3, VAL, ...) VAL
#define GNK_NARGS(...) _GNK_NARGS(unused, ## __VA_ARGS__, 3, 2, 1, 0)

#define GNK_DISPATCHER(MACRO, ...) _GNK_DISPATCHER(MACRO, GNK_NARGS(__VA_ARGS__))
#define _GNK_DISPATCHER(MACRO, NARGS) __GNK_DISPATCHER(MACRO, NARGS)
#define __GNK_DISPATCHER(MACRO, NARGS) MACRO ## NARGS

#define GNK_GENE_0(...) GNKGeneFromArgs(nil, nil, nil)
#define GNK_GENE_1(ARG, ...) GNKGeneFromArgs(GNK_OBJ_CONVERT(ARG), nil, nil)
#define GNK_GENE_2(ARG1, ARG2, ...) GNKGeneFromArgs(GNK_OBJ_CONVERT(ARG1), GNK_OBJ_CONVERT(ARG2), nil)
#define GNK_GENE_3(ARG1, ARG2, ARG3, ...) GNKGeneFromArgs(GNK_OBJ_CONVERT(ARG1), GNK_OBJ_CONVERT(ARG2), GNK_OBJ_CONVERT(ARG3))

#define GNK_OBJ_CONVERT(VAL) GNKGeneConvertToObject(@encode(__typeof__((VAL))), (VAL))

FOUNDATION_EXPORT GNKGene *GNKGeneFromArgs(id arg1, id arg2, id arg3) __attribute((nonnull (1)));
FOUNDATION_EXPORT id GNKGeneConvertToObject(const char *type, ...);