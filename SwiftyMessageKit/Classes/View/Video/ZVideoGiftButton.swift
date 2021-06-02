
import UIKit
import BFKit
import SVGAPlayer
import SwiftBasicKit

class ZVideoGiftButton: UIButton {
    
    private lazy var z_player: SVGAPlayer = {
        let z_temp = SVGAPlayer.init(frame: CGRect.init(4.scale, 4.scale, self.width - 8.scale, self.height - 8.scale))
        z_temp.isUserInteractionEnabled = false
        return z_temp
    }()
    private lazy var z_parser: SVGAParser = {
        let z_temp = SVGAParser.init()
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_player)
        z_parser.parse(with: Asset.svgaGiftButton.data.data, cacheKey: "svgaGiftButton".md5(), completionBlock: { videoItem in
            self.z_player.videoItem = videoItem
            self.z_player.startAnimation()
        }, failureBlock: { error in
            BFLog.debug("load svga error: \(error.localizedDescription)")
        })
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    deinit {
        self.z_player.stopAnimation()
    }
}
