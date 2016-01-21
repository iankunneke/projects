//
//  GameViewController.swift
//  Kabobin
//
//  Created by ian kunneke on 8/18/15.

//
import UIKit
import SpriteKit
import GameKit
import iAd

class GameViewController: UIViewController, ADBannerViewDelegate
    {
    
    var SH = UIScreen.mainScreen().bounds.height
    let transition = SKTransition.fadeWithDuration(1)
    var UIiAd: ADBannerView = ADBannerView()
    
    override func viewWillAppear(animated: Bool)
    {
        let BV = UIiAd.bounds.height
        UIiAd.delegate = self
        UIiAd.frame = CGRectMake(0, SH + BV, 0, 0)
        self.view.addSubview(UIiAd)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        UIiAd.delegate = nil
        UIiAd.removeFromSuperview()
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!)
    {
        _ = UIiAd.bounds.height
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1) // Time it takes the animation to complete
        UIiAd.alpha = 1 // Fade in the animation
        UIView.commitAnimations()
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!)
    {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        UIiAd.alpha = 0
        UIView.commitAnimations()
    }
    
    func showBannerAd()
    {
        UIiAd.hidden = false
        let BV = UIiAd.bounds.height
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1) // Time it takes the animation to complete
        UIiAd.frame = CGRectMake(0, SH - BV, 0, 0) // End position of the animation
        UIView.commitAnimations()
    }
    
    func hideBannerAd()
    {
        UIiAd.hidden = true
        let BV = UIiAd.bounds.height
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1) // Time it takes the animation to complete
        UIiAd.frame = CGRectMake(0, SH + BV, 0, 0) // End position of the animation
        UIView.commitAnimations()
    }
    
    func authenticateLocalPlayer()
    {
        
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil)
            {
                self.presentViewController(viewController!, animated: true, completion: nil)
            }
                
            else
            {
//                println((GKLocalPlayer.localPlayer().authenticated))
            }
        }
        
    }

    func showAds()
    {
        NSNotificationCenter.defaultCenter().postNotificationName("showadsID", object: nil)
    }

    
    override func viewDidLoad()
    {
        self.UIiAd.hidden = true
        self.UIiAd.alpha = 0

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideBannerAd", name: "hideadsID", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showBannerAd", name: "showadsID", object: nil)
        
        super.viewDidLoad()
        let scene = GameStartScene(size: view.bounds.size)
        let skView = view as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)

        authenticateLocalPlayer()
        showAds()
    }

    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
}


