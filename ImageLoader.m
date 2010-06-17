//
//  ImageLoader.m
//
//  Created by Yves Vogl on 19.11.09.
//  Copyright 2009 DEETUNE. All rights reserved.
//

#import "ImageLoader.h"

@implementation ImageLoader

#define CacheDirectory NSTemporaryDirectory()

@synthesize delegate, filename, filepath, cachePath, theConnection, receivedData, shouldCacheImage, cacheIdentifier;


-(id)init {

	self = [super init];
	
	if (self != nil) {
		self.shouldCacheImage = YES;
		self.cachePath = CacheDirectory;
	}
	
	return self;
}

-(id)initWithDelegate:(NSObject <ImageLoaderDelegate> *)theDelegate {
	
	self = [self init];
	
	if (self != nil) {
		self.delegate = theDelegate;
	}
	
	return self;
}

- (id)initWithRemotePath:(NSString *)aPath delegate:(NSObject <ImageLoaderDelegate> *)theDelegate {
	
	self = [self initWithDelegate:theDelegate];
	
	if (self != nil) {
		self.filename = [[[aPath lastPathComponent] componentsSeparatedByString:@"?"] objectAtIndex:0];		
		self.filepath = aPath;	
		
		const char *cString = [aPath UTF8String];
		unsigned char result[CC_MD5_DIGEST_LENGTH];
		CC_MD5(cString, strlen(cString), result);
		self.cacheIdentifier = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];			
	}	
	return self;
}

- (void) dealloc {
	self.delegate = nil;
	self.filename = nil;
	self.cacheIdentifier = nil;
	self.filepath = nil;
	self.cachePath = nil;
	self.theConnection = nil;
	self.receivedData = nil;
	[super dealloc];
}

+(id)loadFromRemotePath:(NSString *)aPath delegate:(NSObject <ImageLoaderDelegate> *)theDelegate {

	ImageLoader *loader = [[[ImageLoader alloc] initWithRemotePath:aPath delegate:theDelegate] autorelease];
	
	if (loader != nil) {
		[loader loadAndCache:NO];
	} 
	
	return loader;	
}

+(id)loadAndCacheFromRemotePath:(NSString *)aPath delegate:(NSObject <ImageLoaderDelegate> *)theDelegate {
	
	ImageLoader *loader = [[[ImageLoader alloc] initWithRemotePath:aPath delegate:theDelegate] autorelease];
	
	if (loader != nil) {
		[loader loadAndCache:YES];
	} 
	
	return loader;	
}

+(id)forceReloadFromRemotePath:(NSString *)aPath delegate:(NSObject <ImageLoaderDelegate> *)theDelegate {
	ImageLoader *loader = [[[ImageLoader alloc] initWithRemotePath:aPath delegate:theDelegate] autorelease];
	
	if (loader != nil) {
		[loader loadAndCache:NO force:YES];
	} 
	
	return loader;	
}

+(id)refreshCacheFromRemotePath:(NSString *)aPath delegate:(NSObject <ImageLoaderDelegate> *)theDelegate {
	ImageLoader *loader = [[[ImageLoader alloc] initWithRemotePath:aPath delegate:theDelegate] autorelease];
	
	if (loader != nil) {
		[loader loadAndCache:YES force:YES];
	} 
	
	return loader;	
}

-(BOOL)loadAndCache {
	return [self loadAndCache:YES force:NO];
}

-(BOOL)loadAndCache:(BOOL)doCaching {
	return [self loadAndCache:doCaching force:NO];
}

-(BOOL)loadAndCache:(BOOL)doCaching force:(BOOL)reload {
	
	if(!reload && [[NSFileManager defaultManager] fileExistsAtPath:[self.cachePath stringByAppendingPathComponent:self.cacheIdentifier]]) {			
		
		NSLog(@"Loading file from cache: %@", [self.cachePath stringByAppendingPathComponent:self.cacheIdentifier]);
		
		if ([self.delegate respondsToSelector:@selector(loaderDidFinishWithResult:fromCache:)]) {
			UIImage *image = [UIImage imageWithContentsOfFile:[self.cachePath stringByAppendingPathComponent:self.cacheIdentifier]];
			[self.delegate loaderDidFinishWithResult:image fromCache:YES];
		}		
		
		return YES;
		
	} else {

		NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.filepath]
											cachePolicy:NSURLRequestUseProtocolCachePolicy
										timeoutInterval:5.0];

		self.theConnection = [[[NSURLConnection alloc] initWithRequest:theRequest delegate:self] autorelease];


		if (self.theConnection) {
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
			self.receivedData = [NSMutableData data];
	
			if (self.shouldCacheImage) {
				self.shouldCacheImage = doCaching;
			}
	
			return YES;
		} else {
			
			if ([self.delegate respondsToSelector:@selector(loaderDidFailWithError:)]) {
				[self.delegate loaderDidFailWithError:[NSError errorWithDomain:@"Failed to load image" code:-1 userInfo:nil]];
			}	
				
			return NO;
		}		
	}	
	return NO;	
}
	

#pragma mark -
#pragma mark NSURLConnection Delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	if ([self.delegate respondsToSelector:@selector(loaderDidFailWithError:)]) {
		[self.delegate loaderDidFailWithError:error];
	}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.theConnection = nil;
    self.receivedData = nil;	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	UIImage *image = [UIImage imageWithData:self.receivedData];
	
	if (image != nil) {
	
		if (shouldCacheImage) {		
			[self.receivedData writeToFile:[self.cachePath stringByAppendingPathComponent:self.cacheIdentifier] atomically:YES];
		}
		
		if ([self.delegate respondsToSelector:@selector(loaderDidFinishWithResult:fromCache:)]) {		
			[self.delegate loaderDidFinishWithResult:image fromCache:NO];
		}
	} else {
		if ([self.delegate respondsToSelector:@selector(loaderDidFailWithError:)]) {
			[self.delegate loaderDidFailWithError:[NSError errorWithDomain:@"Could not initialize image from retrieved data" code:-1 userInfo:nil]];
		}
	}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
    self.theConnection = nil;
	self.receivedData = nil;
}
			 
- (void)cancelConnection {
	
	if ([self.delegate respondsToSelector:@selector(loadedDidCancelConnection)]) {
		[self.delegate loaderDidCancelConnection];
	}
	
	[self.theConnection cancel];
	self.theConnection = nil;
	self.receivedData = nil;
}

@end
