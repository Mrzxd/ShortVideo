//
//  PrefixHeader.h
//  ShortVideo
//
//  Created by 张兴栋 on 2024/3/27.
//  If you want to contact me, you can add my WeChat account: 457742782

#ifndef PrefixHeader_h
#define PrefixHeader_h

#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import <YYModel/YYModel.h>

#import "ShortVideoModel.h"
#import "WebCacheHelpler.h"

#import "NSString+Extension.h"
#import "NSNotification+Extension.h"
#import "NSAttributedString+Extension.h"
#import "UIWindow+Extension.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Extension.h"
#import "NSDate+Extension.h"

//safe thread
#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

//visitor
#define writeVisitor(visitor)\
({\
NSDictionary *dic = [visitor toDictionary];\
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];\
[defaults setObject:dic forKey:@"visitor"];\
[defaults synchronize];\
})

#define UDID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
#define MD5_UDID [UDID md5]

#define WeakSelf  __weak __typeof(&*self)weakSelf = self;
#define RGBHex(rgbValue) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 blue:((float)((rgbValue) & 0xFF))/255.0 alpha:1.0]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/ 255.0f green:g/ 255.0f blue:b/ 255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b, 1.0f)

/// iPhoneX和iPhoneX之后的大屏手机
#define isIphoneXOrLater    (UIScreen.mainScreen.bounds.size.height >= 812)

#define KStatusBarHeight (isIphoneXOrLater ? 44.0 : 20.0)
#define KNavigationHeight (isIphoneXOrLater ? 88.0 : 64.0)
#define KTabBarHeight (isIphoneXOrLater ? 83.0 : 49.0)
#define KSafetyZoneHeight (isIphoneXOrLater ? 34 : 0)

#define AutoRectMake(x,y,width,height)  CGRectMake((CGFloat)(x) *ScalePpth, (CGFloat)(y) *ScalePpth, (CGFloat)(width) *ScalePpth, (CGFloat)(height) *ScalePpth)
#define ScreenWidth                     (CGFloat)[UIScreen mainScreen].bounds.size.width
#define ScreenHeight                    (CGFloat)[UIScreen mainScreen].bounds.size.height
#define ScalePpth                           (CGFloat)((ScreenWidth) /375.0)
#define PPthScale(x)                         (CGFloat)(x) *ScalePpth *1.0
#define CategoryTitleHeight                    34.0

#define StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define SafeAreaTopHeight ((ScreenHeight >= 812.0) && [[UIDevice currentDevice].model isEqualToString:@"iPhone"] ? 88 : 64)
#define SafeAreaBottomHeight ((ScreenHeight >= 812.0) && [[UIDevice currentDevice].model isEqualToString:@"iPhone"]  ? 30 : 0)


