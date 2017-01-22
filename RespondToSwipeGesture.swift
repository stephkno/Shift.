//
//  RespondToSwipeGesture.swift
//  Shift.
//
//  Created by Stephen on 1/17/16.
//  Copyright © 2016 Wedjat. All rights reserved.
//

import Foundation
import SpriteKit

//let pause = SKAction.waitForDuration(0)

class swiped {

    
    func swipedDown(){
        let nc = NumColumns - 1

        for x in stride(from: nc, to: -1, by: -1){
            for y in stride(from: 0, to: NumColumns, by: 1){
                print(NumColumns)
                for player in players{
                    
                    if(canMove[player.name!] == true){
                        
                        count = 1
                      
                        //player.runAction(pause)
                        
                        if(world[y][x] == player.name){  //if found player tile
                            
                            if(y > 0){
                                
                                if(world[y-1][x] == "T" || world[y-1][x] == "1" || world[y-1][x] == "2" || world[y-1][x] == "3" || world[y-1][x] == "4" || world[y-1][x] == "5" || world[y-1][x] == "6" || world[y-1][x] == "7"){   //if tile to right is empty
                                   
                                   // Movement().moveDown(y, x: x, player: player)
                                    if(levels().Level[currentLevel]![y][x] == "I"){
                                        
                                        world[y][x] = levels().Level[currentLevel]![y][x]
                                        
                                    }
                                    else{
                                        
                                        world[y][x] = "T"
                                        
                                    }
                                    world[y-1][x] = player.name!  // move to right
                                    
                                    let action = SKAction.moveBy(x: 0, y: -TileWidth, duration: TimeInterval(Double(count)*0.08))
                                    let a = SKAction.moveBy(x: 0, y: 6, duration: 0.08)
                                    let b = SKAction.moveBy(x: 0, y: -6, duration: 0.08)
                                    let moveWithBounce = SKAction.sequence  ([action, a, b])
                                    
                                    player.run(moveWithBounce, completion:{Tiles().checkTiles(player)})

                                }
                            }
                            
                            if(y > 0 && world[y-1][x] == "I"){
                                
                                
                                count = 1
                                
                                while(y-count > 0 && world[y-count][x] == "I"){
                                    
                                    count += 1
                                    
                                }
                                
                                if(y-count < 0 || world[y-count][x] == "W"){
                                    
                                    count -= 1
                                    
                                }
                                
                                for p in players{
                                    
                                    if(world[y-count][x] == p.name){
                                        
                                        count -= 1
                                        
                                        break
                                        
                                    }
                                    
                                }
                                
                                if(levels().Level[currentLevel]![y][x] == "I"){
                                    
                                    world[y][x] = levels().Level[currentLevel]![y][x]
                                    
                                }
                                else{
                                    
                                    world[y][x] = "T"
                                    
                                }
                                
                                world[y-count][x] = player.name!
                                
                                
                                let action = SKAction.moveBy(x: 0, y: CGFloat(-count)*TileWidth, duration: TimeInterval(Double(count)*0.08))
                                let a = SKAction.moveBy(x: 0, y: 6, duration: 0.08)
                                let b = SKAction.moveBy(x: 0, y: -6, duration: 0.08)
                                let moveWithBounce = SKAction.sequence([action, a, b])
                                player.run(moveWithBounce, completion:{Tiles().checkTiles(player)})
                                
                            }
                            
                        }
                        if(y <= 0){
                            let a = SKAction.moveBy(x: 0, y: -1, duration: 0.08)
                            let b = SKAction.moveBy(x: 0, y: 1, duration: 0.08)
                            let bounceDown = SKAction.sequence([a, b])
                            player.run(bounceDown, completion:{Tiles().checkTiles(player)})
                            
                        }
                        
                    }
                    

                }
                
            }
            
        }

    }
    
