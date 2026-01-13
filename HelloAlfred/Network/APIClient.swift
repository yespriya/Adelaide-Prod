import Foundation
import Alamofire
class APIClient {
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (AFResult<T>) -> Void) -> DataRequest {
        print(route.urlRequest?.url)
        print(route.urlRequest?.headers)
        print(route.urlRequest?.httpMethod)
        print(String(data: route.urlRequest?.httpBody ?? Data(), encoding: .utf8))
        
        // Function to execute the actual request
        func executeRequest() -> DataRequest {
            return AF.request(route).responseDecodable(of: T.self, decoder: decoder) { response in
                if let data = response.data {
                       do {
                           let json = try JSONSerialization.jsonObject(with: data, options: [])
                           print("📦 Response JSON:\n", json)
                       } catch {
                           print("❌ JSON parsing error:", error)
                       }
                   }
                
                if let contentType = response.response?.allHeaderFields["Authorization"] as? String {
                    UserDefaults.standard.set(contentType, forKey: "Authorization")
                }
                
                switch response.result {
                case .success(let value):
                    if let jsonDict = value as? [String: Any],
                       let message = jsonDict["message"] as? String {
                        print("polk: \(message)")
                    }
                    completion(.success(value))
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion(.failure(error))
                }
            }
        }
        
        // 🔁 If token expiring soon, refresh before request
        if let token = TokenManager.shared.accessToken, !token.isEmpty, TokenManager.shared.isTokenExpiringSoon() {
            print("⚠️ Token is expiring soon. Refreshing...")
            
            // Fire dummy request just to satisfy return type
            let placeholderRequest = AF.request("")
            
            TokenManager.shared.refreshToken { success in
                if success {
                    print("✅ Token refreshed. Proceeding with request.")
                    _ = executeRequest() // trigger actual request
                } else {
                    print("❌ Token refresh failed.")
                    completion(.failure(AFError.explicitlyCancelled))
                }
            }
            
            return placeholderRequest // Return dummy request
        } else {
            return executeRequest() // Normal flow
        }
    }
    
    static func updateMessagesToAI(params:[String:Any],completion:@escaping(AFResult<ChatModel>) -> Void) {
        performRequest(route: APIRouter.updateMessagesToAI(params: params),completion: completion)
    }
    static func updateAnswers(params:[String:Any],completion:@escaping(AFResult<QuestionUpdateResModel>) -> Void) {
        performRequest(route: APIRouter.updateAnswers(params: params),completion: completion)
    }
    static func signupUser(params:[String:Any],completion:@escaping(AFResult<CommonResModel>)->Void){
        performRequest(route: APIRouter.signup(params: params),completion: completion)
    }
    static func updateUser(params:[String:Any],completion:@escaping(AFResult<CommonResModel>)->Void){
        performRequest(route: APIRouter.updateUser(params: params),completion: completion)
    }
    static func signInUser(params:[String:Any],completion:@escaping(AFResult<SigninResModel>)->Void){
        performRequest(route: APIRouter.signin(params: params),completion: completion)
    }
    static func addSymptoms(params:[String:Any],completion:@escaping(AFResult<CommonResModel>)->Void){
        performRequest(route: APIRouter.addSymptoms(params: params),completion: completion)
    }
    static func googleAuth(params:[String:Any],completion:@escaping(AFResult<SigninResModel>)->Void){
        performRequest(route: APIRouter.googleAuth(params: params),completion: completion)
    }
    static func fetchUserDetails(completion:@escaping(AFResult<ProfileDetailsModel>)->Void){
        performRequest(route: APIRouter.profileDetails,completion: completion)
    }
    
    static func fetchChatQuestions(completion:@escaping(AFResult<QuestionsResModel>)->Void){
        performRequest(route: APIRouter.chatQuestions,completion: completion)
    }
    static func fetchUserStatus(completion:@escaping(AFResult<UserStatusModel>)->Void){
        performRequest(route: APIRouter.getUserStatus,completion: completion)
    }
    static func updateUserStatus(params:[String:Any],completion:@escaping(AFResult<CommonResModel>)->Void){
        performRequest(route: APIRouter.setUserStatus(params: params),completion: completion)
    }
    static func updateHistoryChatQuestions(params:[String:Any],completion:@escaping(AFResult<HistoryChatQuestionModel>)->Void){
        performRequest(route: APIRouter.updateHistoryChatQuestions(params: params),completion: completion)
    }
    static func updateHistoryFormAnswers(params:[String:Any],completion:@escaping(AFResult<QuestionUpdateResModel>)->Void){
        performRequest(route: APIRouter.updateHistoryFormAnswers(params: params),completion: completion)
    }
    static func fetchHistoryChat(completion:@escaping(AFResult<HistoryChatModel>)->Void){
        performRequest(route: APIRouter.historyChatQuestions,completion: completion)
    }
    static func updateHealthDetails(params:[String:Any],completion:@escaping(AFResult<CommonResModel>)->Void){
        performRequest(route: APIRouter.updateHealthDetails(params: params),completion: completion)
    }
    static func generateOTP(params:[String:Any],completion:@escaping(AFResult<CommonResModel>)->Void){
        performRequest(route: APIRouter.generateOTP(params: params),completion: completion)
    }
    static func verifyOTP(params:[String:Any],completion:@escaping(AFResult<CommonResModel>)->Void){
        performRequest(route: APIRouter.verifyOTP(params: params),completion: completion)
    }
    static func updatePassword(params:[String:Any],completion:@escaping(AFResult<CommonResModel>)->Void){
        performRequest(route: APIRouter.updatePassword(params: params),completion: completion)
    }
    static func lastUpdateHealthDetails(completion:@escaping(AFResult<LastUpdateHealthDetailsModel>)->Void){
        performRequest(route: APIRouter.lastUpdateHealthDetails,completion: completion)
    }
    static func lastUpdateListofSymptoms(completion:@escaping(AFResult<LastUpdateHealthDetailsModel>)->Void){
        performRequest(route: APIRouter.lastUpdateListofSymptoms,completion: completion)
    }
    static func fetchProfileCompletion(params:[String:Any],completion:@escaping(AFResult<ProfileCompletionModel>)->Void){
        performRequest(route: APIRouter.profileCompletion(params: params),completion: completion)
    }
    static func fetchInitialHistoryQuestion(completion:@escaping(AFResult<HistoryChatQuestionModel>)->Void){
        performRequest(route: APIRouter.fetchInitialHistoryQuestion,completion: completion)
    }
    static func fetchHistoryTranscript(completion:@escaping(AFResult<HistoryTranscriptModel>)->Void){
        performRequest(route: APIRouter.fetchInitialHistoryTranscript,completion: completion)
    }
    static func changePassword(params:[String:Any],completion:@escaping(AFResult<CommonResModel>)->Void){
        performRequest(route: APIRouter.changePassword(params: params),completion: completion)
    }
    static func fetchLinearChartData(params:[String:Any],completion:@escaping(AFResult<LinearChartDataModel>)->Void){
        performRequest(route: APIRouter.fetchLinearChartData(params: params),completion: completion)
    }
    static func fetchWeeklyContent(params: String, completion:@escaping(AFResult<WeeklyContentModel>)->Void){
        performRequest(route: APIRouter.getWeeklyContent(params: params),completion: completion)
    }
    static func fetchWeekStatus(completion:@escaping(AFResult<WeekStatusModel>)->Void) {
        performRequest(route: APIRouter.fetchWeekStatus,completion: completion)
    }
    static func fetchBotStaticMessage(completion:@escaping(AFResult<ChatStaticMessageModel>)->Void) {
        performRequest(route: APIRouter.getBotStaticMessage,completion: completion)
    }
    
    static func preferenceChat(params:[String:Any], completion:@escaping(AFResult<ChatPreferenceModel>)->Void) {
        performRequest(route: APIRouter.preferenceChat(params: params),completion: completion)
    }
    
    static func fetchHealthHubDropDownData(params:[String:Any], completion:@escaping(AFResult<HealthHubDropDownModel>)->Void) {
        performRequest(route: APIRouter.fetchHealthHubDropDownData(params: params), completion: completion)
    }
    static func fetechHealthHubOverview(params:[String:Any], completion:@escaping(AFResult<HealthHubOverviewModel>)->Void) {
        performRequest(route: APIRouter.fetchHealthHubOverviewData(params: params), completion: completion)
    }
    static func updateHealthHubStatus(params:[String:Any],completion:@escaping(AFResult<HealthHubStatusResponse>)->Void){
        performRequest(route: APIRouter.updateHealthHubStatus(params: params),completion: completion)
    }
    static func deleteProfileImage(completion:@escaping(AFResult<CommonResModel>)->Void){
        performRequest(route: APIRouter.deleteProfileImage,completion: completion)
    }
    static func lastUpdatedSymptomsDetails(completion:@escaping(AFResult<LastestSymptomsDetailsModel>)->Void){
        performRequest(route: APIRouter.getLatestSymptoms,completion: completion)
    }
    static func lastUpdatedExpertMonitoringDetails(completion:@escaping(AFResult<LastestExpertMonitoringModel>)->Void){
        performRequest(route: APIRouter.getLastExpertMonitoringDetails,completion: completion)
    }
    static func fetchTermsAndConditions(completion:@escaping(AFResult<TermsAndConditionsModel>)->Void){
        performRequest(route: APIRouter.fetchTermsAndConditions,completion: completion)
    }
    static func sendTNC(params:[String:Any],completion:@escaping(AFResult<CommonResModel>)->Void){
        performRequest(route: APIRouter.sendTNC(params: params),completion: completion)
    }
    
    static func fetchVideoContent(completion:@escaping(AFResult<VideoListContentModel>)->Void) {
        performRequest(route: APIRouter.getVideoContent,completion: completion)
    }
    
    static func fetchQuizData(params:[String:Any], completion:@escaping(AFResult<QuestionResponse>)->Void) {
        performRequest(route: APIRouter.fetchQuizData(params: params), completion: completion)
    }
    
    static func evaluateQuizAnswers(params:[String:Any], completion: @escaping(AFResult<QuestionEvaluatedResponse>)->Void) {
        performRequest(route: APIRouter.evaluateQuizAnswer(params: params), completion: completion)
    }
    static func shareChatToEmail(params:[String:Any], completion: @escaping(AFResult<ShareChatEmail>)->Void) {
        performRequest(route: APIRouter.sendChatToEmail(params: params), completion: completion)
    }
}

