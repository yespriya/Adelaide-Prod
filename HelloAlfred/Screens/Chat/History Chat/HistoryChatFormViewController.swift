//
//  HistoryChatFormViewController.swift
//  HelloAlfred
//
//  Created by admin on 03/05/24.
//

import UIKit
import Alamofire
import LocalAuthentication

class HistoryChatFormViewController: UIViewController {

    @IBOutlet var questionsTableView: UITableView!
    var viewModel = ChatViewModel()
    var questions : [HistoryData]?
    let stackView = UIStackView()
    let containerView = UIView()
    var usersAnswers = [QAObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionsTableView.register(UINib(nibName: "HistoryChatFormTableViewCell", bundle: .main), forCellReuseIdentifier: "HistoryChatFormTableViewCell")
        
        questionsTableView.delegate = self
        questionsTableView.dataSource = self
      //  getQuestions()
       
    }
  
    func getQuestions()
     {
         viewModel.getHistoryChatQuestions()
         viewModel.historyChatQuestionUpdatedSuccessfully =
         {
            print("success")
             self.questions = self.viewModel.historyChatData?.data
             
             if(self.questions?.count == 0)
             {
                 self.showDashboardButton()
             }
             self.questionsTableView.reloadData()
         }
        
         viewModel.errorMessageAlert = {
             self.showAlert(self.viewModel.errorMessage ?? "Error")
         }

     }
    func showDashboardButton()
    {
        
        // Create UIView with white background
           let containerView = UIView()
           containerView.backgroundColor = .white
           view.addSubview(containerView)
           
           // Create UIButton
           let button = UIButton(type: .system)
           button.setTitle("Go to Dashboard", for: .normal)
           button.setTitleColor(UIColor.white, for: .normal)
           button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 14)
           button.backgroundColor = UIColor(named: "AppTheme") // Set background color to green
           button.layer.cornerRadius = 12 // Set corner radius to 12
           button.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
           containerView.addSubview(button) // Add button to the containerView
           
