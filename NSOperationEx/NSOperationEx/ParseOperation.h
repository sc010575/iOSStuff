//
//  ParseOperation.h
//  Monitise
//
//  Created by Chatterjee,Suman on 16/12/2012.
//  Copyright (c) 2012 Chatterjee,Suman. All rights reserved.
//

typedef void (^ArrayBlock)(NSArray *);
typedef void (^ErrorBlock)(NSError *);

@class DataRecord;

@interface ParseOperation : NSOperation <NSXMLParserDelegate>

@property (nonatomic, copy) ErrorBlock errorHandler;

- (id)initWithData:(NSData *)data completionHandler:(ArrayBlock)handler;

@end
