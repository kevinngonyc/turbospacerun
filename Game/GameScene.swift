//
//  GameScene.swift
//  Game
//
//  Created by Ngo on 5/31/16.
//  Copyright (c) 2016 Kevin Ngo. All rights reserved.
//

/*
IDEAS

resize everything based on device

stages based on score (background changes and everything) --> different collectibles at each stage

currency can be the health

leveling up system? this might be too much

ship upgrades
maybe most of them can be skins, but you can get a rare powered up ship (maybe special cosmetic powers like rainbow tail and stuff)
 4 purely cosmetic
 
--slower game speed (slower max speed)
--faster game speed (starts out faster)
--extra health
--longer ghost timer
--increase frequency of ships
--increase health from pickups
--increase points from jumping
--increase points from running
--start out with shield
--start out at stage 2
--health worth more currency (double or somethin)
--increase health from gun
--increase points from gun
--two shields
--+1 multiplier

SUPER SPECIAL (tap with a second finger to activate their powers)
--explode destroy everything on screen (once (or more) per game)
--collect everything on screen (once per game)
--skip current stage (once per game)
--go back to beginning with current score (once per game)

upgrade power ups
--longer duration for all
--net gains extra health
--extra shields/extra health
--quicker laser/more points
--higher multiplier

**final**
--longer duration for all
--net gains extra health
--shield gains extra health
--increase magicbulletprobability
--higher multiplier
 
 OPTIONS
 Move bar to other side
 turn off music
 
*/




/*
BUGS

Sometimes if the player has a gun and he collides with the enemy it crashes this is because three things are colliding at once
^^ I might change this to a laser beam to make things more simple <---- fixed?? not fixed lazer beam might work. Hold it for like 1 seconds maybe?

Caution you cannot have two powerups aat once

The player tilts to the side if you hit the powerup at an angle
this doesnt happen too much <--- fixedd?

gun seems to be spawning more often than shield

change spawning points so that they dont fall off screen
*/


/*

 CHANGES
 
 HealthTimer does not sapwn at right place when you resume
 change health so that it is a simple random number instead of all of that convoluted bs
 pause when you close the app
 need to wait some time before resuming
 
 make sure second tap does not trigger jump
 
*/


import SpriteKit

//physics
struct PhysicsCategory {
    static let Enemy : UInt32 = 1
    static let Bullet : UInt32 = 2
    static let Player : UInt32 = 3
    static let Ghost: UInt32 = 4
    static let Health: UInt32 = 5
    static let Gun: UInt32 = 6                  //powerup
    static let Shield: UInt32 = 7               //powerup
    static let Multiplier: UInt32 = 8           //powerup
    static let Net: UInt32 = 9                  //powerup
    static let Protect: UInt32 = 10             //actual shield
    static let Catch: UInt32 = 11               //actual net
    static let MagicBullet: UInt32 = 12
}





