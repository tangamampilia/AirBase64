//
//  AirBase64Encoder.h
//  AirBase64Encoder
//
//  Created by Daniel Fernandez on 6/8/13.
//  Copyright (c) 2013 Daniel Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import "NSData+Base64.h"

@interface AirBase64 : NSObject

@end

// C interface
FREObject AirBase64EncoderEncode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject AirBase64EncoderDecode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);

// ANE setup
void AirBase64EncoderContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);
void AirBase64EncoderContextFinalizer(FREContext ctx);
void AirBase64EncoderInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);
void AirBase64EncoderFinalizer(void* extData);
