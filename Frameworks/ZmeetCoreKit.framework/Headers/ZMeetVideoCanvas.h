//
//  ZMeetVideoCanvas.h
//  ZmeetCoreKit
//
//  Created by bingo on 2020/10/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZMeetVideoMirrorMode) {
    ZMeetVideoMirrorModeAuto = 0,
    ZMeetVideoMirrorModeEnabled = 1,
    ZMeetVideoMirrorModeDisabled = 2,
};

@interface ZMeetVideoCanvas : NSObject

@property (strong, nonatomic) UIView* _Nullable view;
@property (copy, nonatomic) NSString* _Nullable channelId;
@property (assign, nonatomic) NSString *uid;
@property (assign, nonatomic) ZMeetVideoMirrorMode mirrorMode;


@end

NS_ASSUME_NONNULL_END
