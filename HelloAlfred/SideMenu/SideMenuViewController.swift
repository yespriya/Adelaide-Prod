
import UIKit

protocol SideMenuDelegate:class {
    func sideMenuControllerSelected(menu:SideMenuItem)
}

class SideMenuViewController: UIViewController {
    
   
    //IB outlets
    @IBOutlet weak var listView: UITableView!
    // variables
    var selectedIndexPath:IndexPath?
    // constants
    let viewModel:SideMenuViewModel = SideMenuViewModel()
    weak var delegate:SideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.delegate = self
        listView.dataSource = self
        listView.tableFooterView = MyUIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(selectedIndexPath != nil) {
            let cell:SideMenuViewCell = listView.cellForRow(at: selectedIndexPath!) as! SideMenuViewCell
            cell.configureText(selected: false)
        }
        selectedIndexPath = nil
    }
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
}
//MARK: Tableview Delegate
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sideMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SideMenuViewCell = tableView.dequeueReusableCell(withIdentifier: "SideMenuViewCellID", for: indexPath) as! SideMenuViewCell
        
        cell.titleLabel.text = (viewModel.sideMenuItems[indexPath.row]).rawValue
        cell.titleIcon.image = UIImage(named: viewModel.sideMenuIcons[indexPath.row])
        if(indexPath.row == viewModel.sideMenuItems.count - 1 || indexPath.row == viewModel.sideMenuItems.count - 2)
        {
            cell.betaView.isHidden = false
        }
        else
        {
            cell.betaView.isHidden = true
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(selectedIndexPath != nil) {
            let cell:SideMenuViewCell = tableView.cellForRow(at: selectedIndexPath!) as! SideMenuViewCell
            cell.configureText(selected: false)
        }
        selectedIndexPath = indexPath
        
        let cell:SideMenuViewCell = tableView.cellForRow(at: indexPath) as! SideMenuViewCell
        cell.configureText(selected: true)
        
        dismiss(animated: true, completion: nil)
        if let del = delegate {
            del.sideMenuControllerSelected(menu: viewModel.sideMenuItems[indexPath.row])
        }
        
    }
}

