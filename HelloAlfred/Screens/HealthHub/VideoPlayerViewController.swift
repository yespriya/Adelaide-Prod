import UIKit
import WebKit
import AVKit

class VideoPlayerViewController: UIViewController {

    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
//    @IBOutlet weak var durationLabel: UILabel!
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var isPlaying = false
    var webView: WKWebView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.value = 0.0
        
        // Load video from URL
        guard let videoURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4") else {
            print("Invalid video URL")
            return
        }

        do {
            // Create AVPlayer
            //player = try AVPlayer(url: videoURL)
            let playerItem = AVPlayerItem(url: videoURL)
            player = AVPlayer(playerItem: playerItem)


            // Create AVPlayerLayer
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = videoPlayerView.bounds
            videoPlayerView.layer.addSublayer(playerLayer)

            // Add time observer to update slider and labels
            player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main) { [weak self] time in
                self?.updateSliderAndLabels()
            }

            // Start playing
            isPlaying = true
            player.play()
            playPauseButton.setTitle("Pause", for: .normal)
        } catch {
            print("Error creating AVPlayer: \(error)")
        }

    }
    
    @IBAction func closeTapped(_ sender: Any) {
        player.pause()
        dismiss(animated: true)
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        if isPlaying {
            player.pause()
            isPlaying = false
            playPauseButton.setTitle("Play", for: .normal)
        } else {
            player.play()
            isPlaying = true
            playPauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let seekTime = CMTime(seconds: Double(sender.value) * player.currentItem!.duration.seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.seek(to: seekTime)
    }
    
    func updateSliderAndLabels() {
        guard let currentItem = player.currentItem else { return }
        
        let currentTime = player.currentTime().seconds
        let duration = currentItem.duration.seconds
        
        // Check if currentTime and duration are finite numbers
        guard currentTime.isFinite && duration.isFinite else {
            // Handle the case where either currentTime or duration is infinite or NaN
            print("Error: Current time or duration is infinite or NaN")
            return
        }
        
        slider.value = Float(currentTime / duration)
        
        let currentSeconds = Int(currentTime) % 60
        let currentMinutes = Int(currentTime) / 60
        let durationSeconds = Int(duration) % 60
        let durationMinutes = Int(duration) / 60
        
        currentTimeLabel.text = String(format: "%02d:%02d", currentMinutes, currentSeconds)
    }

}


