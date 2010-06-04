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
}

@property(nonatomic, assign) NSObject <ImageLoaderDelegate> *delegate;
@property(nonatomic, retain) NSString *filename;
@property(nonatomic, retain) NSString *filepath;
@property(nonatomic, retain) NSString *cachePath;
@property(nonatomic, retain) NSURLConnection *theConnection;
@property(nonatomic, retain) NSMutableData *receivedData;
@property(nonatomic, assign) BOOL shouldCacheImage;


-(id)initWithDelegate:(NSObject <ImageLoaderDelegate> *)theDelegate;
-(id)initWithRemotePath:(NSString *)aPath delegate:(NSObject <ImageLoaderDelegate> *)theDelegate;

+(id)loadFromRemotePath:(NSString *)aPath delegate:(NSObject <ImageLoaderDelegate> *)theDelegate;
+(id)loadAndCacheFromRemotePath:(NSString *)aPath delegate:(NSObject <ImageLoaderDelegate> *)theDelegate;
+(id)forceReloadFromRemotePath:(NSString *)aPath delegate:(NSObject <ImageLoaderDelegate> *)theDelegate;
+(id)refreshCacheFromRemotePath:(NSString *)aPath delegate:(NSObject <ImageLoaderDelegate> *)theDelegate;

-(BOOL)loadAndCache;
-(BOOL)loadAndCache:(BOOL)doCaching;
-(BOOL)loadAndCache:(BOOL)doCaching force:(BOOL)reload;
-(void)cancelConnection;

@end






