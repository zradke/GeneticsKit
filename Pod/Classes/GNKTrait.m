//
//  GNKTrait.m
//  GeneticsKit
//
//  Created by Zach Radke on 3/17/15.
//  Copyright (c) 2015 Zach Radke. All rights reserved.
//

#import "GNKTrait.h"

@interface _GNKIndexTrait : NSObject <GNKReceivingTrait>

- (instancetype)initWithIndex:(NSUInteger)index;

@property (assign, nonatomic, readonly) NSUInteger index;

@end

@interface _GNKKeyTrait : NSObject <GNKReceivingTrait>

- (instancetype)initWithKey:(NSString *)key;

@property (copy, nonatomic, readonly) NSString *key;

@end

@interface _GNKSequenceTrait : NSObject <GNKReceivingTrait>

- (instancetype)initWithSequence:(NSArray *)traits;

@property (copy, nonatomic, readonly) NSArray *sequence;

@end

@interface _GNKAggregateTrait : NSObject <GNKSourceTrait>

- (instancetype)initWithTraits:(NSSet *)traits;

@property (copy, nonatomic, readonly) NSSet *traits;

@end

@interface _GNKIdentityTrait : NSObject <GNKSourceTrait>

+ (instancetype)sharedTrait;

@end


#pragma mark - Public API

id<GNKSourceTrait, GNKReceivingTrait> GNKIndexTrait(NSInteger index)
{
    return [[_GNKIndexTrait alloc] initWithIndex:index];
}

id<GNKSourceTrait, GNKReceivingTrait> GNKKeyTrait(NSString *key)
{
    return [[_GNKKeyTrait alloc] initWithKey:key];
}

id<GNKSourceTrait, GNKReceivingTrait> GNKSequenceTrait(NSArray *traits)
{
    return [[_GNKSequenceTrait alloc] initWithSequence:traits];
}

id<GNKSourceTrait> GNKAggregateTrait(NSArray *traits)
{
    return [[_GNKAggregateTrait alloc] initWithTraits:[NSSet setWithArray:traits]];
}

id<GNKSourceTrait> GNKIdentityTrait()
{
    return [_GNKIdentityTrait sharedTrait];
}


#pragma mark - GNKIndexTrait

@implementation _GNKIndexTrait

- (instancetype)initWithIndex:(NSUInteger)index
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    _index = index;
    
    return self;
}


#pragma mark NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"%ld", (long)self.index];
}

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    else if (![object isKindOfClass:[self class]])
    {
        return NO;
    }
    
    return self.index == [object index];
}

- (NSUInteger)hash
{
    return self.index;
}


#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


#pragma mark GNKSourceTrait

- (id)traitValueFromObject:(id)object
{
    if ([object respondsToSelector:@selector(count)] && [object count] <= self.index)
    {
        return nil;
    }
    
    return object[self.index];
}


#pragma mark GNKReceivingTrait

- (void)setTraitValue:(id)traitValue onObject:(id)object
{
    if ([object respondsToSelector:@selector(count)])
    {
        for (NSUInteger i = [object count]; i < self.index; i++)
        {
            object[i] = [NSNull null];
        }
    }
    
    object[self.index] = traitValue;
}

@end


#pragma mark - GNKKeyTrait

@implementation _GNKKeyTrait

- (instancetype)initWithKey:(NSString *)key
{
    NSParameterAssert(key);
    
    if (!(self = [super init]))
    {
        return nil;
    }
    
    _key = [key copy];
    
    return self;
}


#pragma mark NSObject

- (NSString *)description
{
    return self.key;
}

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    else if (![object isKindOfClass:[self class]])
    {
        return NO;
    }
    
    return [self.key isEqualToString:[object key]];
}

- (NSUInteger)hash
{
    return self.key.hash;
}


#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


#pragma mark GNKSourceTrait

- (id)traitValueFromObject:(id)object
{
    return [object valueForKeyPath:self.key];
}


#pragma mark GNKReceivingTrait

- (void)setTraitValue:(id)traitValue onObject:(id)object
{
    [object setValue:traitValue forKeyPath:self.key];
}

@end


#pragma mark - GNKSequenceTrait

@implementation _GNKSequenceTrait

- (instancetype)initWithSequence:(NSArray *)traits
{
    NSParameterAssert(traits.count > 0);
    
    if (!(self = [super init]))
    {
        return nil;
    }
    
    _sequence = [traits copy];
    
    return self;
}


#pragma mark NSObject

- (NSString *)description
{
    return [self.sequence componentsJoinedByString:@"/"];
}

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    else if (![object isKindOfClass:[self class]])
    {
        return NO;
    }
    
    return [self.sequence isEqualToArray:[object sequence]];
}

- (NSUInteger)hash
{
    return self.sequence.hash;
}


#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


#pragma mark GNKSourceTrait

- (id)traitValueFromObject:(id)object
{
    id traitValue = object;
    
    for (id<GNKSourceTrait> trait in self.sequence)
    {
        traitValue = [trait traitValueFromObject:traitValue];
    }
    
    return traitValue;
}


#pragma mark GNKReceivingTrait

- (void)setTraitValue:(id)traitValue onObject:(id)object
{
    for (id<GNKSourceTrait> trait in [self.sequence subarrayWithRange:NSMakeRange(0, self.sequence.count - 1)])
    {
        object = [trait traitValueFromObject:object];
    }
    
    [self.sequence.lastObject setTraitValue:traitValue onObject:object];
}

@end


#pragma mark - GNKAggregateTrait

@implementation _GNKAggregateTrait

- (instancetype)initWithTraits:(NSSet *)traits
{
    NSParameterAssert(traits.count > 0);
    
    if (!(self = [super init]))
    {
        return nil;
    }
    
    _traits = [traits copy];
    
    return self;
}


#pragma mark NSObject

- (NSString *)description
{
    if (self.traits.count == 1)
    {
        return [self.traits.anyObject description];
    }
    else
    {
        return [NSString stringWithFormat:@"(%@)", [[self.traits allObjects] componentsJoinedByString:@" AND "]];;
    }
}

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    else if (![object isKindOfClass:[self class]])
    {
        return NO;
    }
    
    return [self.traits isEqualToSet:[object traits]];
}

- (NSUInteger)hash
{
    return self.traits.hash;
}


#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


#pragma mark GNKSourceTrait

- (id)traitValueFromObject:(id)object
{
    NSMutableDictionary *traitsForTraitValues = [NSMutableDictionary dictionary];
    
    id traitValue;
    for (id<GNKSourceTrait> trait in self.traits)
    {
        traitValue = [trait traitValueFromObject:object];
        
        if (traitValue)
        {
            traitsForTraitValues[trait] = traitValue;
        }
    }
    
    if (traitsForTraitValues.count == 0)
    {
        return nil;
    }
    
    return [traitsForTraitValues copy];
}

@end


#pragma mark - GNKIdentityTrait

@implementation _GNKIdentityTrait

+ (instancetype)sharedTrait
{
    static _GNKIdentityTrait *sharedTrait;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTrait = [self new];
    });
    
    return sharedTrait;
}


#pragma mark NSObject

- (NSString *)description
{
    return @"<self>";
}


#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


#pragma mark GNKSourceTrait

- (id)traitValueFromObject:(id)object
{
    return object;
}

@end

