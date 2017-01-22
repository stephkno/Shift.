//
//  Tiles.swift
//  Shift.
//
//  Created by Stephen on 1/15/16.
//  Copyright © 2016 Wedjat. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

var x: CGFloat!
var y: CGFloat!

var once = false

var blooped = false

let masterTiles = ["redNode", "orangeNode", "yellowNode", "greenNode", "blueNode", "indigoNode", "violetNode"]

var tiles = ["redNode", "orangeNode", "yellowNode", "greenNode", "blueNode", "indigoNode", "violetNode"]

var drawTiles = [""]

class Tiles {

    //itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(APP_ID)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1)"
    
    func checkWin(){

        for i in world{
        print(i)
        }
        if(!win){
            
            win = true
            
            print(players)
            
            for p in 0..<players.count {
                
                
                if (p < canMove.count && canMove[colors[p]] == true){
                    
                    win = false
                    
                }
                
            }
            
            //(canMove)
            
            if(win && !menu && !once){

                if(currentLevel >= levelProgress){
                    
                    /*if score > highScore[currentLevel]{
                        highScore[currentLevel] = score
                    }*/
                    
                    if(levelProgress < 96){
                        levelProgress += 1
                    }
                    
                    if(currentLevel == 96){
                    
                    //    let alert = UIAlertControllerStyle(rawValue: 0)
                        
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (a) -> Void in
                            // User tapped 'cancel', so do nothing
                        })
                        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.destructive, handler: { (a) -> Void in
                            // User confirmed, go nuts.
                        })
                        
                        alert.addAction(cancelAction)
                        alert.addAction(confirmAction)
                        
                        GameScene().view?.window?.rootViewController?.present(alert, animated: true, completion: { () -> Void in
                            
                            //Reset Game
                            GameScene().quitLevel()
                            
                        })
                        
                    }
                    
                    UserDefaults.standard.set(levelProgress, forKey: "levelProgress")
                
                }
                
                overlayLayer.removeAllChildren()
                
                once = true
                nextLabel.fontColor = SKColor.black
                nextLabel.text = "Next Level"
                nextLabel.fontSize = 38;
                nextLabel.position = CGPoint(x:0, y: 108)
                nextLabel.zPosition = 12
                nextLabel.fontColor = SKColor.white
                nextLabel.name = "next"
                
                menuLabel.fontColor = SKColor.black
                menuLabel.text = "Main Menu"
                menuLabel.fontSize = 34;
                menuLabel.position = CGPoint(x:0, y: -10)
                menuLabel.zPosition = 12
                menuLabel.fontColor = SKColor.white
                menuLabel.name = "menu"
                
                replayLabel.fontColor = SKColor.black
                replayLabel.text = "Replay"
                replayLabel.fontSize = 34;
                replayLabel.position = CGPoint(x:0, y: -130)
                replayLabel.zPosition = 12
                replayLabel.fontColor = SKColor.white
                replayLabel.name = "replay"
        
                overlay.removeFromParent()
                overlay.xScale = 0.5
                overlay.yScale = 0.5
                buttonPlay.xScale = 0.3
                buttonPlay.yScale = 0.3
                buttonAds.xScale = 0.3
                buttonAds.yScale = 0.3
                buttonReplay.xScale = 0.3
                buttonReplay.yScale = 0.3
                
                buttonPlay.position = CGPoint(x: 0, y: 120)
                buttonReplay.position = CGPoint(x: 0, y: -120)
                buttonAds.position = CGPoint(x: 0, y: 0)
                
                buttonPlay.zPosition = 11
                buttonReplay.zPosition = 11
                buttonReplay.removeFromParent()
                buttonAds.zPosition = 11
                buttonPlay.removeFromParent()
                buttonAds.removeFromParent()

                overlayLayer.addChild(buttonPlay)
                overlayLayer.addChild(buttonAds)
                overlayLayer.addChild(buttonReplay)

                overlayLayer.addChild(menuLabel)
                overlayLayer.addChild(replayLabel)
                overlayLayer.addChild(nextLabel)
                overlayLayer.addChild(overlay)

