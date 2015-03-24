//
//  GKTraitTests.m
//  GeneticsKit
//
//  Created by Zach Radke on 3/17/15.
//  Copyright (c) 2015 Zach Radke. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <GeneticsKit/GeneticsKit.h>

@interface GNKTraitTests : XCTestCase

@end

@implementation GNKTraitTests

#pragma mark - Index trait

- (void)testIndexTraitInit
{
    id trait = [GNKTrait traitWithIndex:9];
    
    XCTAssertNotNil(trait);
    XCTAssertTrue([trait conformsToProtocol:@protocol(GNKReceivingTrait)]);
}

- (void)testIndexTraitEquality
{
    id traitA = [GNKTrait traitWithIndex:9];
    id traitB = [GNKTrait traitWithIndex:9];
    id traitC = [GNKTrait traitWithIndex:8];
    
    XCTAssertEqualObjects(traitA, traitB);
    XCTAssertFalse([traitA isEqual:traitC]);
}

- (void)testIndexTraitCopying
{
    id traitA = [GNKTrait traitWithIndex:9];
    id traitB = [traitA copy];
    
    XCTAssertEqualObjects(traitA, traitB);
}

- (void)testIndexTraitGettingSetting
{
    NSMutableArray *object = [NSMutableArray array];
    
    id trait = [GNKTrait traitWithIndex:2];
    
    XCTAssertNil([trait traitValueFromObject:object]);
    
    [object addObjectsFromArray:@[@0, @1, @2]];
    
    XCTAssertEqualObjects([trait traitValueFromObject:object], @2);
    
    trait = [GNKTrait traitWithIndex:4];
    [trait setTraitValue:@4 onObject:object];
    
    XCTAssertEqualObjects([trait traitValueFromObject:object], @4);
    XCTAssertEqualObjects(object[3], [NSNull null]);
    XCTAssertEqualObjects(object[2], @2);
}


#pragma mark - Key trait

- (void)testKeyTraitInit
{
    id trait = [GNKTrait traitWithKey:@"keyA"];
    
    XCTAssertNotNil(trait);
    XCTAssertTrue([trait conformsToProtocol:@protocol(GNKReceivingTrait)]);
}

- (void)testKeyTraitEquality
{
    id traitA = [GNKTrait traitWithKey:@"keyA"];
    id traitB = [GNKTrait traitWithKey:@"keyA"];
    id traitC = [GNKTrait traitWithKey:@"keyC"];
    
    XCTAssertEqualObjects(traitA, traitB);
    XCTAssertFalse([traitA isEqual:traitC]);
}

- (void)testKeyTraitCopying
{
    id traitA = [GNKTrait traitWithKey:@"keyA"];
    id traitB = [traitA copy];
    
    XCTAssertEqualObjects(traitA, traitB);
}

- (void)testKeyTraitGettingSetting
{
    NSMutableDictionary *object = [NSMutableDictionary dictionary];
    
    id trait = [GNKTrait traitWithKey:@"keyA"];
    
    XCTAssertNil([trait traitValueFromObject:object]);
    
    object[@"keyA"] = @"A";
    
    XCTAssertEqualObjects([trait traitValueFromObject:object], @"A");
    
    trait = [GNKTrait traitWithKey:@"keyB"];
    
    [trait setTraitValue:@"B" onObject:object];
    
    XCTAssertEqualObjects(object[@"keyB"], @"B");
}


#pragma mark - Sequence trait

- (void)testSequenceTraitInit
{
    id trait = [GNKTrait sequenceOfTraits:@[[GNKTrait traitWithKey:@"keyA"], [GNKTrait traitWithIndex:0]]];
    
    XCTAssertNotNil(trait);
    XCTAssertTrue([trait conformsToProtocol:@protocol(GNKReceivingTrait)]);
}

- (void)testSequenceTraitEquality
{
    id traitA = [GNKTrait sequenceOfTraits:@[[GNKTrait traitWithKey:@"keyA"], [GNKTrait traitWithIndex:0]]];
    id traitB = [GNKTrait sequenceOfTraits:@[[GNKTrait traitWithKey:@"keyA"], [GNKTrait traitWithIndex:0]]];
    id traitC = [GNKTrait sequenceOfTraits:@[[GNKTrait traitWithKey:@"keyC"]]];
    
    XCTAssertEqualObjects(traitA, traitB);
    XCTAssertFalse([traitA isEqual:traitC]);
}

