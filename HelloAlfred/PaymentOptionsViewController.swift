//
//  PaymentOptionsViewController.swift
//  FirstPass
//
//  Created by Skeintech on 22/06/21.
//  Copyright © 2021 Sathishkumar Muthukumar. All rights reserved.
//

import UIKit

class PaymentOptionsViewController: UIViewController 
{

    @IBOutlet var achRadioButton: UIButton!
    @IBOutlet var cardsTableView: UITableView!
    var cardDetails = [CardDetailsView(cardNumber: "Citi Bank", bankName: "****4329", bankLogo: "citibank"),CardDetailsView(cardNumber: "HSBC Bank", bankName: "****1224", bankLogo: "hsbc")]
    var selectedCardIndex = -1;
    override func viewDidLoad() {
        super.viewDidLoad()
       
        cardsTableView.delegate = self
        cardsTableView.dataSource = self
        
        // Do any additional setup after loading the view.
        cardsTableView.register(UINib(nibName: "CardsTableViewCell", bundle: .main), forCellReuseIdentifier: "CardsTableViewCell")
    }
    @IBAction func achClicked(_ sender: Any) 
    {
        selectedCardIndex = 3;
        achRadioButton.setImage(UIImage(named: "radio-selected"), for: .normal)
        cardsTableView.reloadData();
    }
    
    @IBAction func downArrowClicked(_ sender: Any) 
    {
        dismiss(animated: true)
    }
    
    @IBAction func ContinueClicked(_ sender: Any) 
    {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let popup = storyboard.instantiateViewController(withIdentifier: "SubscriptionSuccessViewController") as! SubscriptionSuccessViewController
      
        popup.modalPresentationStyle = .overCurrentContext
        present(popup, animated: true, completion: nil)
    }
    
}

extension PaymentOptionsViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return cardDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardsTableViewCell") as! CardsTableViewCell
        cell.cardnumberLabel.text = cardDetails[indexPath.row].cardNumber
        cell.bankNameLabel.text = cardDetails[indexPath.row].bankName
        cell.bankImage.image = UIImage(named: cardDetails[indexPath.row].bankLogo)
        
        if(selectedCardIndex == indexPath.row)
        {
            cell.radioImage.image = UIImage(named: "radio-selected")
        }
        else
        {
            cell.radioImage.image = UIImage(named: "radio-unselected")
        }
        cell.cardSelectionButtonTappedHandler = {
            self.selectedCardIndex = indexPath.row
            self.achRadioButton.setImage(UIImage(named: "radio-unselected"), for: .normal)
            self.cardsTableView.reloadData();
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat 
    {
        return 53
    }
}
struct CardDetailsView
{
    let cardNumber:String;
    let bankName:String
    let bankLogo:String
}
