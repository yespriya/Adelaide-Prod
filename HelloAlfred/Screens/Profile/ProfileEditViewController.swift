//
//  ProfileEditViewController.swift
//  HelloAlfred
//
//  Created by admin on 11/04/24.
//

import UIKit
import Alamofire
import SDWebImage
import FlagPhoneNumber


class ProfileEditViewController: BaseViewController
{
    
    @IBOutlet var idTypeTextFeild: UnderlinedTextField!
    @IBOutlet var bloodGroupTextFeild: UnderlinedTextField!
    @IBOutlet var insuranceNumberTextFeild: MyTextfeild!
    @IBOutlet var feetTextFeild: MyTextfeild!
    
    @IBOutlet var emailTextFeild: MyTextfeild!
    @IBOutlet var insuranceProviderTextFeild: UnderlinedTextField!
    @IBOutlet var educationTextFeild: MyTextfeild!
    @IBOutlet var residentTypeTextFeild: UnderlinedTextField!
    @IBOutlet var ssnTextFeild: MyTextfeild!
    @IBOutlet var weightTextFeild: MyTextfeild!
    
    @IBOutlet var fullNameTextFeild: MyTextfeild!
    
    @IBOutlet var mobileTextFeild: FPNTextField!
    @IBOutlet var dobTextFeild: UnderlinedTextField!
    @IBOutlet var genderTextFeild: UnderlinedTextField!
    @IBOutlet var inchTextFeild: MyTextfeild!
    
    @IBOutlet weak var profileImageView: UIImageView!
    

    let imagePicker = UIImagePickerController()
    var bloodGroupData = ["A+","A-","A Unknown","B+","B-","B Unknown","AB+","AB-","AB Unknown","O+","O-","O Unknown","Unknown"]
    var genderData = ["Male","Female","Others"]
    var residenceData = ["Myself/Parent","Family Member","Care Giver","Other"]
    var idTypeData = ["Emirites Id","National ID","Others"]
    var educationData = ["High school","Graduate","Under Graduate","Post Graduate"]

