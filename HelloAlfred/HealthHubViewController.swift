//
//  HealthHubViewController.swift
//  HelloAlfred
//
//  Created by admin on 20/03/24.
//

import UIKit

class HealthHubViewController: UIViewController {

    @IBOutlet var titleText: UILabel!
    @IBOutlet var videoCollection: UICollectionView!
    
    var videoImages = ["video1","video2"]
    override func viewDidLoad() {
        super.viewDidLoad()
        videoCollection.delegate = self
        videoCollection.dataSource = self
        titleText.attributedText = customizeInitialLetter(categoryText: titleText.text!)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func proceedClicked(_ sender: Any) {
        let defaults = UserDefaults.standard
        var array = defaults.array(forKey: "filledArray")  as? [Int] ?? [Int]()
        
        if (!array.contains(0))
        {
            array.append(0)
            defaults.set(array, forKey: "filledArray")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let popup = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
      
        popup.modalPresentationStyle = .overCurrentContext
        present(popup, animated: true, completion: nil)
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
extension HealthHubViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
        cell.thumbnailImage.image = UIImage(named: videoImages[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let popup = storyboard.instantiateViewController(withIdentifier: "VideoPlayerViewController") as! VideoPlayerViewController
      
        popup.modalPresentationStyle = .overCurrentContext
        present(popup, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var height = videoCollection.frame.size.height;
        var width = (videoCollection.frame.size.width/2)-10;
        return CGSize(width: width, height: height)
    }

    
}
