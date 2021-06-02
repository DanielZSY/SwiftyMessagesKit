
import UIKit
import HandyJSON

/// 呼叫挂断原因
internal enum kEnumVideoHungup: Int, HandyJSONEnum {
    /// 无
    case none = 0
    /// 主叫方取消呼叫 11
    case caller_canceled_call = 11
    /// 被叫方未接 12
    case called_party_missed = 12
    /// 被叫方拒接 13
    case called_party_refused = 13
    /// 观众挂断 21
    case audience_hangup = 21
    /// 主播挂断 22
    case anchor_hangup = 22
    /// 检测到通话已结束 31
    case call_ended_detected = 31
    /// 观众余额不足 32
    case insufficient_balance = 32
    /// Hunting时间1分钟到(成功Hunting) 33
    case hunting_success = 33
}
/// 视频事件枚举
internal enum kEnumSocketEvent: Int, HandyJSONEnum {
    /// 已经连接
    case connect = 0
    /// 收到来电
    case call = 101
    /// 收到应答
    case response = 102
    /// 主动挂断
    case hangup = 103
    /// 用户送礼
    case gift = 104
    /// 命令事件
    case cmd = 105
    /// 更新通话信息
    case update = 106
    /// 余额变动
    case balance = 200
    /// 下线通知
    case isonline = 301
}
/// 视频UI显示枚举
internal enum kEnumSocketUI: Int, HandyJSONEnum {
    /// 默认不处理
    case none = 0
    /// 显示呼叫页面
    case showCallVC = 10
    /// 隐藏呼叫页面
    case dismissCallVC = 11
    /// 显示视频页面
    case showVideoVC = 12
    /// 隐藏视频页面
    case dismissVideoVC = 13
    /// 显示主播标签
    case showAnchorTagVC = 14
    /// 显示推荐主播页面
    case showRecommentAnchorVC = 15
    /// 显示hunting页面
    case showHuntingVC = 16
    /// 显示SY页面
    case showIncomeVC = 17
    /// 显示余额不足页面
    case showRechargeBalance = 18
    /// 因为对方离开视频通知视频隐藏页面
    case dismissOfflineVideoVC = 19
}
/// 视频操作状态
internal enum kEnumSocketOperate: Int, HandyJSONEnum {
    /// 默认不处理
    case none = 0
    /// 挂断操作
    case hangup = 1
    /// 应答操作
    case answer = 2
    /// SDK自己离开视频
    case myout = 5
    /// SDK远端离开视频
    case reout = 6
    /// SDK远端加入频道回调
    case rejoin = 7
    /// SDK自己加入频道回调
    case myjoin = 8
    /// SDK远端第一帧回调
    case first = 9
}
/// 视频礼物图片类型
internal enum kEnumGiftImage: Int {
    /// 冰淇淋
    case IceCream = 1
    /// 棒棒糖
    case Lollipop = 2
    /// 玫瑰花
    case Rose = 3
    /// 香吻
    case Kiss = 4
    /// 香蕉
    case Banana = 5
    /// 钻石
    case Diamond = 6
    /// 皇冠
    case Crown = 7
    /// 跑车
    case LuxuryCar = 8
}
