//
//  VideoListViewController.swift
//  HelloAlfred
//
//  Created by MAC on 12/4/24.
//

import UIKit
import AVFoundation



class VideoListViewController: UIViewController  {
    
    @IBOutlet weak var videoTableView: UITableView!
    var weeklyContent: [WeeklyContent?] = []
    
    var videoViewModel = VideoListViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchVideoListApiCall()
        
    }
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func setupTableView() {
        videoTableView.delegate = self
        videoTableView.dataSource = self
        videoTableView.separatorStyle = .none
        videoTableView.tableFooterView = UIView()
        videoTableView.reloadData()
    }
    
    private func fetchVideoListApiCall() {
        
        videoViewModel.fetchVideoContent()
        videoViewModel.videoContentFetchSuccess = { [weak self] in
            guard let self = self else { return }
            self.activityIndicator(view.self, startAnimate: false)
            self.setupTableView()
        }
        
        videoViewModel.loadingStatus =
        {
            if self.videoViewModel.isLoading {
                self.activityIndicator(self.view, startAnimate: true)
            } else {
                self.activityIndicator(self.view, startAnimate: false)
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
        
        videoViewModel.errorMessageAlert = {
            self.showAlert(self.videoViewModel.errorMessage ?? "Error")
           
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}


extension VideoListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoViewModel.videoContentRes?.data?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListTableViewCell", for: indexPath) as! VideoListTableViewCell
        
        let rawUrl = self.videoViewModel.videoContentRes?.data?[indexPath.row] ?? ""
        let videoId = URL(string: rawUrl)?.lastPathComponent.components(separatedBy: "?").first ?? ""
        let embedUrl = "https://www.youtube.com/embed/\(videoId)"
        let html = """
                <html>
                <head>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <style>
                    body, html { margin: 0; padding: 0; height: 100%%; background-color: black; }
                    iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: none; }
                </style>
                </head>
                <body>
                    <iframe src="\(embedUrl)" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                </body>
                </html>
                """
       // cell.videoWebView.loadHTMLString(html, baseURL: nil)
        let bundleId = Bundle.main.bundleIdentifier
        let referrer = "https://\(bundleId ?? "")".lowercased()
        let referrerUrl = URL(string: referrer)

        let destination = "https://www.youtube.com/embed/\(videoId)"
        let destinationUrl = URL(string: destination)

        var request: NSMutableURLRequest?
        if let destinationUrl {
            request = NSMutableURLRequest(url: destinationUrl)
        }
        request?.addValue(referrerUrl!.absoluteString, forHTTPHeaderField: "Referer")
        cell.videoWebView.load(request as! URLRequest)
        
//        cell.url = rawUrl
//            cell.configure(with: videoId)
        
//        let htmlString = """
//                <html>
//                    <head>
//                        <style>
//                            body, html { margin: 0; padding: 0; height: 100%; width: 100%; }
//                            iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: none; }
//                        </style>
//                    </head>
//                    <body>
//                        <iframe src=\(self.videoViewModel.videoContentRes?.data?[indexPath.row] ?? "") allowfullscreen></iframe>
//                    </body>
//                </html>
//                """
//        cell.videoWebView.loadHTMLString(htmlString, baseURL: nil)
        
//        let videoURL = self.videoViewModel.videoContentRes?.data?[indexPath.row] ?? ""
//        let htmlString = """
//                <html>
//                    <head>
//                        <style>
//                            body, html { margin: 0; padding: 0; height: 100%; width: 100%; }
//                            video { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
//                        </style>
//                    </head>
//                    <body>
//                        <video controls playsinline>
//                            <source src="\(videoURL)" type="video/mp4">
//                            Your browser does not support the video tag.
//                        </video>
//                    </body>
//                </html>
//                """
//        cell.videoWebView.loadHTMLString(htmlString, baseURL: nil)

        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

