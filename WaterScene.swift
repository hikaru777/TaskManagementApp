//
//  WaterScene.swift
//  
//
//  Created by 本田輝 on 2024/11/26.
//


import SpriteKit
import CoreMotion

class WaterScene: SKScene {
    private let motionManager = CMMotionManager()
    private var waterNodes: [SKShapeNode] = []
    
    override func didMove(to view: SKView) {
        backgroundColor = .cyan
        
        // 水の粒子を作成
        for _ in 0..<100 {
            let waterDrop = SKShapeNode(circleOfRadius: 5)
            waterDrop.fillColor = .blue
            waterDrop.strokeColor = .clear
            waterDrop.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            )
            waterDrop.physicsBody = SKPhysicsBody(circleOfRadius: 5)
            waterDrop.physicsBody?.isDynamic = true
            waterDrop.physicsBody?.restitution = 0.2 // 跳ね返り
            waterNodes.append(waterDrop)
            addChild(waterDrop)
        }
        
        // 重力を設定
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        // Motion Manager の開始
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motionData, error in
                guard let self = self, let data = motionData else { return }
                self.updateGravity(with: data)
            }
        }
    }
    
    private func updateGravity(with data: CMDeviceMotion) {
        let gravityX = data.gravity.x
        let gravityY = data.gravity.y
        physicsWorld.gravity = CGVector(dx: gravityX * 10, dy: gravityY * 10)
    }
}