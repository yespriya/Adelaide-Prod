//
//  DashboardLifeStyleViewController.swift
//  HelloAlfred
//
//  Created by admin on 11/07/24.
//

import UIKit
import SideMenu

class DashboardLifeStyleViewController: UIViewController
{
    
    @IBOutlet var riskFactorButton: Mybutton!
    @IBOutlet var afibButton: Mybutton!
    @IBOutlet var lifeStyleButton: Mybutton!
    @IBOutlet var headerView: HeaderMenuView!
    @IBOutlet var bottomView: BottomMenuView!
    @IBOutlet var videoCollectionView: UICollectionView!
    
    @IBOutlet var lifeStyleCategoriesCVHeight: NSLayoutConstraint!
    var videoImages = ["thumbnail-video1","thumbnail-video2"]
    @IBOutlet var lifeStyleCategoriesCollectionView: UICollectionView!
    
    // static data
    let lifeStyleCategories = [
        Category(name: "Meditation", unit: "Hrs", image: "lifestyle-meditation", bgColor: "8B80F8",value: "01"),
        Category(name: "Stress", unit: "Normal", image: "stress", bgColor: "AF8EFF",value: "40"),
        Category(name: "Exercise", unit: "Hrs", image: "lifestyle-exercise", bgColor: "4C5A81",value: "02"),
        Category(name: "Sleep", unit: "Hrs", image: "lifestyle-sleep", bgColor: "1AC9DD",value: "08")
    ]
    
    let riskFactorsCategories = [
        Category(name: "Blood pressure", unit: "/80", image: "lifestyle-bloodpressure", bgColor: "8B80F8",value: "130"),
        Category(name: "Blood Sugar", unit: "Normal", image: "blood-sugar", bgColor: "AF8EFF",value: "5.8"),
        Category(name: "Weight", unit: "Kgs", image: "body-weight", bgColor: "4C5A81",value: "80"),
        Category(name: "Pulse", unit: "", image: "heart_pulse", bgColor: "1AC9DD",value: "79")
    ]
    
    let afibCategories = [
        Category(name: "Pulse", unit: "", image: "heart_pulse", bgColor: "1AC9DD",value: "98"),
        Category(name: "Goal Reached", unit: "", image: "goal_reached", bgColor: "8B80F8",value: "48")
    ]
    var leftMenu: SideMenuViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
    var selectedCategory = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        lifeStyleCategoriesCollectionView.delegate = self
        lifeStyleCategoriesCollectionView.dataSource = self
        
        videoCollectionView.delegate = self
        videoCollectionView.dataSource = self
        
        bottomView.delegate = self
        headerView.delegate = self
        lifeStyleCategoriesCollectionView.register(UINib(nibName: "MedicalDetailsCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "MedicalDetailsCollectionViewCell")
        
        let categories = Categories(
            lifeStyleCategories: lifeStyleCategories,
            riskFactorsCategories: riskFactorsCategories,
            afibCategories: afibCategories
        )
    }
    
    
    // MARK: - Navigation
    
    
    @IBAction func lifeStyleClicked(_ sender: Any) {
        selectedCategoryUIchanges(category: "lifestyle")
        
    }
    @IBAction func afibClicked(_ sender: Any) {
        selectedCategoryUIchanges(category: "afib")
        
    }
    @IBAction func riskFactorsClicked(_ sender: Any) {
        selectedCategoryUIchanges(category: "riskFactor")
    }
    func selectedCategoryUIchanges(category:String) {
        let buttonInfo: [String: (UIButton, Int)] = [
            "lifestyle": (lifeStyleButton, 0),
            "afib": (afibButton, 1),
            "riskFactor": (riskFactorButton, 2)
        ]
        
        for (key, (button, index)) in buttonInfo {
            let isSelected = category == key
            button.setTitleColor(UIColor(named: isSelected ? "SelectedButtonText" : "FormHeading"), for: .normal)
            button.backgroundColor = isSelected ? UIColor(named: "SelectedButtonBG") : UIColor.clear
            if isSelected {
                selectedCategory = index
            }
        }
        reloadDataWithAnimation()
    }
    func reloadDataWithAnimation() {
        UIView.transition(with: lifeStyleCategoriesCollectionView, duration: 0.35, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let self = self else { return }
            self.lifeStyleCategoriesCollectionView.reloadData()
        }, completion: nil)
    }
    
}

