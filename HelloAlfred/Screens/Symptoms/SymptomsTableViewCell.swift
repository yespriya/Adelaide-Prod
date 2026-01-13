
import UIKit

class SymptomsTableViewCell: UITableViewCell 
{

    @IBOutlet var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet var alwaysLabel: UILabel!
    @IBOutlet var ocassionallyLabel: UILabel!
    @IBOutlet var neverLabel: UILabel!
    @IBOutlet var noButton: UIButton!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var oftenLabel: UILabel!
    @IBOutlet var alwaysButton: Mybutton!
    @IBOutlet var oftenButton: Mybutton!
    @IBOutlet var ocassionallyButton: Mybutton!
    @IBOutlet var neverButton: Mybutton!
    @IBOutlet var dropDownButton: UIButton!
    @IBOutlet var bgView: Myview!
    @IBOutlet var symptomTitle: UILabel!
    var sliderValueChanged: ((Float) -> Void)?
    var dropDownButtonTappedHandler: (() -> Void)?
    var frequencyButtonTappedHandler: (() -> Void)?
  
    var EQLButtonTappedHandler: (() -> Void)?


    var selectedFrequencyValue = String()
    var EQLValue = Bool()



    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.shadowRadius = 5
        bgView.layer.shadowOpacity = 0.4
        bgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bgView.layer.shadowColor = UIColor.gray.cgColor
        bgView.layer.cornerRadius = 12
        bgView.layer.masksToBounds = false
        
    }
    @IBAction func noButtonPressed(_ sender: Any) {
        EQLValue = false
        EQLButtonTappedHandler?()
        noButton.setImage(UIImage(named: "radio-selected"), for: .normal)
        yesButton.setImage(UIImage(named: "radio-unselected"), for: .normal)

    }
    @IBAction func yesButtonPressed(_ sender: Any) {
        EQLValue = true
        EQLButtonTappedHandler?()
        yesButton.setImage(UIImage(named: "radio-selected"), for: .normal)
        noButton.setImage(UIImage(named: "radio-unselected"), for: .normal)
    }
   

    @IBAction func oftenClicked(_ sender: Any) {
        selectedFrequencyValue = "Often"
        frequencyButtonTappedHandler?()
        oftenButton.layer.borderColor = UIColor(named: "ButtonBorder1")?.cgColor
        oftenLabel.textColor = UIColor(named: "ButtonBorder1")
        
        alwaysButton.layer.borderColor = UIColor(named: "ButtonBorder")?.cgColor
        alwaysLabel.textColor = UIColor(named: "ButtonBorder")

        neverButton.layer.borderColor = UIColor(named: "ButtonBorder")?.cgColor
        neverLabel.textColor = UIColor(named: "ButtonBorder")

        ocassionallyButton.layer.borderColor = UIColor(named: "ButtonBorder")?.cgColor
        ocassionallyLabel.textColor = UIColor(named: "ButtonBorder")
    }
    @IBAction func neverClicked(_ sender: Any) {
        selectedFrequencyValue = "Never"
        frequencyButtonTappedHandler?()
        oftenButton.layer.borderColor = UIColor(named: "ButtonBorder")?.cgColor
        oftenLabel.textColor = UIColor(named: "ButtonBorder")
        
        alwaysButton.layer.borderColor = UIColor(named: "ButtonBorder")?.cgColor
        alwaysLabel.textColor = UIColor(named: "ButtonBorder")

        neverButton.layer.borderColor = UIColor(named: "ButtonBorder1")?.cgColor
        neverLabel.textColor = UIColor(named: "ButtonBorder1")

        ocassionallyButton.layer.borderColor = UIColor(named: "ButtonBorder")?.cgColor
        ocassionallyLabel.textColor = UIColor(named: "ButtonBorder")
    }
    @IBAction func ocassionallyClicked(_ sender: Any) {
        selectedFrequencyValue = "Occassionally"
        frequencyButtonTappedHandler?()
        oftenButton.layer.borderColor = UIColor(named: "ButtonBorder")?.cgColor
        oftenLabel.textColor = UIColor(named: "ButtonBorder")
        
        alwaysButton.layer.borderColor = UIColor(named: "ButtonBorder")?.cgColor
        alwaysLabel.textColor = UIColor(named: "ButtonBorder")

        neverButton.layer.borderColor = UIColor(named: "ButtonBorder")?.cgColor
        neverLabel.textColor = UIColor(named: "ButtonBorder")

        ocassionallyButton.layer.borderColor = UIColor(named: "ButtonBorder1")?.cgColor
        ocassionallyLabel.textColor = UIColor(named: "ButtonBorder1")
    }
    @IBAction func alwaysClicked(_ sender: Any) {
        selectedFrequencyValue = "Always"
        frequencyButtonTappedHandler?()
        oftenButton.layer.borderColor = UIColor(named: "ButtonBorder")?.cgColor
        oftenLabel.textColor = UIColor(named: "ButtonBorder")
        
        alwaysButton.layer.borderColor = UIColor(named: "ButtonBorder1")?.cgColor
        alwaysLabel.textColor = UIColor(named: "ButtonBorder1")

        neverButton.layer.borderColor = UIColor(named: "ButtonBorder")?.cgColor
        neverLabel.textColor = UIColor(named: "ButtonBorder")

        ocassionallyButton.layer.borderColor = UIColor(named: "ButtonBorder")?.cgColor
        ocassionallyLabel.textColor = UIColor(named: "ButtonBorder")
    }
    
    @IBAction func dropDownClicked(_ sender: Any) {
        dropDownButtonTappedHandler?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        sliderValueChanged?(sender.value)
    }
    
}
