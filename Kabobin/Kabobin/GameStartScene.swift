//
//  GameStartScene.swift
//  Kabobin
//
//  Created by ian kunneke on 8/19/15.

//

import SpriteKit
import GameKit
import iAd
import AVFoundation
import MessageUI

class GameStartScene: SKScene, GKGameCenterControllerDelegate, ADBannerViewDelegate, MFMailComposeViewControllerDelegate
{
    let logo = SKSpriteNode(imageNamed: "Logo")
    let playButton = SKSpriteNode(imageNamed: "PlayNowButton")
    let highScoreButton = SKSpriteNode(imageNamed: "Leaderboards")
    let feedbackButton = SKSpriteNode(imageNamed: "Feedback")
    let volumeOnButton = SKSpriteNode(imageNamed: "Volume")
    let volumeOffButton = SKSpriteNode(imageNamed: "VolumeOff")
    let background = SKSpriteNode(imageNamed: "GameStartScreen")
    
    var fingerOnPlayNow = false
    var backgroundMusicPlayer: AVAudioPlayer!
    var defaults = NSUserDefaults.standardUserDefaults()
    
    func showAds()
    {
        NSNotificationCenter.defaultCenter().postNotificationName("showadsID", object: nil)
    }
    
    func playBackgroundMusic(filename: String)
    {
        let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
        if (url == nil)
        {
//            println("Could not find file: \(filename)")
            return
        }
        
        var error: NSError?
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOfURL: url!)
        } catch let error1 as NSError {
            error = error1
            backgroundMusicPlayer = nil
        }
        if backgroundMusicPlayer == nil
        {
//            println("Could not create audio player: \(error!)")
            return
        }
        else
        {
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.play()
        }
    }

    override func didMoveToView(view: SKView)
    {

        showAds()
        
        self.background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        self.addChild(background)
        
        logo.position = CGPoint(x: size.width * 0.5, y: size.height * 0.94)
        addChild(logo)
        
        playButton.position = CGPoint(x: size.width * 0.5, y: size.height * 0.47)
        addChild(playButton)
        playButton.name = "PlayNow"
        
        highScoreButton.position = CGPoint(x: size.width * 0.5, y: size.height * 0.38)
        addChild(highScoreButton)
        highScoreButton.name = "ViewHighScores"
        
        feedbackButton.position = CGPoint(x: size.width * 0.5, y: size.height * 0.29)
        addChild(feedbackButton)
        feedbackButton.name = "ComposeEmail"
        
        if defaults.boolForKey("soundOff") == false
        {
            playBackgroundMusic("kabobinTheme.mp3")
            
            addVolumeOnButton()
        }
        else
        {
            addVolumeOffButton()
        }
    }
    
    func giveFeedback()
    {
        let fvc = view?.window?.rootViewController
        if MFMailComposeViewController.canSendMail()
        {
            let email = ["info@zivit.me"]
            
            let cev = MFMailComposeViewController()
            cev.mailComposeDelegate = self
            cev.setToRecipients(email)
            cev.setSubject("Kabobin")
            
            fvc?.presentViewController(cev, animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController(title: "Email not configured", message: "Cannot send feedback.", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            fvc?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showLeader()
    {
        let vc = view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        if node.name == "PlayNow"
        {
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = .AspectFill
            
            self.view!.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontalWithDuration(1.0))
        }
        
        if node.name == "ViewHighScores"
        {
            showLeader()
        }
        
        if node.name == "ComposeEmail"
        {
            giveFeedback()
        }
        
        if node.name == "TurnSoundOff"
        {
            volumeOnButton.removeFromParent()
            addVolumeOffButton()
            backgroundMusicPlayer.stop()
            defaults.setBool(true, forKey: "soundOff")
        }
        if node.name == "TurnSoundOn"
        {
            volumeOffButton.removeFromParent()
            addVolumeOnButton()
            playBackgroundMusic("kabobinTheme.mp3")
            defaults.setBool(false, forKey: "soundOff")
        }
    }
    
    func addVolumeOffButton()
    {
        volumeOffButton.position = CGPoint(x: size.width * 0.5, y: size.height * 0.14)
        volumeOffButton.name = "TurnSoundOn"
        addChild(volumeOffButton)
    }
    
    func addVolumeOnButton()
    {
        volumeOnButton.position = CGPoint(x: size.width * 0.5, y: size.height * 0.14)
        volumeOnButton.name = "TurnSoundOff"
        addChild(volumeOnButton)
    }
}