    var userData:UserProfileData?
    let viewModel = ProfileViewModel()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupPicker(for: bloodGroupTextFeild, with: bloodGroupData)
        setupPicker(for: genderTextFeild, with: genderData)
        setupPicker(for: residentTypeTextFeild, with: residenceData)
        setupPicker(for: educationTextFeild, with: educationData)
        setupPicker(for: idTypeTextFeild, with: idTypeData)
        setupPicker(for: educationTextFeild, with: educationData)

        
        setUpUI()
        setupDelegates()

    }
    
    @IBAction func submitClicked(_ sender: Any) {
        if(validateForm)()
        {
            updateUserApiCall()
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        
        navigateTo(viewController: ProfileViewController.self, withIdentifier: "ProfileViewController")
    }
    @IBAction func cancelClicked(_ sender: Any) {
        navigateTo(viewController: ProfileViewController.self, withIdentifier: "ProfileViewController")
    }
    
    
    
    func setUpUI()
     {
         fullNameTextFeild.text = userData?.data?.username
         bloodGroupTextFeild.text = userData?.data?.bloodtype
         insuranceNumberTextFeild.text = userData?.data?.insurance_policy_no
         feetTextFeild.text = userData?.data?.feet
         inchTextFeild.text = userData?.data?.inch
         emailTextFeild.text = userData?.data?.email
         insuranceProviderTextFeild.text = userData?.data?.insurance_provider
         educationTextFeild.text = userData?.data?.education
         residentTypeTextFeild.text = userData?.data?.rtype
         ssnTextFeild.text = userData?.data?.ssn
         weightTextFeild.text = userData?.data?.weight
         
         mobileTextFeild.set(phoneNumber: userData?.data?.mobile ?? "")
         dobTextFeild.text = userData?.data?.dob
         genderTextFeild.text = userData?.data?.gender
         
         if(userData?.data?.profile_url != "NA")
         {
             if let imageUrl = URL(string: userData?.data?.profile_url ?? "") {
                 self.profileImageView.sd_setImage(with: imageUrl, completed: nil)
             }
         }
         else
         {
             if(userData?.data?.gender == "Male")
             {
                 self.profileImageView.image = UIImage(named: "user-male")
             }
             else
             {
                 self.profileImageView.image = UIImage(named: "user-female")
             }
         }
        // ageTextFeild.text = userData?.data?.age

     }
    
    func setupDelegates()
     {
         fullNameTextFeild.delegate = self
         bloodGroupTextFeild.text = userData?.data?.bloodtype
         insuranceNumberTextFeild.delegate = self
         feetTextFeild.delegate = self
         inchTextFeild.delegate = self
         emailTextFeild.delegate = self
         insuranceProviderTextFeild.delegate = self
         educationTextFeild.delegate = self
         residentTypeTextFeild.text = userData?.data?.rtype
         ssnTextFeild.delegate = self
         weightTextFeild.delegate = self
         mobileTextFeild.delegate = self
         dobTextFeild.delegate = self
         genderTextFeild.text = userData?.data?.gender
//         ageTextFeild.delegate = self
         imagePicker.delegate = self
         mobileTextFeild.delegate = self
     }
    
    func validateData()
    {
        if(fullNameTextFeild.text == "" || fullNameTextFeild.text == nil) {
            self.showAlert("Please enter the Full name");
        } else if(emailTextFeild.text == "" || emailTextFeild.text == nil) {
            self.showAlert("Please enter the email Id")
        } else if(!self.isValidEmail(email: emailTextFeild.text ?? "")) {
            self.showAlert("Please enter valid email Id")
        } else if(dobTextFeild.text == "" || dobTextFeild.text == nil) {
            self.showAlert("Please select the date of birth")
        } else if(genderTextFeild.text == "" || genderTextFeild.text == nil) {
            self.showAlert("Please select the gender")
        } else if(mobileTextFeild.text == "" || mobileTextFeild.text == nil) {
            self.showAlert("Please enter the mobile number")
        } else if(residentTypeTextFeild.text == "" || residentTypeTextFeild.text == nil) {
            self.showAlert("Please select residence type")
        } else if(educationTextFeild.text == "" || educationTextFeild.text == nil) {
            self.showAlert("Please enter the education details")
        }
//        else if(ssnTextFeild.text == "" || ssnTextFeild.text == nil) {
//            self.showAlert("Please enter the SSN")
//        }
        else if(feetTextFeild.text == "" || feetTextFeild.text == nil) {
            self.showAlert("Please enter the height in feet")
        }
        else if(feetTextFeild.text == "" || feetTextFeild.text == nil) {
            self.showAlert("Please enter the height in inches")
        }
        else if(weightTextFeild.text == "" || weightTextFeild.text == nil) {
            self.showAlert("Please enter the weight")
        }
        else {
            updateUserApiCall()
        }
    }
    
    func validateForm() -> Bool {
            // Full Name: Required, should be at least 2 characters and only contain alphabets and spaces
            if let fullName = fullNameTextFeild.text, fullName.isEmpty {
                showAlert("Please fill the full name field")
                return false
            } else if fullNameTextFeild.text?.count ?? 0 < 2 {
                showAlert("Full name must be at least 2 characters")
                return false
            }
            
            // Date of Birth: Required
            if let dob = dobTextFeild.text, dob.isEmpty {
                showAlert("Please fill the date of birth field")
                return false
            }
            
            // Gender: Required
            if let gender = genderTextFeild.text, gender.isEmpty {
                showAlert("Please fill the gender field")
                return false
            }
            
            // Mobile: Required, should contain exactly 10 digits
            if let mobile = mobileTextFeild.text {
                if mobile.isEmpty {
                    showAlert("Please fill the mobile number field")
                    return false
                } else if !isValidPhoneNumberWithCountryCode() {
                    showAlert("Please enter valid Phone Number")
                    return false
                }
            }
//        else if !isValidMobile(mobileTextFeild.text) {
//                print("mob \(mobileTextFeild.text)")
//                showAlert("Mobile number must be exactly 10 digits")
//                return false
//            }
            
            // SSN: Required, must be 9 digits
//            if let ssn = ssnTextFeild.text, ssn.isEmpty {
//                showAlert("Please fill the SSN field")
//                return false
//            } else
        if let ssn = ssnTextFeild.text, !ssn.isEmpty {
            if !isValidSSN(ssnTextFeild.text) {
                showAlert("Invalid SSN")
                return false
            }
        }
            
            // SSN: Required, must be 9 digits
        if let feet = feetTextFeild.text, feet.isEmpty {
                showAlert("Please fill the feet value")
                return false
            } else if !isValidFeet(feetTextFeild.text) {
                showAlert("Invalid Feet")
                return false
            }
            
            // Inch: Optional, but if filled must be numeric
        if let inch = inchTextFeild.text, inch.isEmpty
        {
                showAlert("Please fill the inch value")
                return false
            }
            
            // Weight: Optional, but if filled must be between 22 and 1400
            if let weight = weightTextFeild.text {
                    if weight.isEmpty{
                        showAlert("Please fill the Weight feild")
                    } else if !isValidWeight(weight) {
                        showAlert("Weight must be between 22 and 1400")
                        return false
                    }
                }
            
            return true
    }
    private func isValidPhoneNumberWithCountryCode() -> Bool {
        // Try to get the formatted phone number in a desired format
        let formattedNumber = mobileTextFeild.getFormattedPhoneNumber(format: .International)
        // Check if the formatted number is not nil and matches the expected pattern
        return formattedNumber != nil
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if(textField == weightTextFeild)
//        {
//            let currentText = textField.text ?? ""
//                   guard let stringRange = Range(range, in: currentText) else { return false }
//                   let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//                   
//                   // Allow deletion
//                   if string.isEmpty {
//                       return true
//                   }
//                   
//                   // Allow partial input that could lead to a valid number
//                   if let number = Int(updatedText), number >= 0 {
//                       if number >= 22 && number <= 1400 {
//                           return true
//                       } else if number < 10 && updatedText.count <= 2 {
//                           // Allow numbers less than 10 if the length is less than or equal to 2 (partial input)
//                           return true
//                       } else {
//                           showAlert("Value should be between 22 and 1400")
//                           return false
//                       }
//                   }
//                   
//                   showAlert("Invalid Weight")
//                   return false
//                   
//        }
//        else
        if(textField == feetTextFeild)
        {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // Allow deletion
            if string.isEmpty {
                return true
            }

            // Allow partial input that could lead to a valid number
            if let number = Int(updatedText), number >= 1 {
                if number >= 3 && number <= 10 {
                    return true
                } else {
                    showAlert("Value should be between 3 and 9")
                    return false
                }
            }

            showAlert("Value should be between 3 and 9")
            return false
                       
        }
        else if(textField == fullNameTextFeild)
        {
            let allowedCharacters = CharacterSet.letters.union(.whitespaces)
                let characterSet = CharacterSet(charactersIn: string)
                return allowedCharacters.isSuperset(of: characterSet)
        }
        else if(textField == ssnTextFeild)
        {
            // Check if the input string contains only numeric characters
                let allowedCharacters = CharacterSet.decimalDigits
                let characterSet = CharacterSet(charactersIn: string)
                
                // Ensure that only digits are allowed
                if !allowedCharacters.isSuperset(of: characterSet) {
                    return false
                }
                
                // Get the current text in the text field
                let currentText = textField.text ?? ""
                
                // Calculate the new length after the proposed change
                let newLength = currentText.count + string.count - range.length
                
                // Limit to a maximum of 9 digits
                return newLength <= 9
        }
        else if(textField == inchTextFeild)
        {
            // Check if the input string contains only numeric characters
                let allowedCharacters = CharacterSet.decimalDigits
                let characterSet = CharacterSet(charactersIn: string)
                
                // Ensure that only digits are allowed
                if !allowedCharacters.isSuperset(of: characterSet) {
                    return false
                }
                
                // Get the current text in the text field
                let currentText = textField.text ?? ""
                
                // Calculate the new length after the proposed change
                let newLength = currentText.count + string.count - range.length
                
                // Limit to a maximum of 9 digits
                return newLength <= 2
        }
       
        return true
       
    }
    
    func updateUserApiCall()
    {
        let phoneCode = mobileTextFeild.selectedCountry?.phoneCode ?? ""
        let mobileNumber = mobileTextFeild.text ?? ""
        let formattedMobileNumber = phoneCode + mobileNumber
        let params: [String: Any] = [
            "username": fullNameTextFeild.text ?? "",
            "dob": dobTextFeild.text ?? "",
            "gender": genderTextFeild.text ?? "",
            "mobile": formattedMobileNumber,
            "rtype": residentTypeTextFeild.text ?? "",
            "education": educationTextFeild.text ?? "",
            "ssn": ssnTextFeild.text ?? "",
            "feet": (feetTextFeild.text  == "NA" || feetTextFeild.text == "") ? nil : feetTextFeild.text,
            "inch": (inchTextFeild.text  == "0" || inchTextFeild.text == "") ? nil : inchTextFeild.text,
            "weight": (weightTextFeild.text == "NA" || weightTextFeild.text == "") ? nil : weightTextFeild.text,
            "bloodtype": bloodGroupTextFeild.text ?? "",
//            "age": ageTextFeild.text ?? ""
        ]

        
        
        print("params \(params)")
        
        viewModel.updateUserDetails(params: params)
        viewModel.profileUpdateSuccess = {
            self.showAlertWithHandler(message: self.viewModel.userUpdateRes?.message ?? "Error", okActionTitle: "Okay", enableCancel: false, okActionHandler:{_ in
                self.navigateTo(viewController: ProfileViewController.self, withIdentifier: "ProfileViewController")
            })

        }
        viewModel.loadingStatus =
        {
            print("llooadd \(self.viewModel.isLoading)")
            if self.viewModel.isLoading {
                self.activityIndicator(self.view, startAnimate: true)
            } else {
                self.activityIndicator(self.view, startAnimate: false)
            }
        }
        viewModel.errorMessageAlert = {
            self.showAlert(self.viewModel.errorMessage ?? "Error")
        }
    }

    func deleteUserImage()
    {
        viewModel.deleteProfileImage()
        viewModel.profileImageDeleteSuccess = {
            self.navigateTo(viewController: ProfileViewController.self, withIdentifier: "ProfileViewController")
        }
        viewModel.loadingStatus =
        {
            if self.viewModel.isLoading {
                self.activityIndicator(self.view, startAnimate: true)
            } else {
                self.activityIndicator(self.view, startAnimate: false)
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
        viewModel.errorMessageAlert = {
            self.showAlert(self.viewModel.errorMessage ?? "Error")
           
        }
    }

    
    // Function to upload the image as form data using Alamofire
        func uploadImageAsFile(url: String, image: UIImage, token: String, completion: @escaping (Result<Data, Error>) -> Void) {
            // Convert image to Data
            guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image conversion to Data failed."])))
                return
            }
            
            // Create headers including the authorization token
            let headers: HTTPHeaders = [
                "Authorization": token,
                "Content-Type": "multipart/form-data"
            ]
            
            // Create the multipart form data request with Alamofire
            AF.upload(multipartFormData: { multipartFormData in
                // Append image data
                multipartFormData.append(imageData, withName: "file_", fileName: "image.jpg", mimeType: "image/jpeg")
            }, to: url, headers: headers)
            .uploadProgress { progress in
                // Calculate the upload percentage
                let uploadProgress = Float(progress.completedUnitCount) / Float(progress.totalUnitCount)
                
            }
            .response { response in
                // Print the entire response
                debugPrint(response)
                
                switch response.result {
                case .success(let data):
                    if let data = data {
                                // Try to parse the response data to a dictionary
                                do {
                                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                                       let message = json["message"] as? String,
                                       let imgData = json["data"] as? [String: Any],
                                       let profileImg = imgData["profile_img"] as? String {
                                        print("Message: \(message)")
                                        print("Profile Image URL: \(profileImg)")
                                        if let imageUrl = URL(string: profileImg) {
                                            self.profileImageView.sd_setImage(with: imageUrl, completed: nil)
                                                }
                                        completion(.success(data))
                                    } else {
                                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse message or profile image from response."])))
                                    }
                                } catch {
                                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON parsing error: \(error.localizedDescription)"])))
                                }
                            } else {
                                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received."])))
                            }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

}
extension ProfileEditViewController:UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return bloodGroupData.count
        } else if pickerView.tag == 1 {
            return genderData.count
        } else if pickerView.tag == 3 {
            return residenceData.count
        } else if pickerView.tag == 4 {
            return educationData.count
        } else if pickerView.tag == 5 {
            return idTypeData.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return bloodGroupData[row]
        } else if pickerView.tag == 1 {
            return genderData[row]
        } else if pickerView.tag == 3 {
            return residenceData[row]
        } else if pickerView.tag == 4 {
            return educationData[row]
        } else if pickerView.tag == 5 {
            return idTypeData[row]
        }        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            bloodGroupTextFeild.text = bloodGroupData[row]
            bloodGroupTextFeild.resignFirstResponder() // Close
        } else if pickerView.tag == 1 {
            genderTextFeild.text = genderData[row]
            genderTextFeild.resignFirstResponder() // Close
        } else if pickerView.tag == 3 {
            residentTypeTextFeild.text = residenceData[row]
            residentTypeTextFeild.resignFirstResponder()
        }else if pickerView.tag == 4 {
            educationTextFeild.text = educationData[row]
            educationTextFeild.resignFirstResponder()
        }
        else if pickerView.tag == 5 {
            idTypeTextFeild.text = idTypeData[row]
            idTypeTextFeild.resignFirstResponder()
        }
    }
    // MARK: - Helper method to set up UIPickerView for a UITextField
    
    func setupPicker(for textField: UITextField, with data: [String]) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = textField.tag // Assign a unique tag to differentiate between pickers
        
        textField.inputView = pickerView
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        textField.inputAccessoryView = toolbar
    }
    
}
extension ProfileEditViewController:DatePickerDelegate{
    
