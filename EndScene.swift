//
//  EndScene.swift
//  Game
//
//  Created by Ngo on 5/31/16.
//  Copyright © 2016 Kevin Ngo. All rights reserved.
//

import Foundation
import SpriteKit

class EndScene : SKScene {
    
    //buttons
    var RestartBtn : UIButton!
    var MenuBtn : UIButton!
    var ShopBtn: UIButton!
    
    //USERDEFAULTS
    let ScoreDefault = UserDefaults.standard
    var Highscore: Int!
    var Score: Int!
    var Currency: Int!
    var Death: String!
    
    //labels
    var ScoreLbl: UILabel!
    var HighScoreLbl: UILabel!
    var CurrencyLbl: UILabel!
    var DeathLbl: UILabel!
    
    
    
    override func didMove(to view: SKView){
        scene?.backgroundColor = UIColor.white
        
        //Buttons
        RestartBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: 30))
        RestartBtn.center = CGPoint(x: view.frame.size.width / 2, y: (5 * view.frame.size.height) / 8)
        RestartBtn.setTitle("Restart", for: UIControlState())
        RestartBtn.setTitleColor(UIColor.darkGray, for: UIControlState())
        RestartBtn.addTarget(self, action: #selector(EndScene.Restart), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(RestartBtn)
        
        MenuBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: 30))
        MenuBtn.center = CGPoint(x:  view.frame.size.width / 4, y: (5 * view.frame.size.height) / 8)
        MenuBtn.setTitle("Menu", for: UIControlState())
        MenuBtn.setTitleColor(UIColor.darkGray, for: UIControlState())
        MenuBtn.addTarget(self, action: #selector(EndScene.Menu), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(MenuBtn)
        
        ShopBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: 30))
        ShopBtn.center = CGPoint(x: (3 * view.frame.size.width) / 4, y: (5 * view.frame.size.height) / 8)
        ShopBtn.setTitle("Shop", for: UIControlState())
        ShopBtn.setTitleColor(UIColor.darkGray, for: UIControlState())
        ShopBtn.addTarget(self, action: #selector(EndScene.Shop), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(ShopBtn)
        
        //Get values from USERDEFAULTS
        Score = ScoreDefault.integer(forKey: "Score")
        Highscore = ScoreDefault.integer(forKey: "Highscore")
        Currency = ScoreDefault.integer(forKey: "Currency")
        Death = ScoreDefault.value(forKey: "Death") as! String
        
        //Labels
        ScoreLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: 30))
        ScoreLbl.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.width / 3)
        ScoreLbl.text = "\(Score)"
        self.view?.addSubview(ScoreLbl)
        
        CurrencyLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: 30))
        CurrencyLbl.center = CGPoint(x: view.frame.size.width / 2, y: (2 * view.frame.size.height) / 3)
        CurrencyLbl.text = "\(Currency)"
        self.view?.addSubview(CurrencyLbl)
        
        HighScoreLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: 30))
        HighScoreLbl.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.width / 2)
        HighScoreLbl.text = "\(Highscore)"
        self.view?.addSubview(HighScoreLbl)
        
        DeathLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 2, height: 30))
        DeathLbl.center = CGPoint(x: view.frame.size.width / 2, y: (3 * view.frame.size.width) / 4)
        DeathLbl.text = "\(Death)"
        self.view?.addSubview(DeathLbl)
    }
    
    func Restart(){
        removeElements()
        self.view?.presentScene(GameScene(), transition: SKTransition.crossFade(withDuration: 1.0))
    }
    
    func Menu(){
        removeElements()
        self.view?.presentScene(TitleScreen())
    }
    
    func Shop(){
        removeElements()
        //fg667self.view?.presentScene(ShopScene())
    }
    
    func removeElements(){
        ScoreLbl.removeFromSuperview()
        ShopBtn.removeFromSuperview()
        CurrencyLbl.removeFromSuperview()
        HighScoreLbl.removeFromSuperview()
        RestartBtn.removeFromSuperview()
        MenuBtn.removeFromSuperview()
        DeathLbl.removeFromSuperview()
    }
    
}
