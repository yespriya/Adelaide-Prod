//
//  OTPViewController.swift
//  FirstPass
//
//  Created by SkeinTechnologies on 07/09/20.
//  Copyright © 2020 SkeinTechnologies. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController,UITextFieldDelegate
{
       @IBOutlet weak var txtOTP4: UITextField!
       @IBOutlet weak var txtOTP3: UITextField!
       @IBOutlet weak var txtOTP2: UITextField!
       @IBOutlet weak var txtOTP1: UITextField!
       
    @IBOutlet var otpView2: Myview!
    @IBOutlet var otpView1: Myview!
    @IBOutlet var otpView3: Myview!
    
    @IBOutlet var otpView4: Myview!
    override func viewDidLoad() {
           
           super.viewDidLoad()
           // Do any additional setup after loading the view, typically from a nib.
           
           txtOTP1.backgroundColor = UIColor.clear
           txtOTP2.backgroundColor = UIColor.clear
           txtOTP3.backgroundColor = UIColor.clear
           txtOTP4.backgroundColor = UIColor.clear
           
           
           
           txtOTP1.delegate = self
           txtOTP2.delegate = self
           txtOTP3.delegate = self
           txtOTP4.delegate = self
           
           txtOTP1.becomeFirstResponder()
        highLightFocusedView(focusedView: otpView1)
       }
       
    @IBAction func verifyClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let popup = storyboard.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
      
        popup.modalPresentationStyle = .overCurrentContext
        present(popup, animated: true, completion: nil)
    }
    

       
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           if ((textField.text?.count)! < 1 ) && (string.count > 0) {
               if textField == txtOTP1 {
                 highLightFocusedView(focusedView: otpView2)
                   
                   
                   txtOTP2.becomeFirstResponder()
               }
               
               if textField == txtOTP2 {
                   highLightFocusedView(focusedView: otpView3)

                   txtOTP3.becomeFirstResponder()
               }
               
               if textField == txtOTP3 {
                   highLightFocusedView(focusedView: otpView4)
                   txtOTP4.becomeFirstResponder()
               }
             
               
               textField.text = string
               return false
           } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
               if textField == txtOTP2 {
                   highLightFocusedView(focusedView: otpView1)

                   txtOTP1.becomeFirstResponder()
               }
               if textField == txtOTP3 {
                   highLightFocusedView(focusedView: otpView2)

                   txtOTP2.becomeFirstResponder()
               }
               if textField == txtOTP4 {
                   highLightFocusedView(focusedView: otpView3)

                   txtOTP3.becomeFirstResponder()
               }
              
               
               textField.text = ""
               return false
           } else if (textField.text?.count)! >= 1 {
               print("laasstt");
               textField.text = string
               return false
           }
           
           return true
       }
       override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }
    
    func highLightFocusedView(focusedView:UIView)
    {
        
        if(focusedView == otpView1)
        {
            otpView1.layer.masksToBounds = false
            otpView1.borderColor = UIColor(red: 66/255, green: 157/255, blue: 173/255, alpha: 1)
            otpView1.layer.shadowColor = UIColor(red: 66/255, green: 157/255, blue: 173/255, alpha: 1).cgColor
            otpView1.layer.shadowOpacity = 0.4
            otpView1.layer.shadowOffset = CGSize.zero
            otpView1.layer.shadowRadius = 5
            otpView2.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView2.layer.shadowOpacity = 0.0
            otpView3.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView3.layer.shadowOpacity = 0.0

            otpView4.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView4.layer.shadowOpacity = 0.0


        }
        else if(focusedView == otpView2)
        {
            otpView2.layer.masksToBounds = false
            otpView2.borderColor = UIColor(red: 66/255, green: 157/255, blue: 173/255, alpha: 1)
            otpView2.layer.shadowColor = UIColor(red: 66/255, green: 157/255, blue: 173/255, alpha: 1).cgColor
            otpView2.layer.shadowOpacity = 0.4
            otpView2.layer.shadowOffset = CGSize.zero
            otpView2.layer.shadowRadius = 5
            otpView1.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView3.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView4.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            
            otpView4.layer.shadowOpacity = 0.0
            otpView3.layer.shadowOpacity = 0.0
            otpView1.layer.shadowOpacity = 0.0


        }
        else if(focusedView == otpView3)
        {
            otpView3.layer.masksToBounds = false
            otpView3.borderColor = UIColor(red: 66/255, green: 157/255, blue: 173/255, alpha: 1)
            otpView3.layer.shadowColor = UIColor(red: 66/255, green: 157/255, blue: 173/255, alpha: 1).cgColor
            otpView3.layer.shadowOpacity = 0.4
            otpView3.layer.shadowOffset = CGSize.zero
            otpView3.layer.shadowRadius = 5
            otpView1.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView2.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView4.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            
            otpView4.layer.shadowOpacity = 0.0
            otpView2.layer.shadowOpacity = 0.0
            otpView1.layer.shadowOpacity = 0.0

        }else if(focusedView == otpView4)
        {
            otpView4.layer.masksToBounds = false
            otpView4.borderColor = UIColor(red: 66/255, green: 157/255, blue: 173/255, alpha: 1)
            otpView4.layer.shadowColor = UIColor(red: 66/255, green: 157/255, blue: 173/255, alpha: 1).cgColor
            otpView4.layer.shadowOpacity = 0.4
            otpView4.layer.shadowOffset = CGSize.zero
            otpView4.layer.shadowRadius = 5
            otpView1.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView3.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView2.layer.borderColor = UIColor(red: 185/255, green: 196/255, blue: 210/255, alpha: 1).cgColor
            otpView2.layer.shadowOpacity = 0.0
            otpView3.layer.shadowOpacity = 0.0
            otpView1.layer.shadowOpacity = 0.0
        }
    }
}

