//
//  AppRecord.h
//  Monitise
//
//  Created by Chatterjee,Suman on 16/12/2012.
//  Copyright (c) 2012 Chatterjee,Suman. All rights reserved.
//


@interface DataRecord : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) UIImage  *picture;
@property (strong, nonatomic) NSString *notes;
@property (strong, nonatomic) NSString *imageURLString;

@end