    func swipedUp(){
  
        let nc = NumColumns - 1
        for x in stride(from: nc, to: -1, by: -1){
          for y in stride(from: nc, to: -1, by: -1){ //Range(0...NumColumns){
                print(x, y)

                for player in players{
    
                    count = 1
    
                    if(canMove[player.name!] == true){
    
                        if(world[y][x] == player.name){  //if found player tile
    
                            if(y < nc){
    
                                
                                if(world[y+1][x] == "T" || world[y+1][x] == "1" || world[y+1][x] == "2" || world[y+1][x] == "3" || world[y+1][x] == "4" || world[y+1][x] == "5" || world[y+1][x] == "6" || world[y+1][x] == "7"){   //if tile to right is empty
                                    
                                    //Movement().moveUp(y, x: x, player: player)
                                    if(levels().Level[currentLevel]![y][x] == "I"){
                                        
                                        world[y][x] = levels().Level[currentLevel]![y][x]
                                    }
                                    else{
                                        
                                        world[y][x] = "T"
                                        
                                    }
                                    world[y+1][x] = player.name!  // move up
                                    
                                    let action = SKAction.moveBy(x: 0, y: TileWidth, duration: TimeInterval(Double(count)*0.08))
                                    let a = SKAction.moveBy(x: 0, y: -6, duration: 0.08)
                                    let b = SKAction.moveBy(x: 0, y: 6, duration: 0.08)
                                    let moveWithBounce = SKAction.sequence([action, a, b])
                                    player.run(moveWithBounce, completion:{Tiles().checkTiles(player)})

                                }
                            }
                            
                            if(y < nc && world[y+1][x] == "I"){
    
                                
                                count = 1
                                
                                while(y+count < nc && world[y+count][x] == "I"){
    
                                    count += 1
    
                                }
    
                                if(y+count > nc || world[y+count][x] == "W"){
    
                                    count -= 1
    
                                }
    
                                for p in players{
    
                                    if(world[y+count][x] == p.name){
                                        count -= 1
                                        break
                                    }
                                }
                                
                                if(levels().Level[currentLevel]![y][x] == "I"){
    
                                    world[y][x] = levels().Level[currentLevel]![y][x]
    
                                }
                                else{
                                    
                                    world[y][x] = "T"
                                    
                                }
    
                                world[y+count][x] = player.name!
    
                                let action = SKAction.moveBy(x: 0, y: CGFloat(count)*TileWidth, duration: TimeInterval(Double(count)*0.08))
                                let a = SKAction.moveBy(x: 0, y: -6, duration: 0.08)
                                let b = SKAction.moveBy(x: 0, y: 6, duration: 0.08)
                                let moveWithBounce = SKAction.sequence([action, a, b])
                                player.run(moveWithBounce, completion:{Tiles().checkTiles(player)})
    
                            }
    
                        }
                        if(y >= nc){
                            let a = SKAction.moveBy(x: 0, y: 1, duration: 0.08)
                            let b = SKAction.moveBy(x: 0, y: -1, duration: 0.08)
                            let moveWithBounce = SKAction.sequence([a, b])
                            player.run(moveWithBounce, completion:{Tiles().checkTiles(player)})
    
                        }
                    }
    
                }
    
            }
    
        }
    
    
    }
    
    func swipedLeft(){

     
        
        let nc = NumColumns - 1
        
        for x in stride(from: 0, to: NumColumns, by: 1){
            for y in stride(from: nc, to: -1, by: -1){
                //print(NumColumns)

                for player in players {  //for each player
    
    
                    if(canMove[player.name!] == true){
    
                        count = 1
    
                        if(world[y][x] == player.name){  //if found player tile
    
    
                            if(x > 0){
    
                                if(world[y][x-1] == "T" || world[y][x-1] == "1" || world[y][x-1] == "2" || world[y][x-1] == "3" || world[y][x-1] == "4" || world[y][x-1] == "5" || world[y][x-1] == "6" || world[y][x-1] == "7"){ //if tile to right is empty
    
                                   // Movement().moveLeft(y, x: x, player: player)
                                    if(levels().Level[currentLevel]![y][x] == "I"){
                                        
                                        world[y][x] = levels().Level[currentLevel]![y][x]
                                        
                                    }
                                    else{
                                        
                                        world[y][x] = "T"
                                        
                                    }
                                    world[y][x-1] = player.name!  // move to right
                                    
                                    let action = SKAction.moveBy(x: -TileWidth, y: 0, duration: TimeInterval(Double(count)*0.08))
                                    let a = SKAction.moveBy(x: 6, y: 0, duration: 0.08)
                                    let b = SKAction.moveBy(x: -6, y: 0, duration: 0.08)
                                    let moveWithBounce = SKAction.sequence([action, a, b])
                                    player.run(moveWithBounce, completion:{Tiles().checkTiles(player)})
                                }
                            }
    
                            if(x > 0 && world[y][x-1] == "I"){
    
                                count = 1
    
                                while(x-count > 0 && world[y][x-count] == "I"){
    
                                    count += 1
    
                                }
    
                                if(x-count < 0 || world[y][x-count] == "W"){
    
                                    count -= 1
    
                                }
    
                                for p in players{
    
                                    if(world[y][x-count] == p.name){
    
                                        count -= 1
    
                                        break
    
                                    }
    
                                }
    
                                if(levels().Level[currentLevel]![y][x] == "I"){
    
                                    world[y][x] = levels().Level[currentLevel]![y][x]
    
                                }
                                else{
    
                                    world[y][x] = "T"
    
                                }
    
                                world[y][x-count] = player.name!
    
                                let action = SKAction.moveBy(x: CGFloat(-count)*TileWidth, y: 0, duration: TimeInterval(Double(count)*0.08))
                                let a = SKAction.moveBy(x: 6, y: 0, duration: 0.08)
                                let b = SKAction.moveBy(x: -6, y: 0, duration: 0.08)
                                let moveWithBounce = SKAction.sequence([action, a, b])
                                player.run(moveWithBounce, completion:{Tiles().checkTiles(player)})
    
                            }
    
                        }
                        if(x <= 0){
                            print("LB")
                            let a = SKAction.moveBy(x: -1, y: 0, duration: 0.08)
                            let b = SKAction.moveBy(x: 1, y: 0, duration: 0.08)
                            let moveWithBounce = SKAction.sequence([a, b])
                            player.run(moveWithBounce, completion:{Tiles().checkTiles(player)})
    
                        }
    
                    }
                }
    
            }
    
        }
    }
    
