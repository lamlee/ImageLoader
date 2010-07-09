//
//  ImageLoaderDelegate.h
//  OCB
//
//  Created by Yves Vogl on 04.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ImageLoaderDelegate

-(void)loaderDidFinishWithResult:(UIImage *)image fromCache:(BOOL)wasCached;

@optional

-(void)loaderDidFailWithError:(NSError *)error;
-(void)loaderDidCancelConnection;



@end
