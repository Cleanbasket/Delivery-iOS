//
//  Keychain.h
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 7. 10..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keychain : NSObject
{
    NSString * service;
    NSString * group;
}

-(id) initWithService:(NSString *) service_ withGroup:(NSString*)group_;
-(BOOL) insert:(NSString *)key : (NSData *)data;
-(BOOL) update:(NSString*)key :(NSData*) data;
-(BOOL) remove: (NSString*)key;
-(NSData*) find:(NSString*)key;

@end
