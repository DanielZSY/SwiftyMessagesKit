
import UIKit
import AVKit
import BFKit

/// 音频播放管理
public class ZAudioCallKit: NSObject {
    
    /// 静态模式
    public static let shared = ZAudioCallKit()
    /// 是否播放中
    public var isPlayer: Bool { return self.isPlaying }
    /// 是否播放中
    private var isPlaying: Bool = false
    /// 播放音频对象
    private var audioPlayer: AVAudioPlayer?
    
    /// 开始播放声音
    public final func playSound(_ name: String = "anchor") {
        self.stopSound()
        if ZObserverKit.shared.isWhetherMute { return }
        if self.isPlaying { return }
        do {
            let session = AVAudioSession.sharedInstance()
            // 启动音频会话管理，此时会阻断后台音乐播放
            try session.setActive(true)
            // 设置音频播放类别，表示该应用仅支持音频播放
            try session.setCategory(AVAudioSession.Category.playback)
            // 将字符串路径转化为网址路径
            let soundUrl = URL.callUrl(named: name) ?? URL.init(fileURLWithPath: "")
            BFLog.debug("soundUrl: \(soundUrl.path)")
            // 创建播放器对象
            try self.audioPlayer = AVAudioPlayer.init(contentsOf: soundUrl)
            // 为音频播放做好准备
            self.audioPlayer?.prepareToPlay()
            // 设置音量
            self.audioPlayer?.volume = 1.0
            // 设置音频播放的次数，-1为无限循环播放
            self.audioPlayer?.numberOfLoops = -1
            DispatchQueue.main.async {
                self.audioPlayer?.play()
            }
            self.isPlaying = true
        } catch {
            BFLog.debug("error: \(error.localizedDescription)")
        }
    }
    /// 停止播放声音
    public final func stopSound() {
        DispatchQueue.main.async {
            self.audioPlayer?.pause()
            self.audioPlayer?.stop()
        }
        self.audioPlayer?.delegate = nil
        self.audioPlayer = nil
        self.isPlaying = false
    }
    /// 取消按钮声音
    public final func systemCancel(_ isAlert: Bool = false) {
        if ZObserverKit.shared.isWhetherMute {
            ZAudioCallKit.shared.systemVibration()
            return
        }
        if self.isPlaying {
            return
        }
        // 获取声音地址
        let baseURL = (URL.callUrl(named: "reject") as? NSURL) ?? NSURL.init()
        // 建立的SystemSoundID对象
        var soundID: SystemSoundID = 0
        // 赋值
        AudioServicesCreateSystemSoundID(baseURL, &soundID)
        // 添加音频结束时的回调
        let observer = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        AudioServicesAddSystemSoundCompletion(soundID, nil, nil, {
            (soundID, inClientData) -> Void in
            let mySelf = Unmanaged<ZAudioCallKit>.fromOpaque(inClientData!)
                .takeUnretainedValue()
            mySelf.audioServicesPlaySystemSoundCompleted(soundID: soundID)
        }, observer)
        if isAlert {
            AudioServicesPlayAlertSound(soundID)
        } else {
            AudioServicesPlaySystemSound(soundID)
        }
    }
    /// 接听按钮声音 - 是否震动
    public final func systemAnswer(_ isAlert: Bool = false) {
        if ZObserverKit.shared.isWhetherMute {
            ZAudioCallKit.shared.systemVibration()
            return
        }
        if self.isPlaying {
            return
        }
        // 获取声音地址
        let baseURL = (URL.callUrl(named: "answer") as? NSURL) ?? NSURL.init()
        // 建立的SystemSoundID对象
        var soundID: SystemSoundID = 0
        // 赋值
        AudioServicesCreateSystemSoundID(baseURL, &soundID)
        // 添加音频结束时的回调
        let observer = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        AudioServicesAddSystemSoundCompletion(soundID, nil, nil, {
            (soundID, inClientData) -> Void in
            let mySelf = Unmanaged<ZAudioCallKit>.fromOpaque(inClientData!)
                .takeUnretainedValue()
            mySelf.audioServicesPlaySystemSoundCompleted(soundID: soundID)
        }, observer)
        if isAlert {
            AudioServicesPlayAlertSound(soundID)
        } else {
            AudioServicesPlaySystemSound(soundID)
        }
    }
    /// 继续其他播放器播放音乐
    public final func startOtherPlayer() {
        DispatchQueue.main.async {
            do {
                // 启动音频会话管理，此时会阻断后台音乐播放
                try AVAudioSession.sharedInstance().setActive(false, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
            }
            catch {
                BFLog.debug("error: \(error.localizedDescription)")
            }
        }
    }
    /// 震动
    public final func systemVibration() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    /// 开始持续震动
    private final func startSystemVibrate() {
        AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, nil, nil, { (sound, _)  in
            let additionalTime: DispatchTimeInterval = .seconds(3)
            DispatchQueue.main.asyncAfter(deadline: .now() + additionalTime, execute: {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            })
        }, nil)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    //结束持续震动
    private final func stopSystemVibrate() {
        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
        AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate)
    }
    /// 播放声音
    private final func syatemPlayer() {
        if ZObserverKit.shared.isWhetherMute { return }
        if !self.isPlaying {
            // 建立的SystemSoundID对象
            var soundID:SystemSoundID = 0
            // 获取声音地址
            let baseURL = (URL.callUrl(named: "user") as? NSURL) ?? NSURL.init()
            // 赋值
            AudioServicesCreateSystemSoundID(baseURL, &soundID)
            // 添加音频结束时的回调
            let observer = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
            AudioServicesAddSystemSoundCompletion(soundID, nil, nil, {
                (soundID, inClientData) -> Void in
                let mySelf = Unmanaged<ZAudioCallKit>.fromOpaque(inClientData!)
                    .takeUnretainedValue()
                mySelf.audioServicesPlaySystemSoundCompleted(soundID: soundID)
            }, observer)
            // 播放声音
            AudioServicesPlaySystemSound(soundID)
            self.isPlaying = true
        }
    }
    /// 音频结束时的回调
    private func audioServicesPlaySystemSoundCompleted(soundID: SystemSoundID) {
        BFLog.debug("Completion: \(soundID)")
        self.isPlaying = false
        AudioServicesRemoveSystemSoundCompletion(soundID)
        AudioServicesDisposeSystemSoundID(soundID)
    }
}
extension ZAudioCallKit: AVAudioPlayerDelegate {
    
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        BFLog.debug("audioPlayerDecodeErrorDidOccur")
    }
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        BFLog.debug("audioPlayerDidFinishPlaying")
    }
}
