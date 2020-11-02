//
//  ViewController.m
//  ZmeetDemo
//
//  Created by bingo on 2020/10/9.
//

#import "ViewController.h"
#import <ZmeetCoreKit/ZmeetCoreKit.h>
#import <MyLayout/MyLayout.h>
#include <CommonCrypto/CommonCrypto.h>
#import "DemoApi.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <WebKit/WKWebView.h>
#import <Masonry/Masonry.h>
#import "ABCVideoView.h"

static NSString *APP_ID = @"";
static NSString *APP_SECRET = @"";

@interface ViewController ()<ZRtcEngineKitDelegate,ABCVideoViewDelegate>

@property(nonatomic, strong) UITextField *textField;

@property(nonatomic, strong) MyLinearLayout *linearLayout;

@property(nonatomic, strong) MyFlowLayout *flowLayout;

@property(nonatomic, strong) UIButton *connectButton;

@property(nonatomic, strong) UIButton *startPreviewButton;

@property(nonatomic, strong) UIButton *switchCameraButton;

@property(nonatomic, strong) UIButton *muteAudioButton;

@property(nonatomic, strong) NSString *userId;

@property(nonatomic, strong) NSString *nickName;

@property(nonatomic, strong) WKWebView *webview;

@property(nonatomic, strong) UIView *currView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [ZRtcEngineKit sharedEngine].delegate = self;
    // Do any additional setup after loading the view.
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    int y =100 +  (arc4random() % 1000001);
    self.userId = uid?uid:[NSString stringWithFormat:@"%d",y];
    [[NSUserDefaults standardUserDefaults]  setObject:self.userId forKey:@"userId"];
    self.nickName = self.userId;
    [self initTextField];
    [self initMenu];
    [self initFlowLayout];
    [self initCurrView];
}

-(void) initCurrView
{
    self.currView = [UIView new];
    [self.view addSubview:self.currView];
    [self.currView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).equalTo(@(10));
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.flowLayout.mas_top).equalTo(@(-10));
    }];
}

-(void) initTextField
{
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 50, self.view.bounds.size.width-100, 50)];
    self.textField.borderStyle=UITextBorderStyleRoundedRect;
    self.textField.returnKeyType =  UIReturnKeyDone;
    self.textField.text = @"abcpen";
    [self.textField setPlaceholder:@"输入会议号"];
    [self.view addSubview:self.textField];
}

-(void) initMenu
{
    self.linearLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    self.linearLayout.myWidth = MyLayoutSize.wrap;
    self.linearLayout.subviewSpace = 5;
    self.linearLayout.myHeight = 50;
    self.linearLayout.frame = CGRectMake(0, self.view.bounds.size.height-80, self.view.bounds.size.width
                                         , 50);
    [self.view addSubview:self.linearLayout];
    
    self.connectButton = [self createButtonWithTitle:@"连接" highlightedTitle:@"断开连接" action:@"connect"];
    self.startPreviewButton = [self createButtonWithTitle:@"开启视频" highlightedTitle:@"关闭视频" action:@"startPreview"];
    self.switchCameraButton = [self createButtonWithTitle:@"切换摄像头" highlightedTitle:@"切换摄像头" action:@"switchCamera"];
    self.muteAudioButton = [self createButtonWithTitle:@"静音" highlightedTitle:@"解除静音" action:@"muteAudio"];


    [self.linearLayout addSubview:self.connectButton];
    [self.linearLayout addSubview:self.startPreviewButton];
    [self.linearLayout addSubview:self.switchCameraButton];
    [self.linearLayout addSubview:self.muteAudioButton];
}

-(void) initFlowLayout
{
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    self.flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:5];
    self.flowLayout.pagedCount = 5;
    self.flowLayout.myHeight = 80;
    self.flowLayout.myWidth = MyLayoutSize.wrap;
    self.flowLayout.subviewSpace = 8;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.linearLayout.mas_top).equalTo(@(-20));
        make.height.equalTo(@(80));
        make.left.right.equalTo(self.view);
    }];
    [scrollView addSubview:self.flowLayout];
}

/**
 获取sesstionToken建议放在服务端处理，保证appid和appsecret不外泄
 */
-(void) joinRoom
{
    if (self.textField.text.length > 0) {
        [SVProgressHUD show];
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970]*1000;
        NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
        long nonce = 1000000 +  (arc4random() % 1000000);
        NSString *sign = [self getABCSign:APP_ID appSecret:APP_SECRET uid:self.userId timestamp:timeString nonceStr:nonce];
        
        NSMutableDictionary *header = [NSMutableDictionary dictionary];
        [header setObject:timeString forKey:@"timestamp"];
        [header setObject:APP_ID forKey:@"appId"];

        [header setObject:sign forKey:@"sign"];
        [header setObject:[NSString stringWithFormat:@"%ld",nonce] forKey:@"nonceStr"];

        [[DemoApi instance] getAccessToken:self.userId authHeader:header success:^(id  _Nonnull responseObject) {
                NSLog(@"token token token: %@",responseObject);
                [SVProgressHUD dismiss];
                if ([[responseObject objectForKey:@"success"] boolValue]) {
                    NSString *accessToken = [responseObject objectForKey:@"data"];
                    [[ZRtcEngineKit sharedEngine] joinChannelByToken:accessToken channelId:self.textField.text uid:self.userId displayName:self.nickName];
                }
            } failure:^(NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
            }
         ];
    }
}

#pragma mark- ZRtcEngineKit method
-(void) connect
{
    if (self.connectButton.isSelected) {
        [[ZRtcEngineKit sharedEngine] leaveChannel];
        self.connectButton.selected = NO;
    }else{
        [[ZRtcEngineKit sharedEngine] initSDK];
        [self joinRoom];
    }
}

