//
//  DoctorSignUpViewController.swift
//  HelloAlfred
//
//  Created by admin on 29/07/24.
//

import UIKit

class DoctorSignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let countries = getCountries()
        print(countries)
        // Instantiate and call the function
       
        // Do any additional setup after loading the view.
    }
    
    func getCountries() -> [String] {
        var countries = [String]()
        let countryCodes = Locale.isoRegionCodes
        
        for code in countryCodes {
            if let countryName = Locale.current.localizedString(forRegionCode: code) {
                countries.append(countryName)
            }
        }
        
        return countries.sorted()
    }
}


class StreamingAPIHandler: NSObject, URLSessionDataDelegate {
    private var urlSession: URLSession!
    
    override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    func sendPostRequest() {
        guard let url = URL(string: "https://api.stream.helloalfred.ai/education_bot_home") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: String] = ["message": "hello"]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error encoding JSON payload: \(error)")
            return
        }
        
        let task = urlSession.dataTask(with: request)
        task.resume()
    }
    
    // URLSessionDataDelegate methods
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            print("Received JSON chunk: \(jsonResponse)")
        } else {
            let stringResponse = String(data: data, encoding: .utf8)
            print("Received data chunk: \(stringResponse ?? "Unknown data format")")
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("Error in streaming: \(error)")
        } else {
            print("Streaming completed successfully")
        }
    }
}
