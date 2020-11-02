//
//  ZRtcEngine.h
//  ZmeetCoreKit
//
//  Created by bingo on 2020/10/12.
//

#import <Foundation/Foundation.h>

@class ZMeetVideoCanvas;

typedef NS_ENUM(NSUInteger, ZmeetUserOfflineReason) {
    ZMeetUserOfflineReasonQuit = 0,
    ZMeetUserOfflineReasonDropped = 1,
    ZMeetUserOfflineReasonBecomeAudience = 2,
};

typedef NS_ENUM(NSUInteger, ZmeetJoinFailReason) {
    ZmeetJoinFailReasonTokenInvalid = 0,
    ZmeetJoinFailReasonRoom = 1,
};

NS_ASSUME_NONNULL_BEGIN

@protocol ZRtcEngineKitDelegate <NSObject>
@optional

/**
 加入成功
 */
-(void) joinSuccess:(NSString *) channelId userId:(NSString *) userId;

/**
 加入失败，具体看reason
 */
-(void) joinFail:(ZmeetJoinFailReason) reason;

/**
 已离开
 */
-(void) didLeaveChannel;

/**
 本地视频流推送成功
 */
-(void) firstLocalVideoFramePublished;

/**
 远端视频流新增
 */
-(void) firstRemoteVideoFrameOfUid:(NSString *)uid;

/**
 视频mute
 */
-(void) didVideoMuted:(BOOL)muted byUid:(NSString *)uid;

/**
 用户加入
 */
-(void) didUserJoinOfUid:(NSString *) uid displayName:(NSString *) displayName;

/**
 用户离开
 */
-(void) didOfflineOfUid:(NSString *) uid reason:(ZmeetUserOfflineReason)reason;

@end

@interface ZRtcEngineKit : NSObject

@property(nonatomic,weak) id<ZRtcEngineKitDelegate> delegate;
@property(nonatomic,strong) NSString *currentUserId;
@property(nonatomic,strong) NSString *channelId;
@property(nonatomic,strong) NSString *displayName;

+(instancetype) sharedEngine;

-(void) initSDK;

/**
 joinChannelByToken
 token 建议从服务端掉用zmeet api接口生成
 */
-(void) joinChannelByToken:(NSString * _Nullable)token
                channelId:(NSString * _Nonnull)channelId
                       uid:(NSString *) uid
               displayName:(NSString *) displayName;

/**
 离开
 */
-(void) leaveChannel;

/**
 设置本地视频载体，canvas.uid 需与本地userId对应
 */
-(void) setupLocalVideo:(ZMeetVideoCanvas *) canvas;

/**
 设置远端视频载体，canvas.uid与远端用户useerId对应，一般在firstRemoteVideoFrameOfUid 中掉用
 */
-(void) setupRemoteVideo:(ZMeetVideoCanvas *) canvas;

/**
 开启音频
 */
-(void) enableAudio;

/**
 关闭音频
 */
-(void) disenableAudio;

/**
 开启视频
 */
-(void) enableVideo;

/**
 关闭视频
 */
-(void) disEnableVideo;

/**
 切换视频方向，如果有前后置摄像头
 */
-(void) switchCamera;

/**
 mute  本地音频
 */
-(void) muteLocalAudioStream:(BOOL)mute;

/**
 mute 本地视频
 */
-(void) muteLocalVideoStream:(BOOL)mute;


@end

NS_ASSUME_NONNULL_END
