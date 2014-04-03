//
//  BaseModel.h
//  AtlanticJournal
//
//  Created by iN on 15.05.13.
//  Copyright (c) 2013 Boloid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

+ (instancetype)mapObjectFromDictionary:(NSDictionary *)data;
+ (NSArray *)mapArrayOfObjects:(NSArray *)data;

- (void)updateFromObject:(NSDictionary *)object;

//protected methods
- (NSDictionary *)keyToClassMappingRules;
- (NSDictionary *)keyToPropertyNameReplacementRules;


@end
