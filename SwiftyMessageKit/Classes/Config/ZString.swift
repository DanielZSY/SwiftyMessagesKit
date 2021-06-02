
import UIKit
import BFKit

/// 本地化配置文件
internal enum ZString: String {
    
    case btnCancel
    case btnContinue
    case btnAlbum
    case btnCamera
    case btnCallNow
    case btnLeave
    case btnGive
    
    case lbSelectPhoto
    case lbGifts
    case lbGift
    case lbIcecream
    case lbLollipop
    case lbRose
    case lbKiss
    case lbBanana
    case lbDiamond
    case lbCrown
    case lbLuxurycar
    case lbGivea
    case lbCalling
    case lbCallMissed
    case lbFollow
    case lbUnFollow
    case lbOFF
    case lbMe
    case lbGiveGiftTips
    case lbRechargeTips
    case lbRechargeTipsContent
    case lbRechargeFristTips
    case lbMin
    case lbSeconds
    case lbYourBalance
    case lbClose
    case lbTime
    case lbDiamonds
    case lbComplaint
    case lbVerybad
    case lbBad
    case lbGeneral
    case lbGood
    case lbVeryGood
    case lbEvaluate
    case lbAddTags
    case lbID
    case lbEvaluateVeryBadPlaceholder
    case lbEvaluateVeryGoodPlaceholder
    case lbEvaluateComplaintPlaceholder
    case lbEvaluateComplaintSuccessMessage
    case lbEvaluateComplaintContentCheck
    case lbRecommendTitle
    case lbRecommendContent
    case lbRecommendNothanks
    case lbMessagePriceTips
    case lbVideoCloseBigTips
    case lbVideoFollowDesc
    
    case hudLabelText
    case inputAudioProssDown
    case inputMessagePlaceholder
    case inputVideoPlaceholder
    
    case errorResultData
    case errorRecording
    case errorDeviceNotCameraPrompt
    case errorNetwork
    case errorJoinCannel
    
    case messageReleaseSendMessage
    case messageSwipeCancelSend
    case messageFingerCancelSend
    case messageRecordTimeShort
    case messageRecordError
    case messageMicrophoneTitle
    case messageMicrophoneDesc
    case messageMicrophoneReloadError
    case messageisaPicture
    case messageisaVoice
    case messageisaPhoto
    case messageisaAudio
    
    case callWaitDesc
    case callRandomDesc
    
    case alertOtherHungupCall
    case alertLeaveCurrentVideo
    
    /// 充值成功，到账可能会有延迟
    case successRecharge
    
    internal var text: String {
        let language = Locale.preferredLanguages.first?.components(separatedBy: "-").first ?? ""
        switch language {
        default:
            switch self {
            case .btnCancel: return "Cancel"
            case .btnContinue: return "Continue"
            case .btnAlbum: return "Album"
            case .btnCamera: return "Camera"
            case .btnCallNow: return "Call Now"
            case .btnLeave: return "Leave"
            case .btnGive: return "Give"
                
            case .lbSelectPhoto: return "Select a photo"
            case .lbGifts: return "Gifts"
            case .lbGift: return "Gift"
            case .lbIcecream: return "Ice cream"
            case .lbLollipop: return "Lollipop"
            case .lbRose: return "Rose"
            case .lbKiss: return "Kiss"
            case .lbBanana: return "Banana"
            case .lbDiamond: return "Diamond"
            case .lbCrown: return "Crown"
            case .lbLuxurycar: return "Luxury car"
            case .lbGivea: return "Give a"
            case .lbCalling: return "Calling..."
            case .lbCallMissed: return "Call Missed"
            case .lbFollow: return "Follow"
            case .lbUnFollow: return "unFollow"
            case .lbOFF: return "OFF"
            case .lbMe: return "Me"
            case .lbGiveGiftTips: return "Please give me a present"
            case .lbRechargeTips: return "Please recharge now to keep the call going."
            case .lbRechargeFristTips: return "350 Diamonds/min after 40s, the balance is insufficient, please recharge!"
            case .lbRechargeTipsContent: return "You have 1 min left."
            case .lbMin: return "min"
            case .lbSeconds: return "seconds"
            case .lbYourBalance: return "Your Balance"
            case .lbClose: return "close"
            case .lbTime: return "Time"
            case .lbDiamonds: return "Diamonds"
            case .lbComplaint: return "Complaint"
            case .lbVerybad: return "Very bad"
            case .lbBad: return "Bad"
            case .lbGeneral: return "General"
            case .lbGood: return "Good"
            case .lbVeryGood: return "Very Good"
            case .lbEvaluate: return "Evaluate"
            case .lbAddTags: return "Add Tags"
            case .lbID: return "ID"
            case .lbEvaluateVeryBadPlaceholder: return "Tell us about your problems and we will try our best to optimize it."
            case .lbEvaluateVeryGoodPlaceholder: return "Enter here"
            case .lbEvaluateComplaintPlaceholder: return "Sorry for any inconvenience. Please let us know about your problem."
            case .lbEvaluateComplaintSuccessMessage: return "Thank you for your complaint, our support team will deal with it as soon as possible."
            case .lbEvaluateComplaintContentCheck: return "max 140 characters allowed."
            case .lbRecommendTitle: return "Sorry,the anchor failed to answer your video call"
            case .lbRecommendContent: return "You may also like..."
            case .lbRecommendNothanks: return "No,thanks"
            case .lbMessagePriceTips: return " diamonds for 1 message."
            case .lbVideoCloseBigTips: return "He turned off the camera"
            case .lbVideoFollowDesc: return "Follow me and keep in touch!"
                
            case .hudLabelText: return "Waiting..."
            case .inputAudioProssDown: return "Hold to record"
            case .inputMessagePlaceholder: return "Input message..."
            case .inputVideoPlaceholder: return "Type something..."
                
            case .errorResultData: return "Result data error"
            case .errorRecording: return "Recording failed"
            case .errorDeviceNotCameraPrompt: return "The device does not support the camera"
            case .errorNetwork: return "Network Unstable"
            case .errorJoinCannel: return "Join channel error code: "
                
            case .messageReleaseSendMessage: return "Release and send the voice message"
            case .messageSwipeCancelSend: return "Swipe up to cancel sending"
            case .messageFingerCancelSend: return "Release your finger to cancel sending"
            case .messageRecordTimeShort: return "The recording time is too short"
            case .messageRecordError: return "Recording failed, please try again later"
            case .messageMicrophoneTitle: return "Can't access your microphone"
            case .messageMicrophoneDesc: return "Please go to Settings -> Privacy -> Allow to access the microphone"
            case .messageMicrophoneReloadError: return "Failed to initialize recording function"
            case .messageisaPicture: return "You have a picture message"
            case .messageisaVoice: return "You have a voice message"
            case .messageisaPhoto: return "This is a picture message"
            case .messageisaAudio: return "This is a voice message"
                
            case .callWaitDesc: return "Other user may be busy. Try again later."
            case .callRandomDesc: return ZString.randomCallTexts.sample ?? "If not convenient, please use the blur function"
                
            case .alertOtherHungupCall: return "The other party has hung up"
            case .alertLeaveCurrentVideo: return "Are you sure you want to end this video call";
                
            case .successRecharge: return "Recharge is successful, there may be a delay in the account"
            default: break
            }
        }
        return self.rawValue
    }
    internal static var randomCallTexts: [String] {
        return ["If not convenient, please use the blur function",
                "Try to give a gift to the host, which may have some unexpected effects",
                "Contact us if not get diamonds",
                "Come to see and the hosts will update everyday",
                "You can top-up if diamonds are not enough"]
    }
}
