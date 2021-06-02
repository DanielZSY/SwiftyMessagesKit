
import UIKit

class ZTimerKit: NSObject {
    
    static let shared = ZTimerKit()
    /// 定时器
    private var timer: Timer?
    /// 当前循环次数
    private var currentCount: Int = 0
    /// 保持心跳频率
    private let pingTime: Int = 10
    
    override init() {
        super.init()
    }
    deinit {
        self.stopTimer()
    }
    final func startTimer() {
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.executeTimer), userInfo: nil, repeats: true)
            RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
        }
    }
    /// 停止定时器
    final func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    /// 执行定时器
    @objc private func executeTimer() {
        self.currentCount += 1
        if currentCount % pingTime == 0 { ZWebSocketKit.shared.sendPing() }
        NotificationCenter.default.post(name: Notification.Names.ExecuteTimer, object: nil, userInfo: nil)
    }
}
