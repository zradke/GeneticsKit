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

	NSArray *jsonGenome = @[GNKMakeGene(@selector(firstName), @"first_name"),
							GNKMakeGene(@selector(lastName), @"last_name"),
							GNKMakeGene(@selector(avatarURL), @"avatars[0]", [URLTransformer new])];

And we're done! The `GNKMakeGene` macro is pretty smart and can take selectors and convert them into strings. No more having to type `NSStringFromSelector(@selector(...))` just to add some compile-time safety. Also, note that for the `avatarURL`, we provided a value transformer to convert the JSON URL strings to NSURL objects.

### Transfer traits

Now that we have our genome, we can use it to transfer values from our JSON onto our model:

	NSDictionary *json = ...;
	Person *person = [Person new];

	GNKLabTransferTraits(json, person, jsonGenome, 0);

	person.firstName; // "Harry"
	person.lastName; // "Potter"
	person.avatarURL; // "http://..."

Tada!

### Find different traits

Now let's say we got some new JSON from our server:

	{
		"first_name": "Harry",
		"last_name": "Porker",
		avatars: [...]
}

For whatever reason, we only want to have one person instance, and only update it when we need to. We can easily find out whether the JSON has different values from our instance using our genome:

	NSDictionary *newJSON = ...;

	NSSet *differentGenes = GNKLabGenesWithDifferentTraits(newJSON, person, jsonGenome, 0);

	differentGenes.count; // 1
	differentGenes.anyObject; // "<GNKGene:...> firstName ==> first_name"

Now we know that only the `firstName` needs to be updated. In fact, we can just convert the different genes into an array and use that as a new genome!

## Why to all

You may be wondering, why on earth do I need this library? For one, it's simple. Look how quickly we were able to make our JSON gneome. Two, it's very flexible. Because we've separated the mapping from the objects, if we suddenly discover that we need another JSON source that provides `Person` instances, we don't need to subclass `Person`, but instead just make a new genome! For example let's consider this new JSON source:

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

	NSArray *horribleGenome = @[GNKMakeGene(@selector(firstName), 0),
								GNKMakeGene(@selector(lastName), 1),
								GNKMakeGene(@selector(avatarURL), @"[2][0].url", [URLTransformer new])];

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
