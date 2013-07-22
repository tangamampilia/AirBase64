//
//  Base64Encoder.h
//  Base64Encoder
//
//  Created by Daniel Fernandez on 6/8/13.
//  Copyright (c) 2013 Daniel Fernández. All rights reserved.
//

#import "Base64Encoder.h"

FREContext Base64EncoderCtx = nil;

@implementation Base64Encoder


//
// base64EncodedString
//
// Encodes the base64 NSData in the data to a newly NSString
//
//  @params
//  data - the NSData for the encode
//
//  @return
//  the encoded NSString.
//
+ (NSString *)base64EncodedString:(NSData *)data {
	
    size_t outputLength;
	char *outputBuffer = NewBase64Encode([data bytes], [data length], true, &outputLength);
	
	NSString *result = [[NSString alloc] initWithBytes:outputBuffer length:outputLength encoding:NSASCIIStringEncoding];
	free(outputBuffer);
	return result;
    
}


//
// dataFromBase64String
//
// Decodes the base64 NSString in the aString to a newly NSData
//
//  @params
//  aString - the NSString for the decode
//
//  @return
//  the decoded NSData.
//
+ (NSData *)dataFromBase64String:(NSString *)aString {
    
	NSData *data = [aString dataUsingEncoding:NSASCIIStringEncoding];
	size_t outputLength;
	void *outputBuffer = NewBase64Decode([data bytes], [data length], &outputLength);
    
	NSData *result = [NSData dataWithBytes:outputBuffer length:outputLength];
	free(outputBuffer);
	return result;
}

@end


//
// Base64EncoderEncode
//
// Function which encode a ByteArray
//
//  @params
//  FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]
//
//  @return
//  the encoded ByteArray as String.
//
FREObject Base64EncoderEncode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    // Declares vars
    FREObject base64;
    FREByteArray byteArray;
    
    // Get the ByteArray into a native object
    FREAcquireByteArray(argv[0], &byteArray);
    
    // 
    NSData *byteData = [NSData dataWithBytes:(void *)byteArray.bytes length:(NSUInteger)byteArray.length];
    NSString *base64str = [Base64Encoder base64EncodedString:byteData];
    FRENewObjectFromUTF8(strlen([base64str UTF8String]), (const uint8_t *)[base64str UTF8String], &base64);
    FREReleaseByteArray(argv[0]);
    
    return base64;
}


//
// Base64EncoderDecode
//
// Function which decode a Base64 string
//
//  @params
//  FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]
//
//  @return
//  the decoded String as ByteArray.
//
FREObject Base64EncoderDecode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    uint32_t base64strLength;
    NSString *base64str = nil;
    
    const uint8_t *base64String;
    if (FREGetObjectAsUTF8(argv[0], &base64strLength, &base64String) == FRE_OK) {
        base64str = [NSString stringWithUTF8String:(char *)base64String];
    }
    
    NSData *byteData = [Base64Encoder dataFromBase64String:base64str];
    
    FREObject byteObject;
    FREObject byteDataLength;
    FREByteArray byteArray;
    
    FRENewObjectFromInt32(byteData.length, &byteDataLength);
    
    FRENewObject((const uint8_t*)"flash.utils.ByteArray", 0, NULL, &byteObject, NULL);
    FRESetObjectProperty(byteObject, (const uint8_t*)"length", byteDataLength, NULL);
    FREAcquireByteArray(byteObject, &byteArray);
    
    memcpy(byteArray.bytes, byteData.bytes, byteData.length);
    FREReleaseByteArray(byteObject);
    
    return byteObject;
}


#pragma mark - ANE setup

void Base64EncoderContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    // Register the links btwn AS3 and ObjC. (dont forget to modify the nbFuntionsToLink integer if you are adding/removing functions)
    NSInteger nbFuntionsToLink = 2;
    *numFunctionsToTest = nbFuntionsToLink;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * nbFuntionsToLink);
    
    func[0].name = (const uint8_t*) "Base64EncoderEncode";
    func[0].functionData = NULL;
    func[0].function = &Base64EncoderEncode;
    
    func[1].name = (const uint8_t*) "Base64EncoderDecode";
    func[1].functionData = NULL;
    func[1].function = &Base64EncoderDecode;
    
    *functionsToSet = func;
    
    Base64EncoderCtx = ctx;
}

void Base64EncoderContextFinalizer(FREContext ctx) { }

void Base64EncoderInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
	*extDataToSet = NULL;
	*ctxInitializerToSet = &Base64EncoderContextInitializer;
	*ctxFinalizerToSet = &Base64EncoderContextFinalizer;
}

void Base64EncoderFinalizer(void* extData) { }
