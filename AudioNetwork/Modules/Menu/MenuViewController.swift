//
//  MenuViewController.swift
//  AudioNetwork
//
//  Created by Oleg on 04.06.2022.
//

import UIKit
import AVFoundation

class MenuViewController: UIViewController, StoryboardInstantiable {
    // MARK: - @IBOutlet
    @IBOutlet private weak var findSomeIntre: UIButton!
    @IBOutlet private weak var listenRandom: UIButton!
    @IBOutlet private weak var toolBar: UIToolbar!
    @IBOutlet private weak var playPause: UIBarButtonItem!
    @IBOutlet private weak var musicLabel: UILabel!
    @IBOutlet private weak var imgMusic: UIImageView!
    
    // MARK: - Properties
    static var storyboardFileName: UIStoryboard.Storyboard { .menu }
    var coordinator: MenuCoordinator?

    private var player = AVAudioPlayer()
    private var randomInt: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
    
    @IBAction private func findSomeAction(_ sender: UIButton) {
        isStartUIMusic(hidden: true)
        player.stop()
        coordinator?.pushFind()
    }
    
    @IBAction private func listenRandomAction(_ sender: UIButton) {
        randomInt = Int.random(in: 1..<11)
        getMusic(number: randomInt)
        
        playPause.image = UIImage(systemName: "pause.fill")
        isStartUIMusic(hidden: false)
    }
    
    @IBAction private func backAction(_ sender: UIBarButtonItem) {
        if randomInt != 1 {
            randomInt = randomInt - 1
            getMusic(number: randomInt)
        } else {
            randomInt = 10
            getMusic(number: randomInt)
        }
        imgMusic.isHidden = false
        playPause.image = UIImage(systemName: "pause.fill")
    }
    
    @IBAction private func nextAction(_ sender: UIBarButtonItem) {
        nextSong()
        imgMusic.isHidden = false
        playPause.image = UIImage(systemName: "pause.fill")
    }
    
    @IBAction private func pauseAction(_ sender: UIBarButtonItem) {
        if player.isPlaying {
            player.pause()
            playPause.image = UIImage(systemName: "play.fill")
            imgMusic.isHidden = true
            
        } else {
            player.play()
            playPause.image = UIImage(systemName: "pause.fill")
            imgMusic.isHidden = false
        }
    }
    
    @IBAction private func stopAction(_ sender: UIBarButtonItem) {
        isStartUIMusic(hidden: true)
        player.stop()
    }
}

extension MenuViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        nextSong()
    }
}

private extension MenuViewController {
    func setupButtons() {
        findSomeIntre.layer.cornerRadius = 7
        findSomeIntre.layer.borderWidth = 2
        findSomeIntre.layer.borderColor = UIColor.black.cgColor
        
        listenRandom.layer.cornerRadius = 7
        listenRandom.layer.borderWidth = 2
        listenRandom.layer.borderColor = UIColor.black.cgColor
    }
    
    func getMusic(number: Int) {
        var nameOfMusic = "Roads Untraveled"
        
        switch number {
        case 1: nameOfMusic = "Roads Untraveled"
        case 2: nameOfMusic = "Faded"
        case 3: nameOfMusic = "In The End"
        case 4: nameOfMusic = "Give In to Me"
        case 5: nameOfMusic = "Let her go"
        case 6: nameOfMusic = "Lose Yourself"
        case 7: nameOfMusic = "Otherside"
        case 8: nameOfMusic = "See You Again"
        case 9: nameOfMusic = "What a Wonderful World"
        case 10: nameOfMusic = "Yesterday"
        default: nameOfMusic = "Roads Untraveled"
        }
        
        setSong(nameSong: nameOfMusic)
    }
    
    func isStartUIMusic(hidden: Bool) {
        toolBar.isHidden = hidden
        musicLabel.isHidden = hidden
        imgMusic.isHidden = hidden
    }
    
    func setSong(nameSong: String) {
        musicLabel.text = nameSong
        let urlStr = Bundle.main.path(forResource: nameSong, ofType: "mp3")
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlStr = urlStr else { return }
            
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlStr))
            player.play()
            player.delegate = self
            
        } catch {
            print("music have error")
        }
    }
    
    func nextSong() {
        if randomInt != 10 {
            randomInt = randomInt + 1
            getMusic(number: randomInt)
        } else {
            randomInt = 1
            getMusic(number: randomInt)
        }
    }
}
