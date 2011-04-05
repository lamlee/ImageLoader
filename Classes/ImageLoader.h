//
//  ImageLoader.h
//
//  Created by Yves Vogl on 19.11.09.
//  Copyright 2009 DEETUNE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageLoaderDelegate.h"


@interface ImageLoader : NSObject {
	__weak NSObject <ImageLoaderDelegate> *delegate;
	NSString *filename;
	NSString *filepath;
	NSString *cachePath;
	NSMutableData *receivedData;
	NSURLConnection *theConnection;
	BOOL shouldCacheImage;
	NSString *cacheIdentifier;
}

@property(nonatomic, assign) NSObject <ImageLoaderDelegate> *delegate;
@property(nonatomic, copy) NSString *filename;
@property(nonatomic, copy) NSString *filepath;
@property(nonatomic, copy) NSString *cachePath;
@property(nonatomic, retain) NSURLConnection *theConnection;
@property(nonatomic, retain) NSMutableData *receivedData;
@property(nonatomic, assign) BOOL shouldCacheImage;
@property(nonatomic, copy) NSString *cacheIdentifier;

-(id)initWithDelegate:(NSObject <ImageLoaderDelegate> *)theDelegate;
-(id)initWithRemotePath:(NSString *)aPath delegate:(NSObject <ImageLoaderDelegate> *)theDelegate;
-(id)initWithRemoteURL:(NSURL *)aURL delegate:(NSObject <ImageLoaderDelegate> *)theDelegate;

+(id)loadFromRemotePath:(NSString *)aPath delegate:(NSObject <ImageLoaderDelegate> *)theDelegate;
+(id)loadFromRemoteURL:(NSURL *)aURL delegate:(NSObject <ImageLoaderDelegate> *)theDelegate;
+(id)loadAndCacheFromRemotePath:(NSString *)aPath delegate:(NSObject <ImageLoaderDelegate> *)theDelegate;
+(id)loadAndCacheFromRemoteURL:(NSURL *)aURL delegate:(NSObject <ImageLoaderDelegate> *)theDelegate;
+(id)forceReloadFromRemotePath:(NSString *)aPath delegate:(NSObject <ImageLoaderDelegate> *)theDelegate;
+(id)forceReloadFromRemoteURL:(NSURL *)aURL delegate:(NSObject <ImageLoaderDelegate> *)theDelegate;
+(id)refreshCacheFromRemotePath:(NSString *)aPath delegate:(NSObject <ImageLoaderDelegate> *)theDelegate;
+(id)refreshCacheFromRemoteURL:(NSURL *)aURL delegate:(NSObject <ImageLoaderDelegate> *)theDelegate;

+(NSString *)generateUniqueFilename;

-(BOOL)loadAndCache;
-(BOOL)loadAndCache:(BOOL)doCaching;
-(BOOL)loadAndCache:(BOOL)doCaching force:(BOOL)reload;
-(void)cancelConnection;

@end