extension DashboardLifeStyleViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == videoCollectionView)
        {
            videoImages.count
        }
        else
        {
            switch selectedCategory
            {
            case 0:
                lifeStyleCategories.count
            case 1:
                afibCategories.count + 1
            case 2:
                riskFactorsCategories.count
            default:
                lifeStyleCategories.count
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == videoCollectionView)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardVideoCollectionViewCell", for: indexPath) as! DashboardVideoCollectionViewCell
            cell.thumbnailImage.image = UIImage(named: videoImages[indexPath.row])
            return cell
        }
        else
        {
            
            if((selectedCategory == 1 && indexPath.row == 2))
            {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MedicalDetailsCollectionViewCell", for: indexPath) as? MedicalDetailsCollectionViewCell else {
                    return UICollectionViewCell()
                }
                return cell
            }
            else
            {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LifeStyleCategoriesCollectionViewCell", for: indexPath) as? LifeStyleCategoriesCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                switch selectedCategory
                {
                case 0:
                    cell.titleLabel.text = lifeStyleCategories[indexPath.row].name
                    cell.categoryImage.image = UIImage(named: lifeStyleCategories[indexPath.row].image)
                    cell.bgView.backgroundColor = UIColor(hex: lifeStyleCategories[indexPath.row].bgColor)
                    cell.subTitleLabel.text = lifeStyleCategories[indexPath.row].value
                    cell.subTitleUnitLabel.text = lifeStyleCategories[indexPath.row].unit
                    cell.subTitleSpaceConstraint.constant = 4
                    
                case 1:
                    cell.titleLabel.text = afibCategories[indexPath.row].name
                    cell.categoryImage.image = UIImage(named: afibCategories[indexPath.row].image)
                    cell.bgView.backgroundColor = UIColor(hex: afibCategories[indexPath.row].bgColor)
                    cell.subTitleLabel.text = afibCategories[indexPath.row].value
                    cell.subTitleUnitLabel.text = afibCategories[indexPath.row].unit
                    cell.subTitleSpaceConstraint.constant = 4
                    
                case 2:
                    cell.titleLabel.text = riskFactorsCategories[indexPath.row].name
                    cell.categoryImage.image = UIImage(named: riskFactorsCategories[indexPath.row].image)
                    cell.bgView.backgroundColor = UIColor(hex: riskFactorsCategories[indexPath.row].bgColor)
                    cell.subTitleLabel.text = riskFactorsCategories[indexPath.row].value
                    cell.subTitleUnitLabel.text = riskFactorsCategories[indexPath.row].unit
                    if(indexPath.row == 0)
                    {
                        cell.subTitleSpaceConstraint.constant = 0
                    }
                    else
                    {
                        cell.subTitleSpaceConstraint.constant = 4
                    }
                    
                default:
                    cell.titleLabel.text = lifeStyleCategories[indexPath.row].name
                    cell.categoryImage.image = UIImage(named: lifeStyleCategories[indexPath.row].image)
                    cell.bgView.backgroundColor = UIColor(hex: lifeStyleCategories[indexPath.row].bgColor)
                    cell.subTitleLabel.text = lifeStyleCategories[indexPath.row].value
                    cell.subTitleUnitLabel.text = lifeStyleCategories[indexPath.row].unit
                    cell.subTitleSpaceConstraint.constant = 4
                }
                return cell
            }
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView == videoCollectionView)
        {
            navigateTo(viewController: VideoPlayerViewController.self, withIdentifier: "VideoPlayerViewController")
        }
        
    }
    
    // Implement the sizeForItemAt method
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if(collectionView == videoCollectionView)
        {
            let height = videoCollectionView.frame.size.height;
            let width = (videoCollectionView.frame.size.width/2)-10;
            return CGSize(width: width, height: height)
        }
        else
        {
            if((selectedCategory == 1 && indexPath.row == 2))
            {
                let width = lifeStyleCategoriesCollectionView.frame.width
                return CGSize(width: width, height: 150) // Square cells
            }
            else
            {
                let width = collectionView.frame.width / 2 - 10 // Example: Two cells per row with spacing
                return CGSize(width: width, height: width + 44) // Square cells
            }
        }
        
    }
    
}


