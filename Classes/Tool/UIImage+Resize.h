//
//  UIImage+Resize.h
//  hideHere
//
//  Created by sonson on 09/06/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage(Resize) 
+ (UIImage*) reduceUIImage:(UIImage*)inputImage maximumSize:(int)max_size;
@end
