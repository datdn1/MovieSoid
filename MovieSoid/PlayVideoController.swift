//
//  PlayVideoController.swift
//  MovieSoid
//
//  Created by datdn1 on 6/21/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class PlayVideoController: UIViewController {

    @IBOutlet weak var playerView: YTPlayerView!
    var videoId: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeInterfaceOrientationMask(restrictRotation: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        changeInterfaceOrientationMask(restrictRotation: true)
    }

    private func changeInterfaceOrientationMask(restrictRotation: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.restrictRotation = restrictRotation
    }


    private func setupPlayer() {
        let playerVars = ["autoplay" : 1]
        self.playerView.delegate = self
        self.playerView.load(withVideoId: self.videoId, playerVars: playerVars)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PlayVideoController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.playerView.cueVideo(byId: self.videoId, startSeconds: playerView.currentTime(), suggestedQuality: .highRes)
        playerView.playVideo()
    }
}


