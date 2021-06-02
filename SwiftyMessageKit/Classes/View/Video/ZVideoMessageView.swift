
import UIKit
import BFKit
import SwiftBasicKit

/// 视频消息页面
class ZVideoMessageView: UIView {
    
    /// 消息类
    private var tvDataSource = [ZModelMessage]()
    /// 计算高度
    private var tvcCalculatedHeight: ZVideoMessageTVC = ZVideoMessageTVC.init(style: .default, reuseIdentifier: "tvcCalculatedHeight")
    
    private lazy var tvMain: ZBaseTV = {
        let item = ZBaseTV.init(frame: self.bounds)
        item.bounces = false
        item.isUserInteractionEnabled = true
        item.backgroundColor = .clear
        item.showsVerticalScrollIndicator = false
        item.showsHorizontalScrollIndicator = false
        return item
    }()
    override var frame: CGRect {
        didSet {
            self.tvMain.frame = self.bounds
            self.func_changecontent()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.tvMain)
        self.tvMain.delegate = self
        self.tvMain.dataSource = self
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    deinit {
        self.tvMain.dataSource = nil
        self.tvMain.delegate = nil
    }
    private final func func_changecontent() {
        BFLog.debug("self.tvMain.contentSize.height: \(self.tvMain.contentSize.height),  self.height: \(self.height)")
        DispatchQueue.DispatchAfter(after: 0.35, handler: {
            if self.tvMain.contentSize.height < self.height {
                self.tvMain.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            } else {
                let contentOffsetY = self.tvMain.contentSize.height - self.height
                self.tvMain.setContentOffset(CGPoint.init(x: 0, y: contentOffsetY), animated: true)
            }
        })
    }
    final func addMessageModel(_ model: ZModelMessage) {
        self.tvDataSource.append(model)
        self.tvMain.reloadData({
            self.func_changecontent()
        })
    }
}
extension ZVideoMessageView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tvDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: kCellId) as? ZVideoMessageTVC
        if cell == nil {
            cell = ZVideoMessageTVC.init(style: .default, reuseIdentifier: kCellId)
        }
        let model = self.tvDataSource[indexPath.row]
        cell?.func_setcelldata(model: model)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.tvDataSource[indexPath.row]
        return self.tvcCalculatedHeight.func_setcelldata(model: model)
    }
}
