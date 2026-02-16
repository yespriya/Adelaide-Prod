//
//  APIRoute.swift
//  Adelaide Prod
//
//  Created by Prit  on 04/02/26.
//

import Foundation
import Alamofire

enum APIRoute {
    /*
    // MARK: Users
    
    // GET:
    case profileDetails
    case getUserStatus
    
    // POST:
    case signup(model: SignupRequestModel)
    case signIn(model: SignInRequestModel)
    case socialAuth(model: SignInRequestModel)
    case generateOtp(model: OTPRequestModel)
    case verifyOTP(email: String, otp: String)
    case sendTNC(email: String)
    case uploadProfileImage(data: APIUploadData)
    case setUserStatus(model: UserStatusModel)
    
    // PUT:
    case updatePassword(model: SignInRequestModel)
    case changePassword(old: String, new: String)
    case updateUserDetails(model: UserProfileRequest)
    
    // DELETE:
    case deleteProfileImage
    
    // MARK: Chat
    
    // POST:
    case saveChat(model: ChatSaveModel)
    case preferenceChat(model: PrefereceChatModel)
    case getBotStaticMessage
    */
    // MARK: Learning Progress
    
    // POST:
    case learningProgress(model: LearningAnalyticsRequestModel)
    case weekWiseQuizAnalytics(model: WeekWiseQuizAnalyticsRequestModel)
    
    var method: HTTPMethod {
        switch self {
        case /*.signup, .signIn, .socialAuth, .generateOtp, .verifyOTP, .sendTNC, .uploadProfileImage, .setUserStatus, .saveChat, .preferenceChat, */.learningProgress, .weekWiseQuizAnalytics:
            return .post
            
//        case .updatePassword, .changePassword, .updateUserDetails:
//            return .put
//            
//        case .deleteProfileImage:
//            return .delete
            
        default:
            return .get
        }
    }
    
    var url: String {
        switch self {
//        case .saveChat:
//            return DataService.educationChatDevelopmentBaseURL
        case .learningProgress, .weekWiseQuizAnalytics:
            return DataService.superAdminDevelopmentBaseURL
        default:
            return DataService.developmentBaseURL
        }
    }
    
    var path: String {
        switch self {
        /*
        case .signup:
            return "common/create_account"
        case .signIn:
            return "common/login_account"
        case .socialAuth:
            return "common/socialauth"
        case .generateOtp:
            return "common/generate_otp"
        case .updatePassword:
            return "common/update_password"
        case .changePassword:
            return "change-password"
        case .verifyOTP:
            return "common/verify_otp"
        case .sendTNC:
            return "common/send_tnc"
        case .profileDetails:
            return "patient/userdetails"
        case .updateUserDetails:
            return "patient/update_userdetails"
        case .deleteProfileImage:
            return "common/delete_profile_image"
        case .uploadProfileImage:
            return "common/upload_profile_image"
        case .setUserStatus:
            return "patient/setstatus"
        case .getUserStatus:
            return "patient/getstatus"
        case .saveChat:
            return "stream_api/educational-bot-answer-dump"
        case .preferenceChat:
            return "patient/preference_chat"
        case .getBotStaticMessage:
            return "common/get_bot_static_message"
        */
        case .learningProgress:
            return "superadmin/patient_wise_module_analytics"
        case .weekWiseQuizAnalytics:
            return "superadmin/week_wise_quiz_analytics"
        }
    }
    
    var params: [String: Any]? {
        switch self {
            /*
        case .signup(let model):
            return parseModel(data: model)
            
        case .signIn(let model):
            return parseModel(data: model)
            
        case .socialAuth(let model):
            return parseModel(data: model)
            
        case .generateOtp(let model):
            return parseModel(data: model)
        
        case .updatePassword(let model):
            return parseModel(data: model)
        
        case .verifyOTP(let email, let otp):
            return ["email": email, "otp": otp]
        
        case .changePassword(let old, let new):
            return ["old_password": old, "new_password": new]
        
        case .sendTNC(let email):
            return ["email": email]
        
        case .updateUserDetails(let model):
            return parseModel(data: model)
            
        case .setUserStatus(let model):
            return parseModel(data: model)
        
        case .saveChat(let model):
            return parseModel(data: model)
        
        case .preferenceChat(let model):
            return parseModel(data: model)
        */
        case .learningProgress(let model):
            return parseModel(data: model)
            
        case .weekWiseQuizAnalytics(let model):
            return parseModel(data: model)
            
        default:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case /*.signIn, .signup, .socialAuth, .generateOtp, .updatePassword, .verifyOTP, .sendTNC, .changePassword, .updateUserDetails, .setUserStatus, .preferenceChat, .saveChat,*/ .learningProgress, .weekWiseQuizAnalytics:
            return JSONEncoding.default
        default:
            return URLEncoding.queryString
        }
    }
    
    var needAuthorization: Bool {
        switch self {
        case /*.signup, .generateOtp, .updatePassword, .verifyOTP, .sendTNC, .changePassword, .profileDetails, .updateUserDetails, .deleteProfileImage, .uploadProfileImage, .setUserStatus, .getUserStatus, .saveChat, .preferenceChat, .getBotStaticMessage,*/ .learningProgress, .weekWiseQuizAnalytics:
            return true
        default:
            return false
        }
    }
    
    func convertJsonToDictionary(jsonData: Data) -> [String: Any]? {
        do {
            if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                return jsonDict
            }
        } catch let error {
            print("Failed to convert JSON to dictionary: \(error.localizedDescription)")
        }
        return nil
    }
    
    func parseModel<T: Codable>(data: T) -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(data) else { return nil }
        return convertJsonToDictionary(jsonData: data)
    }
    
    var header: [String: String] {
        var header = ["Content-Type": "application/json; charset=utf-8",
                      "Accept": "application/json"]
        
        if needAuthorization {
            let token = KeychainManager.shared.retrieve(for: "accessToken") ?? ""
            header["Authorization"] = "Bearer \(token)"
        } else {
            print("Auth token is not passed in ", self.path)
        }
        return header
    }
    
}

extension APIRoute: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = path.isEmpty ? try url.asURL() : try url.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        urlRequest.timeoutInterval = 60
        urlRequest.headers = HTTPHeaders(header)
        urlRequest = try encoding.encode(urlRequest, with: params)
        return urlRequest
    }
    
    func multipartFormData() -> MultipartFormData {
        let multipartFormData = MultipartFormData()
        switch self {
            /*
        case let .uploadProfileImage(uploadedData):
            multipartFormData.appendUploadData(uploadedData)
            
        case let .uploadSecretImage(uploadData):
            multipartFormData.appendUploadData(uploadData)
        case let .uploadMultipleImages(uploadDataList):
            uploadDataList.forEach { multipartFormData.appendUploadData($0) }
            */
        default:
            break
        }
        return multipartFormData
    }
}
