//
//  GameScene.m
//  AccelerationTest
//
//  Created by Jeremy Novak on 7/30/14.
//  Copyright (c) 2014 Jeremy Novak. All rights reserved.
//

#import "GameScene.h"

@import CoreMotion;

@interface GameScene ()
@property (nonatomic) CGSize viewSize;
@property (nonatomic) SKSpriteNode *ship;
@property (nonatomic) CMMotionManager *motionManager;
@end

@implementation GameScene

-(instancetype)initWithSize:(CGSize)size {
    if ((self = [super initWithSize:size])) {
        
    }
    
    return self;
}

-(void)didMoveToView:(SKView *)view {
    _viewSize = self.frame.size;
    
    self.backgroundColor = [SKColor blackColor];

    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    _ship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    _ship.position = CGPointMake(_viewSize.width / 2, _viewSize.height / 2);
    _ship.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_ship.size.width / 2];
    _ship.physicsBody.affectedByGravity = NO;
    [self addChild:_ship];
    [_ship setScale:0.25];
    
    [self startMotionManager];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void)update:(CFTimeInterval)currentTime {
    [self updateShip];
    //[self updateShipWithoutPhysics];
}

-(void)startMotionManager {
    _motionManager = [[CMMotionManager alloc] init];
    [self.motionManager startAccelerometerUpdates];
}

-(void)stopMotionManager {
    [self.motionManager stopAccelerometerUpdates];
}

-(void)updateShip {
    CMAccelerometerData *data = self.motionManager.accelerometerData;
    
    if (fabs(data.acceleration.x) > 0.2) {
        [_ship.physicsBody applyImpulse:CGVectorMake(10 * data.acceleration.x, 0)];
    }
}

-(void)updateShipWithoutPhysics {
    CMAccelerometerData *data = self.motionManager.accelerometerData;
    
    CGFloat forceX = 10 * data.acceleration.x;
    
    CGPoint newPosition = CGPointMake(_ship.position.x + forceX, _ship.position.y);
    
    _ship.position = newPosition;
}

@end
