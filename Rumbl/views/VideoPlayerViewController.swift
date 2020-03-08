//
//  VideoPlayerViewController.swift
//  Rumbl
//
//  Created by Ramesh A on 29/02/20.
//  Copyright © 2020 Ramesh A. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerViewController: UIViewController {
    
    var video: Video
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var activityIndicator: UIActivityIndicatorView?
    
    private var playerStatusObserver: NSKeyValueObservation?
    
    init(_ video: Video) {
        self.video = video
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = URL(string: video.encodeURL)
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        let deviceBounds = UIScreen.main.bounds
        let playerLayer = AVPlayerLayer(player: player!)
        playerLayer.frame = deviceBounds
        self.view.layer.addSublayer(playerLayer)
        setUpPlayerObserves()
        activityIndicator = showActivityIndicatory(view: self.view)
    }
    
    func showActivityIndicatory(view: UIView) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        spinner.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        spinner.style = UIActivityIndicatorView.Style.large
        view.addSubview(spinner)
        spinner.startAnimating()
        return spinner
    }
    
    func setUpPlayerObserves() {
        playerStatusObserver = player?.observe(\AVPlayer.currentItem?.status, options: [.new, .initial]) { [unowned self] player, _ in
            if player.status == .readyToPlay {
                DispatchQueue.main.async {
                    self.activityIndicator?.stopAnimating()
                }
            }
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(finishVideo),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pause()
    }
    
    @objc func finishVideo()
    {
        print("finishVideo")
        // Resume again
        play()
    }
    
    func play() {
        if let player = player {
            let currentItem = player.currentItem
            if currentItem?.currentTime() == currentItem?.duration {
                currentItem?.seek(to: .zero, completionHandler: nil)
            }
            if player.rate == 0
            {
                player.play()
            }
        }
    }
    
    func pause() {
        if let player = player {
            player.pause()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