    func swipedRight(){

        let nc = NumColumns - 1
        
        for x in stride(from: nc, to: -1, by: -1){
            for y in stride(from: nc, to: -1, by: -1){
                
        //for x in Range(NumColumns..<0){
          //  for y in NumColumns.stride(to: 0, by: -1){
                print(NumColumns)

                for player in players {  //for each player
                    
                    
                    if(canMove[player.name!] == true){
                        
                        count = 1
                        
                        if(world[y][x] == player.name){  //if found player tile
                            
                            if(x < nc){
                                
                                if(world[y][x+1] == "T" || world[y][x+1] == "1" || world[y][x+1] == "2" || world[y][x+1] == "3" || world[y][x+1] == "4" || world[y][x+1] == "5" || world[y][x+1] == "6" || world[y][x+1] == "7"){ //if tile to right is empty
                                    
                                   // Movement().moveRight(y, x: x, player: player)
                                    if(levels().Level[currentLevel]![y][x] == "I"){
                                        
                                        world[y][x] = levels().Level[currentLevel]![y][x]
                                        
                                    }
                                    else{
                                        
                                        world[y][x] = "T"
                                        
                                    }
                                    world[y][x+1] = player.name!  // move to right
                                    
                                    let action = SKAction.moveBy(x: TileWidth, y: 0, duration:
                                        TimeInterval(Double(count)*0.08))
                                    
                                    let a = SKAction.moveBy(x: -6, y: 0, duration: 0.08)
                                    
                                    let b = SKAction.moveBy(x: 6, y: 0, duration: 0.08)
                                    
                                    let moveWithBounce = SKAction.sequence([action, a, b])
                                    
                                    player.run(moveWithBounce, completion:{Tiles().checkTiles(player)})
                                }
                            }
                            
                            if(x < nc && world[y][x+1] == "I"){
                                
                                count = 1
                                
                                while(x+count < nc && world[y][x+count] == "I"){
                                    
                                    count += 1
                                    
                                }
                                
                                if(x-count > nc || world[y][x+count] == "W"){
                                    
                                    count -= 1
                                    
                                }
                                
                                for p in players{
                                    
                                    if(world[y][x+count] == p.name){
                                        
                                        count -= 1
                                        
                                        break
                                        
                                    }
                                    
                                }
                                
                                if(levels().Level[currentLevel]![y][x] == "I"){
                                    
                                    world[y][x] = levels().Level[currentLevel]![y][x]
                                    
                                }
                                else{
                                    
                                    world[y][x] = "T"
                                    
                                }
                                
                                world[y][x+count] = player.name!
                                
                                let action = SKAction.moveBy(x: CGFloat(count)*TileWidth, y: 0, duration: TimeInterval(Double(count)*0.08))
                                                                let moveWithBounce = SKAction.sequence([action])
                                player.run(moveWithBounce, completion:{Tiles().checkTiles(player)})
                                
                            }
                            
                        }
                        if(x >= nc){
                            let a = SKAction.moveBy(x: 1, y: 0, duration: 0.08)
                            let b = SKAction.moveBy(x: -1, y: 0, duration: 0.08)
                            let moveWithBounce = SKAction.sequence([a, b])
                            print("RB")
                            player.run(moveWithBounce, completion:{Tiles().checkTiles(player)})
                            
                        }
                        
                    }
                }
                
            }
            
        }
    
    }

}
