//
//  CustomContent.m
//  Monitise
//
//  Created by Chatterjee,Suman on 18/12/2012.
//  Copyright (c) 2012 Chatterjee,Suman. All rights reserved.
//

#import "CustomContent.h"

@interface CustomContent()

@property (weak ,nonatomic) IBOutlet UILabel * FirstName;
@property (weak ,nonatomic) IBOutlet UILabel * LastName;
@property (weak ,nonatomic) IBOutlet UILabel * Age;
@property (weak ,nonatomic) IBOutlet UILabel * Sex;

@end

@implementation CustomContent

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//Creat the view with the records 
-(void) createView:(DataRecord*)appRecord;
{
    self.FirstName.text = appRecord.firstName;
    self.LastName.text  = appRecord.lastName;
    self.Age.text       = appRecord.age;
    self.Sex.text       = [appRecord.sex capitalizedString];
}

@end