- (void)testSequenceTraitCopying
{
    id traitA = [GNKTrait sequenceOfTraits:@[[GNKTrait traitWithKey:@"keyA"], [GNKTrait traitWithIndex:0]]];
    id traitB = [traitA copy];
    
    XCTAssertEqualObjects(traitA, traitB);
}

- (void)testSequenceTraitGettingSetting
{
    NSMutableDictionary *object = [NSMutableDictionary dictionary];
    
    id trait = [GNKTrait sequenceOfTraits:@[[GNKTrait traitWithKey:@"keyA"], [GNKTrait traitWithIndex:0]]];
    
    XCTAssertNil([trait traitValueFromObject:object]);
    
    object[@"keyA"] = [NSMutableArray arrayWithObject:@"A"];
    
    XCTAssertEqualObjects([trait traitValueFromObject:object], @"A");
    
    trait = [GNKTrait sequenceOfTraits:@[[GNKTrait traitWithKey:@"keyA"], [GNKTrait traitWithIndex:2]]];
    
    [trait setTraitValue:@"C" onObject:object];
    
    XCTAssertEqualObjects(object[@"keyA"][2], @"C");
    XCTAssertEqualObjects(object[@"keyA"][1], [NSNull null]);
}


#pragma mark - Aggregate trait

- (void)testAggregateTraitInit
{
    id trait = [GNKTrait aggregateOfTraits:@[[GNKTrait traitWithKey:@"keyA"], [GNKTrait traitWithKey:@"keyB"]]];
    
    XCTAssertNotNil(trait);
    XCTAssertTrue([trait conformsToProtocol:@protocol(GNKSourceTrait)]);
}

- (void)testAggregateTraitEquality
{
    id traitA = [GNKTrait aggregateOfTraits:@[[GNKTrait traitWithKey:@"keyA"], [GNKTrait traitWithKey:@"keyB"]]];
    id traitB = [GNKTrait aggregateOfTraits:@[[GNKTrait traitWithKey:@"keyA"], [GNKTrait traitWithKey:@"keyB"]]];
    id traitC = [GNKTrait aggregateOfTraits:@[[GNKTrait traitWithKey:@"keyB"]]];
    
    XCTAssertEqualObjects(traitA, traitB);
    XCTAssertFalse([traitA isEqual:traitC]);
}

- (void)testAggregateTraitCopying
{
    id traitA = [GNKTrait aggregateOfTraits:@[[GNKTrait traitWithKey:@"keyA"], [GNKTrait traitWithKey:@"keyB"]]];
    id traitB = [traitA copy];
    
    XCTAssertEqualObjects(traitA, traitB);
}

- (void)testAggregateTraitGetting
{
    NSMutableDictionary *object = [NSMutableDictionary dictionary];
    
    id trait = [GNKTrait aggregateOfTraits:@[[GNKTrait traitWithKey:@"keyA"], [GNKTrait traitWithKey:@"keyB"]]];
    
    XCTAssertNil([trait traitValueFromObject:object]);
    
    object[@"keyA"] = @"A";
    
    NSDictionary *expected = @{[GNKTrait traitWithKey:@"keyA"]: @"A"};
    XCTAssertEqualObjects([trait traitValueFromObject:object], expected);
    
    object[@"keyB"] = @"B";
    
    expected =  @{[GNKTrait traitWithKey:@"keyA"]: @"A", [GNKTrait traitWithKey:@"keyB"]: @"B"};
    XCTAssertEqualObjects([trait traitValueFromObject:object], expected);
}


#pragma mark - Identity trait

- (void)testIdentityTraitInit
{
    id trait = [GNKTrait identityTrait];
    
    XCTAssertNotNil(trait);
    XCTAssertTrue([trait conformsToProtocol:@protocol(GNKSourceTrait)]);
}

- (void)testIdentityTraitEquality
{
    id traitA = [GNKTrait identityTrait];
    id traitB = [GNKTrait identityTrait];
    
    XCTAssertEqualObjects(traitA, traitB);
}

- (void)testIdentityTraitCopying
{
    id traitA = [GNKTrait identityTrait];
    id traitB = [traitA copy];
    
    XCTAssertEqualObjects(traitA, traitB);
}

