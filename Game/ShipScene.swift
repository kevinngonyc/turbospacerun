//
//  ShipScene.swift
//  Game
//
//  Created by Ngo on 7/16/16.
//  Copyright © 2016 Kevin Ngo. All rights reserved.
//

import Foundation
import SpriteKit

class ShipScene : SKScene {
    
    var temp : UILabel!
    var MenuBtn :UIButton!

    
    /*
    var Ship1 : UIButton!
    var Ship2 : UIButton!
    var Ship3 : UIButton!
    var Ship4 : UIButton!
    var Ship5 : UIButton!
    var Ship6 : UIButton!
    var Ship7 : UIButton!
    var Ship8 : UIButton!
    var Ship9 : UIButton!
    var Ship10 : UIButton!
    var Ship11 : UIButton!
    var Ship12 : UIButton!
    var Ship13 : UIButton!
    var Ship14 : UIButton!
    var Ship15 : UIButton!
    var Ship16 : UIButton!
    var Ship17 : UIButton!
    var Ship18 : UIButton!
    var Ship19 : UIButton!
    var Ship20 : UIButton!
    var Ship21 : UIButton!
    var Ship22 : UIButton!
    var Ship23 : UIButton!
    var Ship24 : UIButton!
    
    let ScoreDefault = NSUserDefaults.standardUserDefaults()
    var values = [Int](count: 24, repeatedValue: 0)
    */
     
    override func didMove(to view: SKView){
        self.scene?.backgroundColor = UIColor.white
        temp = UILabel(frame: CGRect(x: view.frame.size.width/4, y: view.frame.size.width/4, width: 200, height: 200))
        temp.text = "COMING SOON"
        self.view?.addSubview(temp)
        
        MenuBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: 30))
        MenuBtn.center = CGPoint(x:  view.frame.size.width / 4, y: (5 * view.frame.size.height) / 8)
        MenuBtn.setTitle("Menu", for: UIControlState())
        MenuBtn.setTitleColor(UIColor.darkGray, for: UIControlState())
        MenuBtn.addTarget(self, action: #selector(ShipScene.Menu), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(MenuBtn)

        /*
        let dimensions = CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: view.frame.size.width/4)
        
        Ship1 = UIButton(frame: dimensions)
        Ship2 = UIButton(frame: dimensions)
        Ship3 = UIButton(frame: dimensions)
        Ship4 = UIButton(frame: dimensions)
        Ship5 = UIButton(frame: dimensions)
        Ship6 = UIButton(frame: dimensions)
        Ship7 = UIButton(frame: dimensions)
        Ship8 = UIButton(frame: dimensions)
        Ship9 = UIButton(frame: dimensions)
        Ship10 = UIButton(frame: dimensions)
        Ship11 = UIButton(frame: dimensions)
        Ship12 = UIButton(frame: dimensions)
        Ship13 = UIButton(frame: dimensions)
        Ship14 = UIButton(frame: dimensions)
        Ship15 = UIButton(frame: dimensions)
        Ship16 = UIButton(frame: dimensions)
        Ship17 = UIButton(frame: dimensions)
        Ship18 = UIButton(frame: dimensions)
        Ship19 = UIButton(frame: dimensions)
        Ship20 = UIButton(frame: dimensions)
        Ship21 = UIButton(frame: dimensions)
        Ship22 = UIButton(frame: dimensions)
        Ship23 = UIButton(frame: dimensions)
        Ship24 = UIButton(frame: dimensions)
        
        let buttons = [Ship1,Ship2,Ship3,Ship4,Ship5,Ship6,Ship7,Ship8,Ship9,Ship10,Ship11,Ship12,Ship13,Ship14,Ship15,Ship16,Ship17,Ship18,Ship19,Ship20,Ship21,Ship22,Ship23,Ship24]
        
        var i = 0
        while (i < buttons.count) {
            let button: UIButton = buttons[i]
            button.tag = i
            
            let widthSpace = CGFloat((i % 4) * 2 + 1)
            let heightSpace = CGFloat(60 * (Int)(i / 4))
            
            button.center = CGPoint(x: (widthSpace * button.frame.size.width) / 2, y: heightSpace + view.frame.size.height / 10)
            button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
            button.backgroundColor = UIColor.greenColor()
            button.addTarget(self, action: #selector(ShipScene.Select(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.view?.addSubview(button)
            
            i += 1
        }
    }
    
    func Select(sender: UIButton){
        let defaul = (Int)(sender.tag / 4)
        let val = sender.tag % 4
        
        ScoreDefault.setValue(sender.tag)
        
        CurrencyDefault.setValue(values[defaul][val], forKey: defaultNames[defaul])
        CurrencyDefault.setValue(CurrencyDefault.integerForKey("Currency") - costs[val], forKey: "Currency")
        
        let buttons = [Gun1, Gun2, Gun3, Gun4, Shield1, Shield2, Shield3, Shield4, Mult1, Mult2, Mult3, Mult4, Net1, Net2, Net3, Net4, PU1, PU2, PU3, PU4]
        refresh(buttons)
    }
    */
}
    func Menu(){
        temp.removeFromSuperview()
        MenuBtn.removeFromSuperview()
        self.view?.presentScene(TitleScreen())
    }
}
