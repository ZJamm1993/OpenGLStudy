//
//  LightTestViewController.m
//  OpenGLStudy
//
//  Created by zjj on 2019/10/24.
//  Copyright © 2019 zjj. All rights reserved.
//

#import "LightTestViewController.h"
#import "SceneUtil.h"
#import "AGLKVertexAttribArrayBuffer.h"

@interface LightTestViewController ()

@property (strong, nonatomic) GLKBaseEffect *extraEffect;

@property AGLKVertexAttribArrayBuffer *vertexBuffer;
@property AGLKVertexAttribArrayBuffer *extraBuffer;
@property (nonatomic) GLfloat centerVertexHeight;

@property UISlider *heightSlider;
@property UISwitch *normalSwitch;

@end

@implementation LightTestViewController {
    SceneTriangle triangles[NUM_FACES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.glBaseEffect.light0.enabled = GL_TRUE;
    self.glBaseEffect.light0.diffuseColor = GLKVector4Make(0.1, 0.7, 0.7, 1);
    self.glBaseEffect.light0.position = GLKVector4Make(1, 1, 0.5, 0);
    
    self.extraEffect = [[GLKBaseEffect alloc] init];
    self.extraEffect.useConstantColor = GL_TRUE;

    BOOL rotated = YES;
    if (rotated) {
        GLKMatrix4 modelViewMatric = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(-60.0f), 1, 0, 0);
        modelViewMatric = GLKMatrix4Rotate(modelViewMatric, GLKMathDegreesToRadians(-30.0f), 0, 0, 1);
        modelViewMatric = GLKMatrix4Translate(modelViewMatric, 0, 0, 0);
        self.glBaseEffect.transform.modelviewMatrix = modelViewMatric;
        self.extraEffect.transform.modelviewMatrix = modelViewMatric;
    }
    
    glDisable(GL_DEPTH_TEST); // 开了depth test反而不显示了？
    glClearColor(0, 0, 0, 1);
     
    triangles[0] = SceneTriangleMake(vertexA, vertexB, vertexD);
    triangles[1] = SceneTriangleMake(vertexB, vertexC, vertexF);
    triangles[2] = SceneTriangleMake(vertexD, vertexB, vertexE);
    triangles[3] = SceneTriangleMake(vertexE, vertexB, vertexF);
    triangles[4] = SceneTriangleMake(vertexD, vertexE, vertexH);
    triangles[5] = SceneTriangleMake(vertexE, vertexF, vertexH);
    triangles[6] = SceneTriangleMake(vertexG, vertexD, vertexH);
    triangles[7] = SceneTriangleMake(vertexH, vertexF, vertexI);
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(triangles) / sizeof(SceneVertex) bytes:triangles usage:GL_DYNAMIC_DRAW];
    self.extraBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex) numberOfVertices:0 bytes:NULL usage:GL_DYNAMIC_DRAW];
    
    
    self.heightSlider = [[UISlider alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    [self.heightSlider addTarget:self action:@selector(heightValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.heightSlider.maximumValue = 0;
    self.heightSlider.minimumValue = -0.5;
    self.heightSlider.value = 0;
    [self.view addSubview:self.heightSlider];
    
    self.centerVertexHeight = 0;
}

- (void)updateNormals {
    SceneTrianglesUpdateFaceNormals(triangles);
    [self.vertexBuffer reinitWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(triangles) / sizeof(SceneVertex) bytes:triangles];
}

- (void)drawNormals
{
    GLKVector3  normalLineVertices[NUM_LINE_VERTS];
    
    SceneTrianglesNormalLinesUpdate(triangles,
                                    GLKVector3MakeWithArray(self.glBaseEffect.light0.position.v),
                                    normalLineVertices);
    
    [self.extraBuffer reinitWithAttribStride:sizeof(GLKVector3)
                            numberOfVertices:NUM_LINE_VERTS
                                       bytes:normalLineVertices];
    
    [self.extraBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                          numberOfCoordinates:3
                                 attribOffset:0
                                 shouldEnable:YES];
    
    
    self.extraEffect.useConstantColor = GL_TRUE;
    self.extraEffect.constantColor =
    GLKVector4Make(0.0, 1.0, 0.0, 1.0);
    
    [self.extraEffect prepareToDraw];
    
    [self.extraBuffer drawArrayWithMode:GL_LINES
                       startVertexIndex:0
                       numberOfVertices:NUM_NORMAL_LINE_VERTS];
    
    self.extraEffect.constantColor =
    GLKVector4Make(1.0, 1.0, 0.0, 1.0);
    
    [self.extraEffect prepareToDraw];
    
    [self.extraBuffer drawArrayWithMode:GL_LINES
                       startVertexIndex:NUM_NORMAL_LINE_VERTS
                       numberOfVertices:(NUM_LINE_VERTS - NUM_NORMAL_LINE_VERTS)];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.5, 0.5, 0.5, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [self.glBaseEffect prepareToDraw];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, position)
                                  shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribNormal
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, normal)
                                  shouldEnable:YES];
    
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:sizeof(triangles) / sizeof(SceneVertex)];
    [self drawNormals];
}

#pragma mark - controls

- (IBAction)heightValueChanged:(UISlider *)sender {
    self.centerVertexHeight = sender.value;
}

- (IBAction)showNormalLine:(UISwitch *)sender {
}

- (IBAction)usePlane:(UISwitch *)sender {
}

#pragma mark - setter

- (void)setCenterVertexHeight:(GLfloat)centerVertexHeight {
    _centerVertexHeight = centerVertexHeight;
    
    SceneVertex newVertexE = vertexE;
    newVertexE.position.z = _centerVertexHeight;
    
    triangles[2] = SceneTriangleMake(vertexD, vertexB, newVertexE);
    triangles[3] = SceneTriangleMake(newVertexE, vertexB, vertexF);
    triangles[4] = SceneTriangleMake(vertexD, newVertexE, vertexH);
    triangles[5] = SceneTriangleMake(newVertexE, vertexF, vertexH);
    
    [self updateNormals];
}

@end
