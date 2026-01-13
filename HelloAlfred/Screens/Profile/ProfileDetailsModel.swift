import Foundation

struct ProfileDetailsModel: Codable {
    let statuscode: Int?
    let status: Bool?
    let message: String?
    let data: ProfileData?

    enum CodingKeys: String, CodingKey {
        case statuscode = "statuscode"
        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statuscode = try values.decodeIfPresent(Int.self, forKey: .statuscode)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(ProfileData.self, forKey: .data)
    }
}

struct ProfileData: Codable {
    let nationality: String?
    let mobile: String?
    let email: String?
    let username: String?
    let dob: String?
    let gender: String?
    let rtype: String?
    let education: String?
    let inch: String?
    let weight: String?
    let ssn: String?
    let bloodtype: String?
    let age: Int?
    let subscription: String?
    let insurance_provider: String?
    let insurance_policy_no: String?
    let profile_percentage: Int?
    let profile_url: String?
    let bmi: String?
    let feet: String?

    enum CodingKeys: String, CodingKey {
        case email = "email"
        case nationality = "nationality"
        case mobile = "mobile"
        case username = "username"
        case dob = "dob"
        case gender = "gender"
        case rtype = "rtype"
        case education = "education"
        case inch = "inch"
        case weight = "weight"
        case ssn = "ssn"
        case bloodtype = "bloodtype"
        case age = "age"
        case subscription = "subscription"
        case insurance_provider = "insurance_provider"
        case insurance_policy_no = "insurance_policy_no"
        case profile_percentage = "profile_percentage"
        case bmi = "bmi"
        case feet = "feet"
        case profile_url = "profile_url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        rtype = try values.decodeIfPresent(String.self, forKey: .rtype)
        education = try values.decodeIfPresent(String.self, forKey: .education)
        inch = try values.decodeIfPresent(String.self, forKey: .inch)
        weight = try values.decodeIfPresent(String.self, forKey: .weight)
        ssn = try values.decodeIfPresent(String.self, forKey: .ssn)
        bloodtype = try values.decodeIfPresent(String.self, forKey: .bloodtype)
        age = try values.decodeIfPresent(Int.self, forKey: .age)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        nationality = try values.decodeIfPresent(String.self, forKey: .nationality)
        subscription = try values.decodeIfPresent(String.self, forKey: .subscription)
        insurance_provider = try values.decodeIfPresent(String.self, forKey: .insurance_provider)
        insurance_policy_no = try values.decodeIfPresent(String.self, forKey: .insurance_policy_no)
        profile_percentage = try values.decodeIfPresent(Int.self, forKey: .profile_percentage)
        feet = try values.decodeIfPresent(String.self, forKey: .feet)
        profile_url = try values.decodeIfPresent(String.self, forKey: .profile_url)


        // Decode BMI as either a Float or a String
        if let bmiFloat = try? values.decodeIfPresent(Float.self, forKey: .bmi) {
            bmi = String(bmiFloat)
        } else if let bmiString = try? values.decodeIfPresent(String.self, forKey: .bmi) {
            bmi = bmiString
        } else {
            bmi = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(username, forKey: .username)
        try container.encodeIfPresent(dob, forKey: .dob)
        try container.encodeIfPresent(gender, forKey: .gender)
        try container.encodeIfPresent(rtype, forKey: .rtype)
        try container.encodeIfPresent(education, forKey: .education)
        try container.encodeIfPresent(inch, forKey: .inch)
        try container.encodeIfPresent(weight, forKey: .weight)
        try container.encodeIfPresent(ssn, forKey: .ssn)
        try container.encodeIfPresent(bloodtype, forKey: .bloodtype)
        try container.encodeIfPresent(age, forKey: .age)
        try container.encodeIfPresent(mobile, forKey: .mobile)
        try container.encodeIfPresent(nationality, forKey: .nationality)
        try container.encodeIfPresent(subscription, forKey: .subscription)
        try container.encodeIfPresent(insurance_provider, forKey: .insurance_provider)
        try container.encodeIfPresent(insurance_policy_no, forKey: .insurance_policy_no)
        try container.encodeIfPresent(profile_percentage, forKey: .profile_percentage)
        try container.encodeIfPresent(feet, forKey: .feet)
        try container.encodeIfPresent(profile_url, forKey: .profile_url)

        // Encode BMI as a String
        try container.encodeIfPresent(bmi, forKey: .bmi)
    }
}

