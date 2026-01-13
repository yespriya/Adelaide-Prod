import Foundation
import Alamofire

enum APIRouter : URLRequestConvertible {

    case updateMessagesToAI(params:[String:Any])
    case updateAnswers(params:[String:Any])
    case updateHistoryChatQuestions(params:[String:Any])
    case signup(params:[String:Any])
    case signin(params:[String:Any])
    case addSymptoms(params:[String:Any])
    case updateUser(params:[String:Any])
    case googleAuth(params:[String:Any])
    case setUserStatus(params:[String:Any])
    case updateHistoryFormAnswers(params:[String:Any])
    case updateHealthDetails(params:[String:Any])
    case generateOTP(params:[String:Any])
    case verifyOTP(params:[String:Any])
    case updatePassword(params:[String:Any])
    case profileCompletion(params:[String:Any])
    case changePassword(params:[String:Any])
    case updateHealthHubStatus(params:[String:Any])
    case fetchLinearChartData(params:[String:Any])
    case getWeeklyContent(params: String)
    case sendTNC(params:[String:Any])
    
    case fetchInitialHistoryQuestion
    case deleteProfileImage

    case fetchInitialHistoryTranscript
    case fetchWeekStatus
    case fetchHealthHubDropDownData(params:[String:Any])
    case fetchHealthHubOverviewData(params:[String:Any])
    case fetchQuizData(params:[String:Any])
    case evaluateQuizAnswer(params:[String:Any])
    case profileDetails
    case chatQuestions
    case historyChatQuestions
    case lastUpdateHealthDetails
    case lastUpdateListofSymptoms
    case getUserStatus
    case getLatestSymptoms
    case getLastExpertMonitoringDetails
    case fetchTermsAndConditions
    case sendChatToEmail(params: [String: Any])
    case getBotStaticMessage
    case getVideoContent
    case preferenceChat(params: [String: Any])


    // MARK: - HTTPMethod
    private var method : HTTPMethod {
        switch self {
        case .updateHealthHubStatus:
            return .post
        case .updateMessagesToAI:
            return .post
        case .updateAnswers:
            return .post
        case .signup:
            return .post
        case .signin:
            return .post
        case .updateUser:
            return .put
        case .profileDetails:
            return .get
        case .addSymptoms:
            return .post
        case .googleAuth:
            return .post
        case .chatQuestions:
            return .get
        case .getUserStatus:
            return .get
        case .historyChatQuestions:
            return .get
        case .lastUpdateHealthDetails:
            return .get
        case .fetchWeekStatus:
            return .get
        case .fetchHealthHubDropDownData:
            return .post
        case .fetchHealthHubOverviewData:
            return .post
        case .fetchQuizData:
            return .post
        case .evaluateQuizAnswer:
            return .post
        case .profileCompletion:
            return .post
        case .updateHistoryChatQuestions:
            return .post
        case .setUserStatus:
            return .post
        case .updateHistoryFormAnswers:
            return .post
        case .updateHealthDetails:
                return .post
        case .generateOTP:
                return .post
        case .verifyOTP:
                return .post
        case .updatePassword:
                return .put
        case .fetchInitialHistoryQuestion:
                return .get
        case .fetchInitialHistoryTranscript:
            return .get
        case .changePassword:
            return .put
        case .fetchLinearChartData:
            return .post
        case .lastUpdateListofSymptoms:
            return .get
        case .getWeeklyContent:
            return .get
        case .deleteProfileImage:
            return .delete
        case .getLatestSymptoms:
            return .get
        case .getLastExpertMonitoringDetails:
            return .get
        case .fetchTermsAndConditions:
            return .get
        case .sendTNC:
            return .post
        case .getVideoContent:
            return .get
        case .sendChatToEmail:
                return .post
        case .getBotStaticMessage:
            return .get
        case .preferenceChat:
            return .post
        }
    }
    
