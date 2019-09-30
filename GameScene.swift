//
//  GameScene.swift
//  FlappyBird
//
//  Created by Addison Chen on 8/31/19.
//  Copyright © 2019 Addison Chen. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var bird = Bird(height: 0, velY: 0)
    var pipes = [Pipe]()
    var time = 0
    var util = Utils()
    
    
    let tapRec = UITapGestureRecognizer()
    
    
    override func didMove(to view: SKView) {
        
        bird = util.initGenerateBird(height: self.frame.height)
        pipes.append(util.initGeneratePipe(height: self.frame.height, width: self.frame.width))
        //TODO
        
        backgroundColor = SKColor.init(red: 1.0, green: 0.78, blue: 0.46, alpha: 0.2)
        
        tapRec.addTarget(self, action:#selector(GameScene.tappedView(_:) ))
        tapRec.numberOfTouchesRequired = 1
        tapRec.numberOfTapsRequired = 1
        self.view!.addGestureRecognizer(tapRec)
        
        self.addChild(bird.drawBird())
        self.addChild(pipes[0].drawPipe())
        
    }
    

    // tap handler
    @objc
    func tappedView(_ sender:UITapGestureRecognizer) {
        bird.flap()
    }

    // update the current game
    override func update(_ currentTime: TimeInterval) {
        //logic
        for pipe in pipes {
            pipe.updatePipe()
        }
        //bird.updateBird()
        
        time += 1
        
        if time == 60 {
            time = 0
            pipes.append(util.initGeneratePipe(height: self.frame.height, width: self.frame.width))
        }
        
        if pipes[0].midX < -50 {
            pipes.remove(at: 0)
        }
        
        
        
        // images
        for child in self.children {
            child.removeFromParent()
        }
        
        let birdImg = bird.drawBird()
        
        self.addChild(birdImg)
        
        var pipeImg: SKSpriteNode
        
        for pipe in pipes {
            pipeImg = pipe.drawPipe()
            self.addChild(pipeImg)
        }
        
    }
}

// represents an obstable
class Pipe {
    var height: CGFloat
    var midX: CGFloat
    
    init(height: CGFloat, midX: CGFloat) {
        self.height = height
        self.midX = midX
    }
    
    public func updatePipe() {
        self.midX -= 5
    }
    
    public func drawPipe() -> SKSpriteNode {
        var pipeImgBottom: SKSpriteNode
        var pipeImgTop: SKSpriteNode
        
        pipeImgBottom = SKSpriteNode(imageNamed: "pipeBottom")
        pipeImgTop = SKSpriteNode(imageNamed: "pipeTop")
        
        //pipeImgBottom?.position = CGPoint(x: midX, y: CGFloat)
        
        pipeImgBottom.addChild(pipeImgTop)
        
        return pipeImgBottom
    
    }


}

// represents the player
class Bird {
    var height: CGFloat
    var velY: CGFloat
    
    init(height: CGFloat, velY: CGFloat) {
        self.height = height
        self.velY = velY
    }
    
    public func flap() {
        self.velY += 10
    }
    
    public func updateBird() {
        self.velY -= 1
        self.height -= self.velY
    }
    
    public func drawBird() -> SKSpriteNode {
        let birdImg = SKSpriteNode(imageNamed: "turtle")
        
        birdImg.position = CGPoint(x: 200, y: 200)
        
        return birdImg
    }

}

// utility class
class Utils {
    
    func initGenerateBird(height: CGFloat) -> Bird {
        return Bird(height: height / 2, velY: 0)
    }
    
    func initGeneratePipe(height: CGFloat, width: CGFloat) -> Pipe {
        let num = CGFloat.random(in: -150 ... 150)
        return Pipe(height: (height / 2) + num, midX: width + 40)
    }
}
