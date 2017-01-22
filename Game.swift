//
//  GameScene.swift
//  Shift.
//
//  Created by Stephen Knotts on 11/22/15.
//  Copyright  © 2016 Stephen Knotts. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation
import GoogleMobileAds

var interAdView = UIView()
var closeButton = UIButton()

var player: SKSpriteNode!
var win: Bool = false
var world = [["A"]]
var collision: Bool = false
var NumColumns = world.count
var NumPlayers = NumColumns-2
var players: [SKSpriteNode] = []
var playersCanMove: [Bool] = []
var TileWidth: CGFloat!
var direction: String = "f"
var menu = false
var score = 0

var tryAgainAfterMoved: SKSpriteNode!
var slip: Bool = true
var count: Int = 0
var move: CGFloat!
var z = 0
var plays: Int = 0
var bounced = 0
var a = false
var c = true

var timer: Timer?
var countr = 3

var redTargetNode = SKSpriteNode(texture: imageAtlas.textureNamed("RedTarget"))
var orangeTargetNode = SKSpriteNode(texture: imageAtlas.textureNamed("OrangeTarget"))
var yellowTargetNode = SKSpriteNode(texture: imageAtlas.textureNamed("YellowTarget"))
var greenTargetNode = SKSpriteNode(texture: imageAtlas.textureNamed("GreenTarget"))
var blueTargetNode = SKSpriteNode(texture: imageAtlas.textureNamed("BlueTarget"))
var indigoTargetNode = SKSpriteNode(texture: imageAtlas.textureNamed("IndigoTarget"))
var violetTargetNode = SKSpriteNode(texture: imageAtlas.textureNamed("VioletTarget"))
var menuButton = SKSpriteNode(texture: imageAtlas.textureNamed("Menu"))
var restartButton = SKSpriteNode(texture: imageAtlas.textureNamed("Restart"))

let backgroundMusic = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Bouncing", withExtension: ".mp3")!)
let bloop = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Bloop", withExtension: ".m4a")!)
let shift = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Shift", withExtension: ".m4a")!)

var display: Bool = false

let menuLabel = SKLabelNode(fontNamed: "Microsoft Sans Serif")
let nextLabel = SKLabelNode(fontNamed: "Microsoft Sans Serif")
let replayLabel = SKLabelNode(fontNamed: "Microsoft Sans Serif")
let resumeLabel = SKLabelNode(fontNamed: "Microsoft Sans Serif")
let restartLabel = SKLabelNode(fontNamed: "Microsoft Sans Serif")

let redNode = SKSpriteNode(texture: imageAtlas.textureNamed("Red"))
let orangeNode = SKSpriteNode(texture: imageAtlas.textureNamed("Orange"))
let yellowNode = SKSpriteNode(texture: imageAtlas.textureNamed("Yellow"))
let greenNode = SKSpriteNode(texture: imageAtlas.textureNamed("Green"))
let blueNode = SKSpriteNode(texture: imageAtlas.textureNamed("Blue"))
let indigoNode = SKSpriteNode(texture: imageAtlas.textureNamed("Indigo"))
let violetNode = SKSpriteNode(texture: imageAtlas.textureNamed("Violet"))
let overlayNode = SKSpriteNode(texture: imageAtlas.textureNamed("NextLevelOverlay"))
let backgroundNode = SKSpriteNode(texture: imageAtlas.textureNamed("Background_Box"))
let tileNode = SKSpriteNode(texture: imageAtlas.textureNamed("Tile"))
let numberLabel = SKLabelNode(fontNamed: "Ariel")
let cursorNode = SKSpriteNode(texture: imageAtlas.textureNamed("Cursor"))

let movesLabel2 = SKLabelNode(fontNamed: "Wednesday")
let movesLabel = SKLabelNode (fontNamed: "Microsoft Sans Serif")
let buttonRestart = SKSpriteNode(texture: imageAtlas.textureNamed("Button"))
let buttonMenu = SKSpriteNode(texture: imageAtlas.textureNamed("Button"))
let buttonReplay = SKSpriteNode(texture: imageAtlas.textureNamed("Button"))

let menuLayer = SKNode()
let displayLayer = SKNode()
let boardLayer = SKNode()

var canMove: [String:Bool] = [
    "A" : true,
    "B" : true,
    "C" : true,
    "D" : true,
    "E" : true,
    "F" : true,
    "G" : true
]

var colors: [String] = [ "A", "B", "C", "D", "E", "F", "G"]

var error: NSError? = nil

class GameScene: SKScene, GADInterstitialDelegate {
    
