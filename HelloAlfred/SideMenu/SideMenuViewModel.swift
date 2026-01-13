//
//  ProfileViewModel.swift
//  Eatzilla_Delivery
//
//  Created by saranya selvaraj on 27/03/19.
//  Copyright © 2019 EatZilla. All rights reserved.
//

import UIKit

enum SideMenuItem:String {
   
    case myProfile = "My Profile"
    case chatWithUs = "Chat with us"
    case goals = "Goals"
    case doctors = "Doctors"
    case knowledgeBank = "Knowledge Bank"
    case schedules = "Schedules"
    case bookAppointments = "Book New Appointment"
    case integrations = "Integrations"
    case historyTranscript = "History Transcript"
    case behavioralChat = "Behavioral Chat"
    case historyChat = "History Chat"


}

class SideMenuViewModel: NSObject {
    var sideMenuItems:[SideMenuItem] = [.myProfile, .chatWithUs, .goals , .doctors, .knowledgeBank,.schedules,.bookAppointments,.integrations,.historyTranscript,.behavioralChat,.historyChat]
    var sideMenuIcons:[String] = ["myaccount","chatwithus","goals","doctors","knowledgebank","schedules","bookappointments","integrations", "beta-feature","beta-feature","beta-feature"]
}
