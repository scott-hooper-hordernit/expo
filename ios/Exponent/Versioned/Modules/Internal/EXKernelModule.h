// Copyright 2015-present 650 Industries. All rights reserved.

#import <React/RCTEventEmitter.h>

@class EXKernelModule;

@protocol EXKernelModuleDelegate <NSObject>

- (void)kernelModule: (EXKernelModule *)module taskDidForegroundWithType: (NSInteger)type params: (NSDictionary *)params;
- (void)kernelModule:(EXKernelModule *)module
didRequestManifestWithUrl:(NSURL *)url
         originalUrl:(NSURL *)originalUrl
             success:(void (^)(NSString *manifestString))success
             failure:(void (^)(NSError *err))failure;
- (BOOL)kernelModuleShouldEnableDevtools:(EXKernelModule *)module;
- (void)kernelModuleDidSelectDevMenu:(EXKernelModule *)module;

// TODO: kill this as an RCTDevSettings followup
- (void)kernelModuleDidSelectKernelDevMenu: (EXKernelModule *)module DEPRECATED_ATTRIBUTE;

@end

@interface EXKernelModule : RCTEventEmitter

@property (nonatomic, assign) id<EXKernelModuleDelegate> delegate;

- (instancetype)initWithVersions: (NSArray *)supportedSdkVersions;
- (void)dispatchJSEvent: (NSString *)eventName
                   body: (NSDictionary *)eventBody
              onSuccess: (void (^)(NSDictionary *))success
              onFailure: (void (^)(NSString *))failure;

@end
