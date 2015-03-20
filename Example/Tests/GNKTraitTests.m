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

#pragma mark - GNKIndexTrait

- (void)testIndexTraitInit
{
    id trait = GNKIndexTrait(9);
    
    XCTAssertNotNil(trait);
    XCTAssertTrue([trait conformsToProtocol:@protocol(GNKReceivingTrait)]);
}

- (void)testIndexTraitEquality
{
    id traitA = GNKIndexTrait(9);
    id traitB = GNKIndexTrait(9);
    id traitC = GNKIndexTrait(8);
    
    XCTAssertEqualObjects(traitA, traitB);
    XCTAssertFalse([traitA isEqual:traitC]);
}

- (void)testIndexTraitCopying
{
    id traitA = GNKIndexTrait(9);
    id traitB = [traitA copy];
    
    XCTAssertEqualObjects(traitA, traitB);
}

- (void)testIndexTraitGettingSetting
{
    NSMutableArray *object = [NSMutableArray array];
    
    id trait = GNKIndexTrait(2);
    
    XCTAssertNil([trait traitValueFromObject:object]);
    
    [object addObjectsFromArray:@[@0, @1, @2]];
    
    XCTAssertEqualObjects([trait traitValueFromObject:object], @2);
    
    trait = GNKIndexTrait(4);
    [trait setTraitValue:@4 onObject:object];
    
    XCTAssertEqualObjects([trait traitValueFromObject:object], @4);
    XCTAssertEqualObjects(object[3], [NSNull null]);
    XCTAssertEqualObjects(object[2], @2);
}


#pragma mark - GNKKeyTrait

- (void)testKeyTraitInit
{
    id trait = GNKKeyTrait(@"keyA");
    
    XCTAssertNotNil(trait);
    XCTAssertTrue([trait conformsToProtocol:@protocol(GNKReceivingTrait)]);
}

- (void)testKeyTraitEquality
{
    id traitA = GNKKeyTrait(@"keyA");
    id traitB = GNKKeyTrait(@"keyA");
    id traitC = GNKKeyTrait(@"keyC");
    
    XCTAssertEqualObjects(traitA, traitB);
    XCTAssertFalse([traitA isEqual:traitC]);
}

- (void)testKeyTraitCopying
{
    id traitA = GNKKeyTrait(@"keyA");
    id traitB = [traitA copy];
    
    XCTAssertEqualObjects(traitA, traitB);
}

- (void)testKeyTraitGettingSetting
{
    NSMutableDictionary *object = [NSMutableDictionary dictionary];
    
    id trait = GNKKeyTrait(@"keyA");
    
    XCTAssertNil([trait traitValueFromObject:object]);
    
    object[@"keyA"] = @"A";
    
    XCTAssertEqualObjects([trait traitValueFromObject:object], @"A");
    
    trait = GNKKeyTrait(@"keyB");
    
    [trait setTraitValue:@"B" onObject:object];
    
    XCTAssertEqualObjects(object[@"keyB"], @"B");
}


#pragma mark - GNKSequenceTrait

- (void)testSequenceTraitInit
{
    id trait = GNKSequenceTrait(@[GNKKeyTrait(@"keyA"), GNKIndexTrait(0)]);
    
    XCTAssertNotNil(trait);
    XCTAssertTrue([trait conformsToProtocol:@protocol(GNKReceivingTrait)]);
}

- (void)testSequenceTraitEquality
{
    id traitA = GNKSequenceTrait(@[GNKKeyTrait(@"keyA"), GNKIndexTrait(0)]);
    id traitB = GNKSequenceTrait(@[GNKKeyTrait(@"keyA"), GNKIndexTrait(0)]);
    id traitC = GNKSequenceTrait(@[GNKKeyTrait(@"keyB")]);
    
    XCTAssertEqualObjects(traitA, traitB);
    XCTAssertFalse([traitA isEqual:traitC]);
}

- (void)testSequenceTraitCopying
{
    id traitA = GNKSequenceTrait(@[GNKKeyTrait(@"keyA"), GNKIndexTrait(0)]);
    id traitB = [traitA copy];
    
    XCTAssertEqualObjects(traitA, traitB);
}

- (void)testSequenceTraitGettingSetting
{
    NSMutableDictionary *object = [NSMutableDictionary dictionary];
    
    id trait = GNKSequenceTrait(@[GNKKeyTrait(@"keyA"), GNKIndexTrait(0)]);
    
    XCTAssertNil([trait traitValueFromObject:object]);
    
    object[@"keyA"] = [NSMutableArray arrayWithObject:@"A"];
    
    XCTAssertEqualObjects([trait traitValueFromObject:object], @"A");
    
    trait = GNKSequenceTrait(@[GNKKeyTrait(@"keyA"), GNKIndexTrait(2)]);
    
    [trait setTraitValue:@"C" onObject:object];
    
    XCTAssertEqualObjects(object[@"keyA"][2], @"C");
    XCTAssertEqualObjects(object[@"keyA"][1], [NSNull null]);
}


#pragma mark - GNKAggregateTrait

- (void)testAggregateTraitInit
{
    id trait = GNKAggregateTrait(@[GNKKeyTrait(@"keyA"), GNKKeyTrait(@"keyB")]);
    
    XCTAssertNotNil(trait);
    XCTAssertTrue([trait conformsToProtocol:@protocol(GNKSourceTrait)]);
}

