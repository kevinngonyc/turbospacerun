//
//  TitleScreen.swift
//  Game
//
//  Created by Ngo on 6/23/16.
//  Copyright © 2016 Kevin Ngo. All rights reserved.
//

import Foundation
import SpriteKit

class TitleScreen : SKScene {
    
    var StartBtn : UIButton!
    var ShopBtn : UIButton!
    var ShipBtn: UIButton!
    var imageView: UIImageView!
    
    let ScoreDefault = UserDefaults.standard
    
    override func didMove(to view: SKView){
        
        imageView = UIImageView(frame: CGRect(x: 0,y: 0,width: view.frame.size.width, height: view.frame.size.height));
        let image = UIImage(named: "cleanBack.png");
        imageView.image = image;
        
        self.view!.addSubview(imageView);
        
        /*
        if (ScoreDefault.valueForKey("Ships") == nil){
            Highscore = ScoreDefault.valueForKey("Highscore") as! NSInteger
        }
        */
        
        NSLog("\(view.frame.size.height)")
        //REMOVE USERDEFAULTS
        
        /*
        let ScoreDefault = NSUserDefaults()
        ScoreDefault.removeObjectForKey("Highscore")
        ScoreDefault.removeObjectForKey("PUDuration")
        ScoreDefault.removeObjectForKey("NetHealthGain")
        ScoreDefault.removeObjectForKey("ShieldHealthGain")
        ScoreDefault.removeObjectForKey("MagicBulletProbability")
        ScoreDefault.removeObjectForKey("Multiplier")
        ScoreDefault.removeObjectForKey("Currency")
        ScoreDefault.synchronize()
        */
        
        StartBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        StartBtn.center = CGPoint(x: view.frame.size.width / 2, y: (7 * view.frame.size.height) / 8)
        //StartBtn.setTitle("Start", forState: UIControlState.Normal)
       // StartBtn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        StartBtn.setImage(UIImage(named: "turboStart.png"),for:UIControlState())
        StartBtn.addTarget(self, action: #selector(TitleScreen.Start), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(StartBtn)
        
        
        ShopBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        ShopBtn.center = CGPoint(x: (4 * view.frame.size.width) / 5, y: (7 * view.frame.size.height) / 8)
        //ShopBtn.setTitle("Shop", forState: UIControlState.Normal)
        //ShopBtn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        ShopBtn.setImage(UIImage(named: "turboShop.png"),for:UIControlState())
        ShopBtn.addTarget(self, action: #selector(TitleScreen.Shop), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(ShopBtn)
        
        ShipBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        ShipBtn.center = CGPoint(x: (view.frame.size.width) / 5, y: (7 * view.frame.size.height) / 8)
        //ShipBtn.setTitle("Ships", forState: UIControlState.Normal)
       // ShipBtn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        ShipBtn.setImage(UIImage(named: "turboShip.png"),for:UIControlState())
        ShipBtn.addTarget(self, action: #selector(TitleScreen.Ship), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(ShipBtn)
    }
    
    
    func Start(){
        self.view?.presentScene(GameScene(), transition: SKTransition.crossFade(withDuration: 1.0))
        StartBtn.removeFromSuperview()
        ShipBtn.removeFromSuperview()
        ShopBtn.removeFromSuperview()
        imageView.removeFromSuperview()
    }
    
    func Shop(){
        ShopBtn.removeFromSuperview()
        //self.view?.presentScene(ShopScene())
        StartBtn.removeFromSuperview()
        ShipBtn.removeFromSuperview()
        imageView.removeFromSuperview()
    }
    func Ship(){
        ShopBtn.removeFromSuperview()
        self.view?.presentScene(ShipScene())
        StartBtn.removeFromSuperview()
        ShipBtn.removeFromSuperview()
        imageView.removeFromSuperview()
    }
 
}
