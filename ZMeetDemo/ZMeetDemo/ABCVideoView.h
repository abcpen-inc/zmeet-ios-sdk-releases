//
//  ABCVideoView.h
//  ZmeetDemo
//
//  Created by bingo on 2020/10/30.
//

#import <UIKit/UIKit.h>

@protocol ABCVideoViewDelegate <NSObject>

@optional

-(void) liveVideoViewClick:(id) sender;
-(void) liveVideoViewRepeatClick:(id) sender;

@end

@interface ABCVideoView : UIView

@property (nonatomic, strong) UIImage *mutedVideoImage;

@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, weak) id<ABCVideoViewDelegate> delegate;

-(instancetype) initViewWithFrame:(CGRect)frame uid:(NSString *) uid;

-(void) showMutedImageView;

-(void) hideMutedImageView;

@end

