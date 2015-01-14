//
//  Original source code
//  Created by takiuchi on 08/12/07.
//  Copyright 2008 s21g LLC. All rights reserved.
//  MIT Lisence
//

//
//  optimizedPNG.h
//  Created by sonson on 09/01/25.
//  Copyright 2009 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIImage (optimizedPNG)
- (NSData*)optimizedData;
@end

@interface NSData (optimizedPNG)
- (NSData*)optimizedData;
@end