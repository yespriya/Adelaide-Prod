//
//  StructDefinitions.swift
//  HelloAlfred
//
//  Created by admin on 02/09/24.
//

import Foundation
import UIKit

struct Category {
    let name: String
    let unit: String
    let image: String
    let bgColor: String
    let value: String
    
}

struct Categories {
    var lifeStyleCategories: [Category]
    var riskFactorsCategories: [Category]
    var afibCategories: [Category]
}

// MARK: - CategoryDetails Struct

struct CategoryDetails {
    let name: String
    let unit: String
    let image: String
    let bgColor: String
    let value: String
    let unfilledColour: String
    let filledColour: String
}
struct CardDetailsView
{
    let cardNumber:String;
    let bankName:String
    let bankLogo:String
}
struct SignupUserData{
    var firstName: String?
    var lastName: String?
    var email: String?
    var dob: String?
    var gender: String?
    var mobile: String?
    var rtype: String?
    var education: String?
    var ssn: String?
    var insuranceurl: String?
    var password: String?
    var nationality: String?


       
}
struct QAObject {
    var question_id: String
    var answer: String
}

struct IntroData
{
    var introImage: UIImage
    var title: String
    var description: String
}

struct UserSymptomsData {
        var categoryIndex: Int?
        var frequency: String?
        var severity: String?
        var eql: Bool?
}

struct Message {
    var text: String
    var isSender: Bool // true if sender, false if receiver
    var isLoading: Bool = false // optional parameter with default value as false
    var isLiked: Bool = false
    var isDisLiked: Bool = false
    var isDislikePopupOpened: Bool = false
}
