// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let arrowDown = ImageAsset(name: "arrowDown")
  internal static let arrowDownW = ImageAsset(name: "arrowDownW")
  internal static let arrowLeftW = ImageAsset(name: "arrowLeftW")
  internal static let arrowRight = ImageAsset(name: "arrowRight")
  internal static let arrowRightW = ImageAsset(name: "arrowRightW")
  internal static let arrowUp = ImageAsset(name: "arrowUp")
  internal static let callAnswer = ImageAsset(name: "callAnswer")
  internal static let callHangup = ImageAsset(name: "callHangup")
  internal static let btnAlbum = ImageAsset(name: "btnAlbum")
  internal static let btnAudioN = ImageAsset(name: "btnAudioN")
  internal static let btnAudioS = ImageAsset(name: "btnAudioS")
  internal static let btnBack = ImageAsset(name: "btnBack")
  internal static let btnBusy = ImageAsset(name: "btnBusy")
  internal static let btnCall = ImageAsset(name: "btnCall")
  internal static let btnCallNow = ImageAsset(name: "btnCallNow")
  internal static let btnCloseP = ImageAsset(name: "btnCloseP")
  internal static let btnCloseR = ImageAsset(name: "btnCloseR")
  internal static let btnCloseW = ImageAsset(name: "btnCloseW")
  internal static let btnCloseWS = ImageAsset(name: "btnCloseWS")
  internal static let btnFlipN = ImageAsset(name: "btnFlipN")
  internal static let btnFlipS = ImageAsset(name: "btnFlipS")
  internal static let btnGift = ImageAsset(name: "btnGift")
  internal static let btnOffline = ImageAsset(name: "btnOffline")
  internal static let btnOnline = ImageAsset(name: "btnOnline")
  internal static let btnPurple = ImageAsset(name: "btnPurple")
  internal static let btnRecharge = ImageAsset(name: "btnRecharge")
  internal static let btnResend = ImageAsset(name: "btnResend")
  internal static let btnSeeN = ImageAsset(name: "btnSeeN")
  internal static let btnSeeS = ImageAsset(name: "btnSeeS")
  internal static let iconCoinsTip = ImageAsset(name: "iconCoinsTip")
  internal static let iconDiamond1 = ImageAsset(name: "iconDiamond1")
  internal static let iconDiamond2 = ImageAsset(name: "iconDiamond2")
  internal static let iconDiamond3 = ImageAsset(name: "iconDiamond3")
  internal static let iconFemale = ImageAsset(name: "iconFemale")
  internal static let iconFollow = ImageAsset(name: "iconFollow")
  internal static let iconMale = ImageAsset(name: "iconMale")
  internal static let iconSeeG = ImageAsset(name: "iconSeeG")
  internal static let iconSeeW = ImageAsset(name: "iconSeeW")
  internal static let userSupport = ImageAsset(name: "userSupport")
  internal static let defaultAvatar = ImageAsset(name: "defaultAvatar")
  internal static let defaultBanner = ImageAsset(name: "defaultBanner")
  internal static let defaultImage = ImageAsset(name: "defaultImage")
  internal static let defaultNodata = ImageAsset(name: "defaultNodata")
  internal static let defaultTransparent = ImageAsset(name: "defaultTransparent")
  internal static let evaBad = ImageAsset(name: "evaBad")
  internal static let evaBadBig = ImageAsset(name: "evaBadBig")
  internal static let evaBadS = ImageAsset(name: "evaBadS")
  internal static let evaGeneral = ImageAsset(name: "evaGeneral")
  internal static let evaGeneralBig = ImageAsset(name: "evaGeneralBig")
  internal static let evaGeneralS = ImageAsset(name: "evaGeneralS")
  internal static let evaGood = ImageAsset(name: "evaGood")
  internal static let evaGoodBig = ImageAsset(name: "evaGoodBig")
  internal static let evaGoodS = ImageAsset(name: "evaGoodS")
  internal static let evaVeryBad = ImageAsset(name: "evaVeryBad")
  internal static let evaVeryBadBig = ImageAsset(name: "evaVeryBadBig")
  internal static let evaVeryBadS = ImageAsset(name: "evaVeryBadS")
  internal static let evaVeryGood = ImageAsset(name: "evaVeryGood")
  internal static let evaVeryGoodBig = ImageAsset(name: "evaVeryGoodBig")
  internal static let evaVeryGoodS = ImageAsset(name: "evaVeryGoodS")
  internal static let giftImg01 = ImageAsset(name: "gift_img_01")
  internal static let giftImg02 = ImageAsset(name: "gift_img_02")
  internal static let giftImg03 = ImageAsset(name: "gift_img_03")
  internal static let giftImg04 = ImageAsset(name: "gift_img_04")
  internal static let giftImg05 = ImageAsset(name: "gift_img_05")
  internal static let giftImg06 = ImageAsset(name: "gift_img_06")
  internal static let giftImg07 = ImageAsset(name: "gift_img_07")
  internal static let giftImg08 = ImageAsset(name: "gift_img_08")
  internal static let giftNum0 = ImageAsset(name: "gift_num_0")
  internal static let giftNum1 = ImageAsset(name: "gift_num_1")
  internal static let giftNum2 = ImageAsset(name: "gift_num_2")
  internal static let giftNum3 = ImageAsset(name: "gift_num_3")
  internal static let giftNum4 = ImageAsset(name: "gift_num_4")
  internal static let giftNum5 = ImageAsset(name: "gift_num_5")
  internal static let giftNum6 = ImageAsset(name: "gift_num_6")
  internal static let giftNum7 = ImageAsset(name: "gift_num_7")
  internal static let giftNum8 = ImageAsset(name: "gift_num_8")
  internal static let giftNum9 = ImageAsset(name: "gift_num_9")
  internal static let giftNumX = ImageAsset(name: "gift_num_x")
  internal static let hudCircle = ImageAsset(name: "hudCircle")
  internal static let bubbleFull = ImageAsset(name: "bubble_full")
  internal static let bubbleFullTailV1 = ImageAsset(name: "bubble_full_tail_v1")
  internal static let bubbleFullTailV2 = ImageAsset(name: "bubble_full_tail_v2")
  internal static let bubbleOutlined = ImageAsset(name: "bubble_outlined")
  internal static let bubbleOutlinedTailV1 = ImageAsset(name: "bubble_outlined_tail_v1")
  internal static let bubbleOutlinedTailV2 = ImageAsset(name: "bubble_outlined_tail_v2")
  internal static let disclouser = ImageAsset(name: "disclouser")
  internal static let pause = ImageAsset(name: "pause")
  internal static let play = ImageAsset(name: "play")
  internal static let recordCancel = ImageAsset(name: "RecordCancel")
  internal static let recordingBkg = ImageAsset(name: "RecordingBkg")
  internal static let recordingSignal001 = ImageAsset(name: "RecordingSignal001")
  internal static let recordingSignal002 = ImageAsset(name: "RecordingSignal002")
  internal static let recordingSignal003 = ImageAsset(name: "RecordingSignal003")
  internal static let recordingSignal004 = ImageAsset(name: "RecordingSignal004")
  internal static let recordingSignal005 = ImageAsset(name: "RecordingSignal005")
  internal static let recordingSignal006 = ImageAsset(name: "RecordingSignal006")
  internal static let recordingSignal007 = ImageAsset(name: "RecordingSignal007")
  internal static let recordingSignal008 = ImageAsset(name: "RecordingSignal008")
  internal static let svgaDiamond = DataAsset(name: "svgaDiamond")
  internal static let svgaGiftButton = DataAsset(name: "svgaGiftButton")
  internal static let svgaIceCream = DataAsset(name: "svgaIceCream")
  internal static let svgaKiss = DataAsset(name: "svgaKiss")
  internal static let svgaLollipop = DataAsset(name: "svgaLollipop")
  internal static let svgaLuxuryCar = DataAsset(name: "svgaLuxuryCar")
  internal static let svgaRedShoes = DataAsset(name: "svgaRedShoes")
  internal static let svgaRose = DataAsset(name: "svgaRose")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct DataAsset {
  internal fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(macOS)
  @available(iOS 9.0, macOS 10.11, *)
  internal var data: NSDataAsset {
    guard let data = NSDataAsset(asset: self) else {
      fatalError("Unable to load data asset named \(name).")
    }
    return data
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(macOS)
@available(iOS 9.0, macOS 10.11, *)
internal extension NSDataAsset {
  convenience init?(asset: DataAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(macOS)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    return Bundle.messageAssetBundle
  }()
}
// swiftlint:enable convenience_type
