//
//  GNKLabTests.m
//  GeneticsKit
//
//  Created by Zach Radke on 3/17/15.
//  Copyright (c) 2015 Zach Radke. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <GeneticsKit/GeneticsKit.h>

@interface GNKDummy : NSObject
@property (copy, nonatomic) NSString *keyA;
@property (copy, nonatomic) NSString *keyB;
@property (copy, nonatomic) NSString *keyC;
@end

@interface GNKNilNullTransformer : NSValueTransformer
@end

@interface GNKUppercaseTransformer : NSValueTransformer
@end

@interface GNKLabTests : XCTestCase

@end

@implementation GNKLabTests

- (void)testTransferTraits
{
    NSDictionary *objA = @{@"keyA": @"A",
                           @"keyB": @"B",
                           @"keyC": @"C"};
    NSMutableArray *objB = [NSMutableArray array];
    
    NSArray *genome = @[GNKMakeGene(@"keyA", 0),
                        GNKMakeGene(@"keyC", 2)];
    
    GNKLabTransferTraits(objA, objB, genome, 0);
    
    XCTAssertEqual(objB.count, 3);
    XCTAssertEqualObjects(objB[0], @"A");
    XCTAssertEqualObjects(objB[1], [NSNull null]);
    XCTAssertEqualObjects(objB[2], @"C");
}

- (void)testTransferTraitsWithTransformer
{
    NSDictionary *objA = @{@"keyA": @"a",
                           @"keyB": @"b",
                           @"keyC": @"c"};
    NSMutableArray *objB = [NSMutableArray array];
    
    NSArray *genome = @[GNKMakeGene(@"keyA", 0, [GNKUppercaseTransformer new]),
                        GNKMakeGene(@"keyC", 2)];
    
    GNKLabTransferTraits(objA, objB, genome, 0);
    
    XCTAssertEqual(objB.count, 3);
    XCTAssertEqualObjects(objB[0], @"A");
    XCTAssertEqualObjects(objB[1], [NSNull null]);
    XCTAssertEqualObjects(objB[2], @"c");
}

- (void)testTransferTraitsWithUseNilValuesOption
{
    GNKLabOptions options = GNKLabDefaultOptions;
    
    NSDictionary *objA = @{@"keyA": @"a",
                           @"keyC": [NSNull null]};
    
    GNKDummy *objB = [GNKDummy new];
    objB.keyB = @"B";
    objB.keyC = @"C";
    
    NSArray *genome = @[GNKMakeGene(@selector(keyB))];
    
    GNKLabTransferTraits(objA, objB, genome, options);
    XCTAssertEqualObjects(objB.keyB, @"B");
    
    options = GNKLabUseNilValues;
    GNKLabTransferTraits(objA, objB, genome, options);
    XCTAssertNil(objB.keyB);
    
}

- (void)testTransferTraitsWithSkipPreTransformationNilConversionOption
{
    GNKLabOptions options = GNKLabDefaultOptions;
    
    NSDictionary *objA = @{@"keyA": @"a",
                           @"keyC": [NSNull null]};
    
    GNKDummy *objB = [GNKDummy new];
    objB.keyB = @"B";
    objB.keyC = @"C";
    
    NSArray *genome = @[GNKMakeGene(@selector(keyC), [GNKNilNullTransformer new])];
    
    GNKLabTransferTraits(objA, objB, genome, options);
    XCTAssertEqualObjects(objB.keyC, @"<NIL>");
    
    options = GNKLabSkipPreTranformationNilConversion;
    GNKLabTransferTraits(objA, objB, genome, options);
    XCTAssertEqualObjects(objB.keyC, @"<NULL>");
}

- (void)testTransferTraitsWithSkipPostTransformationNullConversionOption
{
    GNKLabOptions options = GNKLabSkipPreSettingNilConversion;
    
    NSDictionary *objA = @{@"keyA": @"a",
                           @"keyC": [NSNull null]};
    
    GNKDummy *objB = [GNKDummy new];
    objB.keyB = @"B";
    objB.keyC = @"C";
    
    NSArray *genome = @[GNKMakeGene(@selector(keyC), [NSValueTransformer new])];
    
    GNKLabTransferTraits(objA, objB, genome, options);
    XCTAssertEqualObjects(objB.keyC, [NSNull null]);
    
    options = GNKLabUseNilValues | GNKLabSkipPreSettingNilConversion | GNKLabSkipPostTranformationNullConversion;
    GNKLabTransferTraits(objA, objB, genome, options);
    XCTAssertNil(objB.keyC);
}

