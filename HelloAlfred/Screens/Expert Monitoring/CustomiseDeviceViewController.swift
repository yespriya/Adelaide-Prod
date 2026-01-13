

import UIKit
import JWTKit

class CustomiseDeviceViewController: UIViewController {
    
    @IBOutlet var healthAppsCollectionView: UICollectionView!
    
    let appImages = ["add-app","apple-health","google-health","samsung-health","welltory"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        healthAppsCollectionView.delegate = self
        healthAppsCollectionView.dataSource = self
    }
    
    
    @IBAction func connectDeviceClicked(_ sender: Any) {
        
        navigateTo(viewController: ConnectDeviceViewController.self, withIdentifier: "ConnectDeviceViewController")
    }
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true)
    }
}
extension CustomiseDeviceViewController:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HealthAppCollectionViewCell", for: indexPath) as! HealthAppCollectionViewCell
        cell.healthAppImage.image = UIImage(named: appImages[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 80)
    }
    
}
