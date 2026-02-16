//
//  UserRepository.swift
//  Adelaide Prod
//
//  Created by Prit  on 04/02/26.
//

import Foundation
import RxSwift
import Alamofire

struct UserRepository {
    let api: APIService = .shared
    /*
    // signup
    func signup(with model: SignupRequestModel, isShowLoader: Bool) -> Single<BaseResponse<AccessToken>> {
        return api.request(router: .signup(model: model), checking: isShowLoader ? .checked : .unchecked)
    }
    
    // signIn
    func signIn(with model: SignInRequestModel, isShowLoader: Bool) -> Single<BaseResponse<AccessToken>> {
        return api.request(router: .signIn(model: model), checking: isShowLoader ? .checked : .unchecked)
    }
    
    // socialAuth
    func socialAuth(with model: SignInRequestModel, isShowLoader: Bool) -> Single<BaseResponse<AccessToken>> {
        return api.request(router: .socialAuth(model: model), checking: isShowLoader ? .checked : .unchecked)
    }
     
    // generate OTP
    func generateOTP(with model: OTPRequestModel, isShowLoader: Bool) -> Single<BaseResponse<AccessToken>> {
        return api.request(router: .generateOtp(model: model), checking: isShowLoader ? .checked : .unchecked)
    }
    
    // updatePassword
    func updatePassword(with model: SignInRequestModel, isShowLoader: Bool) -> Single<BaseResponse<AccessToken>> {
        return api.request(router: .updatePassword(model: model), checking: isShowLoader ? .checked : .unchecked)
    }
    
    // verify otp
    func verifyOTP(with email: String, otp: String, isShowLoader: Bool) -> Single<BaseResponse<AccessToken>> {
        return api.request(router: .verifyOTP(email: email, otp: otp), checking: isShowLoader ? .checked : .unchecked)
    }
    
    // change password
    func changePassword(with oldPassword: String, newPassword: String, isShowLoader: Bool) -> Single<BaseResponse<AccessToken>> {
        return api.request(router: .changePassword(old: oldPassword, new: newPassword), checking: isShowLoader ? .checked : .unchecked)
    }
    
    // fetch T&C
    func fetchTNC(with email: String, isShowLoader: Bool) -> Single<BaseResponse<AccessToken>> {
        return api.request(router: .sendTNC(email: email), checking: isShowLoader ? .checked : .unchecked)
    }
    
    // sendTNC
    func sendTNC(with email: String, isShowLoader: Bool) -> Single<BaseResponse<AccessToken>> {
        return api.request(router: .sendTNC(email: email), checking: isShowLoader ? .checked : .unchecked)
    }
    
    // get user details
    func userDetails(isShowLoader: Bool) -> Single<BaseResponse<ProfileData>> {
        return api.request(router: .profileDetails, checking: isShowLoader ? .checked : .unchecked)
    }

    // update user details
    func updateUserDetails(with model: UserProfileRequest, isShowLoader: Bool) -> Single<BaseResponse<Empty>> {
        return api.request(router: .updateUserDetails(model: model), checking: isShowLoader ? .checked : .unchecked)
    }
    
    // delete profile image
    func deleteProfileImage(isShowLoader: Bool) -> Single<BaseResponse<Empty>> {
        return api.request(router: .deleteProfileImage, checking: isShowLoader ? .checked : .unchecked)
    }
    
    // upload profile image
    func uploadProfileImage(data: APIUploadData, isShowLoader: Bool) -> Single<BaseResponse<UserProfileImage>> {
        return api.request(router: .uploadProfileImage(data: data), checking: isShowLoader ? .checked : .unchecked)
    }
    
    // update user status
    func setUserStatus(with model: UserStatusModel, isShowLoader: Bool) -> Single<BaseResponse<Empty>> {
        return api.request(router: .setUserStatus(model: model), checking: isShowLoader ? .checked : .unchecked)
    }
    
    // get user status
    func getUserStatus(isShowLoader: Bool) -> Single<BaseResponse<UserStatusModel>> {
        return api.request(router: .getUserStatus, checking: isShowLoader ? .checked : .unchecked)
    }
    */
    
    // learning process
    func getLearningProgress(with model: LearningAnalyticsRequestModel, isShowLoader: Bool) -> Single<BaseResponse<[PatientAnalyticsData]>> {
        return api.request(router: .learningProgress(model: model), checking: isShowLoader ? .checked : .unchecked)
    }
    
    // week wise quiz analytics
    func getWeekWiseQuizAnalytics(with model: WeekWiseQuizAnalyticsRequestModel, isShowLoader: Bool) -> Single<BaseResponse<[QuizAnalyticsData]>> {
        return api.request(router: .weekWiseQuizAnalytics(model: model), checking: isShowLoader ? .checked : .unchecked)
    }
}
