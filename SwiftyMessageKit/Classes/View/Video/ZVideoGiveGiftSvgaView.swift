
import UIKit
import BFKit
import SwiftDate
import SVGAPlayer
import SwiftBasicKit

class ZVideoGiveGiftSvgaView: UIView {
    
    private var showTime: Int = 5
    private lazy var z_player: SVGAPlayer = {
        let z_temp = SVGAPlayer.init(frame: CGRect.init(0, 0, self.width, self.height))
        z_temp.isUserInteractionEnabled = false
        z_temp.loops = 1
        z_temp.clearsAfterStop = true
        return z_temp
    }()
    private lazy var z_parser: SVGAParser = {
        let z_temp = SVGAParser.init()
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.alpha = 0
        self.isHidden = true
        self.addSubview(z_player)
        self.isUserInteractionEnabled = false
        self.z_player.delegate = self
    }
    deinit {
        self.z_player.delegate = nil
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    final func setShowViewGiftImage(_ type: kEnumGiftImage) {
        var svgName = Asset.svgaIceCream.data
        switch type {
        case .Lollipop: svgName = Asset.svgaLollipop.data
        case .Rose: svgName = Asset.svgaRose.data
        case .Kiss: svgName = Asset.svgaKiss.data
        case .Banana: svgName = Asset.svgaRedShoes.data
        case .Diamond: svgName = Asset.svgaDiamond.data
        case .Crown: svgName = Asset.svgaLuxuryCar.data
        case .LuxuryCar: svgName = Asset.svgaLuxuryCar.data
        default: break
        }
        self.alpha = 0
        self.isHidden = false
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
        })
        z_parser.parse(with: svgName.data, cacheKey: svgName.name.md5(), completionBlock: { videoItem in
            self.z_player.videoItem = videoItem
            self.z_player.startAnimation()
        }, failureBlock: { error in
            BFLog.debug("load svga error: \(error.localizedDescription)")
        })
    }
}
extension ZVideoGiveGiftSvgaView: SVGAPlayerDelegate {
    
    func svgaPlayerDidFinishedAnimation(_ player: SVGAPlayer!) {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }, completion: { end in
            self.isHidden = true
            self.removeFromSuperview()
        })
    }
}