- (void)testIdentityTraitGetting
{
    NSArray *object = @[@"A", @"B", @"C"];
    
    id trait = [GNKTrait identityTrait];
    
    XCTAssertEqual([trait traitValueFromObject:object], object);
}


#pragma mark - Conversions

- (void)testStringSingleTrait
{
    id trait = [@"keyA" GNKReceivingTraitValue];
    
    XCTAssertEqualObjects(trait, [GNKTrait traitWithKey:@"keyA"]);
}

- (void)testStringMultipleTraits
{
    id trait = [@"keyA[0].keyB.keyC[9]" GNKReceivingTraitValue];
    
    id expected = [GNKTrait sequenceOfTraits:@[[GNKTrait traitWithKey:@"keyA"],
                                               [GNKTrait traitWithIndex:0],
                                               [GNKTrait traitWithKey:@"keyB"],
                                               [GNKTrait traitWithKey:@"keyC"],
                                               [GNKTrait traitWithIndex:9]]];
    
    XCTAssertEqualObjects(trait, expected);
    
    trait = [@"keyA[0][9]" GNKReceivingTraitValue];
    
    expected = [GNKTrait sequenceOfTraits:@[[GNKTrait traitWithKey:@"keyA"],
                                            [GNKTrait traitWithIndex:0],
                                            [GNKTrait traitWithIndex:9]]];
    
    XCTAssertEqualObjects(trait, expected);
}

- (void)testStringInvalidFormat
{
    id trait = [@"" GNKReceivingTraitValue];
    XCTAssertNil(trait);
    
    trait = [@"keyA[]" GNKReceivingTraitValue];
    XCTAssertNil(trait);
}

- (void)testNumberTrait
{
    id trait = [@9 GNKReceivingTraitValue];
    
    XCTAssertEqualObjects(trait, [GNKTrait traitWithIndex:9]);
}

- (void)testIndexPathTrait
{
    NSUInteger indexes[] = {9, 4};
    id trait = [[NSIndexPath indexPathWithIndexes:indexes length:2] GNKReceivingTraitValue];
    
    id expected = [GNKTrait sequenceOfTraits:@[[GNKTrait traitWithIndex:9], [GNKTrait traitWithIndex:4]]];
    
    XCTAssertEqualObjects(trait, expected);
}

- (void)testArrayTrait
{
    id trait = [@[[GNKTrait traitWithIndex:9],
                  @"keyA"] GNKReceivingTraitValue];
    
    id expected = [GNKTrait sequenceOfTraits:@[[GNKTrait traitWithIndex:9],
                                               [GNKTrait traitWithKey:@"keyA"]]];
    
    XCTAssertEqualObjects(trait, expected);
}

- (void)testOrderedSetTrait
{
    id trait = [[NSOrderedSet orderedSetWithObjects:@9, [GNKTrait traitWithKey:@"keyA"], nil] GNKReceivingTraitValue];
    
    id expected = [GNKTrait sequenceOfTraits:@[[GNKTrait traitWithIndex:9],
                                               [GNKTrait traitWithKey:@"keyA"]]];
    
    XCTAssertEqualObjects(trait, expected);
}

- (void)testIndexSetTrait
{
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndex:9];
    [indexes addIndex:4];
    id trait = [indexes GNKSourceTraitValue];
    
    id expected = [GNKTrait aggregateOfTraits:@[[GNKTrait traitWithIndex:9],
                                                [GNKTrait traitWithIndex:4]]];
    
    XCTAssertEqualObjects(trait, expected);
}

- (void)testSetTrait
{
    id trait = [[NSSet setWithObjects:@"keyA", @"keyB[0]", nil] GNKSourceTraitValue];
    
    id expected = [GNKTrait aggregateOfTraits:@[[GNKTrait traitWithKey:@"keyA"],
                                                [GNKTrait sequenceOfTraits:@[[GNKTrait traitWithKey:@"keyB"],
                                                                             [GNKTrait traitWithIndex:0]]]]];
    
    XCTAssertEqualObjects(trait, expected);
}

- (void)testNullTrait
{
    id trait = [[NSNull null] GNKSourceTraitValue];
    
    XCTAssertEqualObjects(trait, [GNKTrait identityTrait]);
}



@end
