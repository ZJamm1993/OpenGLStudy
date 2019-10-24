//
//  EarthMoonViewController.m
//  OpenGLStudy
//
//  Created by zjj on 2019/10/22.
//  Copyright © 2019 zjj. All rights reserved.
//

#import "EarthMoonViewController.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "sphere.h"

@interface EarthMoonViewController ()

@property AGLKVertexAttribArrayBuffer *vertexPositionBuffer;
@property AGLKVertexAttribArrayBuffer *vertexNormalBuffer;
@property AGLKVertexAttribArrayBuffer *vertexTextureCoordBuffer;

@property GLKTextureInfo *earthTextureInfo;
@property GLKTextureInfo *moonTextureInfo;
@property GLKMatrixStackRef modelviewMatrixStack;
@property GLfloat earthRotationAngleDegrees;
@property GLfloat moonRotationAngleDegrees;

@property UISwitch *distanceSwitch;

@end

static const GLfloat  SceneEarthAxialTiltDeg = 30;//23.5f;
static const GLfloat  SceneDaysPerMoonOrbit = 5;//28.0f;
static const GLfloat  SceneMoonRadiusFractionOfEarth = 0.25;
static const GLfloat  SceneMoonDistanceFromEarth = 1.0f;

@implementation EarthMoonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.glBaseEffect.light0.enabled = GL_TRUE;
    self.glBaseEffect.light0.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    self.glBaseEffect.light0.position = GLKVector4Make(1.0f, 0.0f, 0.8f, 0.0f);
    self.glBaseEffect.light0.ambientColor = GLKVector4Make(0.2f, 0.2f, 0.2f, 1.0f);
    
    GLfloat aspectRatio = (self.view.bounds.size.width) / (self.view.bounds.size.height);
    
    self.glBaseEffect.transform.projectionMatrix = GLKMatrix4MakeOrtho(-1.0 * aspectRatio,  1.0 * aspectRatio, -1.0, 1.0, 1.0, 120.0);
    
    self.glBaseEffect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -5.0);
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    self.modelviewMatrixStack = GLKMatrixStackCreate(kCFAllocatorDefault);
    
    //顶点数据缓存
    self.vertexPositionBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:(3 * sizeof(GLfloat)) numberOfVertices:sizeof(sphereVerts) / (3 * sizeof(GLfloat)) bytes:sphereVerts usage:GL_STATIC_DRAW];
    self.vertexNormalBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:(3 * sizeof(GLfloat)) numberOfVertices:sizeof(sphereNormals) / (3 * sizeof(GLfloat)) bytes:sphereNormals usage:GL_STATIC_DRAW];
    self.vertexTextureCoordBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:(2 * sizeof(GLfloat)) numberOfVertices:sizeof(sphereTexCoords) / (2 * sizeof(GLfloat)) bytes:sphereTexCoords usage:GL_STATIC_DRAW];
    
    //地球纹理
    CGImageRef earthImageRef = [[UIImage imageNamed:@"Earth512x256.jpg"] CGImage];
    self.earthTextureInfo = [GLKTextureLoader textureWithCGImage:earthImageRef options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil] error:NULL];
    GLKMatrixStackLoadMatrix4(self.modelviewMatrixStack, self.glBaseEffect.transform.modelviewMatrix);
    
    CGImageRef moonImageRef = [[UIImage imageNamed:@"Moon256x128.jpg"] CGImage];
    self.moonTextureInfo = [GLKTextureLoader textureWithCGImage:moonImageRef options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil] error:NULL];
    GLKMatrixStackLoadMatrix4(self.modelviewMatrixStack, self.glBaseEffect.transform.modelviewMatrix);
    
    self.distanceSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.distanceSwitch addTarget:self action:@selector(switchNearOrFar:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.distanceSwitch];
}

- (void)switchNearOrFar:(UISwitch *)swit {
     GLfloat aspectRatio = (float)((GLKView *)self.view).drawableWidth / (float)((GLKView *)self.view).drawableHeight;
    
    if(swit.on) {
        self.glBaseEffect.transform.projectionMatrix = GLKMatrix4MakeFrustum(-1.0 * aspectRatio, 1.0 * aspectRatio, -1.0, 1.0, 2, 120);
    }
    else {
        self.glBaseEffect.transform.projectionMatrix = GLKMatrix4MakeOrtho(-1.0 * aspectRatio, 1.0 * aspectRatio, -1.0, 1.0, 2, 120);
    }
}

//地球
- (void)drawEarth
{
    self.glBaseEffect.texture2d0.name = self.earthTextureInfo.name;
    self.glBaseEffect.texture2d0.target = self.earthTextureInfo.target;
    
    GLKMatrixStackPush(self.modelviewMatrixStack);
    GLKMatrixStackRotate(self.modelviewMatrixStack, GLKMathDegreesToRadians(SceneEarthAxialTiltDeg), 1.0, 0.0, 0.0);
    GLKMatrixStackRotate(self.modelviewMatrixStack, GLKMathDegreesToRadians(self.earthRotationAngleDegrees), 0.0, 1.0, 0.0);
    self.glBaseEffect.transform.modelviewMatrix = GLKMatrixStackGetMatrix4(self.modelviewMatrixStack);
    [self.glBaseEffect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, sphereNumVerts);
    
    GLKMatrixStackPop(self.modelviewMatrixStack);
    
    self.glBaseEffect.transform.modelviewMatrix = GLKMatrixStackGetMatrix4(self.modelviewMatrixStack);
}

- (void)drawMoon
{
    self.glBaseEffect.texture2d0.name = self.moonTextureInfo.name;
    self.glBaseEffect.texture2d0.target = self.moonTextureInfo.target;
    
    GLKMatrixStackPush(self.modelviewMatrixStack);
    GLKMatrixStackRotate(self.modelviewMatrixStack, GLKMathDegreesToRadians(SceneEarthAxialTiltDeg), 1, 0, 0);
    GLKMatrixStackRotate(self.modelviewMatrixStack, GLKMathDegreesToRadians(self.moonRotationAngleDegrees), 0.0, 1.0, 0.0);
    GLKMatrixStackTranslate(self.modelviewMatrixStack, 0.0, 0.0, SceneMoonDistanceFromEarth);
    GLKMatrixStackScale(self.modelviewMatrixStack, SceneMoonRadiusFractionOfEarth, SceneMoonRadiusFractionOfEarth, SceneMoonRadiusFractionOfEarth);
    GLKMatrixStackRotate(self.modelviewMatrixStack, GLKMathDegreesToRadians(self.moonRotationAngleDegrees), 0.0, 1.0, 0.0);
    self.glBaseEffect.transform.modelviewMatrix = GLKMatrixStackGetMatrix4(self.modelviewMatrixStack);
    [self.glBaseEffect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, sphereNumVerts);
    GLKMatrixStackPop(self.modelviewMatrixStack);
    self.glBaseEffect.transform.modelviewMatrix = GLKMatrixStackGetMatrix4(self.modelviewMatrixStack);
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    self.earthRotationAngleDegrees += 360.0f / 60.0f;
    self.moonRotationAngleDegrees += (360.0f / 60.0f) / SceneDaysPerMoonOrbit;

    [self.vertexPositionBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:0 shouldEnable:YES];
    [self.vertexNormalBuffer prepareToDrawWithAttrib:GLKVertexAttribNormal numberOfCoordinates:3 attribOffset:0 shouldEnable:YES];
    [self.vertexTextureCoordBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:0 shouldEnable:YES];

    [self drawEarth];
    [self drawMoon];
}

@end
