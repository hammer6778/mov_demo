// GlowingGemView.m

#import "GlowingGemView.h"

@implementation GlowingGemView {
    SKSpriteNode *_gemNode;
    SKEmitterNode *_glowEmitterNode1;
    SKEmitterNode *_glowEmitterNode2;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupScene];
        [self setupBackground];
        [self setupGlowEmitters];
        [self addRotationAnimation];
        [self addPulseAnimationToGem];
    }
    return self;
}

- (void)setupScene {
    self.backgroundColor = [UIColor clearColor];
    self.showsFPS = NO;
    self.showsNodeCount = NO;
    self.allowsTransparency = YES;
    
    SKScene *scene = [SKScene sceneWithSize:self.bounds.size];
    scene.backgroundColor = [SKColor clearColor];
    [self presentScene:scene];
}

- (void)setupBackground {
    // 添加背景
    SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"stone"];
    backgroundNode.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    backgroundNode.size = self.bounds.size;
    [self.scene addChild:backgroundNode];
}

- (void)setupGlowEmitters {
    // 创建宝石节点
    _gemNode = [SKSpriteNode spriteNodeWithColor:[UIColor systemBlueColor] size:CGSizeMake(100, 100)];
    _gemNode.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    [self.scene addChild:_gemNode];
    
    // 创建光芒粒子效果1
    NSString *glowParticlePath1 = [[NSBundle mainBundle] pathForResource:@"shine_y" ofType:@"sks"];
    NSData *glowParticleData1 = [NSData dataWithContentsOfFile:glowParticlePath1];
    NSError *error;
    _glowEmitterNode1 = [NSKeyedUnarchiver unarchivedObjectOfClass:[SKEmitterNode class] fromData:glowParticleData1 error:&error];
    if (error) {
        NSLog(@"Error loading particle data: %@", error);
    }
    _glowEmitterNode1.targetNode = self.scene;
    _glowEmitterNode1.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    [self.scene addChild:_glowEmitterNode1];

    // 创建光芒粒子效果2
    NSString *glowParticlePath2 = [[NSBundle mainBundle] pathForResource:@"shine_b" ofType:@"sks"];
    NSData *glowParticleData2 = [NSData dataWithContentsOfFile:glowParticlePath2];
    _glowEmitterNode2 = [NSKeyedUnarchiver unarchivedObjectOfClass:[SKEmitterNode class] fromData:glowParticleData2 error:&error];
    if (error) {
        NSLog(@"Error loading particle data: %@", error);
    }
    _glowEmitterNode2.targetNode = self.scene;
    _glowEmitterNode2.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    [self.scene addChild:_glowEmitterNode2];

}

- (void)addRotationAnimation {
    SKAction *rotationAction = [SKAction rotateByAngle:M_PI duration:10.0];
    SKAction *repeat = [SKAction repeatActionForever:rotationAction];
    [_gemNode runAction:repeat];
}

- (void)addPulseAnimationToGem {
    SKAction *scaleUpAction = [SKAction scaleTo:1.2 duration:1.0];
    SKAction *scaleDownAction = [SKAction scaleTo:1.0 duration:1.0];
    SKAction *pulse = [SKAction sequence:@[scaleUpAction, scaleDownAction]];
    SKAction *repeat = [SKAction repeatActionForever:pulse];
    [_gemNode runAction:repeat];
}

@end
