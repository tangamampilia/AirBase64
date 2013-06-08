//
//  Base64Encoder.h
//  Base64Encoder
//
//  Created by Daniel Fernandez on 6/8/13.
//  Copyright (c) 2013 Daniel Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import "NSData+Base64.h"

@interface Base64Encoder : NSObject

@end

// C interface
FREObject Base64EncoderEncode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject Base64EncoderDecode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);

// ANE setup
void Base64EncoderContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);
void Base64EncoderContextFinalizer(FREContext ctx);
void Base64EncoderInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);
void Base64EncoderFinalizer(void* extData);
