//
//  APIService.swift
//  Adelaide Prod
//
//  Created by Prit  on 04/02/26.
//

import Foundation
import Alamofire
import RxSwift
import UIKit

enum CheckingType {
    case checked
    case unchecked
}

class APIService {
    static let shared = APIService()
    private let session: Session
    
    private init(_ session: Session = Session.default) {
        self.session = session
    }
    

    private func showLoader() {
        LoaderManager.shared.show()
    }

    private func dismissLoader() {
        LoaderManager.shared.hide()
    }

    func request<T: Decodable>(router: APIRoute, checking: CheckingType = .checked, isShowLoader:Bool = true) -> Single<T> {
        if checking == .checked {
            if isShowLoader {
                showLoader()
            }
        }

        return Single<T>.create { singleEvent in
            let request: DataRequest
            switch router {
            /*
            case .uploadProfileImage:
                request = self.session.upload(multipartFormData: router.multipartFormData(), with: router)
            */
            default:
                request = self.session.request(router)
            }
            
            // Log request and response
            request.responseString { response in
                print("🌍[API]----Request: \(router.urlRequest?.httpMethod ?? "") " + (router.urlRequest?.url?.absoluteString ?? ""))
                print("[API]----Params: " + (router.params?.toJSONString() ?? ""))
                print("[API]----Response: " + (response.value ?? ""))
            }
            
            // Handle response
            request.responseDecodable(of: T.self) { response in
                if checking == .checked {
                    self.dismissLoader()
                }
                self.handleResponse(response, router, checking, singleEvent)
                print("[API]----response: \(response)")
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func requestToken<T: Decodable>(router: APIRoute, checking: CheckingType = .checked) -> Single<T> {
        if checking == .checked {
            showLoader()
        }

        return Single<T>.create { singleEvent in
            let request: DataRequest
            switch router {
                /*
            case .uploadProfileImage:
                request = self.session.upload(multipartFormData: router.multipartFormData(), with: router)
                 */
            default:
                request = self.session.request(router)
            }

            // Log request and response
            request.responseString { response in
                print("🌍[API]----Request: \(router.urlRequest?.httpMethod ?? "") " + (router.urlRequest?.url?.absoluteString ?? ""))
                print("[API]----Params: " + (router.params?.toJSONString() ?? ""))
                print("[API]----Response: " + (response.value ?? ""))
            }

            // Handle response
            request.responseDecodable(of: T.self) { response in
                if checking == .checked {
                    self.dismissLoader()
                }
                self.handleResponse(response, router, checking, singleEvent)
                print("[API]----response: \(response)")
            }

            return Disposables.create()
        }
    }

    private func handleResponse<T: Decodable>(
        _ response: AFDataResponse<T>,
        _ router: APIRoute,
        _ checking: CheckingType,
        _ singleEvent: @escaping (SingleEvent<T>) -> Void
    ) {
        switch response.result {
        case .success(let value):
            singleEvent(.success(value))
        case .failure(let error):
            if case .responseSerializationFailed(let reason) = error {
                print("Decoding failed:", error)
                singleEvent(.failure(NSError(
                    domain: NSURLErrorDomain,
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: reason]
                )))
                
            } else if let urlError = error.underlyingError as? URLError,
               (urlError.code == .notConnectedToInternet || urlError.code == .networkConnectionLost || urlError.code == .timedOut) {
                singleEvent(.failure(NSError(
                    domain: NSURLErrorDomain,
                    code: NSURLErrorNotConnectedToInternet,
                    userInfo: [NSLocalizedDescriptionKey: "No Internet"]
                )))
            } else {
                singleEvent(.failure(error))
            }
        }
    }
}

extension APIService {
    private func handleResponse<T: Decodable>(_ response: DataResponse<T, AFError>,
                                              _ router: APIRoute,
                                              _: CheckingType,
                                              _ singleEvent: @escaping (SingleEvent<T>) -> Void)
    {
        
        
        let responseDic = response.data?.convertToDictionary()
        let message = responseDic?["message"] as? String
        let errCode = responseDic?["errorCode"] as? Int
        
        switch response.result {
        case let .success(result):
            singleEvent(.success(result))
        case let .failure(errorResponse):
            switch errorResponse {
            case .responseSerializationFailed:
                if T.self == String.self, let data = response.data, let str = String(data: data, encoding: .utf8) {
                    singleEvent(.success(str as! T))
                    return
                }
            default:
                break
            }
            handleError(errorResponse, errCode, message, responseDic, singleEvent)
        }
    }
    
    private func handleError<T>(
        _ errorResponse: Error,
        _ errCode: Int?,
        _ message: String?,
        _ data: [String: Any]?,
        _ singleEvent: @escaping (SingleEvent<T>) -> Void
    ) {
        if errCode == HttpStatusCode.validationFail.rawValue {
            let error = NSError(domain: "Validaiton Error", code: HttpStatusCode.validationFail.rawValue)
            singleEvent(.failure(error))
            return
        }
        
        if errCode == HttpStatusCode.expireToken.rawValue {
            let error = NSError(domain: "Token Expire Error", code: HttpStatusCode.expireToken.rawValue)
            singleEvent(.failure(error))
//            NotificationCenter.default.post(name: NSNotification.expireToken, object: nil, userInfo: nil)
            return
        }
        
        if let data = data {
            let error = NSError(domain: "Other Error", code: HttpStatusCode.unknown.rawValue)
            singleEvent(.failure(error))
            return
        }
        singleEvent(.failure(errorResponse))
    }
}