    private var path: String 
    {
        switch self {
        case .updateMessagesToAI:
            return "ask_gpt"
        case .updateAnswers:
            return "patient/categorizeresponse"
        case .signup:
            return "common/create_account"
        case .signin:
            return "common/login_account"
        case .updateUser:
            return "patient/update_userdetails"
        case .profileDetails:
            return "patient/userdetails"
        case .addSymptoms:
            return "patient/add_symptoms"
        case .googleAuth:
            return "common/socialauth"
        case .chatQuestions:
            return "patient/chatbot_questions"
        case .getUserStatus:
            return "patient/getstatus"
        case .setUserStatus:
            return "patient/setstatus"
        case .historyChatQuestions:
            return "patient/get_chat_history"
        case .updateHistoryChatQuestions:
            return "patient/history_answer"
        case .updateHistoryFormAnswers:
            return "historybotcat"
        case .updateHealthDetails:
            return "patient/add_health_details"
        case .generateOTP:
            return "common/generate_otp"
        case .verifyOTP:
            return "common/verify_otp"
        case .updatePassword:
            return "common/update_password"
        case .lastUpdateHealthDetails:
            return "patient/healthdetails_lastupdate"
        case .profileCompletion:
            return "patient/profile_completions_summary"
        case .fetchInitialHistoryQuestion:
            return "patient/initial_question"
        case .fetchInitialHistoryTranscript:
            return "patient/history_transcript"
        case .changePassword:
            return "change-password"
        case .fetchLinearChartData:
            return "patient/health_details_graph"
        case .lastUpdateListofSymptoms:
            return "patient/latest_symptoms_record_date"
        case .getWeeklyContent(let param):
            return "patient/getweeklycontent/\(param)"
        case .fetchWeekStatus:
            return "patient/weekly_unlock_content"
        case .updateHealthHubStatus:
            return "patient/update_health_hub_status"
        case .deleteProfileImage:
            return "common/delete_profile_image"
        case .getLatestSymptoms:
            return "patient/get_latest_symptoms"
        case .getLastExpertMonitoringDetails:
            return "patient/get_latest_expertmonitoring"
        case .fetchTermsAndConditions:
            return "common/termsandconditions"
        case .sendTNC:
            return "common/send_tnc"
        case .getVideoContent:
            return "patient/get_healthhub_video_link"
        case .fetchHealthHubDropDownData:
            return "patient/get_health_hub_dropdown"
        case .fetchHealthHubOverviewData:
            return "patient/get_health_hub_overivew"
        case .fetchQuizData:
            return "patient/get_quiz_question"
        case .evaluateQuizAnswer:
            return "patient/healthub_quiz_evaluate"
        case .sendChatToEmail:
            return "common/send_chat_to_email"
        case .getBotStaticMessage:
            return "common/get_bot_static_message"
        case .preferenceChat:
            return "patient/preference_chat"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .updateMessagesToAI(let params):
            return params
        case .updateAnswers(let params):
            return params
        case .updateHistoryChatQuestions(let params):
            return params
        case .signup(let params):
            return params
        case .signin(let params):
            return params
        case .updateUser(let params):
            return params
        case .addSymptoms(let params):
            return params
        case .googleAuth(let params):
            return params
        case .setUserStatus(let params):
            return params
        case .updateHistoryFormAnswers(let params):
            return params
        case .updateHealthDetails(let params):
            return params
        case .generateOTP(let params):
            return params
        case .verifyOTP(let params):
            return params
        case .updatePassword(let params):
            return params
        case .changePassword(let params):
            return params
        case .fetchLinearChartData(let params):
            return params
        case .getWeeklyContent(let params):
            return nil
        case .updateHealthHubStatus(let params):
            return params
        case .deleteProfileImage:
            return nil
        case .fetchInitialHistoryQuestion:
            return nil
        case .profileDetails:
            return nil
        case .chatQuestions:
            return nil
        case .getUserStatus:
            return nil
        case .historyChatQuestions:
            return nil
        case .lastUpdateHealthDetails:
            return nil
        case .lastUpdateListofSymptoms:
            return nil
        case .profileCompletion(let params):
            return params
        case .fetchInitialHistoryTranscript:
            return nil
        case .fetchWeekStatus:
            return nil
        case .getLatestSymptoms:
            return nil
        case .getLastExpertMonitoringDetails:
            return nil
        case .fetchTermsAndConditions:
            return nil
        case .sendTNC(let params):
            return params
            
        case .getVideoContent:
            return nil
        case .fetchHealthHubDropDownData(let params):
            return params
        case .fetchHealthHubOverviewData(let params):
            return params
        case .fetchQuizData(let params):
            return params
        case .evaluateQuizAnswer(let params):
            return params
        case .sendChatToEmail(let params):
               return params
        case .getBotStaticMessage:
            return nil
        case .preferenceChat(let params):
            return params
        }
    }
    
    func encodeURLRequestWithoutQuestionMark(urlRequest: URLRequest, with parameters: Parameters) throws -> URLRequest {
        var modifiedRequest = urlRequest
        let query = parameters.map { "\($0.key)\($0.value)" }.joined(separator: "&")
        
        if let url = urlRequest.url {
            var urlString = url.absoluteString
            // Remove the existing query if any
            if let existingQueryRange = urlString.range(of: "?") {
                urlString.removeSubrange(existingQueryRange)
            }
            print("ree \(urlString) \(query)")
            urlString += "/\(query)"
            if let modifiedURL = URL(string: urlString) {
                modifiedRequest.url = modifiedURL
            }
        }
        return modifiedRequest
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try DataService.developmentBaseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 20
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        switch path 
        {
        case "create_user":
        break // "No auth token needed
        case "user/login":
        break // "No auth token needed
        case "chatbot_questions":
        break
        default:
            urlRequest.setValue(UserDefaults.standard.string(forKey: "Authorization"), forHTTPHeaderField: "Authorization")
            debugPrint("user token \(UserDefaults.standard.string(forKey: "Authorization"))");
        }
        // Parameters
        if let parameters = parameters {
            do
            {
                
                if method == .get {
                   
                    if(path == "getweeklycontent")
                    {
                        let modifiedRequest = try  encodeURLRequestWithoutQuestionMark(urlRequest: urlRequest, with: parameters)
                        urlRequest = modifiedRequest
                    }
                    else
                    {
                        urlRequest = try URLEncoding(destination: .queryString).encode(urlRequest, with: parameters)
                    }
                    
                } else {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                }
            } catch
            {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        debugPrint("URL:\(urlRequest)")
        return urlRequest
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
