#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SNHUDActivityView : UIImageView {
	UILabel					*label;
	UIActivityIndicatorView *indicator;
	UIImageView				*check;
}
#pragma mark Original
- (void)addCheck;
- (void)setupWithMessage:(NSString*)msg;
- (BOOL)dismiss;
- (void)arrange:(CGRect)rect;
@end
