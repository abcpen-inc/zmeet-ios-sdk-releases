
#  ZMeetSDK开发手册V1.0.0（ios）
[![Version](https://img.shields.io/cocoapods/v/ZMeetSDK.svg?style=flat)](http://cocoapods.org/pods/ZMeetSDK)
[![License](https://img.shields.io/cocoapods/l/ZMeetSDK.svg?style=flat)](http://cocoapods.org/pods/ZMeetSDK)
[![Platform](https://img.shields.io/cocoapods/p/ZMeetSDK.svg?style=flat)](http://cocoapods.org/pods/ZMeetSDK)

[TOC]

## REVISION HISTORY
Version | Date |Changed By |Changes
------|------|------|------
1.0.0 | 2020-11-01|Bing|1.0.0


## 环境准备
### 请确保满足以下开发环境要求：
* Apple XCode 10.0或以上版本
* iOS 11.0或以上版本
* 本sdk提供一个framework：
```  
1、ZMeetCoreKit.framework

```
### pod导入
~~~
pod 'ZMeetSDK'
~~~
## 快速接入
### Step1 初始化SDK
token生成规则详见服务器文档（*建议把appid和appsecret放到服务器操作）
~~~
 [ZRtcEngineKit sharedEngine];
~~~
### Step2 加入会议
```
/**
  [[ZRtcEngineKit sharedEngine] initSDK];
 [[ZRtcEngineKit sharedEngine] joinChannelByToken:accessToken channelId:self.textField.text uid:self.userId displayName:@"demo1"];
            } failure:^(NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
            }];
```

### 其它接口

#### 离开会议
```

/**
 离开
 */
-(void) leaveChannel;
```

#### 设置本地视频预览view
```
/**
 设置本地视频载体，canvas.uid 需与本地userId对应
 */
-(void) setupLocalVideo:(ZMeetVideoCanvas *) canvas;
```

#### 设置远程视频预览view
```
/**
 设置远端视频载体，canvas.uid与远端用户useerId对应，一般在firstRemoteVideoFrameOfUid 中掉用
 */
-(void) setupRemoteVideo:(ZMeetVideoCanvas *) canvas;
```

#### 开启本地音频
```
/**
 开启音频
 */
-(void) enableAudio;
```
#### 关闭本地音频
```
/**
 关闭音频
 */
-(void) disenableAudio;
```
#### 开启本地视频
```
/**
 开启视频
 */
-(void) enableVideo;
```

#### 关闭本地视频
```
/**
 关闭视频
 */
-(void) disEnableVideo;
```

#### 切换本地摄像头
```
/**
 切换视频方向，如果有前后置摄像头
 */
-(void) switchCamera;
```

#### mute  本地音频
```
/**
 mute  本地音频
 */
-(void) muteLocalAudioStream:(BOOL)mute;
```
#### mute  本地视频
```
/**
 mute 本地视频
 */
-(void) muteLocalVideoStream:(BOOL)mute;
```
