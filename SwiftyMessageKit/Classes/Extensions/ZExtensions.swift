
import UIKit
import Foundation
import SwiftBasicKit

extension Bundle {
    static var messageAssetBundle: Bundle {
        guard let url = Bundle(for: ZMessageViewController.self).url(forResource: "SwiftyMessageKit", withExtension: "bundle"),
              let resourcesBundle = Bundle(url: url)
        else {
            return Bundle.main
        }
        return resourcesBundle
    }
    static var callAssetBundle: Bundle {
        guard let url = Bundle(for: ZCallViewController.self).url(forResource: "SwiftyMessageCallKit", withExtension: "bundle"),
              let resourcesBundle = Bundle(url: url)
        else {
            return Bundle.main
        }
        return resourcesBundle
    }
    static var muteSwitchAssetBundle: Bundle {
        guard let url = Bundle(for: ZCallViewController.self).url(forResource: "SwiftyMuteSwitchKit", withExtension: "bundle"),
              let resourcesBundle = Bundle(url: url)
        else {
            return Bundle.main
        }
        return resourcesBundle
    }
}
extension URL {
    static func callUrl(named: String) -> URL? {
        return Bundle.callAssetBundle.url(forResource: "Call", withExtension: "bundle")?.appendingPathComponent(named).appendingPathExtension("mp3")
    }
    static func muteSwitchUrl(named: String) -> URL? {
        return Bundle.callAssetBundle.url(forResource: "KKMuteSwitchListener", withExtension: "bundle")?.appendingPathComponent(named).appendingPathExtension("mp3")
    }
}
extension UIImage {
    var down: UIImage? {
        if let cgimage = self.cgImage {
            return UIImage.init(cgImage: cgimage, scale: 1, orientation: UIImage.Orientation.down)
        }
        return self
    }
    static func assetImage(named: String) -> UIImage? {
        let image = UIImage(named: named, in: Bundle.messageAssetBundle, compatibleWith: nil)
        if image == nil {
            return UIImage.init(named: named)
        }
        return image
    }
}
extension UIView {
    func onlineColor(online: Bool, busy: Bool) {
        switch online {
        case true:
            switch busy {
            case true:
                self.backgroundColor = "#FECA19".color
            case false:
                self.backgroundColor = "#7037E9".color
            default: break
            }
        case false:
            self.backgroundColor = "#7F7F7F".color
        default: break
        }
    }
}
extension UIImageView {
    func onlineImage(online: Bool, busy: Bool) {
        switch online {
        case true:
            switch busy {
            case true:
                self.image = Asset.btnBusy.image
            case false:
                self.image = Asset.btnOnline.image
            default: break
            }
        case false:
            self.image = Asset.btnOffline.image
        default: break
        }
    }
}
extension String {
    func ranges(of string: String) -> [Range<String.Index>] {
        var rangeArray = [Range<String.Index>]()
        var searchedRange: Range<String.Index>
        guard let sr = self.range(of: self) else {
            return rangeArray
        }
        searchedRange = sr
        var resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        while let range = resultRange {
            rangeArray.append(range)
            searchedRange = Range(uncheckedBounds: (range.upperBound, searchedRange.upperBound))
            resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        }
        return rangeArray
    }
    func nsrange(fromRange range : Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    func nsranges(of string: String) -> [NSRange] {
        return ranges(of: string).map { (range) -> NSRange in
            self.nsrange(fromRange: range)
        }
    }
}
