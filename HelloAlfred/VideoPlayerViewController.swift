import UIKit
import AVKit

class VideoPlayerViewController: UIViewController {

    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.value = 0.0
        // Load video from URL
        guard let videoURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4") else {
            print("Invalid video URL")
            return
        }
        
        // Create AVPlayer
        player = AVPlayer(url: videoURL)
        
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
        player.play()
        isPlaying = true
        playPauseButton.setTitle("Pause", for: .normal)
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
        let currentTime = player.currentTime().seconds
        let duration = player.currentItem!.duration.seconds
        slider.value = Float(currentTime / duration)
        
        let currentSeconds = Int(currentTime) % 60
        let currentMinutes = Int(currentTime) / 60
        let durationSeconds = Int(duration) % 60
        let durationMinutes = Int(duration) / 60
        
        currentTimeLabel.text = String(format: "%02d:%02d", currentMinutes, currentSeconds)
       // durationLabel.text = String(format: "%02d:%02d", durationMinutes, durationSeconds)
    }
}

