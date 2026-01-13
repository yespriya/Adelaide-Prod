//
//  SignUpViewController.swift
//  HelloAlfred
//
//  Created by admin on 01/03/24.
//

import UIKit

class PersonalDetailsViewController: UIViewController,UIDocumentPickerDelegate {

    
    @IBOutlet var weightTextFeild: UnderlinedTextField!
    @IBOutlet var heightTextFeild: UnderlinedTextField!
    
    @IBOutlet var ageTextFeild: UnderlinedTextField!
    @IBOutlet var dobTextfeild: UnderlinedTextField!
    @IBOutlet weak var genderDropDownTextField: UITextField!
    
    let genderData = ["Male", "Female", "Others"]
    let residenceData = ["Home", "Office", "Others"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPicker(for: genderDropDownTextField, with: genderData)
        dobTextfeild.delegate = self
        ageTextFeild.delegate = self;
        heightTextFeild.delegate = self
        weightTextFeild.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func continueClicked(_ sender: Any) {
       
        if(dobTextfeild.text == "" || dobTextfeild.text == nil)
        {
            self.showAlert("Please select the date of birth")
        } else if(genderDropDownTextField.text == "" || genderDropDownTextField.text == nil)
        {
            self.showAlert("Please select the gender")
        }
        else if(ageTextFeild.text == "" || ageTextFeild.text == nil)
        {
            self.showAlert("Please enter the age")
        }else if(heightTextFeild.text == "" || heightTextFeild.text == nil)
        {
            self.showAlert("Please enter height")
        }else if(weightTextFeild.text == "" || weightTextFeild.text == nil)
        {
            self.showAlert("Please enter the weight")
        }
        else
        {
            //validation passed
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension PersonalDetailsViewController:UIPickerViewDelegate, UIPickerViewDataSource
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
extension PersonalDetailsViewController:UITextFieldDelegate,DatePickerDelegate{
    
    func selectedDate(date: String) {
        dobTextfeild.text = date;
    }
    
    func cancelDateSelection() {
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == dobTextfeild)
        {
            textField.resignFirstResponder()
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let popup = storyboard.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
            popup.isTimePicker = false
            popup.modalPresentationStyle = .overCurrentContext
            popup.delegate = self
            present(popup, animated: true, completion: nil)
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           // Dismiss the keyboard
           textField.resignFirstResponder()
           return true
       }

       // Additional delegate methods...

       // You can also handle touches on the background view to dismiss the keyboard
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           view.endEditing(true)
       }
    
    
    
}

