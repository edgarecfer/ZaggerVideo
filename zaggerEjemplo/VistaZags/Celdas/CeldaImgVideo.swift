//
//  CeldaImgVideo.swift
//  zaggerEjemplo
//
//  Created by Edgar Cruz on 11/05/24.
//

import UIKit
import SDWebImage
import AVKit

protocol CeldaImgVideoDelgate: AnyObject {
    func verImgVideo(url: String)
}

class CeldaImgVideo: UICollectionViewCell {
    
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var contenedorVideo: UIView!
    @IBOutlet weak var mostrarOpcionesBtn: UIButton!
    @IBOutlet weak var expandirBtn: UIButton!
    
    @IBOutlet weak var containerColorView: UIView!
    @IBOutlet weak var containerPlayPause: UIView!
    @IBOutlet weak var viewPlayVideo: UIView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var iconIndicator: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var playerLayer = AVPlayerLayer()
    var player = AVPlayer()
    var urlString = ""
    var visibleAction = false
    weak var delegate: CeldaImgVideoDelgate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configIconIndicator()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imagen.image = UIImage(systemName: "photo.fill")
        self.contenedorVideo.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        playerLayer.removeFromSuperlayer()
    }
    
    func configImagen(url: String, esVideo: Bool) {
        if esVideo {
            contenedorVideo.isHidden = false
            containerColorView.isHidden = false
            containerPlayPause.isHidden = false
            mostrarOpcionesBtn.isEnabled = true
            expandirBtn.isHidden = false
            self.urlString = url
            videoPlay()
        } else {
            contenedorVideo.isHidden = true
            containerColorView.isHidden = true
            containerPlayPause.isHidden = true
            mostrarOpcionesBtn.isEnabled = false
            expandirBtn.isHidden = true
            self.imagen.sd_setImage(with: URL(string: url), placeholderImage: UIImage(systemName: "photo.fill"))
        }
    }
    
    func videoPlay() {
        if urlString != "" {
            let videoURL = URL(string: self.urlString)
            player = AVPlayer(url: videoURL!)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.contenedorVideo.bounds
            playerLayer.videoGravity = .resizeAspectFill
            self.contenedorVideo.layer.addSublayer(playerLayer)
            player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
            player.play()
        }
    }
    
    func stopVideo() {
        player.pause()
    }
    
    private func configIconIndicator() {
        iconIndicator.tintColor = .white
    }
    
    private func configIconLoader(HiddenIndicator: Bool) {
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        if HiddenIndicator {
            loaderView.isHidden = HiddenIndicator
            viewPlayVideo.isHidden = !HiddenIndicator
        } else {
            loaderView.isHidden = HiddenIndicator
            viewPlayVideo.isHidden = !HiddenIndicator
        }
    }
    
    private func changeIndicators(isplayin: Bool) {
        iconIndicator.image = (isplayin) ? UIImage(systemName: "pause.circle.fill") : UIImage(systemName: "play.circle.fill")
        playBtn.isHidden = (isplayin) ? true:false
        pauseBtn.isHidden = (isplayin) ? false:true
    }
    
    private func configContainerColor(ishidden: Bool) {
        self.containerColorView.isHidden = ishidden
    }
    
    private func statusAction() {
        visibleAction.toggle()
        
        self.configContainerColor(ishidden: self.visibleAction)
        self.containerPlayPause.isHidden = self.visibleAction
        self.expandirBtn.isHidden = self.visibleAction
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async {[weak self] in
                    if newStatus == .playing || newStatus == .paused {
                        if newStatus == .playing {
                            self?.changeIndicators(isplayin: true)
                            self?.statusAction()
                        } else {
                            self?.changeIndicators(isplayin: false)
                            self?.statusAction()
                        }
                        self?.configIconLoader(HiddenIndicator: true)
                    } else {
                        self?.configIconLoader(HiddenIndicator: false)
                    }
                }
            }
        }
    }

    @IBAction func tapMostrarAccion(_ sender: Any) {
        statusAction()
    }
    
    @IBAction func tapPlay(_ sender: Any) {
        if !(player.isPlaying){
            videoPlay()
        }
    }
    
    @IBAction func pauseTap(_ sender: Any) {
        if (player.isPlaying){
            stopVideo()
        }
    }
    
    @IBAction func tapExpandir(_ sender: Any) {
        delegate?.verImgVideo(url: self.urlString)
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
