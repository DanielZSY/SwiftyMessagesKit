
import UIKit
import BFKit
import SnapKit
import SwiftBasicKit

class ZNetworkErrorGlobalView: UIView {
    
    private static let defaultFrame: CGRect = CGRect.init(0, -50, kScreenWidth, 50)
    
    /// 上一次触发y坐标
    private var lastViewY: CGFloat = -(50)
    /// 默认显示y坐标
    private let defaultShowY: CGFloat = kStatusHeight
    private var isBeganPanGesture: Bool = false
    
    private lazy var viewContent: UIView = {
        let z_temp = UIView.init(frame: CGRect.init((10), 0, self.width - (20), (50)))
        z_temp.border(color: .clear, radius: (10), width: 0)
        z_temp.backgroundColor = .init(hex: "#FF1B54")
        return z_temp
    }()
    private lazy var lbContent: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init((20), (10), self.viewContent.width - (40), (30)))
        z_temp.textColor = .white
        z_temp.textAlignment = .center
        z_temp.boldSize = 18
        z_temp.text = ZString.errorNetwork.text
        return z_temp
    }()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addSubview(self.viewContent)
        self.viewContent.addSubview(self.lbContent)
        
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureEvent(_:)))
        self.addGestureRecognizer(panGesture)
    }
    required convenience init() {
        self.init(frame: ZNetworkErrorGlobalView.defaultFrame)
    }
    @objc private func panGestureEvent(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        switch sender.state {
        case .began:
            self.lastViewY = self.y
            self.isBeganPanGesture = true
        case .changed:
            let newY = self.lastViewY + translation.y
            if newY < self.defaultShowY {
                self.y = self.lastViewY + translation.y
            }
        case .ended:
            let newY = self.lastViewY - translation.y
            if newY != self.defaultShowY {
                self.dismissAnimate()
            }
            self.isBeganPanGesture = false
        default: break
        }
    }
    /// 显示带动画
    final func showAnimate() {
        self.alpha = 0
        self.tag = 1088
        self.frame = ZNetworkErrorGlobalView.defaultFrame
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
            self.y = self.defaultShowY
        }, completion: { end in
            
        })
    }
    /// 隐藏带动画
    final func dismissAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            self.frame = ZNetworkErrorGlobalView.defaultFrame
        }, completion: { end in
            self.removeFromSuperview()
        })
    }
    
    static func removeAllView() {
        UIApplication.shared.keyWindow?.subviews.forEach({ (item) in
            if item.isMember(of: ZNetworkErrorGlobalView.classForCoder()) {
                (item as? ZNetworkErrorGlobalView)?.dismissAnimate()
            }
        })
    }
}
