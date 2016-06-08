//
//  VideoLayer.swift
//  Looplio
//
//  Created by Dima Komar on 3/11/16.
//  Copyright © 2016 Rachel Schneebaum. All rights reserved.
//

import UIKit
import AVFoundation

class VideoLayer: UIView {
    
    var player = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    weak var periodicTimeObserver: AnyObject?
    
    var previewImage: UIImage?
    var previewImagelayer = CALayer()
    var isPaused: Bool = true
    
    var playerReady: (player: AVPlayer)->Void = {_ in }
    
    var duration: CMTime? {
        return self.player.currentItem?.duration
    }
    
    override func didMoveToWindow() {
        print("did move to view")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        inits()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        inits()
    }
    
    private func inits() {
        let rootLayer: CALayer = self.layer
        
        rootLayer.masksToBounds = true
        self.player.muted = true
        avPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.avPlayerLayer.frame = self.bounds
        rootLayer.insertSublayer(avPlayerLayer, atIndex: 0)
        

//        addObserver:self forKeyPath:@"rate" options:0 context:nil];
    }
    
    
    
    override func layoutSubviews() {
        self.avPlayerLayer.frame = self.bounds
    }
    
    func setContentAsset(asset: AVAsset) {
        let item = AVPlayerItem(asset: asset)
        player.replaceCurrentItemWithPlayerItem(item)
    }
    
    var blockSelf = self
    
    func play(completion: Float -> Void) {
        if (player.currentItem != nil) {
            player.play()
            if self.periodicTimeObserver == nil {
                self.periodicTimeObserver = self.player.addPeriodicTimeObserverForInterval(CMTime(value: 1, timescale: 1), queue: nil) { time  in
                    
                    if Float(CMTimeGetSeconds(time)) > 0.01 {
                        completion(Float(CMTimeGetSeconds(time)) + 0.07 )
                    }
                }
            }
        }
    }
    
    func pause() {
        player.pause()
    }
    
    func previewImageForLocalVideo(asset: AVAsset, timeVal: Double) -> UIImage?{
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        var time: CMTime = asset.duration
        time.value =  Int64(time.timescale) * Int64(timeVal)
        
        do {
            let imageRef = try imageGenerator.copyCGImageAtTime(time, actualTime: nil)
            self.previewImage = UIImage(CGImage: imageRef)
            return UIImage(CGImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    
    
    func rewind(time value: Float) {
        if (self.player.status == .ReadyToPlay &&
            self.player.currentItem!.status == .ReadyToPlay) {
                self.player.seekToTime(CMTime(value: CMTimeValue(value), timescale: 1))
        }
    }
    
    func stop() {
        pause()
        rewind(time: 0.0)
    }
    
}