    var interstitial: GADInterstitial!

    func mainMenu(){
        
        overlayLayer.removeAllChildren()
        overlayNode.removeFromParent()
        self.removeAllChildren()
        
        let scene = NewGameScene(size: self.size)
        scene.scaleMode = scaleMode
        self.view?.presentScene(scene, transition:  SKTransition.fade(withDuration: 0.5))

        backgroundMusic.prepareToPlay()
    }
    
    //Main Loops
    override func didMove(to view: SKView) {
        loadInterstitial()

        run(SKAction.wait(forDuration: 0.01), completion: {
            
            backgroundMusic.play()
            
        })

       
        overlayLayer.removeAllChildren()

        self.removeAllChildren()

/*        let skView = view as! SKView
        skView.multipleTouchEnabled = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsDrawCount = true
        skView.ignoresSiblingOrder = true
        self.scene!.scaleMode = .AspectFill
*/
        bloop.prepareToPlay()
        shift.prepareToPlay()
   
        
        if(mute){
            
            buttonMute.texture = SKTexture(imageNamed: "Mute")

            backgroundMusic.volume = 0
            print("M")
        }
        if(!mute){
            buttonMute.texture = SKTexture(imageNamed: "Unmute")
            
            backgroundMusic.volume = 1
            print("UM")
        }
        
        drawLevel()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view?.addGestureRecognizer(swipeLeft)

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.respondToSwipeGesture(_:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view?.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.respondToSwipeGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view?.addGestureRecognizer(swipeDown)
        
        self.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.0)
        //self.backgroundColor = UIColor(red: 240/255, green: 246/255, blue: 229/255, alpha: 0.0)
        //self.backgroundColor = UIColor(red: 72/255, green: 55/255, blue: 97/255, alpha: 0.0)

        self.addChild(overlayLayer)
        
    }