class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //constants
    var maxPU = 20 //22, 25, 27, 30
    var magicBulletProb = 11 //10,9,7,4
    var multiplierMax = 2
    var shieldHealth = 1
    var netHealth = 1
    
    
    //Score, Highscore, Currency, Death, PUDuration, NetHealthGain, ShieldHealthGain, MagicBulletProbability, Multiplier
    let ScoreDefault = UserDefaults.standard

    
    //variables
    let timeInterval : CFTimeInterval = 0.1                 //how fast update
    var GameSpeed = 1.0                                     //how fast things come down and how fast things spawn
    var HealthSpeed = 1.0                                   //how fast health comes down (speeds up as game progresses along with GameSpeed)
    var multiplier = 1                                      //initially one, but with multiplier it increases
    var HealthRand = (Int)(arc4random_uniform(5) + 3)       //initial value for randomized health spawns
    var healthCount = 0                                     //used to randomize health spawns (healthcount % HealthRand) and to keep them in between the enemies
    let maxHealth = 400                                     //max health
    var health = 400                                        //total health
    var Currency = 0                                        //how much health is collected
    var Highscore = 0                                       //highscore
    var Score = 0                                           //score
    var PUCount = 0                                         //count to keep track of PowerUp duration
    var GhostCount = 0                                      //count to keep track of Ghost duration
    var stage = 1
    
    var Player = SKSpriteNode(imageNamed: "galaga.png")     //Player
    let Shield = SKSpriteNode(imageNamed: "bullet.png")     //Shield
    let Net = SKSpriteNode(imageNamed: "bullet.png")        //Net
    let Mult = SKSpriteNode(imageNamed: "galaga.png")       //Multiplier --> Change this so that it can be for all of the power ups
    
    var healthBar = SKShapeNode()                           //health bar
    var ScoreLbl = UILabel()                                //display score
    var CurrencyLbl = UILabel()                             //display currency
    
    var GunTimer = Timer()                                //shoot bullets
    var CDTimer = Timer()                                 //Ghost
    var PUTimer = Timer()                                 //PowerUp run out
    var ScoreTimer = Timer()                              //increase score
    var EnemyTimer = Timer()
    var PUSpawnTimer = Timer()
    var HealthTimer = Timer()
    
    var PUTrue = Bool()
    var GunTrue = Bool()                                    //if gun power up is active
    var ShieldTrue = Bool()                                 //if shield power up is active
    var didTouch = Bool()                                   //if touched the player, can move it
    var didPause = Bool()                                   //checks if is paused
    
    var resume = UIButton()
    var pause = UIButton()
    var start = SKShapeNode()
    
    var enemyRemaining = Double()
    var PURemaining = Double()
    //var healthRemaining = Double()
    var PUTimeRemaining = Double()
    var startOpacity = CGFloat(1.0)
    var jumpLbl = UILabel()
    
    var background = SKSpriteNode(imageNamed: "grid.jpg")
    
    //view
    override func didMove(to view: SKView) {
        
        //Establish view
        physicsWorld.contactDelegate = self
        self.scene?.size = CGSize(width: view.frame.size.width, height:view.frame.size.height)
        
        
        background.size = CGSize(width: view.frame.size.width, height:view.frame.size.height)
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.zPosition = -50
        addChild(background)
        
        
        self.view?.isMultipleTouchEnabled = false
        
        //USERDEFAULTS
        if (ScoreDefault.value(forKey: "Highscore") != nil){
            Highscore = ScoreDefault.value(forKey: "Highscore") as! NSInteger
        }
        if (ScoreDefault.value(forKey: "PUDuration") != nil){
            maxPU = ScoreDefault.value(forKey: "PUDuration") as! NSInteger
        }
        if (ScoreDefault.value(forKey: "NetHealthGain") != nil){
            netHealth = ScoreDefault.value(forKey: "NetHealthGain") as! NSInteger
        }
        if (ScoreDefault.value(forKey: "ShieldHealthGain") != nil){
            shieldHealth = ScoreDefault.value(forKey: "ShieldHealthGain") as! NSInteger
        }
        if (ScoreDefault.value(forKey: "MagicBulletProbability") != nil){
            magicBulletProb = ScoreDefault.value(forKey: "MagicBulletProbability") as! NSInteger
        }
        if (ScoreDefault.value(forKey: "Multiplier") != nil){
            multiplierMax = ScoreDefault.value(forKey: "Multiplier") as! NSInteger
        }
        
        //Add Labels
        ScoreLbl.text = "\(Score)"
        ScoreLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        ScoreLbl.backgroundColor = UIColor(colorLiteralRed: 0.1, green: 0.1, blue: 0.1, alpha: 0.3)
        ScoreLbl.textColor = UIColor.white
        self.view?.addSubview(ScoreLbl)
        CurrencyLbl.text = "\(Currency)"
        CurrencyLbl = UILabel(frame: CGRect(x: 0, y: 20, width: 100, height: 20))
        CurrencyLbl.backgroundColor = UIColor(colorLiteralRed: 0.1, green: 0.1, blue: 0.1, alpha: 0.3)
        CurrencyLbl.textColor = UIColor.white
        self.view?.addSubview(CurrencyLbl)
        
        
        //Create HealthBar
        healthBar.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 5, height: view.frame.size.height / 2), cornerRadius: 0).cgPath
        healthBar.position = CGPoint(x: 0, y: 0)
        healthBar.zPosition = 5
        healthBar.fillColor = UIColor.blue
        addChild(healthBar)
        
        //Create Pause Button
        pause = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        pause.center = CGPoint(x: view.frame.size.width - 30, y: 30)
        pause.setTitle("||", for: UIControlState())
        pause.setTitleColor(UIColor.darkGray, for: UIControlState())
        pause.addTarget(self, action: #selector(GameScene.Pause), for: UIControlEvents.touchUpInside)
        pause.addTarget(self, action: #selector(GameScene.PauseMenu), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(pause)
 
        //Ready Shield
        Shield.zPosition = 5
        Shield.physicsBody = SKPhysicsBody(rectangleOf: Shield.size)
        Shield.physicsBody?.affectedByGravity = false
        Shield.physicsBody?.categoryBitMask = PhysicsCategory.Protect
        Shield.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        Shield.physicsBody?.isDynamic = true
        Shield.physicsBody?.collisionBitMask = 0
        
        //Ready Net
        Net.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 10))
        Net.physicsBody?.affectedByGravity = false
        Net.physicsBody?.categoryBitMask = PhysicsCategory.Catch
        Net.physicsBody?.contactTestBitMask = PhysicsCategory.Health
        Net.physicsBody?.isDynamic = true
        Net.physicsBody?.collisionBitMask = 0
        Net.position = CGPoint(x: self.size.width/2,y: 50)
        
        //Ready PowerUp Identifier
        Mult.position = CGPoint(x: view.frame.size.width / 2, y: view.frame.height - 30)
        
        //Start button
        start.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 25, width: self.frame.size.width, height: 100), cornerRadius: 0).cgPath
        start.position = CGPoint(x: 0, y: 0)
        start.fillColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: startOpacity)
        start.name = "start"
        start.isUserInteractionEnabled = false
        addChild(start)
        
        jumpLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 2, height: 30))
        jumpLbl.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.width / 3)
        jumpLbl.text = "LET GO TO JUMP"
        self.view?.addSubview(jumpLbl)
        
    }
    
    func StartGame(){
        //start.removeFromParent()
        start.name = "started"
        jumpLbl.removeFromSuperview()
        
        //Create Player
        Player.size = CGSize(width: 32, height: 32)
        Player.position = CGPoint(x: self.size.width/2, y: self.size.height/3)
        Player.physicsBody = SKPhysicsBody(rectangleOf: Player.size)
        Player.physicsBody?.affectedByGravity = false
        Player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        Player.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        Player.physicsBody?.isDynamic = true
        Player.physicsBody?.collisionBitMask = 0
        Player.isUserInteractionEnabled = false
        self.addChild(Player)
        
        //Start timers
        
        ScoreTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameScene.increaseScore), userInfo: nil, repeats: true)
        EnemyTimer = Timer.scheduledTimer(timeInterval: GameSpeed, target: self, selector: #selector(GameScene.SpawnEnemies), userInfo: nil, repeats: false)
        PUSpawnTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(GameScene.SpawnPowerUps), userInfo: nil, repeats: false) //make sure this is slower than PU time
    }

    
    
    
    
    func Pause(){
        self.view?.isPaused = true
        didPause = true
        CDTimer.invalidate()
        GunTimer.invalidate()
        PUTimer.invalidate()
        ScoreTimer.invalidate()
        HealthTimer.invalidate()
        
        pause.isEnabled = false
        
        let fireDate1 = EnemyTimer.fireDate
        let fireDate2 = PUSpawnTimer.fireDate
        //let fireDate3 = HealthTimer.fireDate
        let fireDate4 = PUTimer.fireDate
        
        let nowDate = Date()
        enemyRemaining = -1 * nowDate.timeIntervalSince(fireDate1)
        PURemaining = -1 * nowDate.timeIntervalSince(fireDate2)
        //healthRemaining = -1 * nowDate.timeIntervalSinceDate(fireDate3)
        PUTimeRemaining = -1 * nowDate.timeIntervalSince(fireDate4)
        
        EnemyTimer.invalidate()
        PUSpawnTimer.invalidate()
    }
    
    func PauseMenu(){
        resume = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        resume.center = CGPoint(x: view!.frame.size.width / 2, y: view!.frame.height / 2)
        resume.setTitle("RESUME", for: UIControlState())
        resume.setTitleColor(UIColor.darkGray, for: UIControlState())
        resume.addTarget(self, action: #selector(GameScene.Resume), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(resume)
    }
    
    func Resume(){
        resume.removeFromSuperview()
        self.view?.isPaused = false
        didPause = false
        pause.isEnabled = true
        
        CDTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.GhostTimer), userInfo: nil, repeats: true)
        ScoreTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameScene.increaseScore), userInfo: nil, repeats: true)
        EnemyTimer = Timer.scheduledTimer(timeInterval: enemyRemaining, target: self, selector: #selector(GameScene.SpawnEnemies), userInfo: nil, repeats: false)
        PUSpawnTimer = Timer.scheduledTimer(timeInterval: PURemaining, target: self, selector: #selector(GameScene.SpawnPowerUps), userInfo: nil, repeats: false)
        //if(healthRemaining > 0){
        //HealthTimer = NSTimer.scheduledTimerWithTimeInterval(healthRemaining, target: self, selector: #selector(GameScene.SpawnHealth), userInfo: nil, repeats: false)
        //}
        if(PUTrue == true){
        Timer.scheduledTimer(timeInterval: PUTimeRemaining, target: self, selector: #selector(GameScene.ResumePU), userInfo: nil, repeats: false)
        }
    }
    
    func ResumePU(){
        EndPU()
        PUTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameScene.EndPU), userInfo: nil, repeats: true)
    }
    
    
    //ScoreTimer
    func increaseScore(){
        //can't go over max health
        if(health>maxHealth){
            health = maxHealth;
        }
        
        //linear increase of speed
        if(GameSpeed>0.4){
            GameSpeed = GameSpeed - 0.001
            HealthSpeed = HealthSpeed + 0.005
        }
        
        //decrease health
        health = (Int)((Double)(health) - HealthSpeed)
        healthBar.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 5, height: (Int)( (view!.frame.size.height / 2) * CGFloat(health) / CGFloat(maxHealth) )), cornerRadius: 0).cgPath
        healthBar.position = CGPoint(x: 0, y: 0)
        
        //increase score
        Score = Score + (1 * multiplier)
        ScoreLbl.text = "\(Score)"
        
        //change scene
        if(Score > 1000){
            self.scene?.backgroundColor = UIColor.lightGray
            stage = 2
        }
        if(Score > 2000){
            self.scene?.backgroundColor = UIColor.darkGray
            stage = 3
        }
        if(Score > 3000){
            self.scene?.backgroundColor = UIColor.black
            stage = 4
        }
        
        //end game if health dips below 0
        if(health<=0){
            endGame("You ran out of health.")
        }
        
        if(startOpacity > 0){
            startOpacity -= 0.01
            start.fillColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: startOpacity)
        }
        else if(startOpacity <= 0){
            start.removeFromParent()
        }
    }
    
    
    
    
    //endGame
    func endGame(_ message: String){
        ScoreDefault.setValue(Score, forKey: "Score")
        ScoreDefault.setValue(ScoreDefault.integer(forKey: "Currency") + Currency, forKey: "Currency")
        ScoreDefault.synchronize()
        if (Score > Highscore){
            ScoreDefault.setValue(Score, forKey: "Highscore")
        }
        ScoreDefault.setValue(message, forKey: "Death")
        CDTimer.invalidate()
        GunTimer.invalidate()
        PUTimer.invalidate()
        ScoreTimer.invalidate()
        PUCount = 0
        Player.removeFromParent()
        self.view?.presentScene(EndScene())
        ScoreLbl.removeFromSuperview()
        CurrencyLbl.removeFromSuperview()
        pause.removeFromSuperview()
    }
    
    
    
    
    
    //Contact
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody : SKPhysicsBody = contact.bodyA
        let secondBody : SKPhysicsBody = contact.bodyB

        if((firstBody.categoryBitMask == PhysicsCategory.Enemy) && (secondBody.categoryBitMask == PhysicsCategory.Bullet)){
            CollisionWithBullet(firstBody.node as! SKSpriteNode, Bullet: secondBody.node as! SKSpriteNode)
        }
        else if ((firstBody.categoryBitMask == PhysicsCategory.Bullet) && (secondBody.categoryBitMask == PhysicsCategory.Enemy)){
            CollisionWithBullet(secondBody.node as! SKSpriteNode, Bullet: firstBody.node as! SKSpriteNode)
        }
        else if((firstBody.categoryBitMask == PhysicsCategory.Enemy) && (secondBody.categoryBitMask == PhysicsCategory.MagicBullet) ||
            (firstBody.categoryBitMask == PhysicsCategory.MagicBullet) && (secondBody.categoryBitMask == PhysicsCategory.Enemy)){
                CollisionWithMagicBullet(firstBody.node as! SKSpriteNode, Bullet: secondBody.node as! SKSpriteNode)
        }
        else if((firstBody.categoryBitMask == PhysicsCategory.Enemy) && (secondBody.categoryBitMask == PhysicsCategory.Player) ||
            (firstBody.categoryBitMask == PhysicsCategory.Player) && (secondBody.categoryBitMask == PhysicsCategory.Enemy)){
                endGame("You hit an enemy")
        }
        else if((firstBody.categoryBitMask == PhysicsCategory.Enemy) && (secondBody.categoryBitMask == PhysicsCategory.Ghost) ||
            (firstBody.categoryBitMask == PhysicsCategory.Ghost) && (secondBody.categoryBitMask == PhysicsCategory.Enemy)){
                CollisionWithGhost(firstBody.node as! SKSpriteNode, Ghost: secondBody.node as! SKSpriteNode)
        }
        else if((firstBody.categoryBitMask == PhysicsCategory.Gun) && (secondBody.categoryBitMask == PhysicsCategory.Player) ||
            (firstBody.categoryBitMask == PhysicsCategory.Player) && (secondBody.categoryBitMask == PhysicsCategory.Gun)){
                GunPowerUp(firstBody.node as! SKSpriteNode, PowerUp: secondBody.node as! SKSpriteNode)
        }
        else if((firstBody.categoryBitMask == PhysicsCategory.Shield) && (secondBody.categoryBitMask == PhysicsCategory.Player) ||
            (firstBody.categoryBitMask == PhysicsCategory.Player) && (secondBody.categoryBitMask == PhysicsCategory.Shield)){
                SpawnShield(firstBody.node as! SKSpriteNode, PowerUp: secondBody.node as! SKSpriteNode)
        }
        else if((firstBody.categoryBitMask == PhysicsCategory.Multiplier) && (secondBody.categoryBitMask == PhysicsCategory.Player) ||
            (firstBody.categoryBitMask == PhysicsCategory.Player) && (secondBody.categoryBitMask == PhysicsCategory.Multiplier)){
                MultiplierPowerUp(firstBody.node as! SKSpriteNode, PowerUp: secondBody.node as! SKSpriteNode)
        }
        else if((firstBody.categoryBitMask == PhysicsCategory.Net) && (secondBody.categoryBitMask == PhysicsCategory.Player) ||
            (firstBody.categoryBitMask == PhysicsCategory.Player) && (secondBody.categoryBitMask == PhysicsCategory.Net)){
                SpawnNet(firstBody.node as! SKSpriteNode, PowerUp: secondBody.node as! SKSpriteNode)
        }
        else if((firstBody.categoryBitMask == PhysicsCategory.Protect) && (secondBody.categoryBitMask == PhysicsCategory.Enemy) ||
            (firstBody.categoryBitMask == PhysicsCategory.Enemy) && (secondBody.categoryBitMask == PhysicsCategory.Protect)){
                ShieldPowerUp(firstBody.node as! SKSpriteNode, Enemy: secondBody.node as! SKSpriteNode)
        }
        else if((firstBody.categoryBitMask == PhysicsCategory.Enemy) && (secondBody.categoryBitMask == PhysicsCategory.Gun || secondBody.categoryBitMask == PhysicsCategory.Shield || secondBody.categoryBitMask == PhysicsCategory.Net || secondBody.categoryBitMask == PhysicsCategory.Multiplier)){
                CollisionRemovePU(firstBody.node as! SKSpriteNode, PowerUp: secondBody.node as! SKSpriteNode)
        }
        else if((firstBody.categoryBitMask == PhysicsCategory.Gun || firstBody.categoryBitMask == PhysicsCategory.Shield || firstBody.categoryBitMask == PhysicsCategory.Net || firstBody.categoryBitMask == PhysicsCategory.Multiplier) && (secondBody.categoryBitMask == PhysicsCategory.Enemy)){
                CollisionRemovePU(secondBody.node as! SKSpriteNode, PowerUp: firstBody.node as! SKSpriteNode)
        }
        else if((firstBody.categoryBitMask == PhysicsCategory.Health) && (secondBody.categoryBitMask == PhysicsCategory.Player) ||
            (firstBody.categoryBitMask == PhysicsCategory.Player) && (secondBody.categoryBitMask == PhysicsCategory.Health)){
                CollisionWithHealth(firstBody.node as! SKSpriteNode, Health: secondBody.node as! SKSpriteNode)
        }
        else if((firstBody.categoryBitMask == PhysicsCategory.Catch) && (secondBody.categoryBitMask == PhysicsCategory.Health)){
                CollisionWithHealth(firstBody.node as! SKSpriteNode, Health: secondBody.node as! SKSpriteNode)
        }
        else if((firstBody.categoryBitMask == PhysicsCategory.Health) && (secondBody.categoryBitMask == PhysicsCategory.Catch)){
            CollisionWithHealth(secondBody.node as! SKSpriteNode, Health: firstBody.node as! SKSpriteNode)
        }
        
    }
    
    
    
    
    
    //Powerups
    func EndPU(){
        if(PUCount == 0){
            PUTrue = true
        }
        NSLog("\(PUCount)")
        PUCount += 1
        if(PUCount>maxPU){
            PUTrue = false
            GunTrue = false
            ShieldTrue = false
            multiplier = 1
            Shield.removeFromParent()
            GunTimer.invalidate()
            PUTimer.invalidate()
            Mult.removeFromParent()
            Net.removeFromParent()
        }
    }
    
    //*****GUN*****
    func GunPowerUp(_ Player: SKSpriteNode, PowerUp: SKSpriteNode){
        PowerUp.removeFromParent()
        GunTrue = true
        GunTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameScene.SpawnBullets), userInfo: nil, repeats: true)
        
        PUCount = 0
        PUTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameScene.EndPU), userInfo: nil, repeats: true)
    }
    
    func SpawnBullets(){
        //basic
        let BulletType = arc4random_uniform((UInt32)(magicBulletProb))
        let Bullet = SKSpriteNode(imageNamed: "bullet.png")
        
        //physics
        Bullet.zPosition = -5
        Bullet.position = CGPoint(x: Player.position.x, y: Player.position.y + 50)
        Bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Bullet.size.width + 10, height: Bullet.size.height + 10))
        if(BulletType == 0){
            Bullet.physicsBody?.categoryBitMask = PhysicsCategory.MagicBullet
            Bullet.texture = SKTexture(imageNamed: "enemy1.png")
        }
        else{
            Bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        }
        Bullet.physicsBody?.affectedByGravity = false
        Bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        Bullet.physicsBody?.isDynamic = true
        Bullet.physicsBody?.collisionBitMask = 0
        
        //action
        let action = SKAction.moveTo(y: self.size.height, duration: 0.8)
        let actionDone = SKAction.removeFromParent()
        Bullet.run(SKAction.sequence([action, actionDone]))
        Bullet.run(SKAction.repeatForever(action))
        
        //add
        self.addChild(Bullet)
    }
    func CollisionWithBullet(_ Enemy: SKSpriteNode, Bullet: SKSpriteNode){
        Bullet.removeFromParent()
    }
    func CollisionWithMagicBullet(_ Enemy: SKSpriteNode, Bullet: SKSpriteNode){
        Enemy.removeFromParent()
        Bullet.removeFromParent()
        Score=Score+(20 * multiplier)
        ScoreLbl.text = "\(Score)"
    }
    
    //*****SHIELD******
    func SpawnShield(_ Player: SKSpriteNode, PowerUp: SKSpriteNode){
        PowerUp.removeFromParent()
        PUCount = 0
        
        Shield.position = CGPoint(x: Player.position.x, y: Player.position.y + 50)
        
        self.addChild(Shield)
        ShieldTrue = true
        PUTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameScene.EndPU), userInfo: nil, repeats: true)
    }
    func ShieldPowerUp(_ Protect: SKSpriteNode, Enemy: SKSpriteNode){
        Enemy.removeFromParent()
        Protect.removeFromParent()
        ShieldTrue=false
        PUTimer.invalidate()
    }
    
    //*****MULTIPLIER*****
    func MultiplierPowerUp(_ Player: SKSpriteNode, PowerUp: SKSpriteNode){
        PUCount = 0
        PowerUp.removeFromParent()
        multiplier = multiplierMax
        self.addChild(Mult)
        PUTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameScene.EndPU), userInfo: nil, repeats: true)
    }
    
    //*****NET***** (Uses CollisionWithHealth)
    func SpawnNet(_ Player: SKSpriteNode, PowerUp: SKSpriteNode){
        PUCount = 0
        PowerUp.removeFromParent()
        self.addChild(Net)
        PUTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameScene.EndPU), userInfo: nil, repeats: true)
    }

    
    
    
    
    //Collisions
    func CollisionWithHealth(_ Player: SKSpriteNode, Health: SKSpriteNode){
        Health.removeFromParent()
        health = health + 100
        Currency += 1
        CurrencyLbl.text = "\(Currency)"
    }
    func CollisionRemovePU(_ Enemy: SKSpriteNode, PowerUp: SKSpriteNode){             //gets rid of overlapping PowerUps and enemies
        PowerUp.removeFromParent()
    }
    func CollisionWithGhost(_ Enemy: SKSpriteNode, Ghost: SKSpriteNode){
        Score = Score + (20 * multiplier)
    }
    
    
    
    
    
    //Spawning
    func SpawnEnemies(){
        if(didPause == false){
        //basic
        let EnemyType = arc4random_uniform(10)
        let Enemy = SKSpriteNode(imageNamed: "enemy\(EnemyType).png")
        
        //random position
        let MinValue = self.size.width/8
        let MaxValue = 7 * self.size.width/8
        let SpawnPoint = UInt32(MaxValue - MinValue)
        Enemy.position = CGPoint(x: CGFloat(arc4random_uniform(SpawnPoint)), y: self.size.height)
        
        //physics
        Enemy.zPosition = -3
        Enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Enemy.frame.size.width - 20, height: Enemy.frame.size.height - 20))
        Enemy.physicsBody?.affectedByGravity = false
        Enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        Enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
        Enemy.physicsBody?.isDynamic = false
        Enemy.physicsBody?.collisionBitMask = 0
        
        //action
        let action = SKAction.moveTo(y: 0, duration: GameSpeed * 3.0)
        Enemy.run(SKAction.repeatForever(action))
        let actionDone = SKAction.removeFromParent()
        Enemy.run(SKAction.sequence([action, actionDone]))
        
        //add
        self.addChild(Enemy)
        
        //repeat enemy and health
        
        let healthTime = GameSpeed / 2
        
        EnemyTimer = Timer.scheduledTimer(timeInterval: GameSpeed, target: self, selector: #selector(GameScene.SpawnEnemies), userInfo: nil, repeats: false)
        HealthTimer = Timer.scheduledTimer(timeInterval: healthTime, target: self, selector: #selector(GameScene.SpawnHealth), userInfo: nil, repeats: false)
        }

        
        
    }
    
    func SpawnHealth(){
        //spawn in random multiples
        if(healthCount % HealthRand == 0){
            
            //change factor to another random number
            HealthRand = (Int)(arc4random_uniform(5) + 3)
            //HealthRand = 1
            
            //create (random position same as enemy)
            let Health = SKSpriteNode(imageNamed: "bullet.png")
            let MinValue = self.size.width/8
            let MaxValue = 7 * self.size.width/8
            let SpawnPoint = UInt32(MaxValue - MinValue)
            Health.position = CGPoint(x: CGFloat(arc4random_uniform(SpawnPoint)), y: self.size.height)
            Health.zPosition = -3
            Health.physicsBody = SKPhysicsBody(rectangleOf: Health.size)
            Health.physicsBody?.affectedByGravity = false
            Health.physicsBody?.categoryBitMask = PhysicsCategory.Health
            Health.physicsBody?.contactTestBitMask = PhysicsCategory.Player
            Health.physicsBody?.isDynamic = false
            Health.physicsBody?.collisionBitMask = 0
    
            //action
            let action = SKAction.moveTo(y: 0, duration: GameSpeed * 3.0)
            Health.run(SKAction.repeatForever(action))
            let actionDone = SKAction.removeFromParent()
            Health.run(SKAction.sequence([action, actionDone]))
        
            //add
            self.addChild(Health)
        }
        healthCount = healthCount + 1
    }
    
    func SpawnPowerUps(){
        if(didPause == false){
            
        //basic
        let PUType = 0 //arc4random_uniform(4)
        let PU = SKSpriteNode(imageNamed: "ghost.png")
        
        //rand spawn
        let MinValue = self.size.width/8
        let MaxValue = 7 * self.size.width/8
        let SpawnPoint = UInt32(MaxValue - MinValue)
        
        //physics
        PU.position = CGPoint(x: CGFloat(arc4random_uniform(SpawnPoint)), y: self.size.height)
        PU.zPosition = -10
        PU.physicsBody = SKPhysicsBody(rectangleOf: PU.size)
        PU.physicsBody?.affectedByGravity = false
        if(PUType == 0){
            PU.physicsBody?.categoryBitMask = PhysicsCategory.Gun
        }
        else if(PUType == 1){
            PU.physicsBody?.categoryBitMask = PhysicsCategory.Shield
        }
        else if(PUType == 2){
            PU.physicsBody?.categoryBitMask = PhysicsCategory.Multiplier
        }
        else if(PUType == 3){
            PU.physicsBody?.categoryBitMask = PhysicsCategory.Net
        }
        PU.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        PU.physicsBody?.isDynamic = true
        PU.physicsBody?.collisionBitMask = 0
        
        //action
        let action = SKAction.moveTo(y: 0, duration: GameSpeed * 3.0)
        PU.run(SKAction.repeatForever(action))
        let actionDone = SKAction.removeFromParent()
        PU.run(SKAction.sequence([action, actionDone]))
        
        //add
        self.addChild(PU)
        
        //repeat
        let SpawnTimer = (Double)(arc4random_uniform(11) + 40)

        PUSpawnTimer = Timer.scheduledTimer(timeInterval: SpawnTimer, target: self, selector: #selector(GameScene.SpawnPowerUps), userInfo: nil, repeats: false)
        }
    }
    
    
    
    
    
    //touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //UnGHOST
        Player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        Shield.physicsBody?.categoryBitMask = PhysicsCategory.Protect
        Player.texture = SKTexture(imageNamed: "galaga.png")
        GhostCount = 0
        CDTimer.invalidate()
        let fade = SKAction.fadeAlpha(to: 1.0, duration: 0)
        Player.run(fade)
        
        let action = SKAction.scale(to: 0.9, duration: 0.1)
        let actionDone = SKAction.scale(to: 1, duration: 0.1)
        let time = SKActionTimingMode(rawValue: 2)
        actionDone.timingMode = time!
        Player.run(SKAction.sequence([action, actionDone]), withKey: "Jump")
       
        for touch in touches {
            
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            
            if let name = touchedNode.name
            {
                if name == "start"
                {
                    StartGame()
                }
            }
            
            //start gun if powerup active
            if(GunTrue){
                GunTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameScene.SpawnBullets), userInfo: nil, repeats: true)
            }
            
            //can move if touched player
            let position : CGPoint = touch.location(in: view)
            if (position.x < Player.position.x + Player.frame.size.width + 10 && position.x > Player.position.x - Player.frame.size.width - 10)
            {
                didTouch = true;
            }
        }
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //ghostON
        didTouch = false
        Player.physicsBody?.categoryBitMask = PhysicsCategory.Ghost
        Shield.physicsBody?.categoryBitMask = PhysicsCategory.Ghost
        Player.texture = SKTexture(imageNamed: "ghost.png")
        
        let action = SKAction.scale(to: 1.5, duration: 0.8)
        let actionDone = SKAction.fadeAlpha(to: 0.6, duration: 0.2)
        let time = SKActionTimingMode(rawValue: 2)
        action.timingMode = time!
        let time2 = SKActionTimingMode(rawValue: 1)
        actionDone.timingMode = time2!
        Player.run(SKAction.sequence([action, actionDone]), withKey: "Jump")
        
        if(didPause == false){
            CDTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.GhostTimer), userInfo: nil, repeats: true)
        }
        
        //turn off gun
        GunTimer.invalidate()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            //can move if player was touched
            let position :CGPoint = touch.location(in: view)
            if (position.x < Player.position.x + Player.frame.size.width + 10 && position.x > Player.position.x - Player.frame.size.width - 10)
            {
                didTouch = true;
            }
            if(didTouch==true){

                
                Player.position.x = location.x
                if(ShieldTrue==true){
                    Shield.position.x = location.x
                    health = health + 1
                }
            }
            
        }
    }

    
    
    
    
    //ghost
    func GhostTimer(){
        GhostCount += 1
        
        if(GhostCount==0){
            //blinking animation
        }
        else if(GhostCount>=1){
            endGame("Don't jump for too long!")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}
