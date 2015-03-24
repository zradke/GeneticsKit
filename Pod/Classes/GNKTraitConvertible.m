//
//  GNKTraitConvertible.m
//  GeneticsKit
//
//  Created by Zach Radke on 3/17/15.
//  Copyright (c) 2015 Zach Radke. All rights reserved.
//

#import "GNKTraitConvertible.h"

@implementation NSString (GeneticsKit)

- (id<GNKSourceTrait>)GNKSourceTraitValue
{
    return [self _GNKTraitValue];
}

- (id<GNKReceivingTrait>)GNKReceivingTraitValue
{
    return [self _GNKTraitValue];
}

- (id)_GNKTraitValue
{
    NSArray *keyPaths = [self componentsSeparatedByString:@"."];
    NSMutableArray *traits = [NSMutableArray array];
    
    for (NSString *keyPath in keyPaths)
    {
        NSScanner *scanner = [NSScanner scannerWithString:keyPath];
        
        while (!scanner.isAtEnd)
        {
            NSString *key;
            [scanner scanUpToString:@"[" intoString:&key];
            
            if (key.length > 0)
            {
                [traits addObject:[GNKTrait traitWithKey:key]];
            }
            
            NSInteger index;
            if ([scanner scanString:@"[" intoString:nil])
            {
                if ([scanner scanInteger:&index] &&
                    [scanner scanString:@"]" intoString:nil])
                {
                    [traits addObject:[GNKTrait traitWithIndex:index]];
                }
                else
                {
                    return nil;
                }
            }
        }
    }
    
    if (traits.count == 0)
    {
        return nil;
    }
    else if (traits.count == 1)
    {
        return traits.firstObject;
    }
    else
    {
        return [GNKTrait sequenceOfTraits:traits];
    }
}

@end

@implementation NSNumber (GeneticsKit)

- (id<GNKSourceTrait>)GNKSourceTraitValue
{
    return [self _GNKTraitValue];
}

- (id<GNKReceivingTrait>)GNKReceivingTraitValue
{
    return [self _GNKTraitValue];
}

- (id)_GNKTraitValue
{
    return [GNKTrait traitWithIndex:[self integerValue]];
}

@end

@implementation NSIndexPath (GeneticsKit)

- (id<GNKSourceTrait>)GNKSourceTraitValue
{
    return [self _GNKTraitValue];
}

- (id<GNKReceivingTrait>)GNKReceivingTraitValue
{
    return [self _GNKTraitValue];
}

- (id)_GNKTraitValue
{
    NSMutableArray *traits = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < self.length; i++)
    {
        [traits addObject:[GNKTrait traitWithIndex:[self indexAtPosition:i]]];
    }
    
    return [GNKTrait sequenceOfTraits:traits];
}

@end

@implementation NSArray (GeneticsKit)

- (id<GNKSourceTrait>)GNKSourceTraitValue
{
    return [self _GNKTrait];
}

- (id<GNKReceivingTrait>)GNKReceivingTraitValue
{
    return [self _GNKTrait];
}

- (id)_GNKTrait
{
    NSMutableArray *traits = [NSMutableArray array];
    for (id obj in [self reverseObjectEnumerator])
    {
        // GNKSequenceTrait requires the last object be a GNKReceivingTrait object.
        if (traits.count == 0)
        {
            if ([obj conformsToProtocol:@protocol(GNKReceivingTrait)])
            {
                [traits addObject:obj];
            }
            else if ([obj conformsToProtocol:@protocol(GNKReceivingTraitConvertible)])
            {
                [traits addObject:[obj GNKReceivingTraitValue]];
            }
        }
        else
        {
            if ([obj conformsToProtocol:@protocol(GNKSourceTrait)])
            {
                [traits insertObject:obj atIndex:0];
            }
            else if ([obj conformsToProtocol:@protocol(GNKSourceTraitConvertible)])
            {
                [traits insertObject:[obj GNKSourceTraitValue] atIndex:0];
            }
        }
    }
    
    if (traits.count == 0)
    {
        return nil;
    }
    else
    {
        return [GNKTrait sequenceOfTraits:traits];
    }
}

@end

@implementation NSOrderedSet (GeneticsKit)

- (id<GNKSourceTrait>)GNKSourceTraitValue
{
    return [[self array] GNKSourceTraitValue];
}

- (id<GNKReceivingTrait>)GNKReceivingTraitValue
{
    return [[self array] GNKReceivingTraitValue];
}

@end

@implementation NSIndexSet (GeneticsKit)

- (id<GNKSourceTrait>)GNKSourceTraitValue
{
    NSMutableArray *traits = [NSMutableArray array];
    
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [traits addObject:[GNKTrait traitWithIndex:idx]];
    }];
    
    return [GNKTrait aggregateOfTraits:traits];
}

@end

@implementation NSSet (GeneticsKit)

- (id<GNKSourceTrait>)GNKSourceTraitValue
{
    NSMutableArray *traits = [NSMutableArray array];
    
    for (id obj in self)
    {
        if ([obj conformsToProtocol:@protocol(GNKSourceTrait)])
        {
            [traits addObject:obj];
        }
        else if ([obj conformsToProtocol:@protocol(GNKSourceTraitConvertible)])
        {
            [traits addObject:[obj GNKSourceTraitValue]];
        }
        else
        {
            return nil;
        }
    }
    
    return [GNKTrait aggregateOfTraits:traits];
}

@end

@implementation NSNull (GeneticsKit)

- (id<GNKSourceTrait>)GNKSourceTraitValue
{
    return [GNKTrait identityTrait];
}

@end
