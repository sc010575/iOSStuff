/*
     File: ParseOperation.m 

  
 */

#import "ParseOperation.h"
#import "DataRecord.h"
#import "NSOPAppDelegate.h"

// string contants found in the RSS feed
static NSString *kFirstNameStr     = @"firstName";
static NSString *kLastNameStr   = @"lastName";
static NSString *kPictureStr  = @"picture";
static NSString *kAgeStr = @"age";
static NSString *kSexStr = @"sex";
static NSString *kNotesStr = @"notes";
static NSString *kEntryStr  = @"contact";

//Private extension.
@interface ParseOperation ()
{
    ArrayBlock      completionHandler;
    ErrorBlock      errorHandler;
    
    NSData          *dataToParse;
    
    NSMutableArray  *workingArray;
    DataRecord       *workingEntry;
    NSMutableString *workingPropertyString;
    NSArray         *elementsToParse;
    BOOL            storingCharacterData;

}

@property (nonatomic, copy) ArrayBlock completionHandler;
@property (nonatomic, strong) NSData *dataToParse;
@property (nonatomic, strong) NSMutableArray *workingArray;
@property (nonatomic, strong) DataRecord *workingEntry;
@property (nonatomic, strong) NSMutableString *workingPropertyString;
@property (nonatomic, strong) NSArray *elementsToParse;
@property (nonatomic, assign) BOOL storingCharacterData;
@end

@implementation ParseOperation

@synthesize completionHandler, errorHandler, dataToParse, workingArray, workingEntry, workingPropertyString, elementsToParse, storingCharacterData;

- (id)initWithData:(NSData *)data completionHandler:(ArrayBlock)handler
{
    self = [super init];
    if (self != nil)
    {
        self.dataToParse = data;
        self.completionHandler = handler;
        self.elementsToParse = [NSArray arrayWithObjects:kFirstNameStr, kLastNameStr, kPictureStr, kAgeStr, kSexStr,nil];
    }
    return self;
}

// -------------------------------------------------------------------------------
//	dealloc:
// -------------------------------------------------------------------------------

// -------------------------------------------------------------------------------
//	main:
//  Given data to parse, use NSXMLParser and process all the top paid apps.
// -------------------------------------------------------------------------------
- (void)main
{
	@autoreleasepool {
	
    self.workingArray = [NSMutableArray array];
    self.workingPropertyString = [NSMutableString string];
    
    // NSXMLParser
    //
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataToParse];
		[parser setDelegate:self];
    [parser parse];
		
		if (![self isCancelled])
    {
        // call our completion handler with the result of our parsing
        self.completionHandler(self.workingArray);
    }
    
    self.workingArray = nil;
    self.workingPropertyString = nil;
    self.dataToParse = nil;
    

	}
}


#pragma mark -
#pragma mark XML processing

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
                                        namespaceURI:(NSString *)namespaceURI
                                       qualifiedName:(NSString *)qName
                                          attributes:(NSDictionary *)attributeDict
{
    // entry: { id (link), im:name (app name), im:image (variable height) }
    //
    if ([elementName isEqualToString:kEntryStr])
	{
        self.workingEntry = [[DataRecord alloc] init];
    }
    storingCharacterData = [elementsToParse containsObject:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
                                      namespaceURI:(NSString *)namespaceURI
                                     qualifiedName:(NSString *)qName
{
    if (self.workingEntry)
	{
        if (storingCharacterData)
        {
            NSString *trimmedString = [workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [workingPropertyString setString:@""];  // clear the string for next time
            if ([elementName isEqualToString:kFirstNameStr])
            {
                self.workingEntry.firstName = trimmedString;
            }
            else if ([elementName isEqualToString:kLastNameStr])
            {        
                self.workingEntry.lastName = trimmedString;
            }
            else if ([elementName isEqualToString:kPictureStr])
            {
                self.workingEntry.imageURLString = trimmedString;
            }
            else if ([elementName isEqualToString:kAgeStr])
            {
                self.workingEntry.age = trimmedString;
            }
            else if ([elementName isEqualToString:kSexStr])
            {
                self.workingEntry.sex = trimmedString;
            }
            else if ([elementName isEqualToString:kNotesStr])
            {
                self.workingEntry.notes = trimmedString;
            }
        }
        else if ([elementName isEqualToString:kEntryStr])
        {
            [self.workingArray addObject:self.workingEntry];  
            self.workingEntry = nil;
        }
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (storingCharacterData)
    {
        [workingPropertyString appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    self.errorHandler(parseError);
}

//special persing needed for CDAT objects
- (void) parser:(NSXMLParser *)parser foundCDATA:(NSData *)data {
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet];
    if(self.workingEntry)
        self.workingEntry.notes= string;
}

@end
