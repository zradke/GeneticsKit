//
//  GNKGene.m
//  GeneticsKit
//
//  Created by Zach Radke on 3/17/15.
//  Copyright (c) 2015 Zach Radke. All rights reserved.
//

#import "GNKGene.h"
#import "GNKTrait.h"

@implementation GNKGene

#pragma mark - API

- (instancetype)initWithSourceTrait:(id<GNKSourceTrait>)sourceTrait receivingTrait:(id<GNKReceivingTrait>)receivingTrait transformer:(NSValueTransformer *)transformer
{
    NSParameterAssert(sourceTrait);
    NSParameterAssert(receivingTrait);
    
    if (!(self = [super init]))
    {
        return nil;
    }
    
    _sourceTrait = [(id)sourceTrait copy];
    _receivingTrait = [(id)receivingTrait copy];
    _transformer = transformer;
    
    return self;
}

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return [self initWithSourceTrait:nil receivingTrait:nil transformer:nil];
}

- (BOOL)isEqualToGene:(GNKGene *)gene
{
    if (!gene)
    {
        return NO;
    }
    
    BOOL equalSourceTraits = [self.sourceTrait isEqual:gene.sourceTrait];
    BOOL equalReceivingTraits = [self.receivingTrait isEqual:gene.receivingTrait];
    BOOL equalTransformers = (!self.transformer && !gene.transformer) || (gene.transformer && [self.transformer isEqual:gene.transformer]);
    
    return equalSourceTraits && equalReceivingTraits && equalTransformers;
}

- (id)sourceValueFromObject:(id)object
{
    id value = [self.sourceTrait traitValueFromObject:object];
    if (!value || !self.transformer)
    {
        return value;
    }
    
    if (value == [NSNull null])
    {
        value = nil;
    }
    
    value = [self.transformer transformedValue:value];
    
    if (!value)
    {
        value = [NSNull null];
    }
    
    return value;
}

- (id)receivingValueFromObject:(id)object
{
    return [self.receivingTrait traitValueFromObject:object];
}


#pragma mark - NSObject

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@:%p> %@ ==> %@", [self class], self, self.sourceTrait, self.receivingTrait];
    if (self.transformer)
    {
        [description appendFormat:@" (transformer: %@)", self.transformer];
    }
    
    return [description copy];
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
    
    return [self isEqualToGene:object];
}

- (NSUInteger)hash
{
    return [self.sourceTrait hash] ^ [self.receivingTrait hash] ^ [self.transformer hash];
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithSourceTrait:self.sourceTrait receivingTrait:self.receivingTrait transformer:self.transformer];
}

@end


#pragma mark - Private

void GNKPopulateGeneArgs(id arg, id __autoreleasing *sourceTrait, id __autoreleasing *receivingTrait, NSValueTransformer *__autoreleasing *transformer)
{
    NSCParameterAssert(sourceTrait);
    NSCParameterAssert(receivingTrait);
    NSCParameterAssert(transformer);
    
    if (!arg)
    {
        return;
    }
    
    if (!(*sourceTrait))
    {
        if ([arg conformsToProtocol:@protocol(GNKSourceTrait)])
        {
            *sourceTrait = arg;
            return;
        }
        else if ([arg conformsToProtocol:@protocol(GNKSourceTraitConvertible)])
        {
            *sourceTrait = [arg GNKSourceTraitValue];
            return;
        }
    }
    
    if (!(*receivingTrait))
    {
        if ([arg conformsToProtocol:@protocol(GNKReceivingTrait)])
        {
            *receivingTrait = arg;
            return;
        }
        else if ([arg conformsToProtocol:@protocol(GNKReceivingTraitConvertible)])
        {
            *receivingTrait = [arg GNKReceivingTraitValue];
            return;
        }
    }
    
    if (!(*transformer) && [arg isKindOfClass:[NSValueTransformer class]])
    {
        *transformer = arg;
    }
}

GNKGene *GNKGeneFromArgs(id arg1, id arg2, id arg3)
{
    if (!arg1 && !arg2 && !arg3)
    {
        return nil;
    }
    
    id sourceTrait;
    id receivingTrait;
    NSValueTransformer *transformer;
    
    GNKPopulateGeneArgs(arg1, &sourceTrait, &receivingTrait, &transformer);
    GNKPopulateGeneArgs(arg2, &sourceTrait, &receivingTrait, &transformer);
    GNKPopulateGeneArgs(arg3, &sourceTrait, &receivingTrait, &transformer);
    
    if (!receivingTrait && [sourceTrait conformsToProtocol:@protocol(GNKReceivingTrait)])
    {
        receivingTrait = sourceTrait;
    }
    
    return [[GNKGene alloc] initWithSourceTrait:sourceTrait receivingTrait:receivingTrait transformer:transformer];
}

id GNKGeneConvertToObject(const char *type, ...)
{
    va_list args;
    va_start(args, type);
    
    id object = nil;
    
    if (strstr(type, @encode(id)) != 0)
    {
        object = va_arg(args, id);
    }
    else if (strcmp(type, @encode(SEL)) == 0)
    {
        SEL actual = va_arg(args, SEL);
        object = NSStringFromSelector(actual);
    }
    else if (strcmp(type, @encode(int)) == 0 ||
             strcmp(type, @encode(short)) == 0)
    {
        int actual = va_arg(args, int);
        object = @(actual);
    }
    else if (strcmp(type, @encode(long)) == 0)
    {
        long actual = va_arg(args, long);
        object = @(actual);
    }
    else if (strcmp(type, @encode(long long)) == 0)
    {
        long long actual = va_arg(args, long long);
        object = @(actual);
    }
    else if (strcmp(type, @encode(unsigned int)) == 0 ||
             strcmp(type, @encode(unsigned short)) == 0)
    {
        unsigned int actual = va_arg(args, unsigned int);
        object = @(actual);
    }
    else if (strcmp(type, @encode(unsigned long)) == 0)
    {
        unsigned long actual = va_arg(args, unsigned long);
        object = @(actual);
    }
    else if (strcmp(type, @encode(unsigned long long)) == 0)
    {
        unsigned long long actual = va_arg(args, unsigned long long);
        object = @(actual);
    }
    else if (strcmp(type, @encode(float)) == 0 ||
             strcmp(type, @encode(double)) == 0)
    {
        double actual = va_arg(args, double);
        object = @(actual);
    }
    else
    {
        [NSException raise:NSInternalInconsistencyException format:@"Unsupported automatic GNKGene boxing type (%s).", type];
    }
    
    return object;
}