- (void)testAggregateTraitEquality
{
    id traitA = GNKAggregateTrait(@[GNKKeyTrait(@"keyA"), GNKKeyTrait(@"keyB")]);
    id traitB = GNKAggregateTrait(@[GNKKeyTrait(@"keyA"), GNKKeyTrait(@"keyB")]);
    id traitC = GNKAggregateTrait(@[GNKKeyTrait(@"keyB")]);
    
    XCTAssertEqualObjects(traitA, traitB);
    XCTAssertFalse([traitA isEqual:traitC]);
}

- (void)testAggregateTraitCopying
{
    id traitA = GNKAggregateTrait(@[GNKKeyTrait(@"keyA"), GNKKeyTrait(@"keyB")]);
    id traitB = [traitA copy];
    
    XCTAssertEqualObjects(traitA, traitB);
}

- (void)testAggregateTraitGetting
{
    NSMutableDictionary *object = [NSMutableDictionary dictionary];
    
    id trait = GNKAggregateTrait(@[GNKKeyTrait(@"keyA"), GNKKeyTrait(@"keyB")]);
    
    XCTAssertNil([trait traitValueFromObject:object]);
    
    object[@"keyA"] = @"A";
    
    NSDictionary *expected = @{GNKKeyTrait(@"keyA"): @"A"};
    XCTAssertEqualObjects([trait traitValueFromObject:object], expected);
    
    object[@"keyB"] = @"B";
    
    expected =  @{GNKKeyTrait(@"keyA"): @"A", GNKKeyTrait(@"keyB"): @"B"};
    XCTAssertEqualObjects([trait traitValueFromObject:object], expected);
}


#pragma mark - GNKIdentityTrait

- (void)testIdentityTraitInit
{
    id trait = GNKIdentityTrait();
    
    XCTAssertNotNil(trait);
    XCTAssertTrue([trait conformsToProtocol:@protocol(GNKSourceTrait)]);
}

- (void)testIdentityTraitEquality
{
    id traitA = GNKIdentityTrait();
    id traitB = GNKIdentityTrait();
    
    XCTAssertEqualObjects(traitA, traitB);
}

- (void)testIdentityTraitCopying
{
    id traitA = GNKIdentityTrait();
    id traitB = [traitA copy];
    
    XCTAssertEqualObjects(traitA, traitB);
}

- (void)testIdentityTraitGetting
{
    NSArray *object = @[@"A", @"B", @"C"];
    
    id trait = GNKIdentityTrait();
    
    XCTAssertEqual([trait traitValueFromObject:object], object);
}


#pragma mark - Conversions

- (void)testStringSingleTrait
{
    id trait = [@"keyA" GNKReceivingTraitValue];
    
    XCTAssertEqualObjects(trait, GNKKeyTrait(@"keyA"));
}

- (void)testStringMultipleTraits
{
    id trait = [@"keyA[0].keyB.keyC[9]" GNKReceivingTraitValue];
    
    id expected = GNKSequenceTrait(@[GNKKeyTrait(@"keyA"),
                                           GNKIndexTrait(0),
                                           GNKKeyTrait(@"keyB"),
                                           GNKKeyTrait(@"keyC"),
                                           GNKIndexTrait(9)]);
    
    XCTAssertEqualObjects(trait, expected);
    
    trait = [@"keyA[0][9]" GNKReceivingTraitValue];
    
    expected = GNKSequenceTrait(@[GNKKeyTrait(@"keyA"),
                                  GNKIndexTrait(0),
                                  GNKIndexTrait(9)]);
    
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
    
    XCTAssertEqualObjects(trait, GNKIndexTrait(9));
}

- (void)testIndexPathTrait
{
    NSUInteger indexes[] = {9, 4};
    id trait = [[NSIndexPath indexPathWithIndexes:indexes length:2] GNKReceivingTraitValue];
    
    id expected = GNKSequenceTrait(@[GNKIndexTrait(9),
                                     GNKIndexTrait(4)]);
    
    XCTAssertEqualObjects(trait, expected);
}

- (void)testArrayTrait
{
    id trait = [@[GNKIndexTrait(9),
                  @"keyA"] GNKReceivingTraitValue];
    
    id expected = GNKSequenceTrait(@[GNKIndexTrait(9),
                                     GNKKeyTrait(@"keyA")]);
    
    XCTAssertEqualObjects(trait, expected);
}

- (void)testOrderedSetTrait
{
    id trait = [[NSOrderedSet orderedSetWithObjects:@9, GNKKeyTrait(@"keyA"), nil] GNKReceivingTraitValue];
    
    id expected = GNKSequenceTrait(@[GNKIndexTrait(9),
                                     GNKKeyTrait(@"keyA")]);
    
    XCTAssertEqualObjects(trait, expected);
}

- (void)testIndexSetTrait
{
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndex:9];
    [indexes addIndex:4];
    id trait = [indexes GNKSourceTraitValue];
    
    id expected = GNKAggregateTrait(@[GNKIndexTrait(4),
                                      GNKIndexTrait(9)]);
    
    XCTAssertEqualObjects(trait, expected);
}

- (void)testSetTrait
{
    id trait = [[NSSet setWithObjects:@"keyA", @"keyB[0]", nil] GNKSourceTraitValue];
    
    id expected = GNKAggregateTrait(@[GNKKeyTrait(@"keyA"),
                                      GNKSequenceTrait(@[GNKKeyTrait(@"keyB"),
                                                         GNKIndexTrait(0)])]);
    
    XCTAssertEqualObjects(trait, expected);
}

- (void)testNullTrait
{
    id trait = [[NSNull null] GNKSourceTraitValue];
    
    XCTAssertEqualObjects(trait, GNKIdentityTrait());
}



@end