static inline NSString * NonNullString(id obj);
static inline NSString * NonNullString(id obj) {
    if ([obj isKindOfClass:[NSNumber class]]) {
        if ([obj  isEqual: @0]) {
            return obj = @"0";
        }
    }
    
    if (obj == nil || obj == NULL || obj == Nil || [obj isKindOfClass:[NSNull class]]) {
        return obj = @"";
    } else {
        obj = [NSString stringWithFormat:@"%@",obj];
        if ([obj containsString:@"(null)"]) {
            obj = [obj stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        } else if ([obj containsString:@"<null>"]) {
            obj = [obj stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        } else if ([obj containsString:@"null"]) {
            obj = [obj stringByReplacingOccurrencesOfString:@"null" withString:@""];
        }
        return obj;
    }
}

static inline NSString *getTheFormatOfObtainingIsDate(void) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

/// 获取当前的系统的时间戳
static inline NSInteger getTheCurrentTimestamp(void) {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    return timestamp;
}

#define ScreenFrame [UIScreen mainScreen].bounds

#define UIViewX(control) (control.frame.origin.x)
#define UIViewY(control) (control.frame.origin.y)

#define UIViewWidth(view) CGRectGetWidth(view.frame)
#define UIViewHeight(view) CGRectGetHeight(view.frame)

#define UIViewMaxX(view) CGRectGetMaxX(view.frame)
#define UIViewMaxY(view) CGRectGetMaxY(view.frame)

#define UIViewMinX(view) CGRectGetMinX(view.frame)
#define UIViewMinY(view) CGRectGetMinY(view.frame)

#define UIViewMidX(view) CGRectGetMidX(view.frame)
#define UIViewMidY(view) CGRectGetMidY(view.frame)

//color
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0    \
blue:((float)(rgbValue & 0xFF)) / 255.0             \
alpha:1.0]

#define ColorWhiteAlpha10 RGBA(255.0, 255.0, 255.0, 0.1)
#define ColorWhiteAlpha20 RGBA(255.0, 255.0, 255.0, 0.2)
#define ColorWhiteAlpha40 RGBA(255.0, 255.0, 255.0, 0.4)
#define ColorWhiteAlpha60 RGBA(255.0, 255.0, 255.0, 0.6)
#define ColorWhiteAlpha80 RGBA(255.0, 255.0, 255.0, 0.8)

#define ColorBlackAlpha1 RGBA(0.0, 0.0, 0.0, 0.01)
#define ColorBlackAlpha5 RGBA(0.0, 0.0, 0.0, 0.05)
#define ColorBlackAlpha10 RGBA(0.0, 0.0, 0.0, 0.1)
#define ColorBlackAlpha20 RGBA(0.0, 0.0, 0.0, 0.2)
#define ColorBlackAlpha40 RGBA(0.0, 0.0, 0.0, 0.4)
#define ColorBlackAlpha60 RGBA(0.0, 0.0, 0.0, 0.6)
#define ColorBlackAlpha80 RGBA(0.0, 0.0, 0.0, 0.8)
#define ColorBlackAlpha90 RGBA(0.0, 0.0, 0.0, 0.9)

#define ColorThemeGrayLight RGBA(104.0, 106.0, 120.0, 1.0)
#define ColorThemeGray RGBA(92.0, 93.0, 102.0, 1.0)
#define ColorThemeGrayDark RGBA(20.0, 21.0, 30.0, 1.0)
#define ColorThemeYellow RGBA(250.0, 206.0, 21.0, 1.0)
#define ColorThemeYellowDark RGBA(235.0, 181.0, 37.0, 1.0)
#define ColorThemeBackground RGBA(14.0, 15.0, 26.0, 1.0)
#define ColorThemeGrayDarkAlpha95 RGBA(20.0, 21.0, 30.0, 0.95)

#define ColorThemeRed RGBA(241.0, 47.0, 84.0, 1.0)

#define ColorRoseRed RGBA(220.0, 46.0, 123.0, 1.0)
#define ColorClear [UIColor clearColor]
#define ColorBlack [UIColor blackColor]
#define ColorWhite [UIColor whiteColor]
#define ColorGray  [UIColor grayColor]
#define ColorBlue RGBA(40.0, 120.0, 255.0, 1.0)
#define ColorGrayLight RGBA(40.0, 40.0, 40.0, 1.0)
#define ColorGrayDark RGBA(25.0, 25.0, 35.0, 1.0)
#define ColorGrayDarkAlpha95 RGBA(25.0, 25.0, 35.0, 0.95)
#define ColorSmoke RGBA(230.0, 230.0, 230.0, 1.0)


//Font
#define SuperSmallFont [UIFont systemFontOfSize:10.0]
#define SuperSmallBoldFont [UIFont boldSystemFontOfSize:10.0]

#define SmallFont [UIFont systemFontOfSize:12.0]
#define SmallBoldFont [UIFont boldSystemFontOfSize:12.0]

#define MediumFont [UIFont systemFontOfSize:14.0]
#define MediumBoldFont [UIFont boldSystemFontOfSize:14.0]

#define BigFont [UIFont systemFontOfSize:16.0]
#define BigBoldFont [UIFont boldSystemFontOfSize:16.0]

#define LargeFont [UIFont systemFontOfSize:18.0]
#define LargeBoldFont [UIFont boldSystemFontOfSize:18.0]

#define SuperBigFont [UIFont systemFontOfSize:26.0]
#define SuperBigBoldFont [UIFont boldSystemFontOfSize:26.0]

#define readVisitor()\
({\
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];\
NSDictionary *dic = [defaults objectForKey:@"visitor"];\
Visitor *visitor = [[Visitor alloc] initWithDictionary:dic error:nil];\
(visitor);\
})

#endif /* PrefixHeader_h */
