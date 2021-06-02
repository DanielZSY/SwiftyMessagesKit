
import UIKit
import BFKit
import AgoraRtmKit
import SwiftBasicKit

class ZChatUploadKit: NSObject {
    
    /// 上传一张图片
    internal static func uploadImage(_ imageUrl: URL, _ model: ZModelMessage) {
        var capacity = Int64(arc4random())
        let pointer = withUnsafePointer(to: &capacity) { return $0 }
        let request = UnsafeMutablePointer<Int64>.init(mutating: pointer)
        ZChatSDKKit.shared.agoraRtmKit?.createImageMessage(byUploading: imageUrl.path, withRequest: request, completion: { (requestId, message, errorCode) in
            if let msg = message {
                BFLog.debug("upload image success mediaId: \(msg.mediaId)")
                model.message_file_id = msg.mediaId
                ZChatSDKKit.shared.sendMessageToService(model, need_notify: 1)
            }
        })
    }
    /// 上传一张图片
    internal static func uploadImage(_ image: UIImage, _ model: ZModelMessage) {
        let imageUrl = ZLocalFileApi.imagePath
        ZLocalFileApi.saveImage(image: image, toPath: imageUrl)
        ZChatUploadKit.uploadImage(imageUrl, model)
    }
    /// 上传一个文件
    internal static func uploadFile(_ fileUrl: URL, _ model: ZModelMessage) {
        var capacity = Int64(arc4random())
        let pointer = withUnsafePointer(to: &capacity) { return $0 }
        let request = UnsafeMutablePointer<Int64>.init(mutating: pointer)
        ZChatSDKKit.shared.agoraRtmKit?.createFileMessage(byUploading: fileUrl.path, withRequest: request, completion: { (requestId, message, errorCode) in
            if let msg = message {
                BFLog.debug("upload file success mediaId: \(msg.mediaId)")
                model.message_file_id = msg.mediaId
                ZChatSDKKit.shared.sendMessageToService(model, need_notify: 1)
            }
        })
    }
    /// 群发上传一张图片
    internal static func uploadImage(imageUrl: URL, resultBlock: ((_ message: AgoraRtmImageMessage?) -> Void)?) {
        var capacity = Int64(arc4random())
        let pointer = withUnsafePointer(to: &capacity) { return $0 }
        let request = UnsafeMutablePointer<Int64>.init(mutating: pointer)
        ZChatSDKKit.shared.agoraRtmKit?.createImageMessage(byUploading: imageUrl.path, withRequest: request, completion: { (requestId, message, errorCode) in
            resultBlock?(message)
        })
    }
}