    func selectedDate(date: String) {
        let validDate = validateDateOfBirth(dateString: date)
        if(validDate)
        {
           dobTextFeild.text = date;
        }
        else
        {
            showAlert("Sorry! Age limit should be between 18 and 120 years")
        }    }
    
    func cancelDateSelection() { }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      if textField == dobTextFeild{
        self.view.endEditing(true)
          let storyboard = UIStoryboard(name: "Main", bundle: .main)
          let popup = storyboard.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
          popup.isTimePicker = false
          popup.modalPresentationStyle = .overCurrentContext
          popup.delegate = self
          present(popup, animated: true, completion: nil)
        return false
      }else{
        return true
      }
    }
    

       // Additional delegate methods...

       // You can also handle touches on the background view to dismiss the keyboard
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           view.endEditing(true)
       }
    
    
    
}
extension ProfileEditViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBAction func openCameraButtonTapped(_ sender: UIButton) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                present(imagePicker, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
        }

        @IBAction func openGalleryButtonTapped(_ sender: UIButton) {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
        @IBAction func deleteImageButtonTapped(_ sender: UIButton) {
            self.showAlertWithHandler(message: "Are you sure to delete the image?", okActionTitle: "Okay", enableCancel: true, okActionHandler:{_ in
                self.deleteUserImage()
            })
        }

        // MARK: - UIImagePickerControllerDelegate Methods

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else {
                       return
                   }
            self.activityIndicator(self.view, startAnimate: true)

            let url = DataService.developmentBaseURL + "common" + "/upload_profile_image"

                   // Now you have the selected image, you can upload it
                   let token = UserDefaults.standard.string(forKey: "Authorization")
                   uploadImageAsFile(url: url, image: selectedImage, token: token!) { result in
                       self.activityIndicator(self.view, startAnimate: false)

                                  
                       switch result {
                       case .success(let data):
                           print("Upload successful, received data: \(data)")
                       case .failure(let error):
                           print("Upload failed with error: \(error)")
                       }
                   }
            dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
}

extension ProfileEditViewController: FPNTextFieldDelegate {
    
    // Called when the user selects a country
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print("Selected country: \(name), Dial code: \(dialCode), Code: \(code)")
    }
    
    // Called when the phone number input changes
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            // Valid phone number
            print("Phone number is valid: \(textField.getFormattedPhoneNumber(format: .E164) ?? "Invalid")")
        } else {
            // Invalid phone number
            print("Invalid phone number")
        }
    }
    
    // Optional: Format the number as the user types
    func fpnDisplayCountryList() {
        // Opens the country picker if necessary
    }
}


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
