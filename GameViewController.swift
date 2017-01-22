//
//  GameViewController.swift
//  Shift.
//
//  Created by Stephen Knotts on 11/22/15.
//  Copyright  ©  2016 Stephen Knotts. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

extension SKNode {
    class func unarchiveFromFile(_ file : NSString) -> SKNode? {
        if let path = Bundle.main.path(forResource: file as String, ofType: "sks") {
            let sceneData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, GADInterstitialDelegate {
    
    //properties
    var scene: GameScene!
    //ads
    @IBOutlet var bannerView: GADBannerView!
    
    /// The countdown timer.
    
    
    func showAd() {
        /*if GameScene().interstitial.isReady {
            GameScene().interstitial.presentFromRootViewController(self)
        } else {
            print("Fail Interstitial")
        }*/
        print("Interstitial..... someday")
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
          


        let scene = NewGameScene(size: view.bounds.size)

        let skView = view as! SKView
       // skView.multipleTouchEnabled = true
       // skView.showsFPS = true
       // skView.showsNodeCount = true
       // skView.showsDrawCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        

        skView.presentScene(scene)
    
        if UserDefaults.standard.bool(forKey: "purchased") != true {
            print("Ads Enabled")
            //self.bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"//test
            self.bannerView.adUnitID = "ca-app-pub-6507479540703114/4428372984"//real
            self.bannerView.rootViewController = self
            let request: GADRequest = GADRequest()
            self.bannerView.load(request)
            
            bannerView.isHidden = false
            
        }
            
        else {
            disableBanner()
        }
    }
    
    
    func disableBanner(){
        
        print("Ads Disabled")
        bannerView.isHidden = true

        
    }
  
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer!.fireDate = Date.distantFuture

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
  
   
}
    

