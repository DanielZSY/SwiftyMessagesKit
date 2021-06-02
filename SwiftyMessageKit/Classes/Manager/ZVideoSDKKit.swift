
import UIKit
import BFKit
import AgoraRtcKit
import AgoraRtmKit
import SwiftBasicKit

class ZVideoSDKKit: NSObject {
    
    public struct Names {
        /// 远端第一帧
        public static let FirstRemoteVideo = Notification.Name.init(rawValue: "FirstRemoteVideo")
        /// 加入频道错误
        public static let JoinedChannelError = Notification.Name.init(rawValue: "JoinedChannelError")
        /// 加入频道成功
        public static let JoinedChannel = Notification.Name.init(rawValue: "JoinedChannel")
        // 重新加入频道
        public static let RejoinChannel = Notification.Name.init(rawValue: "RejoinChannel")
        /// 远端离线
        public static let RemoteOffline = Notification.Name.init(rawValue: "RemoteOffline")
        /// 远端加入频道
        public static let RemoteJoinedChannel = Notification.Name.init(rawValue: "RemoteJoinedChannel")
        /// 远端离开频道
        public static let RemoteLeaveChannel = Notification.Name.init(rawValue: "RemoteLeaveChannel")
    }
    static let shared = ZVideoSDKKit()
    
    var isSpeakerphone: Bool = false
    var callOperate: kEnumSocketOperate = .none
    var callOperateid: Int = 0
    
    private var modelAnswer: ZModelIMAnswer?
    private var agoraKit: AgoraRtcEngineKit?
    
    override init() {
        super.init()
    }
    required init(model: ZModelIMAnswer?) {
        super.init()
        guard let answer = model else { return }
        
        UIApplication.shared.isIdleTimerDisabled = true
        self.modelAnswer = answer.copyable()
        /// 初始化 AgoraRtcEngineKit 类
        self.agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: ZReload.shared.agora_app_id, delegate: self)
        /// 设置流加密
        let encryption = AgoraEncryptionConfig.init()
        encryption.encryptionMode = AgoraEncryptionMode.AES128XTS
        self.agoraKit?.enableEncryption(true, encryptionConfig: encryption)
        /// 设置视频编码配置
        let videoEncoder = AgoraVideoEncoderConfiguration.init()
        videoEncoder.frameRate = AgoraVideoFrameRate.fps15.rawValue
        videoEncoder.bitrate = AgoraVideoBitrateStandard
        self.agoraKit?.setVideoEncoderConfiguration(videoEncoder)
        /// 设置默认使用扬声器
        self.agoraKit?.setDefaultAudioRouteToSpeakerphone(true)
        /// 监听耳机或扬声器
        NotificationCenter.default.addObserver(self, selector: #selector(funcAudioRouteChangeEvent(_:)), name: AVAudioSession.routeChangeNotification, object: AVAudioSession.sharedInstance())
    }
    deinit {
        self.agoraKit?.delegate = nil
        self.agoraKit = nil
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.routeChangeNotification, object: AVAudioSession.sharedInstance())
    }
    /// 监听耳机或扬声器
    @objc private func funcAudioRouteChangeEvent(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else {
            return
        }
        switch reason {
        case .newDeviceAvailable:
            // 插入耳机时关闭扬声器播放
            self.agoraKit?.setEnableSpeakerphone(false)
        case .oldDeviceUnavailable:
            // 播出耳机时，开启扬声器播放
            self.agoraKit?.setEnableSpeakerphone(true)
        default: break
        }
    }
    /// 设置声网耳机和扬声器
    private final func setEnableSpeakerphone(_ enable: Bool) {
        self.agoraKit?.setEnableSpeakerphone(enable)
    }
    /// 加入频道
    final func joinChannel() {
        let uid = ZSettingKit.shared.userId.intValue
        let token = self.modelAnswer?.channel_token ?? ""
        let channelId = self.modelAnswer?.channel_id ?? ""
        BFLog.debug("joinChannel token: \(token), channelId: \(channelId), uid: \(uid)")
        self.agoraKit?.joinChannel(byToken: token, channelId: channelId, info: nil, uid: UInt(uid))
    }
    /// 离开频道
    final func leaveChannel() {
        self.agoraKit?.disableVideo()
        self.agoraKit?.leaveChannel({ (state) in
            BFLog.info("leaveChannel state: \(state)")
        })
        AgoraRtcEngineKit.destroy()
        UIApplication.shared.isIdleTimerDisabled = false
    }
    /// 切换前后摄像头
    final func switchCamera() {
        self.agoraKit?.switchCamera()
    }
    /// 设置本地视频
    final func setupLocalVideo(_ view: UIView, userid: String) {
        /// 启用视频模块
        self.agoraKit?.enableVideo()
        /// AnchorD启用美颜效果
        let isBeauty = (ZSettingKit.shared.getUserConfig(key: "isBeauty") as? Bool) ?? false
        if ZSettingKit.shared.role == .anchor && isBeauty == true {
            /// 开启美颜
            let options = AgoraBeautyOptions.init()
            // 亮度
            options.lighteningLevel = 0.1
            // 平滑度
            options.smoothnessLevel = 0.3
            // 红色度
            options.rednessLevel = 0.3
            // 亮度明暗对比度
            options.lighteningContrastLevel = .low
            self.agoraKit?.setBeautyEffectOptions(true, options: options)
        } else {
            self.agoraKit?.setBeautyEffectOptions(false, options: nil)
        }
        /// 创建视频控件
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = UInt(userid.intValue)
        videoCanvas.view = view
        videoCanvas.renderMode = .hidden
        /// 设置本地视图
        self.agoraKit?.setupLocalVideo(videoCanvas)
        BFLog.info("setupLocalVideo userid: \(userid)")
    }
    /// 设置远端视频
    final func setupRemoteVideo(_ view: UIView, userid: String) {
        /// 创建视频控件
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = UInt(userid.intValue)
        videoCanvas.view = view
        videoCanvas.renderMode = .hidden
        /// 设置远端视图
        self.agoraKit?.setupRemoteVideo(videoCanvas)
        BFLog.info("setupRemoteVideo uid: \(userid)")
    }
}
extension ZVideoSDKKit: AgoraRtcEngineDelegate {
    
