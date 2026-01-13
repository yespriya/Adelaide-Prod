//
//  HealthHubViewController.swift
//  HelloAlfred
//
//  Created by admin on 03/08/24.
//

import UIKit
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let healthHubOverviewModel = try? JSONDecoder().decode(HealthHubOverviewModel.self, from: jsonData)

import Foundation

// MARK: - HealthHubOverviewModel
struct HealthHubOverviewModel: Codable {
    let status: Bool?
    let statuscode: Int?
    let message: String?
    let data: [AFTopic]?
}

// MARK: - Datum
struct AFTopic: Codable {
    let week: Week
    let title: String
    let list: [String]
}

enum Week: Codable {
    case string(String)
    case stringArray([String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([String].self) {
            self = .stringArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Week.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Week"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .stringArray(let x):
            try container.encode(x)
        }
    }
}

class HealthHubOverViewViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var afTopics: [AFTopic] = []
    
    @IBOutlet var overViewTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        overViewTableView.delegate = self
        overViewTableView.dataSource = self
    }
    
    
    // MARK: - Navigation
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return afTopics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HealthHubOverviewTableViewCell") as! HealthHubOverviewTableViewCell
        cell.titleLabel.text = "Module \(indexPath.row+1)"
        cell.weekLabel.text = afTopics[indexPath.row].title
        let combinedText = afTopics[indexPath.row].list.joined(separator: "\n• ")
        cell.detail1Label.text = "• " + combinedText
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Call this method when you want to dismiss and send data back
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
