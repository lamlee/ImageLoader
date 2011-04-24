//
//  ImageLoaderDelegate.h
//  OCB
//
//  Created by Yves Vogl on 04.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageLoader;

@protocol ImageLoaderDelegate


- (void)imageLoader:(ImageLoader *)theLoader didFinishWithResult:(UIImage *)image fromCache:(BOOL)wasCached;

@optional

- (void)imageLoader:(ImageLoader *)theLoader didFailWithError:(NSError *)error;
- (void)imageLoaderDidCancelConnection:(ImageLoader *)theLoader;



@end