    // SDK 接收到第一帧远端视频并成功解码时，会触发该回调。
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        BFLog.info("firstRemoteVideoDecodedOfUid uid: \(uid), elapsed: \(elapsed)")
        
        NotificationCenter.default.post(name: ZVideoSDKKit.Names.FirstRemoteVideo, object: uid)
    }
    // SDK 远端视频流状态改变
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStateChangedOfUid uid: UInt, state: AgoraVideoRemoteState, reason: AgoraVideoRemoteStateReason, elapsed: Int) {
        BFLog.info("remoteVideoStateChangedOfUid reason: \(reason)")
        switch reason {
        case .remoteOffline:
            NotificationCenter.default.post(name: ZVideoSDKKit.Names.RemoteOffline, object: uid)
        default: break
        }
    }
    /// 发生错误回调
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        BFLog.info("didOccurError errorCode: \(errorCode.rawValue)")
        switch errorCode {
        case .invalidAppId, .invalidToken, .invalidChannelId, .invalidUserAccount:
            NotificationCenter.default.post(name: ZVideoSDKKit.Names.JoinedChannelError, object: errorCode.rawValue)
        default: break
        }
    }
    /// 自己加入频道回调
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        BFLog.info("didJoinChannel uid: \(uid), channelid：\(channel)，elapsed: \(elapsed)")
        
        NotificationCenter.default.post(name: ZVideoSDKKit.Names.JoinedChannel, object: uid)
    }
    /// 重新加入频道回调
    func rtcEngine(_ engine: AgoraRtcEngineKit, didRejoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        BFLog.info("didRejoinChannel uid: \(uid), channelid：\(channel)，elapsed: \(elapsed)")
        
        NotificationCenter.default.post(name: ZVideoSDKKit.Names.RejoinChannel, object: uid)
    }
    /// 已离开频道回调
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
        BFLog.info("didLeaveChannelWith stats: \(stats)")
        
    }
    /// 本地用户成功注册 User Account 回调
    func rtcEngine(_ engine: AgoraRtcEngineKit, didRegisteredLocalUser userAccount: String, withUid uid: UInt) {
        BFLog.info("didRegisteredLocalUser uid: \(uid), userAccount: \(userAccount)")
    }
    /// 远端用户信息已更新回调
    func rtcEngine(_ engine: AgoraRtcEngineKit, didUpdatedUserInfo userInfo: AgoraUserInfo, withUid uid: UInt) {
        BFLog.info("didUpdatedUserInfo uid: \(uid), userAccount: \(userInfo.userAccount)")
    }
    /// 远端用户/主播加入回调
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        BFLog.info("didJoinedOfUid uid: \(uid), elapsed: \(elapsed)")
        
        NotificationCenter.default.post(name: ZVideoSDKKit.Names.RemoteJoinedChannel, object: uid)
    }
    /// 远端用户（通信场景）/主播（直播场景）离开当前频道回调
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        BFLog.info("didOfflineOfUid uid: \(uid), reason: \(reason.rawValue)")
        
        NotificationCenter.default.post(name: ZVideoSDKKit.Names.RemoteLeaveChannel, object: uid)
    }
    /// 网络连接中断，且 SDK 无法在 10 秒内连接服务器回调
    func rtcEngineConnectionDidLost(_ engine: AgoraRtcEngineKit) {
        BFLog.info("rtcEngineConnectionDidLost")
        
    }
    /// Token 服务即将过期回调
    func rtcEngine(_ engine: AgoraRtcEngineKit, tokenPrivilegeWillExpire token: String) {
        BFLog.info("tokenPrivilegeWillExpire token: \(token)")
        self.agoraKit?.renewToken(token)
    }
}
