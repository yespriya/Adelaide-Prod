//
//  TokenManager.swift
//  HelloAlfred
//
//  Created by SS on 13/07/25.
//

import Foundation
import Alamofire
import UIKit

// MARK: - Token Response Model
struct TokenResponse: Decodable {
    let statuscode: Int
    let message: String
    let data: TokenData?
}

struct TokenData: Decodable {
    let token: String?
}

// MARK: - Token Manager
class TokenManager {
    static let shared = TokenManager()
    private init() {}

    var accessToken: String? {
        get { UserDefaults.standard.string(forKey: "Authorization") }
        set { UserDefaults.standard.set(newValue, forKey: "Authorization") }
    }

    var isRefreshing = false
    var refreshQueue: [() -> Void] = []

    /// Decode JWT and check if expiring in next 5 mins
    func isTokenExpiringSoon() -> Bool {
        guard let token = accessToken else { return true }
        let parts = token.components(separatedBy: ".")

        if parts.count > 1 {
            let payloadPart = parts[1]
            let payloadData = base64Decode(payloadPart)
            if let payload = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any],
               let exp = payload["exp"] as? TimeInterval {
                
                let expiryDate = Date(timeIntervalSince1970: exp)

                let currentDate = Date()
                let buffer: TimeInterval = 5 * 60 // 5 min buffer
                print(expiryDate.timeIntervalSince(currentDate))
                print(buffer)
                return expiryDate.timeIntervalSince(currentDate) < buffer
            }
        }
        return true
    }

    private func base64Decode(_ str: String) -> Data {
        var base64 = str.replacingOccurrences(of: "-", with: "+")
                       .replacingOccurrences(of: "_", with: "/")
        let rem = base64.count % 4
        if rem > 0 {
            base64 += String(repeating: "=", count: 4 - rem)
        }
        return Data(base64Encoded: base64) ?? Data()
    }

    /// Call token refresh API
    func refreshToken(completion: @escaping (Bool) -> Void) {
        guard !isRefreshing else {
            refreshQueue.append { completion(true) }
            return
        }

        guard let token = accessToken, !token.isEmpty else {
            print("🔴 No token found. Forcing logout.")
            forceLogout()
            completion(false)
            return
        }

        isRefreshing = true
        let url =  DataService.developmentBaseURL + "common" + "/refresh_token"

       // let url = "https://qa.helloalfred.ai/common/refresh_token"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        AF.request(url, method: .get, headers: headers)
            .responseData { response in
                self.isRefreshing = false

                if let data = response.data {
                    let rawJSON = String(data: data, encoding: .utf8) ?? "N/A"
                    print("🟨 Raw Token Refresh Response: \(rawJSON)")
                }

                switch response.result {
                case .success:
                    do {
                        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: response.data!)
                        if let token = tokenResponse.data?.token {
                            self.accessToken = token
                            self.refreshQueue.forEach { $0() }
                            self.refreshQueue.removeAll()
                            completion(true)
                        } else {
                            print("⚠️ Token missing in parsed response. Forcing logout.")
                            self.forceLogout()
                            completion(false)
                        }
                    } catch {
                        print("🟥 Decoding Error: \(error). Forcing logout.")
                        self.forceLogout()
                        completion(false)
                    }

                case .failure(let error):
                    print("🔴 Token Refresh Failed: \(error). Forcing logout.")
                    self.forceLogout()
                    completion(false)
                }
            }
    }
    
    func forceLogout() {
        print("🔒 Logging out user...")

        DispatchQueue.main.async {
            let topVc = self.topViewController()
            topVc?.clearStoredData()
            topVc?.navigateTo(viewController: SignInViewController.self, withIdentifier: "SignInViewController")
        }
    }
    
    func topViewController(base: UIViewController? = UIApplication.shared.connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
        .first?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }

}