    func remove(){
        overlayLayer.removeAllChildren()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
      //  next()
    
        for touch in touches {
                
                let location = touch.location(in: self)
            
                // restartButton.position = location
                // print(location)
                let touchedNode = self.atPoint(location)
              //  print(touchedNode)
            
            
            
                if(touchedNode.name == "mute" && !mute){
                    
                    mute = true
                    backgroundMusic.volume = 0
                    buttonMute.texture = SKTexture(imageNamed: "Mute")
                    
                    break
                }
                if(touchedNode.name == "mute" && mute){
                    click.play()

                    mute = false
                    backgroundMusic.volume = 1
                    buttonMute.texture = SKTexture(imageNamed: "UnMute")
                    break
                }
                
                if(win && touchedNode.name == "next"){
                    click.play()

                    once = false
                    
                    overlayLayer.run(SKAction.moveBy(x: 0, y: 700, duration: 0.2), completion:{self.next()})

                }
             
                if(win && touchedNode.name == "replay"){
                    click.play()
                    
                    if(!purchased){
                    
                    }
                    if(purchased){
                    
                    }
                }
                
                if touchedNode.name == "display" {
                    click.play()

                    if(display){
                        movesLabel.text = "level"
                        movesLabel2.text = String(currentLevel)
                        movesLabel.position = CGPoint(x: screenSize.width/2-55, y: screenSize.height/2+190)
                        display = false
                        break
                    }
                   
                    if(!display){
                        movesLabel.text = "moves"
                        movesLabel2.text = String(score)
                        movesLabel.position = CGPoint(x: screenSize.width/2+35, y: screenSize.height/2+190)
                        display = true
                    }
                
                }
                
                if(touchedNode.name == "resume" && menu && !win){
                    click.play()

                    buttonPlay.run(SKAction.scale(by: 0.9, duration: 0.1), completion: {menu = false;overlayLayer.run(SKAction.moveBy(x: 0, y: 700, duration: 0.2), completion:{})})
                }
                if(touchedNode.name == "levels" && menu && !win){
                    click.play()
                    
                    buttonAds.run(SKAction.scale(by: 0.9, duration: 0.2))

                    boardLayer.run(SKAction.moveBy(x: 0, y: 700, duration: 0.2), completion:{
                        
                        
                        counter = 16
                        
                        let a = [3, 2, 1, 0]
                        
                        TileWidth = (screenSize.size.width-20)/CGFloat(4) //grid size
                        self.addChild(menuLayer)
                        
                        for row in 0..<4 {
                            
                            for column in a {
                                
                                if(!darkMode){
                                    tileNode.texture = SKTexture(imageNamed: "Tile")
                                }
                                if(darkMode){
                                    tileNode.texture = SKTexture(imageNamed: "TileDark")
                                }
                                
                                
                                tileNode.position = Tiles().pointForColumn(column, row: row)
                                
                                cursorNode.xScale = TileWidth * 0.001
                                cursorNode.yScale = TileWidth * 0.001
                                cursorNode.name = String(counter)
                                
                                tileNode.xScale = TileWidth * 0.001
                                tileNode.yScale = TileWidth * 0.001
                                tileNode.name = String(counter)
                                tileNode.zPosition = 14
                                
                                numberLabel.text = String(counter)
                                numberLabel.fontColor = SKColor.gray
                                numberLabel.position = Tiles().pointForColumn(column, row: row)
                                numberLabel.position.y -= 17
                                numberLabel.zPosition = 15
                                numberLabel.fontSize = 45
                                numberLabel.name = String(counter)
                                
                                menuLayer.position = CGPoint(x: layerPosition.x, y: layerPosition.y+500)
                                
                                if(levelProgress > 16){
                                    tileNode.texture = SKTexture(imageNamed: textures[counter%7])
                                    numberLabel.fontColor = SKColor.black
                                    
                                    menuLayer.addChild(tileNode)
                                    
                                }
                                if(levelProgress >= counter && levelProgress < 16){
                                    tileNode.texture = SKTexture(imageNamed: textures[counter%7])
                                    numberLabel.fontColor = SKColor.black
                                    
                                    menuLayer.addChild(tileNode)
                                    
                                }
                                if(levelProgress < counter){
                                    menuLayer.addChild(tileNode)
                                }
                                
                                if(counter == levelProgress+1){
                                    tileNode.texture = SKTexture(imageNamed: "Completed")
                                    numberLabel.fontColor = SKColor.yellow
                                    cursorNode.position = Tiles().pointForColumn(column, row: row)
                                    menuLayer.addChild(cursorNode)
                                }
                                menuLayer.addChild(numberLabel)
                                
                                menuLayer.run(SKAction.move(to: layerPosition, duration: 0.2))
                                counter -= 1
                            }
                            
                        }
                        
                        
                    })
                    
                }
                
                if(touchedNode.name == "quit" && menu && !win){
                    click.play()

                    print("A")
                    
                    buttonMenu.run(SKAction.scale(by: 0.9, duration: 0.1), completion: {menu = false;overlayLayer.run(SKAction.moveBy(x: 0, y: 700, duration: 0.2), completion:{self.remove();self.quitLevel()})})

                 //  backgroundMusic.removeFromParent()
            
                    
                }
                if(touchedNode.name == "menu" && menu && !win){
                    click.play()

                    menu = false
                    menuButton.run(SKAction.scale(by: -0.1, duration: 0.01))
                
                    overlayLayer.run(SKAction.moveBy(x: 0, y: 700, duration: 0.2), completion:{self.remove()})
                    break
                    
                }
            //
                if(touchedNode.name == "restart" && !menu && !win){
                    
                    click.play()
                    //interstitial ads
                    if(!purchased){
                    
                            beginCounter()
                        self.restart();
                        
                    }
                    if(purchased){
                        menu = false
                        self.restart();
                    }
                }
            //
                if(touchedNode.name == "menu" && !menu && !win){
                    click.play()

                    
                    menu = true
                    
                    overlayLayer.removeAllChildren()
                    
                    overlayLayer.zPosition = 10
                    overlayLayer.position.x = screenSize.width/2
                    overlayLayer.position.y = screenSize.height/2 + 600
                    
                    buttonMenu.xScale = 0.3
                    buttonMenu.yScale = 0.3
                    buttonMenu.position = CGPoint(x: 0, y: -0)
                    buttonMenu.zPosition = 11
                    buttonMenu.name = "quit"
                    
                    buttonRestart.xScale = 0.3
                    buttonRestart.yScale = 0.3
                    buttonRestart.zPosition = 11
                    buttonRestart.position = CGPoint(x: 0, y: -130)
                    
                    buttonAds.xScale = 0.3
                    buttonAds.yScale = 0.3
                    buttonAds.zPosition = 11
                    buttonAds.name = "levels"
                    buttonAds.position = CGPoint(x: 0, y: 0)
                    
                    buttonPlay.xScale = 0.3
                    buttonPlay.yScale = 0.3
                    buttonPlay.zPosition = 11
                    buttonPlay.position = CGPoint(x: 0, y: 120)
                    buttonPlay.name = "resume"

                    overlay.xScale = 0.5
                    overlay.yScale = 0.5
                    
                    resumeLabel.fontColor = SKColor.black
                    resumeLabel.text = "Resume"
                    resumeLabel.fontSize = 40
                    resumeLabel.position = CGPoint(x:0, y: 105)
                    resumeLabel.zPosition = 12
                    resumeLabel.fontColor = SKColor.white
                    resumeLabel.name = "resume"
                    
                    menuLabel.text = "Menu"
                    menuLabel.name = "quit"
                    menuLabel.zPosition = 12
                    menuLabel.fontColor = SKColor.white
                    menuLabel.fontSize = 40
                    menuLabel.position = CGPoint(x:0, y: -18)

                    
                    buttonMute.xScale = 0.1
                    buttonMute.yScale = 0.1
                    buttonMute.position = CGPoint(x:-65, y: -135)
                    buttonMute.zPosition = 11
                    buttonMute.name = "mute"
                    
                    restartLabel.fontColor = SKColor.black
                    restartLabel.text = "Levels"
                    restartLabel.fontSize = 40
                    restartLabel.position = CGPoint(x:0, y: -15)
                    restartLabel.zPosition = 12
                    restartLabel.fontColor = SKColor.white
                    restartLabel.name = "levels"
                    
                    overlayLayer.addChild(overlay)
                    overlayLayer.addChild(buttonPlay)
                    overlayLayer.addChild(resumeLabel)
                    overlayLayer.addChild(buttonMenu)
                    overlayLayer.addChild(menuLabel)
                    overlayLayer.addChild(buttonMute)
                    
                    let action = SKAction.moveBy(x: 0, y: -600, duration: 0.2)
                    let a = SKAction.moveBy(x: 0, y: -1, duration: 0.1)
                    let b = SKAction.moveBy(x: 0, y: 1, duration: 0.1)
                    let sequence = SKAction.sequence([action, a, b])
                    
                    menuButton.run(SKAction.scale(by: 1.0, duration: 0.01), completion:{overlayLayer.run(sequence)})

                }
                
            }

    }
    
    
    func beginCounter() {
        countr = 1
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                                       target: self,
                                                       selector:#selector(decrementCounter(_:)),
                                                       userInfo: nil,
                                                       repeats: true)
    }
    
    
    func decrementCounter(_ timer: Timer) {
        countr -= 1
        if countr > 0 {
        } else {
            GameViewController().showAd()
        }
    }

    
    func loadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-6507479540703114/4428372984")
        interstitial.delegate = self
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made. GADInterstitial automatically returns test ads when running on a
        // simulator.
        interstitial.load(GADRequest())
    }
    

    
    func quitLevel(){
        
        overlayLayer.removeAllChildren()
        overlayNode.removeFromParent()
        
        self.removeAllChildren()
        
        backgroundMusic.stop()
        
        let scene = NewGameScene(size: self.size)
        scene.scaleMode = scaleMode
        self.view?.presentScene(scene, transition:  SKTransition.fade(withDuration: 0.5))
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {



    }

    override func update(_ currentTime: TimeInterval) {



    }

        
    //Draw Level Tiles
    func restart(){
        
        print("Restarting level")
        
        players.removeAll()
        world.removeAll()
        win = false
        
        nextLabel.removeFromParent()
        menuLabel.removeFromParent()
        
        world = levels().Level[currentLevel]!
        boardLayer.removeFromParent()
        drawLevel()
        
    }
      
    func next(){
        
        print(currentLevel)
        players.removeAll()
        world.removeAll()
        win = false
        boardLayer.removeAllChildren()
        nextLabel.removeFromParent()
        menuLabel.removeFromParent()

        if(currentLevel < levels().Level.count-1){
            
            currentLevel += 1
         
        }
        else{
        
        }
        
        world = levels().Level[currentLevel]!
        boardLayer.removeFromParent()
        drawLevel()
    }

    func drawLevel(){
        
        
        addChild(boardLayer)
        
        score = 0
        
     
        if(display){
            movesLabel.text = "level"
            movesLabel2.text = String(currentLevel)
            display = false
    
        }
        if(!display){
            movesLabel.text = "moves"
            movesLabel2.text = String(score)
            display = true
        }
        

        world = levels().Level[currentLevel]!
        NumColumns = world.count
        NumPlayers = NumColumns-2
        
        canMove = [
            "A" : true,
            "B" : true,
            "C" : true,
            "D" : true,
            "E" : true,
            "F" : true,
            "G" : true
        ]

      Tiles().addTiles(0)
        
        movesLabel.removeFromParent()
        movesLabel2.removeFromParent()

        menuButton.removeFromParent()
        backgroundNode.removeFromParent()
        restartButton.removeFromParent()

        //movesLabel.text = String(score)
        //movesLabel.anchorPoint = CGPoint(x: 0, y: 1.0)

        movesLabel.fontColor = SKColor.red
        movesLabel2.fontColor = SKColor.red


        movesLabel.zPosition = 9
        movesLabel2.zPosition = 9
        
    
        backgroundNode.xScale = 0.18
        backgroundNode.yScale = 0.18
        backgroundNode.name = "display"
        
        movesLabel.fontSize = 26
        movesLabel2.fontSize = 60
        
        if(screenMode == "4s"){
            menuButton.position = CGPoint(x: screenSize.width/2+125, y: screenSize.height/2+180)
            restartButton.position = CGPoint(x: screenSize.width/2-125, y: screenSize.height/2+180)
            backgroundNode.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2+180)
            movesLabel.position = CGPoint(x: screenSize.width/2+35, y: screenSize.height/2+140)
            movesLabel2.position = CGPoint(x: screenSize.width/2+45, y: screenSize.height/2+170)

            menuButton.xScale = 0.08
            menuButton.yScale = 0.08

            restartButton.xScale = 0.08
            restartButton.yScale = 0.08
            
        }
        if(screenMode == "5s"){
            
            menuButton.position = CGPoint(x: screenSize.width/2+125, y: screenSize.height/2+180)
            restartButton.position = CGPoint(x: screenSize.width/2-125, y: screenSize.height/2+180)
            backgroundNode.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2+180)
            movesLabel.position = CGPoint(x: screenSize.width/2+35, y: screenSize.height/2+140)
            movesLabel2.position = CGPoint(x: screenSize.width/2+45, y: screenSize.height/2+170)
            
            menuButton.xScale = 0.08
            menuButton.yScale = 0.08
            restartButton.xScale = 0.08
            restartButton.yScale = 0.08
        }
        if(screenMode == "6"){
            menuButton.position = CGPoint(x: screenSize.width/2+135, y: screenSize.height/2+200)
            restartButton.position = CGPoint(x: screenSize.width/2-135, y: screenSize.height/2+200)
            backgroundNode.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2+200)
            movesLabel.position = CGPoint(x: screenSize.width/2+35, y: screenSize.height/2+160)
            movesLabel2.position = CGPoint(x: screenSize.width/2+45, y: screenSize.height/2+190)
            
            menuButton.xScale = 0.1
            menuButton.yScale = 0.1
            restartButton.xScale = 0.1
            restartButton.yScale = 0.1
        }
        if(screenMode == "6p"){
            menuButton.position = CGPoint(x: screenSize.width/2+140, y: screenSize.height/2+230)
            restartButton.position = CGPoint(x: screenSize.width/2-140, y: screenSize.height/2+230)
            backgroundNode.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2+230)
            movesLabel.position = CGPoint(x: screenSize.width/2+35, y: screenSize.height/2+190)
            movesLabel2.position = CGPoint(x: screenSize.width/2+45, y: screenSize.height/2+220)

            menuButton.xScale = 0.1
            menuButton.yScale = 0.1
            
            restartButton.xScale = 0.1
            restartButton.yScale = 0.1
        }
        
      
        
        menuButton.name = "menu"
        restartButton.name = "restart"
        
        movesLabel2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
    
        
        self.addChild(restartButton)
        self.addChild(backgroundNode)
        self.addChild(movesLabel)
        self.addChild(movesLabel2)
        self.addChild(menuButton)
    
    }
    
    func pointForColumn(_ column: Int, row: Int) -> CGPoint {
    
        return CGPoint(
            x: CGFloat(column)*TileWidth+TileWidth/2+2,//grid position x
            y: CGFloat(row)*TileWidth+TileWidth/2-1)//grid position y
    }
    
    func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            blooped = false
            
            score += 1
            
            
            if(display){
                movesLabel2.text = String(score)
            }
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right:
                
                print("Right")
                
                shift.play()

                swiped().swipedRight()
                
                break
            
            case UISwipeGestureRecognizerDirection.left:
                
                print("Left")
                shift.play()

                swiped().swipedLeft()
                
                break
                
            case UISwipeGestureRecognizerDirection.up:
                
                print("Up")
                shift.play()

                swiped().swipedUp()
                
                break
                
            case UISwipeGestureRecognizerDirection.down:
                
                print("Down")
                shift.play()

                swiped().swipedDown()
                
                break
                
            default:
                break
            }
        }
    }
   
}
