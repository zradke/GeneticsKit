//
//  GNKLab.m
//  GeneticsKit
//
//  Created by Zach Radke on 3/20/15.
//  Copyright (c) 2015 Zach Radke. All rights reserved.
//

#import "GNKLab.h"
#import "GNKGene.h"
#import "GNKTrait.h"

static id GNKTraitValue(id object, id<GNKSourceTrait> trait, NSValueTransformer *transformer, GNKLabOptions options)
{
    id value = [trait traitValueFromObject:object];
    
    if ((!(options & GNKLabUseNilValues) && !value) || !transformer)
    {
        return value;
    }
    
    if (!(options & GNKLabSkipPreTranformationNilConversion) && value == [NSNull null])
    {
        value = nil;
    }
    
    value = [transformer transformedValue:value];
    
    if (!(options & GNKLabSkipPostTranformationNullConversion) && !value)
    {
        value = [NSNull null];
    }
    
    return value;
}

@implementation GNKLab

+ (void)transferTraitsFromSource:(id)source receiver:(id)receiver genome:(NSArray *)genome options:(GNKLabOptions)options
{
    NSParameterAssert(source);
    NSParameterAssert(receiver);
    NSParameterAssert(genome.count > 0);
    
    NSOrderedSet *genomeCopy = [NSOrderedSet orderedSetWithArray:genome];
    
    for (GNKGene *gene in genomeCopy)
    {
        id sourceValue = GNKTraitValue(source, gene.sourceTrait, gene.transformer, options);
        if (!(options & GNKLabUseNilValues) && !sourceValue)
        {
            continue;
        }
        
        if (!(options & GNKLabSkipPreSettingNilConversion) && sourceValue == [NSNull null])
        {
            sourceValue = nil;
        }
        
        [gene.receivingTrait setTraitValue:sourceValue onObject:receiver];
    }
}

+ (NSSet *)findGenesWithDifferentTraitsFromSource:(id)source receiver:(id)receiver genome:(NSArray *)genome options:(GNKLabOptions)options
{
    NSParameterAssert(source);
    NSParameterAssert(receiver);
    NSParameterAssert(genome.count > 0);
    
    NSSet *genomeCopy = [NSSet setWithArray:genome];
    NSMutableSet *differentGenes = [NSMutableSet set];
    
    for (GNKGene *gene in genomeCopy)
    {
        id sourceValue = GNKTraitValue(source, gene.sourceTrait, gene.transformer, options);
        id receivingValue = GNKTraitValue(receiver, gene.receivingTrait, nil, options);
        
        if ((!sourceValue && !receivingValue) || (sourceValue && [receivingValue isEqual:sourceValue]))
        {
            continue;
        }
        
        [differentGenes addObject:gene];
    }
    
    return [differentGenes copy];
}

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
