import UIKit
import WebKit

class WeeklyHealthDetailsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var vwCollection: UIView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    var webView: WKWebView!
    @IBOutlet var videoCollectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var leftArrowButton: UIButton!
    @IBOutlet var rightArrowButton: UIButton!
    var videoLink: String?
    var imageLink: String?
    var thumbnailLink: String?

    var indexNumber = 0

    var currentPage: Int = 0
    var autoScrollTimer: Timer?
    
    @IBOutlet var descriptionDropDown: DropDown!
    @IBOutlet weak var dropDownHeightConstraint: NSLayoutConstraint!
    var onDescriptionTapped: (() -> Void)?
    
    enum MediaType {
        case video(String)  // video link
        case image(String)  // image URL
    }
    var mediaItems: [MediaType] = [] 

    override func awakeFromNib() {
        super.awakeFromNib()
        videoCollectionView.delegate = self
        videoCollectionView.dataSource = self
        videoCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        videoCollectionView.isPagingEnabled = false
        configUI()
        
        leftArrowButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        leftArrowButton.layer.cornerRadius = 5
        leftArrowButton.clipsToBounds = true

        rightArrowButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        rightArrowButton.layer.cornerRadius = 5
        rightArrowButton.clipsToBounds = true
        
        descriptionLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDescription(_:))))


//        startAutoScroll()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        stopAutoScroll()
        stopVideo()
    }
    

    func stopVideo() {
        webView?.stopLoading()
        webView?.loadHTMLString("", baseURL: nil) // clear iframe
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        videoCollectionView.layoutIfNeeded()
        
        let totalItems = videoCollectionView.numberOfItems(inSection: 0)
        if totalItems > 0 {
            scrollToPage(page: min(currentPage, totalItems - 1), animated: false)
        }
    }
    	

	
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        videoCollectionView.layoutIfNeeded()
//        scrollToPage(page: currentPage, animated: false)
////        startAutoScroll()	
//    }

    deinit {
        stopAutoScroll()
    }
    
    @objc func handleDescription(_ sender: UITapGestureRecognizer) {
        onDescriptionTapped?()
    }
    
    func configUI() {
    
        pageControl.numberOfPages = 2
        pageControl.currentPage = currentPage
        // Removed unnecessary reload here
        DispatchQueue.main.async {
            self.scrollToPage(page: self.currentPage, animated: false)
        }
    }
    
    
    @IBAction func leftArrowClicked(_ sender: UIButton) {
        let previousPage = max(currentPage - 1, 0) // Prevent scrolling past the first item
        scrollToPage(page: previousPage, animated: true)
    }
    
    @IBAction func rightArrowClicked(_ sender: UIButton) {
        let nextPage = min(currentPage + 1, pageControl.numberOfPages - 1) // Prevent scrolling past the last item
        scrollToPage(page: nextPage, animated: true)
    }

    func startAutoScroll() {
        stopAutoScroll()
        autoScrollTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
    }

    func stopAutoScroll() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }

    @objc func scrollToNextPage() {
        let nextPage = (currentPage + 1) % pageControl.numberOfPages
        scrollToPage(page: nextPage, animated: true)
    }
