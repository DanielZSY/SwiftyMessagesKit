import UIKit

/// 用户对象
public struct ZModelMessageKitUser: SenderType, Equatable {
    /// 用户id
    public var senderId: String
    /// 用户昵称
    public var displayName: String
    /// 用户头像
    public var head: String
    /// 角色
    public var role: Int
    /// 性别
    public var gender: Int
}
