//
//  AirBase64.h
//  AirBase64
//
//  Created by Daniel Fernandez on 6/8/13.
//  Copyright (c) 2013 Daniel Fernández. All rights reserved.
//

#import "AirBase64.h"

FREContext AirBase64Ctx = nil;

@implementation AirBase64


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
// AirBase64Encode
//
// Function which encode a ByteArray
//
//  @params
//  FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]
//
//  @return
//  the encoded ByteArray as String.
//
FREObject AirBase64Encode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    // Declares vars
    FREObject base64;
    FREByteArray byteArray;
    
    // Get the ByteArray into a native object
    FREAcquireByteArray(argv[0], &byteArray);
    
    // 
    NSData *byteData = [NSData dataWithBytes:(void *)byteArray.bytes length:(NSUInteger)byteArray.length];
    NSString *base64str = [AirBase64 base64EncodedString:byteData];
    FRENewObjectFromUTF8(strlen([base64str UTF8String]), (const uint8_t *)[base64str UTF8String], &base64);
    FREReleaseByteArray(argv[0]);
    
    return base64;
}


//
// AirBase64Decode
//
// Function which decode a Base64 string
//
//  @params
//  FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]
//
//  @return
//  the decoded String as ByteArray.
//
FREObject AirBase64Decode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    uint32_t base64strLength;
    NSString *base64str = nil;
    
    const uint8_t *base64String;
    if (FREGetObjectAsUTF8(argv[0], &base64strLength, &base64String) == FRE_OK) {
        base64str = [NSString stringWithUTF8String:(char *)base64String];
    }
    
    NSData *byteData = [AirBase64 dataFromBase64String:base64str];
    
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

void AirBase64ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    // Register the links btwn AS3 and ObjC. (dont forget to modify the nbFuntionsToLink integer if you are adding/removing functions)
    NSInteger nbFuntionsToLink = 2;
    *numFunctionsToTest = nbFuntionsToLink;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * nbFuntionsToLink);
    
    func[0].name = (const uint8_t*) "AirBase64Encode";
    func[0].functionData = NULL;
    func[0].function = &AirBase64Encode;
    
    func[1].name = (const uint8_t*) "AirBase64Decode";
    func[1].functionData = NULL;
    func[1].function = &AirBase64Decode;
    
    *functionsToSet = func;
    
    AirBase64Ctx = ctx;
}

void AirBase64ContextFinalizer(FREContext ctx) { }

void AirBase64Initializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
	*extDataToSet = NULL;
	*ctxInitializerToSet = &AirBase64ContextInitializer;
	*ctxFinalizerToSet = &AirBase64ContextFinalizer;
}

void AirBase64Finalizer(void* extData) { }