-(void) startPreview
{
    if (self.startPreviewButton.isSelected) {
        [[ZRtcEngineKit sharedEngine] disEnableVideo];
        self.startPreviewButton.selected = NO;
    }else{
        ZMeetVideoCanvas *viewCanvas = [[ZMeetVideoCanvas alloc] init];
        UIView *localView = [self getOrAddUserView:self.userId];
        localView.tag = [self.userId hash];
        viewCanvas.view = localView;
        viewCanvas.uid = self.userId;
        
        [[ZRtcEngineKit sharedEngine] setupLocalVideo:viewCanvas];
        [[ZRtcEngineKit sharedEngine] enableVideo];
    }
}

-(void) switchCamera
{
    [[ZRtcEngineKit sharedEngine] switchCamera];
}

-(void) muteAudio
{
    self.muteAudioButton.selected = !self.muteAudioButton.isSelected;
    [[ZRtcEngineKit sharedEngine] muteLocalAudioStream:self.muteAudioButton.isSelected];

}

-(UIButton *) createButtonWithTitle:(NSString *) title
                   highlightedTitle:(NSString *) highlightedTitle
                             action:(NSString *) action
{
                 
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:highlightedTitle forState:UIControlStateSelected];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    button.widthSize.equalTo(@(self.view.bounds.size.width/4));
    button.heightSize.equalTo(@40);
    SEL selector = NSSelectorFromString(action);
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark- private

-(ABCVideoView *) getOrAddUserView:(NSString *) uid
{
    return [self getOrAddUserView:uid withNickName:@""];
}


-(ABCVideoView *) getOrAddUserView:(NSString *) uid withNickName:(NSString *) nickName
{
    for (ABCVideoView *view in self.flowLayout.subviews) {
        if (view.tag == [uid hash]) {
            return view;
        }
    }
   
    ABCVideoView *videoView = [[ABCVideoView alloc] initViewWithFrame:CGRectMake(0, 0, 50, 50) uid:uid];
    videoView.delegate = self;
    videoView.mySize = CGSizeMake(50, 50);
    videoView.userId = uid;
    [self.flowLayout addSubview:videoView];
    return videoView;
}

-(void) removeUserViewWithUid:(NSString *) uid
{
    ABCVideoView *targetView = nil;
    for (ABCVideoView *view in self.flowLayout.subviews) {
        if (view.tag == [uid hash]) {
            targetView = view;
            break;
        }
    }
    [targetView removeFromSuperview];
}

#pragma mark- ZRtcEngineKitDelegate
- (void)joinSuccess:(NSString *)channelId userId:(NSString *)userId
{
    [SVProgressHUD dismiss];
    [self getOrAddUserView:userId withNickName:self.nickName];
    self.connectButton.selected = YES;
    [[ZRtcEngineKit sharedEngine] enableAudio];
}

- (void)joinFail:(ZmeetJoinFailReason)reason
{
    [SVProgressHUD dismiss];
}

-(void) didLeaveChannel
{
    self.connectButton.selected = NO;
    self.muteAudioButton.selected = NO;
    self.startPreviewButton.selected = NO;
    [self.flowLayout removeAllSubviews];
}

- (void) firstLocalVideoFramePublished
{
    self.startPreviewButton.selected = YES;
}

- (void) firstRemoteVideoFrameOfUid:(NSString *)uid
{
    UIView *removeView = [self getOrAddUserView:uid];
    ZMeetVideoCanvas *viewCanvas = [[ZMeetVideoCanvas alloc] init];
    viewCanvas.view = removeView;
    viewCanvas.uid = uid;
    [[ZRtcEngineKit sharedEngine] setupRemoteVideo:viewCanvas];
}

-(void) didUserJoinOfUid:(NSString *)uid displayName:(nonnull NSString *)displayName
{
    [self getOrAddUserView:uid withNickName:displayName];
}

- (void)didOfflineOfUid:(NSString *)uid reason:(ZmeetUserOfflineReason)reason
{
    [self removeUserViewWithUid:uid];
}

-(NSString *) getABCSign:(NSString *) appid
               appSecret:(NSString *) appSecret
                     uid:(NSString *) uid
               timestamp:(NSString *) timestamp
                nonceStr:(long) nonceStr
{
    NSString *signStr = [NSString stringWithFormat:@"appId=%@&timestamp=%@&uid=%@&nonceStr=%ld",appid,timestamp,uid,nonceStr];
    signStr = [self md5String:[signStr dataUsingEncoding:NSUTF8StringEncoding]];
    signStr = [NSString stringWithFormat:@"%@&appSecret=%@",signStr,appSecret];
    signStr = [[self md5String:[signStr dataUsingEncoding:NSUTF8StringEncoding]] uppercaseString];
    return signStr;
}

- (NSString *)md5String:(NSData *) data
{
    unsigned char result[16];
    CC_MD5(data.bytes,(CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

-(void) liveVideoViewClick:(id) sender
{
    ABCVideoView *videoView = sender;
    NSString *uid = videoView.userId;
    if ([self.userId isEqualToString:uid]) {
        
    }else{
        [self cleanCurrView];
        ZMeetVideoCanvas *viewCanvas = [[ZMeetVideoCanvas alloc] init];
        viewCanvas.view = self.currView;
        viewCanvas.uid = uid;
        [[ZRtcEngineKit sharedEngine] setupRemoteVideo:viewCanvas];
    }
}

-(void) cleanCurrView
{
    for (UIView *view in self.currView.subviews) {
        [view removeFromSuperview];
    }
}

@end