                let action = SKAction.move(to: CGPoint(x: screenSize.width/2, y: screenSize.height/2), duration: 0.2)
                let a = SKAction.moveBy(x: 0, y: 1, duration: 0.1)
                let b = SKAction.moveBy(x: 0, y: -1, duration: 0.1)
                let sequence = SKAction.sequence([action, a, b])
                overlayLayer.run(sequence)
                
            }
        }
    }
    

    func checkTiles(_ player: SKSpriteNode){
                
        let x = Int(player.position.x/TileWidth)
        let y = Int(player.position.y/TileWidth+1)
        
        if(levels().Level[currentLevel]![y][x] == "1" && player.name! == "A"){
            
            let fade = SKAction.fadeOut(withDuration: 0.50)
            let expand = SKAction.scale(by: 100, duration: 100)
            redTargetNode.run(fade, completion: {self.checkWin()})
            redTargetNode.run(expand)
            
            canMove["A"] = false
            if(!blooped){
                bloop.play();
                blooped = true
            }
            
                print(x, y)
            
        }
        if(levels().Level[currentLevel]![y][x] == "2" && player.name! == "B"){
            //
            let fade = SKAction.fadeOut(withDuration: 0.50)
            let expand = SKAction.scale(by: 100, duration: 100)
            orangeTargetNode.run(fade, completion: {self.checkWin()})
            orangeTargetNode.run(expand)
            
            canMove["B"] = false//move all of these up there ^^^
            if(!blooped){
                bloop.play();
                blooped = true
            }
            
        }
        if(levels().Level[currentLevel]![y][x] == "3" && player.name! == "C"){
            
            let fade = SKAction.fadeOut(withDuration: 0.50)
            let expand = SKAction.scale(by: 100, duration: 100)
            yellowTargetNode.run(fade, completion: {self.checkWin()})
            yellowTargetNode.run(expand)
            
            canMove["C"] = false
            if(!blooped){
                bloop.play();
                blooped = true
            }
        }
        if(levels().Level[currentLevel]![y][x] == "4" && player.name! == "D"){
            
            let fade = SKAction.fadeOut(withDuration: 0.50)
            let expand = SKAction.scale(by: 100, duration: 100)
            greenTargetNode.run(fade, completion: {self.checkWin()})
            greenTargetNode.run(expand)
            
            canMove["D"] = false
            if(!blooped){
                bloop.play();
                blooped = true
            }
        }
        if(levels().Level[currentLevel]![y][x] == "5" && player.name! == "E"){
            
            let fade = SKAction.fadeOut(withDuration: 0.50)
            let expand = SKAction.scale(by: 100, duration: 100)
            blueTargetNode.run(fade, completion: {self.checkWin()})
            blueTargetNode.run(expand)
            canMove["E"] = false
            if(!blooped){
                bloop.play();
                blooped = true
            }
        }
        if(levels().Level[currentLevel]![y][x] == "6" && player.name! == "F"){
            
            let fade = SKAction.fadeOut(withDuration: 0.50)
            let expand = SKAction.scale(by: 100, duration: 100)
            indigoTargetNode.run(fade, completion: {self.checkWin()})
            indigoTargetNode.run(expand)
            
            canMove["F"] = false
            if(!blooped){
                bloop.play();
                blooped = true
            }
            
        }
        if(levels().Level[currentLevel]![y][x] == "7" && player.name! == "G"){
            
            let fade = SKAction.fadeOut(withDuration: 0.50)
            let expand = SKAction.scale(by: 100, duration: 100)
            violetTargetNode.run(fade, completion: {self.checkWin()})
            violetTargetNode.run(expand)
            
            canMove["G"] = false
            if(!blooped){
                bloop.play();
                blooped = true
            }
            
        }
        
        
    }

    func pointForColumn(_ column: Int, row: Int) -> CGPoint {
        
        let x = CGFloat(column)*TileWidth+TileWidth/2//grid position x
        var y = CGFloat(row)*TileWidth+TileWidth/2-1//grid position y
        
        if(modelName == "iPhone 5" || modelName == "iPhone 5s"){
            y -= 40
        }
        if(modelName == "iPhone 4" || modelName == "iPhone 4s"){
            
        }
        
        y -= 70
        
        return CGPoint(x: x, y: y)
        
    }

    func addTiles(_ a: Int) {
    
        boardLayer.removeAllChildren()
        if(screenMode == "4s"){
            boardLayer.position = CGPoint(x: layerPosition.x, y: layerPosition.y)
            //restartButton.scale = 10
        }
        if(screenMode == "5s"){
            boardLayer.position = CGPoint(x: layerPosition.x, y: layerPosition.y)
        }
        if(screenMode == "6"){
            boardLayer.position = CGPoint(x: layerPosition.x, y: layerPosition.y)
        }
        if(screenMode == "6p"){
            boardLayer.position = CGPoint(x: layerPosition.x, y: layerPosition.y)
        }
        
        
        TileWidth = (screenSize.size.width-20)/CGFloat(NumColumns) //grid size
        
        for row in 0..<NumColumns {
            
            for column in 0..<NumColumns {
                
                if(levels().Level[currentLevel]![row][column] == "T"){
                    let tileNode = SKSpriteNode(texture: imageAtlas.textureNamed("Tile"))
                    
                   /* if(!darkMode){
                        tileNode.texture = SKTexture(imageNamed: "Tile")
                    }
                    if(darkMode){
                        tileNode.texture = SKTexture(imageNamed: "TileDark")
                    }*/
                    tileNode.position = pointForColumn(column, row: row)
                    tileNode.xScale = TileWidth * 0.001
                    tileNode.yScale = TileWidth * 0.001
                    tileNode.name = String(row) + "x" + String(column)
                    
                    boardLayer.addChild(tileNode)
                }
                if(levels().Level[currentLevel]![row][column] == "W"){
                    let wallNode = SKSpriteNode(texture: imageAtlas.textureNamed("Wall"))
                    
                    
                    wallNode.position = pointForColumn(column, row: row)
                    wallNode.xScale = TileWidth * 0.001
                    wallNode.yScale = TileWidth * 0.001
                    wallNode.name = String(row) + "x" + String(column)
                    
                    boardLayer.addChild(wallNode)
                }
                
                if(levels().Level[currentLevel]![row][column] == "I"){
                    let iceNode = SKSpriteNode(texture: imageAtlas.textureNamed("Ice"))
                    
                    iceNode.position = pointForColumn(column, row: row)
                    iceNode.xScale = TileWidth * 0.001
                    iceNode.yScale = TileWidth * 0.001
                    
                    iceNode.name = String(row) + "x" + String(column)
                    
                    boardLayer.addChild(iceNode)
                }
                if(levels().Level[currentLevel]![row][column] == "1"){
                    redTargetNode = SKSpriteNode(texture: imageAtlas.textureNamed("RedTarget"))
                    
                    redTargetNode.position = pointForColumn(column, row: row)
                    redTargetNode.xScale = TileWidth * 0.001
                    redTargetNode.yScale = TileWidth * 0.001
                    redTargetNode.name = String(row) + "x" + String(column)
                    redTargetNode.zPosition = 5
                    
                    boardLayer.addChild(redTargetNode)
                    
                }
                if(levels().Level[currentLevel]![row][column] == "2"){
                    
                    orangeTargetNode = SKSpriteNode(texture: imageAtlas.textureNamed("OrangeTarget"))
                    
                    orangeTargetNode.position = pointForColumn(column, row: row)
                    orangeTargetNode.xScale = TileWidth * 0.001
                    orangeTargetNode.yScale = TileWidth * 0.001
                    orangeTargetNode.name = String(row) + "x" + String(column)
                    orangeTargetNode.zPosition = 5
                    
                    boardLayer.addChild(orangeTargetNode)
                    
                }
                if(levels().Level[currentLevel]![row][column] == "3"){
                    
                    yellowTargetNode = SKSpriteNode(texture: imageAtlas.textureNamed("YellowTarget"))
                    
                    yellowTargetNode.position = pointForColumn(column, row: row)
                    yellowTargetNode.xScale = TileWidth * 0.001
                    yellowTargetNode.yScale = TileWidth * 0.001
                    yellowTargetNode.name = String(row) + "x" + String(column)
                    yellowTargetNode.zPosition = 5
                    
                    boardLayer.addChild(yellowTargetNode)
                    
                }

                
                if(levels().Level[currentLevel]![row][column] == "4"){
                    
                    greenTargetNode = SKSpriteNode(texture: imageAtlas.textureNamed("GreenTarget"))
                    
                    greenTargetNode.position = pointForColumn(column, row: row)
                    greenTargetNode.xScale = TileWidth * 0.001
                    greenTargetNode.yScale = TileWidth * 0.001
                    greenTargetNode.name = String(row) + "x" + String(column)
                    greenTargetNode.zPosition = 5
                    
                    boardLayer.addChild(greenTargetNode)
                    
                }
                if(levels().Level[currentLevel]![row][column] == "5"){
                    
                    blueTargetNode = SKSpriteNode(texture: imageAtlas.textureNamed("BlueTarget"))
                    
                    blueTargetNode.position = pointForColumn(column, row: row)
                    blueTargetNode.xScale = TileWidth * 0.001
                    blueTargetNode.yScale = TileWidth * 0.001
                    blueTargetNode.name = String(row) + "x" + String(column)
                    blueTargetNode.zPosition = 5
                    
                    boardLayer.addChild(blueTargetNode)
                    
                }
                if(levels().Level[currentLevel]![row][column] == "6"){
                    
                    indigoTargetNode = SKSpriteNode(texture: imageAtlas.textureNamed("IndigoTarget"))
                    
                    indigoTargetNode.position = pointForColumn(column, row: row)
                    indigoTargetNode.xScale = TileWidth * 0.001
                    indigoTargetNode.yScale = TileWidth * 0.001
                    indigoTargetNode.name = String(row) + "x" + String(column)
                    indigoTargetNode.zPosition = 5
                    
                    boardLayer.addChild(indigoTargetNode)
                    
                }
                if(levels().Level[currentLevel]![row][column] == "7"){
                    
                    violetTargetNode = SKSpriteNode(texture: imageAtlas.textureNamed("VioletTarget"))
                    
                    violetTargetNode.position = pointForColumn(column, row: row)
                    violetTargetNode.xScale = TileWidth * 0.001
                    violetTargetNode.yScale = TileWidth * 0.001
                    violetTargetNode.name = String(row) + "x" + String(column)
                    violetTargetNode.zPosition = 5
                    
                    boardLayer.addChild(violetTargetNode)
                    
                }
                
                if(levels().Level[currentLevel]![row][column] == "A"){
                    
                    let tileNode = SKSpriteNode(texture: imageAtlas.textureNamed("Tile"))
                    
                    tileNode.position = pointForColumn(column, row: row)
                    tileNode.xScale = TileWidth * 0.001
                    tileNode.yScale = TileWidth * 0.001
                    tileNode.name = String(row) + "x" + String(column)
                    
                    boardLayer.addChild(tileNode)
                    
                    redNode.position = pointForColumn(column, row: row)
                    redNode.xScale = TileWidth * 0.001
                    redNode.yScale = TileWidth * 0.001
                    redNode.name = "A"
                    
                    boardLayer.addChild(redNode)
                    
                    redNode.zPosition = 6
                    
                    players.append(redNode)
                    
                }
                if(levels().Level[currentLevel]![row][column] == "B"){
                    
                    let tileNode = SKSpriteNode(texture: imageAtlas.textureNamed("Tile"))
                    
                    tileNode.position = pointForColumn(column, row: row)
                    tileNode.xScale = TileWidth * 0.001
                    tileNode.yScale = TileWidth * 0.001
                    tileNode.name = String(row) + "x" + String(column)
                    
                    boardLayer.addChild(tileNode)
                    
                    orangeNode.position = pointForColumn(column, row: row)
                    orangeNode.xScale = TileWidth * 0.001
                    orangeNode.yScale = TileWidth * 0.001
                    orangeNode.name = "B"
                    
                    boardLayer.addChild(orangeNode)
                    
                    orangeNode.zPosition = 6
                    
                    players.append(orangeNode)
                    
                    
                }
                if(levels().Level[currentLevel]![row][column] == "C"){
                    
                    let tileNode = SKSpriteNode(texture: imageAtlas.textureNamed("Tile"))
                    
                    tileNode.position = pointForColumn(column, row: row)
                    tileNode.xScale = TileWidth * 0.001
                    tileNode.yScale = TileWidth * 0.001
                    tileNode.name = String(row) + "x" + String(column)
                    
                    boardLayer.addChild(tileNode)
                    
                    yellowNode.position = pointForColumn(column, row: row)
                    yellowNode.xScale = TileWidth * 0.001
                    yellowNode.yScale = TileWidth * 0.001
                    yellowNode.name = "C"
                    
                    boardLayer.addChild(yellowNode)
                    
                    yellowNode.zPosition = 6
                    
                    players.append(yellowNode)
                    
                    
                }
                if(levels().Level[currentLevel]![row][column] == "D"){
                    
                    let tileNode = SKSpriteNode(texture: imageAtlas.textureNamed("Tile"))
                    
                    tileNode.position = pointForColumn(column, row: row)
                    tileNode.xScale = TileWidth * 0.001
                    tileNode.yScale = TileWidth * 0.001
                    tileNode.name = String(row) + "x" + String(column)
                    
                    boardLayer.addChild(tileNode)
                    
                    greenNode.position = pointForColumn(column, row: row)
                    greenNode.xScale = TileWidth * 0.001
                    greenNode.yScale = TileWidth * 0.001
                    greenNode.name = "D"
                    
                    boardLayer.addChild(greenNode)
                    
                    greenNode.zPosition = 6
                    
                    players.append(greenNode)
                    
                    
                }
                if(levels().Level[currentLevel]![row][column] == "E"){
                    
                    let tileNode = SKSpriteNode(texture: imageAtlas.textureNamed("Tile"))
                    
                    tileNode.position = pointForColumn(column, row: row)
                    tileNode.xScale = TileWidth * 0.001
                    tileNode.yScale = TileWidth * 0.001
                    tileNode.name = String(row) + "x" + String(column)
                    
                    boardLayer.addChild(tileNode)
                    
                    blueNode.position = pointForColumn(column, row: row)
                    blueNode.xScale = TileWidth * 0.001
                    blueNode.yScale = TileWidth * 0.001
                    blueNode.name = "E"
                    
                    boardLayer.addChild(blueNode)
                    
                    blueNode.zPosition = 6
                    
                    players.append(blueNode)
                    
                    
                }
                if(levels().Level[currentLevel]![row][column] == "F"){
                    
                    let tileNode = SKSpriteNode(texture: imageAtlas.textureNamed("Tile"))
                    
                    tileNode.position = pointForColumn(column, row: row)
                    tileNode.xScale = TileWidth * 0.001
                    tileNode.yScale = TileWidth * 0.001
                    tileNode.name = String(row) + "x" + String(column)
                    
                    boardLayer.addChild(tileNode)
                    
                    indigoNode.position = pointForColumn(column, row: row)
                    indigoNode.xScale = TileWidth * 0.001
                    indigoNode.yScale = TileWidth * 0.001
                    indigoNode.name = "F"
                    
                    boardLayer.addChild(indigoNode)
                    
                    indigoNode.zPosition = 6
                    
                    players.append(indigoNode)
                    
                }
                if(levels().Level[currentLevel]![row][column] == "G"){
                    
                    let tileNode = SKSpriteNode(texture: imageAtlas.textureNamed("Tile"))
                    
                    tileNode.position = pointForColumn(column, row: row)
                    tileNode.xScale = TileWidth * 0.001
                    tileNode.yScale = TileWidth * 0.001
                    tileNode.name = String(row) + "x" + String(column)
                    
                    boardLayer.addChild(tileNode)
                    
                    violetNode.position = pointForColumn(column, row: row)
                    violetNode.xScale = TileWidth * 0.001
                    violetNode.yScale = TileWidth * 0.001
                    violetNode.name = "G"
                    
                    boardLayer.addChild(violetNode)
                    
                    violetNode.zPosition = 6
                    
                    players.append(violetNode)
                    
                }

            }
        }
    }
}
