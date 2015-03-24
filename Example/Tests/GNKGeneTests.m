//
//  GKGeneTests.m
//  GeneticsKit
//
//  Created by Zach Radke on 3/17/15.
//  Copyright (c) 2015 Zach Radke. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <GeneticsKit/GeneticsKit.h>

@interface GNKTestOneWayTransformer : NSValueTransformer
@end

@interface GNKTestReversibleTransformer : NSValueTransformer
@end

@interface GNKGeneTests : XCTestCase

@end

@implementation GNKGeneTests

- (void)testInit
{
    GNKGene *gene = [[GNKGene alloc] initWithSourceTrait:[GNKTrait traitWithKey:@"A"] receivingTrait:[GNKTrait traitWithKey:@"A'"] transformer:nil];
    XCTAssertNotNil(gene);
}

- (void)testEquality
{
    GNKGene *geneA = [[GNKGene alloc] initWithSourceTrait:[GNKTrait traitWithKey:@"A"] receivingTrait:[GNKTrait traitWithKey:@"A'"] transformer:nil];
    GNKGene *geneB = [[GNKGene alloc] initWithSourceTrait:[GNKTrait traitWithKey:@"A"] receivingTrait:[GNKTrait traitWithKey:@"A'"] transformer:nil];
    GNKGene *geneC = [[GNKGene alloc] initWithSourceTrait:[GNKTrait traitWithKey:@"A"] receivingTrait:[GNKTrait traitWithKey:@"B"] transformer:nil];
    
    XCTAssertEqualObjects(geneA, geneB);
    XCTAssertFalse([geneA isEqual:geneC]);
    XCTAssertFalse([geneA isEqualToGene:geneC]);
}

- (void)testCanInvertGene
{
    GNKGene *gene = [[GNKGene alloc] initWithSourceTrait:[GNKTrait traitWithKey:@"A"] receivingTrait:[GNKTrait traitWithKey:@"A'"] transformer:nil];
    
    XCTAssertTrue([gene canInvertGene]);
    
    gene = [[GNKGene alloc] initWithSourceTrait:[GNKTrait traitWithKey:@"A"] receivingTrait:[GNKTrait traitWithKey:@"A'"] transformer:[GNKTestReversibleTransformer new]];
    
    XCTAssertTrue([gene canInvertGene]);
    
    gene = [[GNKGene alloc] initWithSourceTrait:[GNKTrait identityTrait] receivingTrait:[GNKTrait traitWithKey:@"A"] transformer:nil];
    
    XCTAssertFalse([gene canInvertGene]);
    
    gene = [[GNKGene alloc] initWithSourceTrait:[GNKTrait traitWithKey:@"A"] receivingTrait:[GNKTrait traitWithKey:@"A'"] transformer:[GNKTestOneWayTransformer new]];
    
    XCTAssertFalse([gene canInvertGene]);
}

- (void)testInvertedGene
{
    GNKGene *geneA = [[GNKGene alloc] initWithSourceTrait:[GNKTrait traitWithKey:@"A"] receivingTrait:[GNKTrait traitWithKey:@"A'"] transformer:[GNKTestReversibleTransformer new]];
    
    NSDictionary *sourceA = @{@"A": @"http://www.google.com"};
    NSMutableDictionary *receiverA = [NSMutableDictionary dictionary];
    
    [GNKLab transferTraitsFromSource:sourceA receiver:receiverA genome:@[geneA] options:0];
    
    NSDictionary *sourceB = @{@"A'": [NSURL URLWithString:@"http://www.google.com"]};
    XCTAssertEqualObjects(receiverA, sourceB);
    
    GNKGene *geneB = [geneA invertedGene];
    
    XCTAssertNotNil(geneB);
    
    NSMutableDictionary *receiverB = [NSMutableDictionary dictionary];
    
    [GNKLab transferTraitsFromSource:sourceB receiver:receiverB genome:@[geneB] options:0];
    
    XCTAssertEqualObjects(receiverB, sourceA);
}


#pragma mark - Macro

- (void)testMakeGeneWithSingleArg
{
    GNKGene *gene = GNKMakeGene(@"keyA");
    
    XCTAssertEqualObjects(gene.receivingTrait, [GNKTrait traitWithKey:@"keyA"]);
    XCTAssertEqualObjects(gene.sourceTrait, [GNKTrait traitWithKey:@"keyA"]);
    XCTAssertNil(gene.transformer);
}

- (void)testMakeGeneWithTwoArgs
{
    GNKGene *gene = GNKMakeGene(@"keyA", @"keyB");
    
    XCTAssertEqualObjects(gene.sourceTrait, [GNKTrait traitWithKey:@"keyA"]);
    XCTAssertEqualObjects(gene.receivingTrait, [GNKTrait traitWithKey:@"keyB"]);
    XCTAssertNil(gene.transformer);
    
    NSValueTransformer *transformer = [NSValueTransformer new];
    gene = GNKMakeGene(@"keyA", transformer);
    
    XCTAssertEqualObjects(gene.sourceTrait, [GNKTrait traitWithKey:@"keyA"]);
    XCTAssertEqualObjects(gene.receivingTrait, [GNKTrait traitWithKey:@"keyA"]);
    XCTAssertEqualObjects(gene.transformer, transformer);
    
    gene = GNKMakeGene(transformer, @"keyA");
    
    XCTAssertEqualObjects(gene.sourceTrait, [GNKTrait traitWithKey:@"keyA"]);
    XCTAssertEqualObjects(gene.receivingTrait, [GNKTrait traitWithKey:@"keyA"]);
    XCTAssertEqualObjects(gene.transformer, transformer);
}

- (void)testMakeGeneWithThreeArgs
{
    NSValueTransformer *transformer = [NSValueTransformer new];
    GNKGene *gene = GNKMakeGene(@"keyA", @"keyB", transformer);
    
    XCTAssertEqualObjects(gene.sourceTrait, [GNKTrait traitWithKey:@"keyA"]);
    XCTAssertEqualObjects(gene.receivingTrait, [GNKTrait traitWithKey:@"keyB"]);
    XCTAssertEqualObjects(gene.transformer, transformer);
    
    gene = GNKMakeGene(transformer, @"keyA", @"keyB");
    
    XCTAssertEqualObjects(gene.sourceTrait, [GNKTrait traitWithKey:@"keyA"]);
    XCTAssertEqualObjects(gene.receivingTrait, [GNKTrait traitWithKey:@"keyB"]);
    XCTAssertEqualObjects(gene.transformer, transformer);
    
    gene = GNKMakeGene(@"keyA", transformer, @"keyB");
    
    XCTAssertEqualObjects(gene.sourceTrait, [GNKTrait traitWithKey:@"keyA"]);
    XCTAssertEqualObjects(gene.receivingTrait, [GNKTrait traitWithKey:@"keyB"]);
    XCTAssertEqualObjects(gene.transformer, transformer);
}

- (void)testMakeGeneWithPrimitives
{
    GNKGene *gene = GNKMakeGene(@selector(key), 9);
    
    XCTAssertEqualObjects(gene.sourceTrait, [GNKTrait traitWithKey:@"key"]);
    XCTAssertEqualObjects(gene.receivingTrait, [GNKTrait traitWithIndex:9]);
}

@end


@implementation GNKTestOneWayTransformer

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    return [value uppercaseString];
}

@end

@implementation GNKTestReversibleTransformer

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return [NSURL URLWithString:value];
}

- (id)reverseTransformedValue:(id)value
{
    return [value absoluteString];
}

@end
