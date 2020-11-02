//
//  ABCVideoView.m
//  ZmeetDemo
//
//  Created by bingo on 2020/10/30.
//

#import "ABCVideoView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@interface ABCVideoView()
{
    NSString *_uid;
    UIButton *tapButton;
}

@property(nonatomic,strong) UILabel *labNickName;

@property(nonatomic,strong) UIImageView *mutedVideoImageView;

@end


@implementation ABCVideoView

-(instancetype) initViewWithFrame:(CGRect)frame uid:(NSString *) uid
{
    self = [super initWithFrame:frame];
    if (self) {
        _uid = uid;
        [self setupUI];
    }
    return self;
}

-(instancetype) init
{
    self = [super init];
    if (self) {
        _uid = @"0";
        [self setupUI];
    }
    return self;
}

-(void) setupUI
{
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor redColor];
    
    [self addSubview:self.labNickName];
    [_labNickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(20));
    }];
    
    tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tapButton.userInteractionEnabled = YES;
    [self addSubview:tapButton];
    [tapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    tapButton.tag = ([self javaHashCode:_uid] & 0xffffffffL);
    
    [tapButton addTarget:self action:@selector(videoViewDoubleClick:) forControlEvents:UIControlEventTouchDownRepeat];
    [tapButton addTarget:self action:@selector(videoViewClick:) forControlEvents:UIControlEventTouchDown];
}

-(void) setMutedVideoImage:(UIImage *)mutedVideoImage
{
    _mutedVideoImage = mutedVideoImage;
    self.mutedVideoImageView.image = mutedVideoImage;
}

-(void) setNickName:(NSString *)nickName
{
    _nickName = nickName;
    _labNickName.text = nickName;
}

-(void) showMutedImageView
{
    [self addSubview:self.mutedVideoImageView];
    [_mutedVideoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}

-(void) hideMutedImageView
{
    [self.mutedVideoImageView removeFromSuperview];
}

- (void)buttonSingle:(id)sender {
    if ([_delegate respondsToSelector:@selector(liveVideoViewClick:)]) {
        [_delegate liveVideoViewClick:self];
    }
}

- (void)buttonRepeat:(id)sender {
    if ([_delegate respondsToSelector:@selector(liveVideoViewRepeatClick:)]) {
        [_delegate liveVideoViewRepeatClick:self];
    }
}

-(void) videoViewDoubleClick:(id) sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonSingle:)object:sender];
    [self buttonRepeat:sender];
}

-(void) videoViewClick:(id) sender
{
    [self performSelector:@selector(buttonSingle:) withObject:sender afterDelay:0.3];
}

- (void)didAddSubview:(UIView *)subview;
{
    [super didAddSubview:subview];
    [self bringSubviewToFront:_labNickName];
    [self bringSubviewToFront:tapButton];
}

-(UILabel *) labNickName
{
    if (!_labNickName) {
        _labNickName = [[UILabel alloc] initWithFrame:CGRectZero];
        _labNickName.textColor = [UIColor blackColor];
        _labNickName.contentMode = UIViewContentModeCenter;
        _labNickName.textAlignment = NSTextAlignmentCenter;
        _labNickName.font = [UIFont systemFontOfSize:9];
        _labNickName.backgroundColor = [UIColor colorWithHexString:@"2b3944" alpha:0.2];
    }
    return _labNickName;
}

-(UIImageView *) mutedVideoImageView
{
    if (!_mutedVideoImageView) {
        _mutedVideoImageView = [[UIImageView alloc] init];
        if (_mutedVideoImage) {
            _mutedVideoImageView.image = _mutedVideoImage;
        }
    }
    return _mutedVideoImageView;
}

- (int)javaHashCode:(NSString *) str
{
    int h = 0;
    for (int i = 0; i < (int)str.length; i++) {
        h = (31 * h) + [str characterAtIndex:i];
    }
    return h;
}

@end
