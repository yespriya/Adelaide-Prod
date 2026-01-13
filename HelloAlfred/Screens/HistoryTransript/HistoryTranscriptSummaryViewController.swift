//
//  HistoryTranscriptSummaryViewController.swift
//  HelloAlfred
//
//  Created by admin on 30/05/24.
//

import UIKit

class HistoryTranscriptSummaryViewController: UIViewController {

    @IBOutlet var descriptionTextView: UITextView!
    
    let viewModel=HistoryTranscriptViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Define large HTML content as a string
           getHistoryTranscriptApiCall()
    }
    
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func getHistoryTranscriptApiCall()
    {
        viewModel.fetchHistoryTranscript()
        viewModel.historyTranscriptFetchSuccess = {
           print("success")
            self.loadHTMLContent(self.viewModel.historyTranscriptRes?.data?.patient_info ?? "")

        }
        viewModel.loadingStatus =
        {
            if self.viewModel.isLoading {
                self.activityIndicator(self.view, startAnimate: true)
            } else {
                self.activityIndicator(self.view, startAnimate: false)
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
        viewModel.errorMessageAlert = {
            self.showAlert(self.viewModel.errorMessage ?? "Error")
           
        }
    }
    func loadHTMLContent(_ htmlContent: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let attributedString = htmlContent.htmlToAttributedString() else { return }
            DispatchQueue.main.async {
                self.descriptionTextView.attributedText = attributedString
            }
        }
    }


    
    // MARK: - Navigation

    @IBAction func bacPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    

}
extension String {
    // A helper method to convert HTML string to NSAttributedString
    func htmlToAttributedString() -> NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
}
