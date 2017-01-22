//
//  NewGameScene.swift
//  Shift.
//
//  Created by Stephen on 12/14/15.
//  Copyright © 2016 Wedjat. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation
import StoreKit
import CoreGraphics
import UIKit
import Darwin

//let screenSize = UIScreen.mainScreen().bounds

var screenMode: String!

var egg = 0

let imageAtlas = SKTextureAtlas(named: "Images")

var statsArray: [NSString] = [NSString]()

var product: SKProduct!
let alert = UIAlertController(title: "That's All, Folks", message: "Thank you for playing. More levels coming soon. Please rate us on the App Store!", preferredStyle: UIAlertControllerStyle.alert)

let firstLaunch = UserDefaults.standard.bool(forKey: "FirstLaunch")

var layerPosition = CGPoint(
    x: 7,  //Grid X pos
    y: 125) //Grid Y pos

var buttons: [SKSpriteNode] = []
let screenSize = UIScreen.main.bounds

let label = SKLabelNode(fontNamed: "Microsoft Sans Serif")
let textures = ["Red", "Orange", "Yellow", "Green", "Blue", "Indigo", "Violet"]
let backButton = SKSpriteNode(texture: imageAtlas.textureNamed("back"))

var counter = 0

let adsLabel = SKLabelNode(fontNamed: "Microsoft Sans Serif")
let restorePurchases = SKLabelNode(fontNamed: "Microsoft Sans Serif")
let playLabel = SKLabelNode(fontNamed: "Microsoft Sans Serif")
let comingSoon = SKLabelNode(fontNamed: "Microsoft Sans Serif")

let overlayLayer = SKNode()
var levelProgress = UserDefaults.standard.integer(forKey: "levelProgress")
var levelSelectPointer = 0

var tutorial = false
var levelSelectMode = false
var mute = false

let click = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Click", withExtension: ".mp3")!)

var darkMode = false

let overlay = SKSpriteNode(texture: imageAtlas.textureNamed("NextLevelOverlay"))
let buttonPlay = SKSpriteNode(texture: imageAtlas.textureNamed("Button"))
let buttonAds = SKSpriteNode(texture: imageAtlas.textureNamed("Button"))
let buttonMute = SKSpriteNode(texture: imageAtlas.textureNamed("UnMute"))
let buttonDark = SKSpriteNode(texture: imageAtlas.textureNamed("DarkModeButtonLight"))
var purchased = UserDefaults.standard.bool(forKey: "purchased")

var highScore = [0]


var currentLevel: Int = 0

let modelName = UIDevice.current.modelName

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}

