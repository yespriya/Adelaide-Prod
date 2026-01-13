//
//  SignUpViewController.swift
//  HelloAlfred
//
//  Created by admin on 01/03/24.


import UIKit

class SignUpViewController: UIViewController,UIDocumentPickerDelegate {

    
    @IBOutlet var ssnTextFeild: UnderlinedTextField!
    @IBOutlet var educationTextFeild: UnderlinedTextField!
    @IBOutlet var mobileTextFeild: UnderlinedTextField!
    @IBOutlet var emailTextFeild: UnderlinedTextField!
    @IBOutlet var fullNameTextFeild: UnderlinedTextField!
    @IBOutlet var dobTextfeild: UnderlinedTextField!
    @IBOutlet weak var genderDropDownTextField: UITextField!
    @IBOutlet weak var residenceDropDownTextField: UITextField!
    
    
    
    let genderData = ["Male", "Female", "Others"]
    let residenceData = ["Home", "Office", "Others"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPicker(for: genderDropDownTextField, with: genderData)
        setupPicker(for: residenceDropDownTextField, with: residenceData)
        dobTextfeild.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        if(fullNameTextFeild.text == "" || fullNameTextFeild.text == nil) {
            self.showAlert("Please enter the Full name");
        } else if(emailTextFeild.text == "" || emailTextFeild.text == nil) {
            self.showAlert("Please enter the email Id")
        } else if(!self.isValidEmail(email: emailTextFeild.text ?? "")) {
            self.showAlert("Please enter valid email Id")
        } else if(dobTextfeild.text == "" || dobTextfeild.text == nil) {
            self.showAlert("Please select the date of birth")
        } else if(genderDropDownTextField.text == "" || genderDropDownTextField.text == nil) {
            self.showAlert("Please select the gender")
        } else if(mobileTextFeild.text == "" || mobileTextFeild.text == nil) {
            self.showAlert("Please enter the mobile number")
        } else if(residenceDropDownTextField.text == "" || residenceDropDownTextField.text == nil) {
            self.showAlert("Please select residence type")
        } else if(educationTextFeild.text == "" || educationTextFeild.text == nil) {
            self.showAlert("Please enter the education details")
        } else if(ssnTextFeild.text == "" || ssnTextFeild.text == nil) {
            self.showAlert("Please enter the SSN")
        } else {
            //validation passed
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let popup = storyboard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
          
            popup.modalPresentationStyle = .overCurrentContext
            present(popup, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func selectFileButtonTapped(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    // MARK: - UIDocumentPickerDelegate
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            return
        }
        
        // Handle the selected file URL
        print("Selected file URL: \(selectedFileURL.absoluteString)")
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // Handle cancellation
        print("Document picker was cancelled")
    }
    
}
extension SignUpViewController:UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return genderData.count
        } else if pickerView.tag == 2 {
            return residenceData.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return genderData[row]
        } else if pickerView.tag == 2 {
            return residenceData[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            genderDropDownTextField.text = genderData[row]
            genderDropDownTextField.resignFirstResponder() // Close the picker
            
        } else if pickerView.tag == 2 {
            residenceDropDownTextField.text = residenceData[row]
            residenceDropDownTextField.resignFirstResponder() // Close the picker
            
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
extension SignUpViewController:UITextFieldDelegate,DatePickerDelegate{
    
    func selectedDate(date: String) {
        dobTextfeild.text = date;
    }
    
    func cancelDateSelection() {
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let popup = storyboard.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
        popup.isTimePicker = false
        popup.modalPresentationStyle = .overCurrentContext
        popup.delegate = self
        present(popup, animated: true, completion: nil)
        
    }
    
    
    
}