           // Add constraints to position the container view and button
           containerView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor), // Pin containerView to the bottom of the parent view
               containerView.heightAnchor.constraint(equalToConstant: 80) // Adjust height as needed
           ])
           
           button.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20), // 20 points from leading edge of the containerView
               button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20), // 20 points from trailing edge of the containerView
               button.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10), // 10 points from top edge of the containerView
               button.heightAnchor.constraint(equalToConstant: 50) // Button height
           ])
    }
    @IBAction func backPressed(_ sender: Any) {
        navigateTo(viewController: DashboardViewController.self, withIdentifier: "DashboardViewController")
    }
    
    @IBAction func chatPressed(_ sender: Any) {
        navigateTo(viewController: HistoryChatViewController.self, withIdentifier: "HistoryChatViewController")
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        navigateTo(viewController: HistoryChatViewController.self, withIdentifier: "HistoryChatViewController")
    }
    func doesQuestionExist(question: String, in dataArray: [QAObject]) -> Int? {
        // Iterate over the array of QAObject
        for (index, qaObject) in dataArray.enumerated() {
            // Check if the question matches
            if qaObject.question_id == question {
                return index
            }
        }
        // Question not found
        return nil
    }
    
    func updateUserApiCall() {
  
        var usersAnswersDictionary = [String: String]()
        var answerArray = [usersAnswersDictionary]
        // Convert array to dictionary
        
        for qaObject in usersAnswers {
            usersAnswersDictionary["question_id"] = qaObject.question_id
            usersAnswersDictionary["answer"] = qaObject.answer
            answerArray.append(usersAnswersDictionary)
        }

        // Print the resulting dictionary
        answerArray.remove(at: 0)
        print(answerArray)
        
        if(answerArray.count > 0)
        {
            self.activityIndicator(self.view, startAnimate: true)

            var authToken = UserDefaults.standard.string(forKey: "Authorization")
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: answerArray)
                let url = DataService.developmentBaseURL

                // URL of your server endpoint
                let urlString = "\(url)/history_answer"
                guard let url = URL(string: urlString) else {
                    print("Invalid URL")
                    return
                }
                
                // Create URL request
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                // Add authorization header if needed
                if let authToken = authToken {
                    request.addValue(authToken, forHTTPHeaderField: "Authorization")
                }
                
                // Create URLSession
                let session = URLSession.shared
                
                let task = session.dataTask(with: request) { (data, response, error) in
                    DispatchQueue.main.async {
                        self.activityIndicator(self.view, startAnimate: false)
                    }
                    

                    if let error = error {
                        DispatchQueue.main.async {
                            self.showAlert("Error")
                        }
                        print("Error:", error)
                        return
                    }
                    
                    // Check for response
                    guard let httpResponse = response as? HTTPURLResponse else {
                        DispatchQueue.main.async {
                            self.showAlert("Invalid Response")
                        }
                        return
                    }
                    
                    // Check for successful response
                    guard (200...299).contains(httpResponse.statusCode) else {
                        print("HTTP response status code:", httpResponse.statusCode)
                        return
                    }
                    
                    // Check for data
                    guard let responseData = data else {
                        print("No data received")
                        DispatchQueue.main.async {
                            self.showAlert("No data received")
                        }
                        return
                    }
                    
                    // Print response data
                    if let responseString = String(data: responseData, encoding: .utf8) {
                        print("Response data:", responseString)
                        
                        // Perform UI-related tasks on the main thread
                        DispatchQueue.main.async {
                            self.showAlertWithHandler(message: "Answers updated successfully", okActionTitle: "Okay", enableCancel: false) { _ in
                                self.usersAnswers.removeAll()
                                self.getQuestions()
                            }
                        }
                    }
                }
                
                // Start the task
                task.resume()
            } catch {
                print("Error serializing JSON:", error)
            }
        }
        else
        {
            showAlert("PLease answer atleast any question")
        }
        

           
        }
}
extension HistoryChatFormViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions?.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var numOfSections: Int = 0
        
        
        if questions?.count ?? 0 > 0
        {
                numOfSections            = 1
                tableView.backgroundView = nil
        }
        else
        {
            if(self.viewModel.historyChatData?.message != "" && self.viewModel.historyChatData?.message != nil)
            {
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = self.viewModel.historyChatData?.message
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
            }
                
        }
        return numOfSections

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryChatFormTableViewCell") as! HistoryChatFormTableViewCell
        cell.questionsTitle.text = questions?[indexPath.row].description ?? "Question not available"
        
        if(questions?[indexPath.row].type_ == "Text" || questions?[indexPath.row].type_ == "Number")
        {
            
            cell.textfeildView.isHidden = false
            cell.radioButtonView.isHidden = true
            cell.dropDownView.isHidden = true
            
            if let index = self.doesQuestionExist(question: self.questions?[indexPath.row].question_key ?? "", in: self.usersAnswers) {
                // Update the value inside the object
                cell.textField.text = self.usersAnswers[index].answer

                print("Value updated")
            } else {
                // Add a new object to the array
                cell.textField.text = nil

            }

        }
        
        else if(questions?[indexPath.row].type_ == "Dropdown")
        {
            cell.textfeildView.isHidden = true
            cell.radioButtonView.isHidden = true
            cell.dropDownView.isHidden = false
            cell.optionsData = questions?[indexPath.row].options ?? []
            if let index = self.doesQuestionExist(question: self.questions?[indexPath.row].question_key ?? "", in: self.usersAnswers) {
                // Update the value inside the object
                cell.dropDownTextFeild.text = self.usersAnswers[index].answer
            } else {
                // Add a new object to the array
                cell.dropDownTextFeild.text = nil

            }
        }
        else
        {
            if let index = self.doesQuestionExist(question: self.questions?[indexPath.row].question_key ?? "", in: self.usersAnswers) {
                // Update the value inside the object
                if(self.usersAnswers[index].answer == cell.option1Button.titleLabel?.text)
                {
                    cell.option1Button.setImage(UIImage(named: "radio-selected"), for: .normal)
                    cell.option2Button.setImage(UIImage(named: "radio-unselected"), for: .normal)

                }
                else if (self.usersAnswers[index].answer == cell.option2Button.titleLabel?.text)
                {
                    cell.option2Button.setImage(UIImage(named: "radio-selected"), for: .normal)
                    cell.option1Button.setImage(UIImage(named: "radio-unselected"), for: .normal)

                }
                else
                {
                    cell.option1Button.setImage(UIImage(named: "radio-unselected"), for: .normal)
                    cell.option2Button.setImage(UIImage(named: "radio-unselected"), for: .normal)
                }
            } else {
                cell.option1Button.setImage(UIImage(named: "radio-unselected"), for: .normal)
                cell.option2Button.setImage(UIImage(named: "radio-unselected"), for: .normal)

            }
            
            
            cell.textfeildView.isHidden = true
            cell.radioButtonView.isHidden = false
            cell.dropDownView.isHidden = true
            cell.option1Button.setTitle(questions?[indexPath.row].options?[0] ?? "", for: .normal)
            cell.option2Button.setTitle(questions?[indexPath.row].options?[1] ?? "", for: .normal)

        }
        
        cell.radioButtonTappedHandler = {
            
            if let index = self.doesQuestionExist(question: self.questions?[indexPath.row].question_key ?? "", in: self.usersAnswers) {
                // Update the value inside the object
                self.usersAnswers[index].answer = cell.radioButtonSelectedText
                print("Value updated")
            } else {
                // Add a new object to the array
                print("Added")
                self.usersAnswers.append(QAObject(question_id: self.questions![indexPath.row].question_key!, answer: cell.radioButtonSelectedText))
            }
            
            
        }
        
        cell.dropDownTappedHandler = {
            if let index = self.doesQuestionExist(question: self.questions?[indexPath.row].question_key ?? "", in: self.usersAnswers) {
                // Update the value inside the object
                self.usersAnswers[index].answer = cell.dropDownSelectedText
                print("Value updated")
            } else {
                // Add a new object to the array
                print("Added")
                self.usersAnswers.append(QAObject(question_id: self.questions![indexPath.row].question_key!, answer: cell.dropDownSelectedText))
            }
            

           
        }
        cell.textFieldEnteredHandler = {
            if let index = self.doesQuestionExist(question: self.questions?[indexPath.row].question_key ?? "", in: self.usersAnswers) {
                // Update the value inside the object
                self.usersAnswers[index].answer = cell.textField.text ?? ""
                print("Value updated")
            } else {
                // Add a new object to the array
                print("Added")
                self.usersAnswers.append(QAObject(question_id: self.questions![indexPath.row].question_key!, answer: cell.textField.text ?? ""))
            }        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 // Provide an estimated height for smoother scrolling
    }
}


