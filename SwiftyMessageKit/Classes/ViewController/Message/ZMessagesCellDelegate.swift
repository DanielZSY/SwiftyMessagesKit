import UIKit
import AVKit
import BFKit.Swift
import SwiftBasicKit
import SKPhotoBrowser.Swift

extension ZMessageViewController: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        BFLog.info("didTapAvatar")
    }
    func didTapMessage(in cell: MessageCollectionViewCell) {
        BFLog.info("didTapMessage")
    }
    func didTapImage(in cell: MessageCollectionViewCell) {
        BFLog.info("didTapImage")
        guard let mediaCell = cell as? MediaMessageCell, let image = mediaCell.imageView.image else {
            return
        }
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImage(image)
        images.append(photo)
        SKPhotoBrowserOptions.displayStatusbar = false
        let itemVC = ZPhotoBrowserViewController(photos: images)
        itemVC.initializePageIndex(0)
        ZRouterKit.present(toVC: itemVC, fromVC: self, animated: true, completion: nil)
    }
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        BFLog.info("didTapCellTopLabel")
    }
    func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {
        BFLog.info("didTapCellBottomLabel")
    }
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        BFLog.info("didTapMessageTopLabel")
    }
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        BFLog.info("didTapMessageBottomLabel")
    }
    func didTapPlayButton(in cell: AudioMessageCell) {
        BFLog.info("didTapPlayButton")
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
              let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
            BFLog.debug("Failed to identify message when audio cell receive tap gesture")
            return
        }
        guard self.audioPlayManager.state != .stopped else {
            self.audioPlayManager.playSound(for: message, in: cell)
            return
        }
        if self.audioPlayManager.playingMessage?.messageId == message.messageId {
            if self.audioPlayManager.state == .playing {
                self.audioPlayManager.pauseSound(for: message, in: cell)
            } else {
                self.audioPlayManager.resumeSound()
            }
        } else {
            self.audioPlayManager.stopAnyOngoingPlaying()
            self.audioPlayManager.playSound(for: message, in: cell)
        }
    }
    func didStartAudio(in cell: AudioMessageCell) {
        BFLog.info("didStartAudio")
    }
    func didPauseAudio(in cell: AudioMessageCell) {
        BFLog.info("didPauseAudio")
    }
    func didStopAudio(in cell: AudioMessageCell) {
        BFLog.info("didStopAudio")
    }
    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        BFLog.info("didTapAccessoryView")
    }
}
