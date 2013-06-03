//
//  MCOAbstractMessage.m
//  mailcore2
//
//  Created by DINH Viêt Hoà on 3/10/13.
//  Copyright (c) 2013 MailCore. All rights reserved.
//

#import "MCOAbstractMessage.h"

#include "MCAbstractMessage.h"
#include "MCMessageHeader.h"
#include "MCAbstractPart.h"

#import "MCOMessageHeader.h"
#import "MCOAbstractPart.h"
#import "NSObject+MCO.h"
#import "NSString+MCO.h"

@implementation MCOAbstractMessage {
    mailcore::AbstractMessage * _message;
}

#define nativeType mailcore::AbstractMessage

- (mailcore::Object *) mco_mcObject
{
    return _message;
}

- (id) initWithMCMessage:(mailcore::AbstractMessage *)message
{
    self = [super init];
    
    message->retain();
    _message = message;
    
    return self;
}

- (id) initWithCoder:(NSCoder *)decoder
{
	self = [super init];
	
	self.header = [[decoder decodeObjectForKey:@"header"] retain];
	
	return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.header forKey:@"header"];
}

- (id) copyWithZone:(NSZone *)zone
{
	MCOAbstractMessage *message;
	
	
	message = [[[self class] alloc] initWithMCMessage:(mailcore::AbstractMessage *)_message->copy()];
	message.header = [self header];
	
	return message;
}

- (void) dealloc
{
    _message->release();
    [super dealloc];
}

- (NSString *) description
{
    return MCO_OBJC_BRIDGE_GET(description);
}

MCO_OBJC_SYNTHESIZE(MessageHeader, setHeader, header)

- (MCOAbstractPart *) partForContentID:(NSString *)contentID
{
    return MCO_TO_OBJC(MCO_NATIVE_INSTANCE->partForContentID([contentID mco_mcString]));
}

- (MCOAbstractPart *) partForUniqueID:(NSString *)uniqueID
{
    return MCO_TO_OBJC(MCO_NATIVE_INSTANCE->partForUniqueID([uniqueID mco_mcString]));
}

- (NSArray *) attachments
{
    return MCO_OBJC_BRIDGE_GET(attachments);
}

- (NSArray *) htmlInlineAttachments
{
    return MCO_OBJC_BRIDGE_GET(htmlInlineAttachments);
}

@end