//
//    func scrollToPage(page: Int, animated: Bool) {
//        let indexPath = IndexPath(item: page, section: 0)
//        guard page < videoCollectionView.numberOfItems(inSection: 0) else { return }
//        DispatchQueue.main.async {
//            self.videoCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
//            self.pageControl.currentPage = page
//            self.currentPage = page
//        }
//    }
    func scrollToPage(page: Int, animated: Bool) {
        let totalItems = videoCollectionView.numberOfItems(inSection: 0)
        guard totalItems > 0, page < totalItems else { return } // ✅ safe check
        
        let indexPath = IndexPath(item: page, section: 0)
        DispatchQueue.main.async {
//            self.videoCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
            self.pageControl.currentPage = page
            self.currentPage = page
        }
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        currentPage = Int(pageIndex)
        pageControl.currentPage = currentPage		
    }

    // MARK: - UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return mediaItems.count
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           switch mediaItems[indexPath.row] {
           case .video(let link):
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
               configureVideoCell(cell, videoLink: link, thumbnailLink: thumbnailLink ?? "")
               return cell
           case .image(let link):
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
               configureImageCell(cell, imageLink: link)
               return cell
           }
       }

       // MARK: - Video Cell
    private func configureVideoCell(_ cell: VideoCollectionViewCell, videoLink: String, thumbnailLink: String) {
        if webView == nil {
            let config = WKWebViewConfiguration()
            config.allowsInlineMediaPlayback = true
            webView = WKWebView(frame: cell.webView.bounds, configuration: config)
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cell.webView.addSubview(webView)
        }
        let videoUrlString = videoLink
        let thumbnailUrlString = thumbnailLink // Your provided thumbnail URL
        
        // We set the baseURL to the video host so the web view has context for resource loading.
        let baseUrl = URL(string: "https://imagesgaccountprod.blob.core.windows.net/")
        
        let htmlContent = """
                   <html>
                   <head>
                   <style>
                   .video-container {
                       display: flex;
                       justify-content: center;
                       align-items: center;
                       height: 100vh;
                       background-color: black;
                   }
                   video {
                       max-width: 100%;
                       height: auto;
                   }
                   </style>
                   </head>
                   <body>
                   <div class="video-container">
                   <video controls poster="\(thumbnailUrlString)">
                   <source src="\(videoUrlString)" type="video/mp4">
                   Your browser does not support the video tag.
                   </video>
                   </div>
                   </body>
                   </html>
                   """
        
        // Load the HTML string using the base URL
        webView.loadHTMLString(htmlContent, baseURL: baseUrl)
    }

       // MARK: - Image Cell
       private func configureImageCell(_ cell: ImageCollectionViewCell, imageLink: String) {
           if let url = URL(string: imageLink) {
               cell.imageView.sd_setImage(with: url)
           }
           cell.imageHeightConstraint.constant = 160
           cell.imageWidthConstraint.constant = UIScreen.main.bounds.width - 48
       }
   	

//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 2
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let isVideoCell = (indexNumber % 2 == 0) == (indexPath.row == 0)
//        if isVideoCell {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
//            configureVideoCell(cell)
//            return cell
//        } else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
//            configureImageCell(cell)
//            return cell
//        }
//    }

    // MARK: - Video Cell Configuration

    private func configureVideoCell(_ cell: VideoCollectionViewCell) {
        if webView == nil {
            let config = WKWebViewConfiguration()
            config.allowsInlineMediaPlayback = true
            
//            if #available(iOS 10.0, *) {
//                // Require user action for playback (prevents autoplay)
//                config.mediaTypesRequiringUserActionForPlayback = [.video, .audio]
//            }

            cell.layoutIfNeeded()
            webView = WKWebView(frame: cell.webView.bounds, configuration: config)
            webView.frame.size = CGSize(width: UIScreen.main.bounds.width - 48, height: 160.0)
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cell.webView.addSubview(webView)
        }

        guard let videoLink = videoLink else { return }

        let htmlString = """
        <html>
            <head>
                <style>
                    body, html { margin: 0; padding: 0; height: 100%; width: 100%; }
                    iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: none; }
                </style>
            </head>
            <body>
                <iframe src="\(videoLink)" frameborder="0"
                    allow="accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                    allowfullscreen>
                </iframe>
            </body>
        </html>
        """

        webView.loadHTMLString(htmlString, baseURL: nil)
    }

//    private func configureVideoCell(_ cell: VideoCollectionViewCell) {
//        if webView == nil {
//            webView = WKWebView(frame: cell.webView.bounds)
//            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            cell.webView.addSubview(webView)
//        }
//        let htmlString = """
//        <html>
//            <head>
//                <style>
//                    body, html { margin: 0; padding: 0; height: 100%; width: 100%; }
//                    iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: none; }
//                </style>
//            </head>
//            <body>
//                <iframe src=\(videoLink ?? "") allowfullscreen></iframe>
//            </body>
//        </html>
//        """
//        webView.loadHTMLString(htmlString, baseURL: nil)
//    }

    // MARK: - Image Cell Configuration

    private func configureImageCell(_ cell: ImageCollectionViewCell) {
        if let imageUrl = URL(string: imageLink ?? "") {
            cell.imageView.sd_setImage(with: imageUrl, completed: nil)
        }
        cell.imageHeightConstraint.constant = 160.0
        cell.imageWidthConstraint.constant = UIScreen.main.bounds.width - 48
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = 160.0
        let width = UIScreen.main.bounds.width - 48
        return CGSize(width: width, height: height)
    }
}

