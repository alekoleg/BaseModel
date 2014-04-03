//
//  BaseModel.m
//  AtlanticJournal
//
//  Created by iN on 15.05.13.
//  Copyright (c) 2013 Boloid. All rights reserved.
//

#import "BaseModel.h"
#import "objc/runtime.h"

@implementation BaseModel


+ (instancetype)mapObjectFromDictionary:(NSDictionary *)data {
    
    BaseModel *model = [[self alloc] init];
    [data enumerateKeysAndObjectsUsingBlock:^(NSString * inputKey, id value, BOOL *stop) {

        BOOL isArray = [value isKindOfClass:[NSArray class]];
        Class classToMap = [model keyToClassMappingRules][inputKey];
        
        NSString *propertyName = [[model keyToPropertyNameReplacementRules] valueForKey:inputKey];
        propertyName = propertyName?propertyName:inputKey;
        
        if (classToMap) {
            if (isArray){
                [model setValue:[classToMap mapArrayOfObjects:value] forKey:propertyName];
            } else {
                [model setValue:[classToMap mapObjectFromDictionary:value] forKey:propertyName];
            }
        } else {
            [model setValue:value forKey:propertyName];
        }
    }];
    return model;
}

+ (NSArray *)mapArrayOfObjects:(NSArray *)data {
    
    NSMutableArray *mappedArray = [NSMutableArray arrayWithCapacity:data.count];
    
    for (id value in data) {
        BOOL isArray = [value isKindOfClass:[NSArray class]];
        if (isArray) {
            [mappedArray addObject:[self mapArrayOfObjects:value]];
        } else {
            [mappedArray addObject:[self mapObjectFromDictionary:value]];
        }
    }
    
    return [NSArray arrayWithArray:mappedArray];
}

- (void)updateFromObject:(NSDictionary *)object {
    
    [object enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        BOOL isArray = [obj isKindOfClass:[NSArray class]];
        Class classToMap = [self keyToClassMappingRules][key];
        
        NSString *propertyName = [[self keyToPropertyNameReplacementRules] valueForKey:key];
        propertyName = propertyName ? propertyName : key;
        if (classToMap) {
            if (isArray){
                [self setValue:[classToMap mapArrayOfObjects:obj] forKey:propertyName];
            } else {
                [self setValue:[classToMap mapObjectFromDictionary:obj] forKey:propertyName];
            }
        } else {
            [self setValue:obj forKey:propertyName];
        }
    }];
}
//============================================================================================
#pragma mark - Rules -
//--------------------------------------------------------------------------------------------
- (NSDictionary *)keyToClassMappingRules {
    return nil;
}

- (NSDictionary *)keyToPropertyNameReplacementRules {
    return nil;
}


//============================================================================================
#pragma mark - KVC -
//--------------------------------------------------------------------------------------------

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"--------------------------");
    NSLog(@"undefined key set to - %@ to class - %@", key, NSStringFromClass(self.class));
    NSLog(@"--------------------------");
}


//============================================================================================
#pragma mark - Debug -
//--------------------------------------------------------------------------------------------

#if DEBUG
- (NSString *)description {
    
    NSMutableDictionary *propertyValues = [NSMutableDictionary dictionary];
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++) {
        char const *propertyName = property_getName(properties[i]);
        const char *attr = property_getAttributes(properties[i]);
        if (attr[1] == '@') {
            NSString *selector = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
            SEL sel = sel_registerName([selector UTF8String]);
            NSObject * propertyValue = objc_msgSend(self, sel);
            if (propertyValue){
                propertyValues[selector] = propertyValue.description;
            }
        }
    }
    free(properties);
    return [NSString stringWithFormat:@"%@: %@", self.class, propertyValues];
}
#endif

@end