- (void)testTransferTraitsWithSkipPreSettingNilConversionOption
{
    GNKLabOptions options = GNKLabDefaultOptions;
    
    NSDictionary *objA = @{@"keyA": @"a",
                           @"keyC": [NSNull null]};
    
    GNKDummy *objB = [GNKDummy new];
    objB.keyB = @"B";
    objB.keyC = @"C";
    
    NSArray *genome = @[GNKMakeGene(@selector(keyC))];
    
    GNKLabTransferTraits(objA, objB, genome, options);
    XCTAssertNil(objB.keyC);
    
    options = GNKLabSkipPreSettingNilConversion;
    GNKLabTransferTraits(objA, objB, genome, options);
    XCTAssertEqual(objB.keyC, (id)[NSNull null]);
}

- (void)testDifferentTraitsWhenInequal
{
    NSDictionary *objA = @{@"keyA": @"A",
                           @"keyB": @"B",
                           @"keyC": @"C"};
    
    NSArray *objB = @[@"A", [NSNull null], @"C"];
    
    NSArray *genome = @[GNKMakeGene(@"keyA", 0),
                        GNKMakeGene(@"keyB", 1),
                        GNKMakeGene(@"keyC", 2)];
    
    NSSet *genes = GNKLabGenesWithDifferentTraits(objA, objB, genome, 0);
    
    XCTAssertEqual(genes.count, 1);
    XCTAssertEqualObjects([genes anyObject], GNKMakeGene(@"keyB", 1));
}

- (void)testDifferentTraitsWhenInequalWithTransformer
{
    NSDictionary *objA = @{@"keyA": @"a",
                           @"keyB": @"b",
                           @"keyC": @"c"};
    
    NSArray *objB = @[@"A", @"b", @"C"];
    
    GNKUppercaseTransformer *transformer = [GNKUppercaseTransformer new];
    NSArray *genome = @[GNKMakeGene(@"keyA", 0, transformer),
                        GNKMakeGene(@"keyB", 1, transformer),
                        GNKMakeGene(@"keyC", 2, transformer)];
    
    NSSet *genes = GNKLabGenesWithDifferentTraits(objA, objB, genome, 0);
    
    XCTAssertEqual(genes.count, 1);
    XCTAssertEqualObjects([genes anyObject], GNKMakeGene(@"keyB", 1, transformer));
}

- (void)testDifferentTraitsWhenEqual
{
    NSDictionary *objA = @{@"keyA": @"A",
                           @"keyB": @"B",
                           @"keyC": @"C"};
    
    NSArray *objB = @[@"A", @"B", @"C"];
    
    NSArray *genome = @[GNKMakeGene(@"keyA", 0),
                        GNKMakeGene(@"keyB", 1),
                        GNKMakeGene(@"keyC", 2)];
    
    NSSet *genes = GNKLabGenesWithDifferentTraits(objA, objB, genome, 0);
    
    XCTAssertNotNil(genes);
    XCTAssertEqual(genes.count, 0);
}

- (void)testDifferentTraitsWhenEqualWithTransformer
{
    NSDictionary *objA = @{@"keyA": @"a",
                           @"keyB": @"b",
                           @"keyC": @"c"};
    
    NSArray *objB = @[@"A", @"B", @"C"];
    
    GNKUppercaseTransformer *transformer = [GNKUppercaseTransformer new];
    NSArray *genome = @[GNKMakeGene(@"keyA", 0, transformer),
                        GNKMakeGene(@"keyB", 1, transformer),
                        GNKMakeGene(@"keyC", 2, transformer)];
    
    NSSet *genes = GNKLabGenesWithDifferentTraits(objA, objB, genome, 0);
    
    XCTAssertNotNil(genes);
    XCTAssertEqual(genes.count, 0);
}

@end


@implementation GNKDummy
@end

@implementation GNKNilNullTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

- (id)transformedValue:(id)value
{
    if (!value)
    {
        return @"<NIL>";
    }
    if (value == [NSNull null])
    {
        return @"<NULL>";
    }
    else
    {
        return value;
    }
}

@end

@implementation GNKUppercaseTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

- (id)transformedValue:(id)value
{
    return [value uppercaseString];
}

@end
