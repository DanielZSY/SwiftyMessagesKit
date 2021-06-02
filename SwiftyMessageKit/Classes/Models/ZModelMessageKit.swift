import UIKit
import CoreLocation
import AVFoundation

/// 聊天消息对象
public struct ZModelMessageKit: MessageType {
    
    public var id: Int = 0
    /// 发送者
    public var sender: SenderType {
        return sendUser
    }
    public var sendUser: ZModelMessageKitUser
    
    public var messageId: String
    
    public var sentDate: Date
    public var sentTime: TimeInterval = 0
    public var kind: MessageKind
    /// 接收者
    public var receive: SenderType {
        return receiveUser
    }
    public var receiveUser: ZModelMessageKitUser
    
    public init(kind: MessageKind, sender: ZModelMessageKitUser, receive: ZModelMessageKitUser, messageId: String, sentDate: Date) {
        self.kind = kind
        self.sendUser = sender
        self.messageId = messageId
        self.sentDate = sentDate
        self.receiveUser = receive
        self.messageId = messageId
    }
    /// 普通文本消息
    public init(text: String, sender: ZModelMessageKitUser, receive: ZModelMessageKitUser, messageId: String, sentDate: Date) {
        self.init(kind: .text(text), sender: sender, receive: receive, messageId: messageId, sentDate: sentDate)
    }
    /// 富文本消息
    public init(attributedText: NSAttributedString, sender: ZModelMessageKitUser, receive: ZModelMessageKitUser, messageId: String, sentDate: Date) {
        self.init(kind: .attributedText(attributedText), sender: sender, receive: receive, messageId: messageId, sentDate: sentDate)
    }
    /// 图片文件
    public init(image: UIImage?, imageUrl: URL, sender: ZModelMessageKitUser, receive: ZModelMessageKitUser, messageId: String, sentDate: Date) {
        var mediaItem = ZModelMediaItem(image: image)
        mediaItem.url = imageUrl
        self.init(kind: .photo(mediaItem), sender: sender, receive: receive, messageId: messageId, sentDate: sentDate)
    }
    /// 定位消息
    public init(location: CLLocation, sender: ZModelMessageKitUser, receive: ZModelMessageKitUser, messageId: String, sentDate: Date) {
        let locationItem = ZModelLocationItem(location: location)
        self.init(kind: .location(locationItem), sender: sender, receive: receive, messageId: messageId, sentDate: sentDate)
    }
    /// 音频文件
    public init(audioURL: URL, sender: ZModelMessageKitUser, receive: ZModelMessageKitUser, messageId: String, sentDate: Date) {
        let audioItem = ZModelAudioItem(url: audioURL)
        self.init(kind: .audio(audioItem), sender: sender, receive: receive, messageId: messageId, sentDate: sentDate)
    }
}
/// 消息定位对象
private struct ZModelLocationItem: LocationItem {
    
    var location: CLLocation
    var size: CGSize
    
    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: (200), height: (200))
    }
}
/// 消息图片对象
private struct ZModelMediaItem: MediaItem {
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage?) {
        if let image = image {
            self.image = image
            var imageWidth: CGFloat = (135)
            if image.size.width < imageWidth {
                imageWidth = image.size.width
            }
            var imageHeight: CGFloat = (165)
            if image.size.height < imageHeight {
                imageHeight = image.size.height
            }
            self.size = CGSize(width: imageWidth, height: imageHeight)
        } else {
            self.size = CGSize.zero
        }
        self.placeholderImage = UIImage.init()
    }
}
/// 消息音频对象
private struct ZModelAudioItem: AudioItem {
    
    var url: URL
    var size: CGSize
    var duration: Float
    
    init(url: URL) {
        self.url = url
        self.size = CGSize(width: 160, height: 40)
        let options = [AVURLAssetPreferPreciseDurationAndTimingKey: true]
        let audioAsset = AVURLAsset.init(url: url, options: options)
        self.duration = Float(CMTimeGetSeconds(audioAsset.duration))
    }
}
