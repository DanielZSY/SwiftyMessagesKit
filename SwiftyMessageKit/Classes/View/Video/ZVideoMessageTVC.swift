
import UIKit
import SwiftBasicKit

/// 视频消息显示Cell
class ZVideoMessageTVC: ZBaseTVC {

    private lazy var z_viewcontent: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(10, 10, 100, 65))
        z_temp.backgroundColor = "#000000".color.withAlphaComponent(0.5)
        z_temp.border(color: .clear, radius: 15, width: 0)
        return z_temp
    }()
    private lazy var z_lbusername: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(10, 5, 80, 22))
        z_temp.textColor = "#7037E9".color
        z_temp.boldSize = 14
        z_temp.text = ""
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_lbmessage: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(10, 32, 80, 22))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 14
        z_temp.text = ""
        z_temp.numberOfLines = 0
        return z_temp
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(z_viewcontent)
        z_viewcontent.addSubview(z_lbusername)
        z_viewcontent.addSubview(z_lbmessage)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    final func func_setcelldata(model: ZModelMessage?) -> CGFloat {
        if let message = model {
            if message.message_direction == .send {
                z_lbusername.textColor = "#FFAC04".color
                z_lbusername.text = ZString.lbMe.text
            } else {
                z_lbusername.text = message.message_user?.nickname ?? ""
                z_lbusername.textColor = "#7037E9".color
            }
            z_lbmessage.text = message.message
        } else {
            z_lbusername.textColor = "#FFAC04".color
            z_lbusername.text = ZString.lbMe.text
            z_lbmessage.text = " "
        }
        let contentmaxw = self.cellWidth - 40
        let usernamew = z_lbusername.text!.getWidth(z_lbusername.font, height: z_lbusername.height)
        if usernamew > contentmaxw {
            z_lbusername.width = contentmaxw
        } else {
            z_lbusername.width = usernamew
        }
        let messagew = z_lbmessage.text!.getWidth(z_lbmessage.font, height: 22)
        if messagew > contentmaxw {
            z_lbmessage.width = contentmaxw
        } else {
            z_lbmessage.width = messagew
        }
        z_lbmessage.height = z_lbmessage.text!.getHeight(z_lbmessage.font, width: z_lbmessage.width)
        if z_lbusername.width > z_lbmessage.width {
            z_viewcontent.width = z_lbusername.width + 20
        } else {
            z_viewcontent.width = z_lbmessage.width + 20
        }
        z_viewcontent.height = z_lbmessage.y + z_lbmessage.height + 13
        
        self.cellHeight = z_viewcontent.y + z_viewcontent.height
        
        return self.cellHeight
    }
}
