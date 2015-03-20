//
//  GKGeneTests.m
//  GeneticsKit
//
//  Created by Zach Radke on 3/17/15.
//  Copyright (c) 2015 Zach Radke. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <GeneticsKit/GeneticsKit.h>

@interface GNKGeneTests : XCTestCase

@end

@implementation GNKGeneTests

- (void)testInit
{
    GNKGene *gene = [[GNKGene alloc] initWithSourceTrait:GNKKeyTrait(@"A") receivingTrait:GNKKeyTrait(@"A'") transformer:nil];
    XCTAssertNotNil(gene);
}

- (void)testEquality
{
    GNKGene *geneA = [[GNKGene alloc] initWithSourceTrait:GNKKeyTrait(@"A") receivingTrait:GNKKeyTrait(@"A'") transformer:nil];
    GNKGene *geneB = [[GNKGene alloc] initWithSourceTrait:GNKKeyTrait(@"A") receivingTrait:GNKKeyTrait(@"A'") transformer:nil];
    GNKGene *geneC = [[GNKGene alloc] initWithSourceTrait:GNKKeyTrait(@"A") receivingTrait:GNKKeyTrait(@"B") transformer:nil];
    
    XCTAssertEqualObjects(geneA, geneB);
    XCTAssertFalse([geneA isEqual:geneC]);
    XCTAssertFalse([geneA isEqualToGene:geneC]);
}


#pragma mark - Macro

- (void)testMakeGeneWithSingleArg
{
    GNKGene *gene = GNKMakeGene(@"keyA");
    
    XCTAssertEqualObjects(gene.receivingTrait, GNKKeyTrait(@"keyA"));
    XCTAssertEqualObjects(gene.sourceTrait, GNKKeyTrait(@"keyA"));
    XCTAssertNil(gene.transformer);
}

- (void)testMakeGeneWithTwoArgs
{
    GNKGene *gene = GNKMakeGene(@"keyA", @"keyB");
    
    XCTAssertEqualObjects(gene.sourceTrait, GNKKeyTrait(@"keyA"));
    XCTAssertEqualObjects(gene.receivingTrait, GNKKeyTrait(@"keyB"));
    XCTAssertNil(gene.transformer);
    
    NSValueTransformer *transformer = [NSValueTransformer new];
    gene = GNKMakeGene(@"keyA", transformer);
    
    XCTAssertEqualObjects(gene.sourceTrait, GNKKeyTrait(@"keyA"));
    XCTAssertEqualObjects(gene.receivingTrait, GNKKeyTrait(@"keyA"));
    XCTAssertEqualObjects(gene.transformer, transformer);
    
    gene = GNKMakeGene(transformer, @"keyA");
    
    XCTAssertEqualObjects(gene.sourceTrait, GNKKeyTrait(@"keyA"));
    XCTAssertEqualObjects(gene.receivingTrait, GNKKeyTrait(@"keyA"));
    XCTAssertEqualObjects(gene.transformer, transformer);
}

- (void)testMakeGeneWithThreeArgs
{
    NSValueTransformer *transformer = [NSValueTransformer new];
    GNKGene *gene = GNKMakeGene(@"keyA", @"keyB", transformer);
    
    XCTAssertEqualObjects(gene.sourceTrait, GNKKeyTrait(@"keyA"));
    XCTAssertEqualObjects(gene.receivingTrait, GNKKeyTrait(@"keyB"));
    XCTAssertEqualObjects(gene.transformer, transformer);
    
    gene = GNKMakeGene(transformer, @"keyA", @"keyB");
    
    XCTAssertEqualObjects(gene.sourceTrait, GNKKeyTrait(@"keyA"));
    XCTAssertEqualObjects(gene.receivingTrait, GNKKeyTrait(@"keyB"));
    XCTAssertEqualObjects(gene.transformer, transformer);
    
    gene = GNKMakeGene(@"keyA", transformer, @"keyB");
    
    XCTAssertEqualObjects(gene.sourceTrait, GNKKeyTrait(@"keyA"));
    XCTAssertEqualObjects(gene.receivingTrait, GNKKeyTrait(@"keyB"));
    XCTAssertEqualObjects(gene.transformer, transformer);
}

- (void)testMakeGeneWithPrimitives
{
    GNKGene *gene = GNKMakeGene(@selector(key), 9);
    
    XCTAssertEqualObjects(gene.sourceTrait, GNKKeyTrait(@"key"));
    XCTAssertEqualObjects(gene.receivingTrait, GNKIndexTrait(9));
}

@end
