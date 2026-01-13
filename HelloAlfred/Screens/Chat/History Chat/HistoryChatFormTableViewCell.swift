//
//  HistoryChatFormTableViewCell.swift
//  HelloAlfred
//
//  Created by admin on 03/05/24.
//

import UIKit

class HistoryChatFormTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet var dropDownTextFeild: UITextField!
    @IBOutlet var dropDownView: UIView!
    @IBOutlet var radioButtonView: UIView!
    @IBOutlet var textfeildView: UIView!
    @IBOutlet var questionsTitle: UILabel!
    @IBOutlet var option1Button: UIButton!
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var option2Button: UIButton!
    
    var radioButtonTappedHandler: (() -> Void)?
    var dropDownTappedHandler: (() -> Void)?
    var textFieldEnteredHandler: (() -> Void)?

   
    var optionsData = [""]
    var radioButtonSelectedText = ""
    var dropDownSelectedText = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        setupPicker(for: dropDownTextFeild, with: optionsData)
        // Initialization code
    }

    @IBAction func option2Clicked(_ sender: Any) 
    {
        radioButtonSelectedText = option2Button.titleLabel?.text ?? ""
        radioButtonTappedHandler?()
        option2Button.setImage(UIImage(named: "radio-selected"), for: .normal)
        option1Button.setImage(UIImage(named: "radio-unselected"), for: .normal)

    }
    @IBAction func option1Clicked(_ sender: Any) {
        radioButtonTappedHandler?()
        radioButtonSelectedText = option1Button.titleLabel?.text ?? ""
        radioButtonTappedHandler?()
        option1Button.setImage(UIImage(named: "radio-selected"), for: .normal)
        option2Button.setImage(UIImage(named: "radio-unselected"), for: .normal)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        textFieldEnteredHandler?()
        print("end")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension HistoryChatFormTableViewCell:UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return optionsData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        optionsData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dropDownSelectedText = optionsData[row]
        dropDownTextFeild.text = optionsData[row]
        dropDownTappedHandler?()
        dropDownView.resignFirstResponder()
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
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)

        textField.inputAccessoryView = toolbar
    }
    @objc func doneButtonTapped() {
        //print
        dropDownTextFeild.resignFirstResponder() // Dismiss the keyboard or picker view
    }
}
