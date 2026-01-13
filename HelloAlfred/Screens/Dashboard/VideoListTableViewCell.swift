//
//  VideoListTableViewCell.swift
//  HelloAlfred
//
//  Created by MAC on 12/6/24.
//

import UIKit
import WebKit

class VideoListTableViewCell: UITableViewCell {
    
    var videoLink: String?
    //    @IBOutlet weak var videoWebView: WKWebView!
    //
    var videoWebView: WKWebView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true // Enable inline playback
        videoWebView = WKWebView(frame: CGRect(x: 24, y: 10, width: self.contentView.frame.size.width - 48, height: self.contentView.frame.size.height - 20), configuration: webConfiguration)
        videoWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        videoWebView.scrollView.isScrollEnabled = false
        videoWebView.layer.cornerRadius = 10
        videoWebView.clipsToBounds = true
        self.contentView.addSubview(videoWebView)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoWebView.loadHTMLString("", baseURL: nil) // Clear the WebView content
    }
    
    
}


//class VideoListTableViewCell: UITableViewCell {
//
//    @IBOutlet weak var thumbnailImageView: UIImageView!
//    
//    private var videoId: String?
//    var url = ""
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        setupTap()
//    }
//
//    private func setupTap() {
//        thumbnailImageView.isUserInteractionEnabled = true
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(thumbnailTapped))
//        thumbnailImageView.addGestureRecognizer(tapGesture)
//    }
//
//    func configure(with videoId: String) {
//        self.videoId = videoId
//        let urlString = "https://img.youtube.com/vi/\(videoId)/hqdefault.jpg"
//        if let url = URL(string: urlString) {
//            // Use Kingfisher, SDWebImage, or URLSession here to load image.
//            // For demo:
//            URLSession.shared.dataTask(with: url) { data, _, _ in
//                if let data = data {
//                    DispatchQueue.main.async {
//                        self.thumbnailImageView.image = UIImage(data: data)
//                    }
//                }
//            }.resume()
//        }
//    }
//
//    @objc private func thumbnailTapped() {
//        guard let videoId = videoId,
//              let url = URL(string: url) else { return }
//
//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//    }
//}
//
