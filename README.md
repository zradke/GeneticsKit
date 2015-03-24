# GeneticsKit

[![CI Status](http://img.shields.io/travis/zradke/GeneticsKit.svg?style=flat)](https://travis-ci.org/zradke/GeneticsKit)
[![Version](https://img.shields.io/cocoapods/v/GeneticsKit.svg?style=flat)](http://cocoadocs.org/docsets/GeneticsKit)
[![License](https://img.shields.io/cocoapods/l/GeneticsKit.svg?style=flat)](http://cocoadocs.org/docsets/GeneticsKit)
[![Platform](https://img.shields.io/cocoapods/p/GeneticsKit.svg?style=flat)](http://cocoadocs.org/docsets/GeneticsKit)

Simple and flexible mapping for any object.

## Basics

Let's say you're starting with a class:

    @interface Person : NSObject

    @property (copy, nonatomic) NSString *firstName;
    @property (copy, nonatomic) NSString *lastName;
    @property (strong, nonatomic) NSURL *avatarURL;

    @end

Now let's say you've got some JSON:

    {
        "first_name": "Harry",
        "last_name": "Potter",
        "avatars": ["http://...", "http://...", "http://..."]
    }

Let's get started!

### Create a genome

A genome is just an array of `GNKGene` objects. A gene represents the mapping of a single trait between two objects. So for our JSON:

    NSArray *jsonGenome = @[GNKMakeGene(@"first_name", @selector(firstName)),
                            GNKMakeGene(@"last_name", @selector(lastName)),
                            GNKMakeGene(@"avatars[0]", @selector(avatarURL), [URLTransformer new])];

And we're done! `GNKGene` objects are initialized with a `GNKSourceTrait`, a `GNKReceivingTrait`, and an optional `NSValueTransformer`. The `GNKMakeGene` macro simplifies this by allowing you to provide one to three arguments and will attempt to convert them to the correct type. It's pretty smart and can take selectors and primitive numbers. No more having to type `NSStringFromSelector(@selector(...))` just to add some compile-time safety.

### Transfer traits

Now that we have our genome, we can use it to transfer values from our JSON onto our model:

    NSDictionary *json = ...;
    Person *person = [Person new];

    [GNKLab transferTraitsFromSource:json receiver:person genome:jsonGenome options:0];

    person.firstName; // "Harry"
    person.lastName; // "Potter"
    person.avatarURL; // "http://..."

Tada!

### Find different traits

Now let's say we got some new JSON from our server:

    {
        "first_name": "Harry",
        "last_name": "Porker",
        "avatars": [...]
    }

For whatever reason, we only want to have one person instance, and only update it when we need to. We can easily find out whether the JSON has different values from our instance using our genome:

    NSDictionary *newJSON = ...;

    NSSet *differentGenes = [GNKLab findGenesWithDifferentTraitsFromSource:newJSON receiver:person genome:jsonGenome options:0];

    differentGenes.count; // 1
    differentGenes.anyObject; // "<GNKGene:...> first_name ==> firstName"

Now we know that only the `firstName` needs to be updated. In fact, we can just convert the 
different genes into an array and use that as a new genome!

### Available traits and trait-convertibles

The driving force behind GeneticsKit are two protocols: `GNKSourceTrait` and `GNKReceivngTrait`. These two protocols make up the designated initializer for `GNKGene`. To mask some of the implementation drudgery, GeneticsKit provides the `GNKTrait` class cluster to provide some common traits.

Additionally, some Foundation classes have been extended to conform to the `GNKSourceTraitConvertible` and `GNKReceivingTraitConvertible` protocols.

| Foundation class | Protocols | Description |
| --- | --- | --- |
| `NSString` | `GNKSourceTraitConvertible`, `GNKReceivingTraitConvertible` | Converts the string into either a single index or key trait or a sequence of the two. |
| `NSNumber` | `GNKSourceTraitConvertible`, `GNKReceivingTraitConvertible` | Converts the number into an index trait. |
| `NSIndexPath` | `GNKSourceTraitConvertible`, `GNKReceivingTraitConvertible` | Converts the index path into a sequence of index traits. |
| `NSArray` | `GNKSourceTraitConvertible`, `GNKReceivingTraitConvertible` | Converts the array into a sequence of traits. |
| `NSOrderedSet` | `GNKSourceTraitConvertible`, `GNKReceivingTraitConvertible` | Converts the ordered set to a sequence of traits. |
| `NSIndexSet` | `GNKSourceTraitConvertible` | Converts the index set into an aggregate of index traits. |
| `NSSet` | `GNKSourceTraitConvertible` | Converts the set into an aggregate of traits. |
| `NSNull` | `GNKSourceTraitConvertible` | Equivalent to the identity trait. |

## Why to all

You may be wondering, why on earth do I need this library? For one, it's simple. Look how quickly we were able to make our JSON gneome. Two, it's very flexible. Because we've separated the mapping from the model class and the source type, if we suddenly discover that we need another JSON source that provides `Person` instances, we don't need to subclass `Person`, but instead just make a new genome! For example let's consider this new JSON source:

    [
        "Harry", // The first name will always be index 0
        "Potter", // The last name will always be index 1
        [
            {"url": "https://..."},
            {...},
            {...}
        ] // The array of avatars will always be index 2
    ]

This JSON is horrible, but we can work with it if we need to:

    NSArray *horribleGenome = @[GNKMakeGene(0, @selector(firstName)),
                                GNKMakeGene(1, @selector(lastName)),
                                GNKMakeGene(@"[2][0].url", @selector(avatarURL), [URLTransformer new])];

This has no impact on our `jsonGenome` because why should it?

GeneticsKit is also flexible because it doesn't require major changes to your architecture to implement. If you've made models in Core Data, you can keep them there. If you like to use raw `NSMutableDictionary` models, go ahead! As long as you've created a genome that is meaningful, it will work.

If you're not sold, or you think you need something more heavy duty, here are a few frameworks you can consider:

* [Mantle](https://github.com/Mantle/Mantle)
* [KZPropertyMapper](https://github.com/krzysztofzablocki/KZPropertyMapper)
* [JSONModel](https://github.com/icanzilb/JSONModel)

## Installation

GeneticsKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

pod "GeneticsKit"

## Author

Zach Radke, zach.radke@gmail.com

## License

GeneticsKit is available under the MIT license. See the LICENSE file for more info.