class NewGameScene: SKScene, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    
    
    var product_id: NSString?;
      override func didMove(to view: SKView) {

//        levelProgress = 96

        if(UIScreen.main.bounds.height == 480.0 && UIScreen.main.bounds.width == 320.0){
            print(screenSize)
            screenMode = "4s"
            
        }
        if(UIScreen.main.bounds.height == 568.0 && UIScreen.main.bounds.width == 320.0){
            print(screenSize)
            
            screenMode = "5s"
            
        }
        if(UIScreen.main.bounds.height == 667.0 && UIScreen.main.bounds.width == 375.0){
            print(screenSize)
            
            screenMode = "6"
            
        }
        if(UIScreen.main.bounds.height == 736.0 && UIScreen.main.bounds.width == 414.0){
            print(screenSize)
            
            screenMode = "6p"
            
            
        }

        if(screenMode == "4s"){
            layerPosition = CGPoint(x: layerPosition.x, y: layerPosition.y)
            backButton.xScale = 0.08
            backButton.yScale = 0.08
        }
        if(screenMode == "5s"){
            layerPosition = CGPoint(x: layerPosition.x, y: 150)
            backButton.xScale = 0.08
            backButton.yScale = 0.08
        }
        if(screenMode == "6"){
            layerPosition = CGPoint(x: layerPosition.x, y: 200)
            backButton.xScale = 0.08
            backButton.yScale = 0.08
        }
        if(screenMode == "6p"){
            layerPosition = CGPoint(x: layerPosition.x, y: 200)
            backButton.xScale = 0.08
            backButton.yScale = 0.08
        }

        egg = 0
        
        print(purchased)
        
        if(purchased){
            //hide ads!
            GameViewController().bannerView.isHidden = false
            
        }
             //label.text = String(screenSize)

        
        print(modelName)
        
        overlayLayer.removeAllChildren()
        overlayLayer.removeFromParent()
        self.addChild(overlayLayer)
        
        let invertColorNode = SKEffectNode()
        let invertColor = CIFilter(name: "CIColorInvert")
        invertColorNode.filter = invertColor
        addChild(invertColorNode)
        
        //Dark Mode: WIP
        
       // if(!darkMode){
            
//         self.backgroundColor = UIColor(red: 240/255, green: 246/255, blue: 229/255, alpha: 0.0)//old color
        self.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.0)

            label.fontColor = SKColor.black
            playLabel.fontColor = SKColor.white
            adsLabel.fontColor = SKColor.white
            
        //}
      /*  if(darkMode){
            
            invertColorNode.addChild(overlayLayer)
            /*overlay.texture = SKTexture(imageNamed: "NextLevelOverlayDark")
            buttonDark.texture = SKTexture(imageNamed: "DarkModeButtonDark")
            buttonPlay.texture = SKTexture(imageNamed: "ButtonDark")
            buttonAds.texture = SKTexture(imageNamed: "ButtonDark")
            buttonMute.texture = SKTexture(imageNamed: "UnMuteDark")*/
            
            self.backgroundColor = UIColor(red: 72/255, green: 55/255, blue: 97/255, alpha: 0.0)
            label.fontColor = SKColor.whiteColor()
            playLabel.fontColor = SKColor.blackColor()
            adsLabel.fontColor = SKColor.blackColor()
        }*/
        
        run(SKAction.wait(forDuration: 0.01), completion: {

            //introMusic.play();
            
        })
        
        if(mute){

            //introMusic.volume = 0
            
        }
        if(!mute){

            //introMusic.volume = 0.2
            
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(NewGameScene.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(NewGameScene.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view?.addGestureRecognizer(swipeLeft)
        
        //High Score: WIP
        // var highScores = NSUserDefaults.standardUserDefaults().arrayForKey("HighScores")

        print(levelProgress)
        
        if (firstLaunch) {
            print("A")
           // if let testArray : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("statsArray") {
               // statsArray = testArray as! [NSString]
             //   print(statsArray)
            
           // }
            tutorial = false
            
          /*  for _ in 1...96 {
                
                highScore.append(0)
                
            }*/
           // highScores = highScore
            //print(highScores)

        }
        
        else {
            print("B")
            
            for _ in 0..<96{
                statsArray.append(String(0) as NSString)
            }
            
            UserDefaults.standard.set(statsArray, forKey: "statsArray")
            UserDefaults.standard.set(true, forKey: "FirstLaunch")

           // print(highScores)
            
            tutorial = true

        }
        
        buttonMute.position = CGPoint(x:-65, y: -120)
        playLabel.position = CGPoint(x:0, y: 95)
        restorePurchases.position = CGPoint(x:0, y: -213)

        adsLabel.position = CGPoint(x: 0, y: -18)
        buttonPlay.position = CGPoint(x: 0, y: 110)
        buttonAds.position = CGPoint(x: 0, y: -5)

        
        let textFadeIn = SKAction.colorize(with: SKColor.yellow, colorBlendFactor: 1.0, duration: 1.0)
        let textFadeOut = SKAction.colorize(with: SKColor.white, colorBlendFactor: 1.0, duration: 1.0)
        let textSequence = SKAction.sequence([textFadeIn, textFadeOut])
        
        buttonMute.xScale = 0.1
        buttonMute.yScale = 0.1
        buttonMute.zPosition = 11
        buttonMute.name = "mute"

        label.text = "Shift."
       
        print(screenMode)
        
        if(screenMode == "4s"){
            label.position = CGPoint(x:0, y: 200)
    
            label.fontSize = 50
        }
        if(screenMode == "5s"){
            label.position = CGPoint(x:0, y: 230)

            label.fontSize = 50
        }
        if(screenMode == "6"){
            label.position = CGPoint(x:0, y: 225)
            
            label.fontSize = 100
            
        }
        if(screenMode == "6p"){
            label.position = CGPoint(x:0, y: 250)

            label.fontSize = 100
            
        }
        label.zPosition = 10
        
        restorePurchases.text = "restore purchases"
        restorePurchases.fontSize = 10
        restorePurchases.zPosition = 10
        restorePurchases.name = "restore"

        playLabel.text = "Play"
 //     playLabel.text = String(highScores![0]) + String(firstLaunch)
        playLabel.fontSize = 50;
        playLabel.zPosition = 12

        if(!purchased){
            adsLabel.text = "Remove Ads"
            adsLabel.name = "ads"
            buttonAds.name = "ads"
        //}
        }
        if(purchased){
          //  adsLabel.text = "Stats"
          //  adsLabel.name = "stats"
          //  buttonAds.name = "stats"
        }
        adsLabel.fontSize = 32;
        adsLabel.zPosition = 12

        overlay.xScale = 0.5
        overlay.yScale = 0.5
        overlayLayer.zPosition = 10
        
        buttonPlay.xScale = 0.3
        buttonPlay.yScale = 0.3
        buttonAds.xScale = 0.3
        buttonAds.yScale = 0.3
        buttonPlay.zPosition = 11
        buttonAds.zPosition = 11
        buttonPlay.name = "play"
//        buttonAds.name = "ads"
        
        playLabel.name = "play"
        adsLabel.name = "ads"
        
        label.run(textSequence)
        
        overlayLayer.position.x = screenSize.width/2
        overlayLayer.position.y = screenSize.height/2 + 600
        
        
        overlayLayer.addChild(overlay)
        overlayLayer.addChild(playLabel)
      
        overlayLayer.addChild(label)
        overlayLayer.addChild(buttonMute)
        overlayLayer.addChild(buttonPlay)

        if(!purchased) {
            overlayLayer.addChild(restorePurchases)
            overlayLayer.addChild(adsLabel)
            overlayLayer.addChild(buttonAds)
        }
            
        overlay.name = "overlay"
        overlayLayer.name = "overlayLayer"
    
        let action = SKAction.moveBy(x: 0, y: -600, duration: 0.2)
        
        let a = SKAction.moveBy(x: 0, y: 1, duration: 0.1)
        let b = SKAction.moveBy(x: 0, y: -1, duration: 0.1)
        let sequence = SKAction.sequence([action, a, b])
        
        overlayLayer.run(sequence)
    }
    
    func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right:
                
                print("Right")
                
                if(!tutorial && levelSelectMode == true){
                    
                    if(levelSelectPointer > 0){
                        levelSelectPointer -= 1
                        boardLayer.run(SKAction.moveBy(x: screenSize.width, y: 0, duration: 0.2))

                    }
                }
                
            case UISwipeGestureRecognizerDirection.left:
                
                print("Left")
                
                if(!tutorial && levelSelectMode == true){
                    
                    if(levelSelectPointer < 5){
                        
                        levelSelectPointer += 1
                        boardLayer.run(SKAction.moveBy(x: -screenSize.width, y: 0, duration: 0.2))

                    }
                    
                }
                
                default:
                break
            }
        }
    }
    
    
    func productsRequest (_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("got the request from Apple")
        print(response)
        let count : Int = response.products.count
       /* if (count>0) {
          //  let validProducts = response.products
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == self.product_id) {
                print(validProduct.localizedTitle)
                print(validProduct.localizedDescription)
                print(validProduct.price)
                buyProduct(validProduct);
            } else {
                print(validProduct.productIdentifier)
            }
        } else {
            print("Items: " + String(count))
        }*/
    }
    
    func buyProduct(_ product: SKProduct){
        print("Sending the Payment Request to Apple");
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment);
        
    }
    
    func removeAds(){
        
        purchased = true
        UserDefaults.standard.set(true, forKey: "purchased")
        print("Ads Removed")

                   print("ABC")
        sleep(3)
        restartScene()
      
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error: " + String(describing: error));
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])    {
        print("Received Payment Transaction Response from Apple");
        
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .purchased, .restored:
                    print("Product Purchased");
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    removeAds()
                    
                    break;
                case .failed:
                    print("Purchased Failed");
                    print(product)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
               // case .Restored:
                //    print("Product Restored")
                 //   SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
                  //  removeAds()
                default:
                    break;
                }
            }
        }
    }
    
    func restartScene(){
        
        print("Restarting scene")
        
        let scene = NewGameScene(size: self.size)
        scene.scaleMode = scaleMode
        self.view?.presentScene(scene, transition:  SKTransition.fade(withDuration: 0))
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        for touch in touches {

            let location = touch.location(in: self)
            
            
           // label.position = location
             //   print(location)
            

            let touchedNode = self.atPoint(location)
            
            if(touchedNode.name == "ads" && UserDefaults.standard.bool(forKey: "purchased") == false){
                click.play()
                buttonAds.run(SKAction.scale(by: 0.9, duration: 0.01))
                
                //Store().buyProduct()
                print("Ads")
                product_id = "shift.remove.ads";
                super.didMove(to: SKView())
                SKPaymentQueue.default().add(self)
                if (SKPaymentQueue.canMakePayments())
                {
                    let productID:NSSet = NSSet(object: self.product_id!);
                    let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
                    productsRequest.delegate = self;
                    productsRequest.start();
                    print("Fetching Products");
                    
                }else{
                    print("can't make purchases");
                }
                buttonAds.run(SKAction.scale(to: 0.3, duration: 0.1))

                
            }
            
            if(touchedNode.name == "play"){
                click.play()

                buttonPlay.run(SKAction.scale(by: 0.9, duration: 0.01), completion: {overlayLayer.run(SKAction.moveBy(x: 0, y: 710, duration: 0.2), completion: {self.play()})})
                boardLayer.removeAllChildren()

            }
            
            if(touchedNode.name == "back" && levelSelectMode ){
                click.play()

                levelSelectMode = false
                  //backButton.runAction(SKAction.scaleBy(0.9, duration: 0.01))
                
                self.removeAllChildren()
                overlayLayer.removeAllChildren()
                
                let scene = NewGameScene(size: self.size)
                scene.scaleMode = scaleMode
                self.view?.presentScene(scene, transition:  SKTransition.fade(withDuration: 0))
                
            }
            if(touchedNode.name == "restore"){
                click.play()
                product_id = "shift.remove.ads";
                super.didMove(to: SKView())
                SKPaymentQueue.default().add(self)
                if (SKPaymentQueue.canMakePayments())
                {
                    let productID:NSSet = NSSet(object: self.product_id!);
                    let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
                    productsRequest.delegate = self;
                    productsRequest.start();
                    print("Fetching Products");
                    
                }else{
                    print("can't make purchases");
                }

                
                print("Restored")
                
               // Store().RestorePurchases()
            
            }
            
            if(touchedNode.name == "mute" && !mute){
                click.play()
                egg += 1
                mute = true
                //introMusic.runAction(SKAction.changeVolumeTo(0, duration: 0.1))
                //introMusic.volume = 0
                if(!darkMode){
                    buttonMute.texture = SKTexture(imageNamed: "Mute")
                }
                if(darkMode){
                    buttonMute.texture = SKTexture(imageNamed: "MuteDark")
                }
                
                if(egg > 25){
                    
                    UIApplication.shared.openURL(URL(string: "https://soundcloud.com/dontevenworryaboutit")!)
                    
                }
                break
            }
            
            if(touchedNode.name == "mute" && mute){
                //introMusic.volume = 1
                egg += 1
                mute = false
                //introMusic.runAction(SKAction.changeVolumeTo(1, duration: 0.1))
                
                if(!darkMode){
                    buttonMute.texture = SKTexture(imageNamed: "UnMute")
                }
                if(darkMode){
                    buttonMute.texture = SKTexture(imageNamed: "UnMuteDark")
                }
                
                if(egg > 25){
                    
                    UIApplication.shared.openURL(URL(string: "https://soundcloud.com/dontevenworryaboutit")!)
                    
                }
                break
            }
           
            for a in 1...96{

                if(touchedNode.name != nil){
                    
                    if(touchedNode.name! == String(a) && levelProgress+1 >= a){
                        click.play()
                        

                        //touchedNode.scaleBy(scale: 0.9, duration: 0.01)
                        
                       // print(buttons)
                        
                        currentLevel = Int(a)
                        
                        overlayLayer.removeAllChildren()
                        self.removeAllChildren()
                        
                        playLabel.removeFromParent()
                        adsLabel.removeFromParent()
                        label.removeFromParent()
                       // introMusic.removeFromParent()
                        //introMusic.stop()
                        levelSelectMode = false
                    

                        let scene = GameScene(size: self.size)
                        scene.scaleMode = scaleMode
                        self.view?.presentScene(scene, transition:  SKTransition.fade(withDuration: 1))
                        
                    }
                }
            }
        }
    }
    
    func pointForColumn(_ column: Int, row: Int, board: Int) -> CGPoint {
        
            let x = CGFloat(column)*TileWidth+TileWidth/2+(screenSize.width*CGFloat(board-1))//grid position x
            var y = CGFloat(row)*TileWidth+TileWidth/2-1//grid position y
        
        if(modelName == "iPhone 5" || modelName == "iPhone 5s"){
            y -= 40
        }
        
        y -= 60

        return CGPoint(x: x, y: y)
        
    }
    

    
    func drawLevelSelectBoard(){
        
        levelSelectPointer = 0
        let a = [3, 2, 1, 0]
    
        TileWidth = (screenSize.size.width-20)/CGFloat(4) //grid size
        
        for board in 1...6{
            
            counter = (16*board)
            
            for row in 0..<4 {
                
                for column in a {

                    let tileNode = SKSpriteNode(imageNamed: "Tile")

                    if(!darkMode){
                        tileNode.texture = SKTexture(imageNamed: "Tile")
                    }
                    if(darkMode){
                        tileNode.texture = SKTexture(imageNamed: "TileDark")
                    }
                    
                    let numberLabel = SKLabelNode(fontNamed: "Ariel")
                    let cursorNode = SKSpriteNode(imageNamed: "Cursor")
                    
                    tileNode.position = pointForColumn(column, row: row, board: board)
                    
                    cursorNode.xScale = TileWidth * 0.001
                    cursorNode.yScale = TileWidth * 0.001
                    cursorNode.name = String(counter)
                    
                    tileNode.xScale = TileWidth * 0.001
                    tileNode.yScale = TileWidth * 0.001
                    tileNode.name = String(counter)
                    tileNode.zPosition = 14
                    
                    numberLabel.text = String(counter)
                    numberLabel.fontColor = SKColor.lightGray
                    numberLabel.position = pointForColumn(column, row: row, board: board)
                    numberLabel.position.y -= 17
                    numberLabel.zPosition = 15
                    numberLabel.fontSize = 45
                    numberLabel.name = String(counter)
                    
                    //boardLayer.position = CGPoint(x: layerPosition.x, y: layerPosition.y+500)
                    
                    if(counter+(16*levelSelectPointer) <= levelProgress){
                        
                        boardLayer.addChild(tileNode)
                        
                    }
                    
                    if(counter == levelProgress+1){
                        
                        tileNode.texture = SKTexture(imageNamed: "Completed")
                        numberLabel.fontColor = SKColor.yellow
                        cursorNode.position = pointForColumn(column, row: row, board: board)
                        
                        boardLayer.addChild(cursorNode)
                        
                    }
                    if(counter+(16*levelSelectPointer) > levelProgress){
                        
                        boardLayer.addChild(tileNode)
                       
                    }
                    if(counter+(16*levelSelectPointer) <= levelProgress){
                        
                        tileNode.texture = SKTexture(imageNamed: textures[counter%7])
                        numberLabel.fontColor = SKColor.black
                    }
                    
                    boardLayer.addChild(numberLabel)
                    
                    boardLayer.run(SKAction.move(to: layerPosition, duration: 0.2))
                    counter -= 1
                }
                
            }
        }
        
        backButton.name = "back"
      
        backButton.zPosition = 11
        backButton.position = CGPoint(x: 44, y: screenSize.height-75)
        run(SKAction.wait(forDuration: 0.1), completion: {
            self.addChild(backButton)
        })
    }

    func play(){
       
        addChild(boardLayer)
        
        if (tutorial){
            var volume = 1.0
            
            for _ in 1..<101 {
                
                volume += -0.01
                //introMusic.volume = Float(volume)
                
            }
            

            currentLevel = 0
            
            overlayLayer.removeAllChildren()
            self.removeAllChildren()
            
            playLabel.removeFromParent()
            adsLabel.removeFromParent()
            label.removeFromParent()
            
            let scene = GameScene(size: self.size)
            scene.scaleMode = scaleMode
            let reveal = SKTransition.fade(withDuration: 0.5)
            self.view?.presentScene(scene, transition: reveal)
        }
        
        if (!tutorial){
            levelSelectMode = true

            drawLevelSelectBoard()


        }
        
        
    }

}
