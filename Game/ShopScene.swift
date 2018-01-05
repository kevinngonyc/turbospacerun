//
//  ShopScene.swift
//  Game
//
//  Created by Ngo on 6/24/16.
//  Copyright © 2016 Kevin Ngo. All rights reserved.
//

/*
import Foundation
import SpriteKit

class ShopScene : SKScene {
    
    var Gun1 : UIButton!
    var Gun2 : UIButton!
    var Gun3 : UIButton!
    var Gun4 : UIButton!
    
    var Shield1 : UIButton!
    var Shield2 : UIButton!
    var Shield3 : UIButton!
    var Shield4 : UIButton!
    
    var Mult1 : UIButton!
    var Mult2 : UIButton!
    var Mult3 : UIButton!
    var Mult4 : UIButton!
    
    var Net1 : UIButton!
    var Net2 : UIButton!
    var Net3 : UIButton!
    var Net4 : UIButton!
    
    var PU1 : UIButton!
    var PU2 : UIButton!
    var PU3 : UIButton!
    var PU4 : UIButton!
    
    var UpgradeBtn : UIButton!
    var DowngradeBtn: UIButton!
    var MenuBtn : UIButton!
    var CurrencyLbl: UILabel!
    let CurrencyDefault = UserDefaults.standard

    let defaultNames = ["MagicBulletProbability","ShieldHealthGain","Multiplier","NetHealthGain","PUDuration"]
    let buttonNames = ["Gun1", "Gun2", "Gun3", "Gun4","Shield1", "Shield2", "Shield3", "Shield4","Mult1","Mult2","Mult3","Mult4","Net1","Net2","Net3","Net4","PU1","PU2","PU3","PU4"]
    let values = [[10,9,7,4],[2,3,4,5],[3,4,5,6],[2,3,4,5],[22, 25, 27, 30]]
    let costs = [100,300,600,1000]
    
    var imageView: UIImageView!
    
    override func didMove(to view: SKView){
        imageView = UIImageView(frame: CGRect(x: 0,y: 0,width: view.frame.size.width, height: view.frame.size.height));
        let image = UIImage(named: "upgradeScreen.png");
        imageView.image = image;
        
        self.view!.addSubview(imageView);
        
        MenuBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: 30))
        MenuBtn.center = CGPoint(x: view.frame.size.width / 2, y: (view.frame.size.height * 7) / 8)
        MenuBtn.setTitle("Menu", for: UIControlState())
        MenuBtn.setTitleColor(UIColor.darkGray, for: UIControlState())
        MenuBtn.addTarget(self, action: #selector(ShopScene.Menu), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(MenuBtn)
        
        CurrencyLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: 30))
        CurrencyLbl.center = CGPoint(x: view.frame.size.width / 2, y: (2 * view.frame.size.height) / 3)
        CurrencyLbl.text = "\(CurrencyDefault.integer(forKey: "Currency"))"
        self.view?.addSubview(CurrencyLbl)
        
        UpgradeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: 30))
        UpgradeBtn.center = CGPoint(x: view.frame.size.width - (UpgradeBtn.frame.size.width/2), y: view.frame.size.height - (UpgradeBtn.frame.size.height/2)-30)
        UpgradeBtn.setTitleColor(UIColor.darkGray, for: UIControlState())
        UpgradeBtn.addTarget(self, action: #selector(ShopScene.Upgrade), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(UpgradeBtn)
        DowngradeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: 30))
        DowngradeBtn.center = CGPoint(x: DowngradeBtn.frame.size.width/2, y: view.frame.size.height - (DowngradeBtn.frame.size.height/2))
        DowngradeBtn.setTitleColor(UIColor.darkGray, for: UIControlState())
        DowngradeBtn.addTarget(self, action: #selector(ShopScene.Downgrade), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(DowngradeBtn)
        UpgradeBtn.setTitle("Upgrade", for: UIControlState())
        DowngradeBtn.setTitle("Downgrade", for: UIControlState())
        
        Gun1 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        Gun2 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        Gun3 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        Gun4 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        Shield1 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        Shield2 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        Shield3 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        Shield4 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        Mult1 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        Mult2 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        Mult3 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        Mult4 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        Net1 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        Net2 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        Net3 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        Net4 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        PU1 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        PU2 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        PU3 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        PU4 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        
        let buttons = [Gun1, Gun2, Gun3, Gun4, Shield1, Shield2, Shield3, Shield4, Mult1, Mult2, Mult3, Mult4, Net1, Net2, Net3, Net4, PU1, PU2, PU3, PU4]
        
        var i = 0
        while (i < buttonNames.count) {
            let button: UIButton = buttons[i]
            button.tag = i
            
            let widthSpace = CGFloat((i % 4) * 2 + 1)
            let heightSpace = CGFloat(100 * (Int)(i / 4))
            
            button.center = CGPoint(x: (widthSpace * button.frame.size.width) / 2, y: heightSpace + 2 * view.frame.size.height / 9)
            button.setTitleColor(UIColor.darkGray, for: UIControlState())
            button.addTarget(self, action: #selector(ShopScene.Purchase(_:)), for: UIControlEvents.touchUpInside)
            self.view?.addSubview(button)
            
            i += 1
        }

        refresh(buttons)
    }
    
    
    
    
    
    func refresh(_ buttons : [UIButton!]){
        enableButtons(buttons)
        disableButtons(buttons)
        lockButtons(buttons)
        CurrencyLbl.text = "\(CurrencyDefault.integer(forKey: "Currency"))"
    }
    
    
    
    
    
    func Purchase(_ sender: UIButton){
        let defaul = (Int)(sender.tag / 4)
        let val = sender.tag % 4
        CurrencyDefault.setValue(values[defaul][val], forKey: defaultNames[defaul])
        CurrencyDefault.setValue(CurrencyDefault.integer(forKey: "Currency") - costs[val], forKey: "Currency")
        
        let buttons = [Gun1, Gun2, Gun3, Gun4, Shield1, Shield2, Shield3, Shield4, Mult1, Mult2, Mult3, Mult4, Net1, Net2, Net3, Net4, PU1, PU2, PU3, PU4]
        refresh(buttons)
    }
    
    
    
    
    
    func enableButtons(_ buttons : [UIButton!]){
        var i = 0
        
        while(i < buttonNames.count){
            let button = buttons[i]
            button.setTitle(buttonNames[i], for: UIControlState())
            button.backgroundColor = UIColor.white
            buttons[i].isEnabled = true
            i += 1
        }
    }
    
    
    
    
    
    func disableButton(_ button : UIButton){
        button.isEnabled = false
        button.setTitle("EXPENSIVE", for: UIControlState())
    }
    func disableButtons(_ buttons : [UIButton!]){
        var i = 0
        
        while(i < buttonNames.count){
            let val = i % 4
            let button = buttons[i]
            if(CurrencyDefault.integer(forKey: "Currency") < costs[val]){
                disableButton(button)
            }
            i += 1
        }
    }

    
    
    
    
    func lockButton(_ button: UIButton){
        button.isEnabled = false
        button.setTitle("LOCKED", for: UIControlState())
    }
    func boughtButton(_ button: UIButton){
        button.isEnabled = false
        button.backgroundColor = UIColor.blue
        button.setTitle("", for: UIControlState())
    }
    func lockButtons(_ buttons : [UIButton!]){
        var i = 0
        
        while(i < defaultNames.count){
            let button1 = buttons[i * 4]
            let button2 = buttons[i * 4 + 1]
            let button3 = buttons[i * 4 + 2]
            let button4 = buttons[i * 4 + 3]
            
            if(CurrencyDefault.integer(forKey: defaultNames[i])==values[i][3]){
                boughtButton(button1)
                boughtButton(button2)
                boughtButton(button3)
                boughtButton(button4)
            }
            if(CurrencyDefault.integer(forKey: defaultNames[i])==values[i][2]){
                boughtButton(button1)
                boughtButton(button2)
                boughtButton(button3)
            }
            if(CurrencyDefault.integer(forKey: defaultNames[i])==values[i][1]){
                boughtButton(button1)
                boughtButton(button2)
                lockButton(button4)
            }
            if(CurrencyDefault.integer(forKey: defaultNames[i])==values[i][0]){
                boughtButton(button1)
                lockButton(button3)
                lockButton(button4)
            }
            if(CurrencyDefault.value(forKey: defaultNames[i])==nil){
                lockButton(button2)
                lockButton(button3)
                lockButton(button4)
            }
            i += 1
        }
    }
    
    
    
    
    func Upgrade(){
        CurrencyDefault.setValue(CurrencyDefault.integer(forKey: "Currency") + costs[0], forKey: "Currency")
        CurrencyLbl.text = "\(CurrencyDefault.integer(forKey: "Currency"))"
        
        let buttons = [Gun1, Gun2, Gun3, Gun4, Shield1, Shield2, Shield3, Shield4, Mult1, Mult2, Mult3, Mult4, Net1, Net2, Net3, Net4, PU1, PU2, PU3, PU4]
        refresh(buttons)
    }
    func Downgrade(){
        CurrencyDefault.setValue(CurrencyDefault.integer(forKey: "Currency") - costs[0], forKey: "Currency")
        CurrencyLbl.text = "\(CurrencyDefault.integer(forKey: "Currency"))"
        
        let buttons = [Gun1, Gun2, Gun3, Gun4, Shield1, Shield2, Shield3, Shield4, Mult1, Mult2, Mult3, Mult4, Net1, Net2, Net3, Net4, PU1, PU2, PU3, PU4]
        refresh(buttons)
    }
    
    func Menu(){
        removeElements()
        self.view?.presentScene(TitleScreen())
    }
    
    func removeElements(){
        
        let buttons = [Gun1, Gun2, Gun3, Gun4, Shield1, Shield2, Shield3, Shield4, Mult1, Mult2, Mult3, Mult4, Net1, Net2, Net3, Net4, PU1, PU2, PU3, PU4]
        for button in buttons{
            button.removeFromSuperview()
        }
        
        imageView.removeFromSuperview()
        DowngradeBtn.removeFromSuperview()
        MenuBtn.removeFromSuperview()
        UpgradeBtn.removeFromSuperview()
        CurrencyLbl.removeFromSuperview()
    }
}
 */
