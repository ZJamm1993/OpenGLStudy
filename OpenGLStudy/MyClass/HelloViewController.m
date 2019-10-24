//
//  ViewController.m
//  OpenGLStudy
//
//  Created by zjj on 2019/10/18.
//  Copyright © 2019 zjj. All rights reserved.
//

#import "HelloViewController.h"

@interface HelloViewController ()

@property (nonatomic, assign) int mCount;
@property (nonatomic, assign) float mDegreeX;
@property (nonatomic, assign) float mDegreeY;
@property (nonatomic, assign) float mDegreeZ;

@end

@implementation HelloViewController {
    NSTimer *timer;
}

- (void)dealloc {
    [timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //顶点数据，前三个是顶点坐标， 中间三个是顶点颜色，    最后两个是纹理坐标
    GLfloat attrArr[] =
    {
        -0.5f, 0.5f, 0.0f,      0.0f, 0.0f, 0.5f,       0.0f, 1.0f,//左上
        0.5f, 0.5f, 0.0f,       0.0f, 0.5f, 0.0f,       1.0f, 1.0f,//右上
        -0.5f, -0.5f, 0.0f,     0.5f, 0.0f, 1.0f,       0.0f, 0.0f,//左下
        0.5f, -0.5f, 0.0f,      0.0f, 0.0f, 0.5f,       1.0f, 0.0f,//右下
        0.0f, 0.0f, 1.0f,       1.0f, 1.0f, 1.0f,       0.5f, 0.5f,//顶点
    };
    //顶点索引
    GLuint indices[] =
    {
        0, 3, 2,
        0, 1, 3,
        0, 2, 4,
        0, 4, 1,
        2, 3, 4,
        1, 4, 3,
    };
    self.mCount = sizeof(indices) / sizeof(GLuint);
    
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_STATIC_DRAW);
    
    GLuint index;
    glGenBuffers(1, &index);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, index);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 8, (GLfloat *)NULL);
    //顶点颜色
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE, 4 * 8, (GLfloat *)NULL + 3);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 4 * 8, (GLfloat *)NULL + 6);

    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"png"];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
    self.glBaseEffect.texture2d0.enabled = GL_TRUE;
    self.glBaseEffect.texture2d0.name = textureInfo.name;
    
    CGSize size = self.view.bounds.size;
    float aspect = fabs(size.width / size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 10);
    projectionMatrix = GLKMatrix4Scale(projectionMatrix, 1, 1, 1);
    self.glBaseEffect.transform.projectionMatrix = projectionMatrix;
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0f, 0.0f, -2.0f);
//    modelViewMatrix = GLKMatrix4RotateZ(modelViewMatrix, M_PI_4);
    self.glBaseEffect.transform.modelviewMatrix = modelViewMatrix;
    
    __weak typeof(self) weakself = self;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.016 repeats:YES block:^(NSTimer * _Nonnull timer) {
        weakself.mDegreeX += 0.01;
        weakself.mDegreeY += 0.02;
        weakself.mDegreeZ += 0.03;
    }];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.5, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [self.glBaseEffect prepareToDraw];
    glDrawElements(GL_TRIANGLES, self.mCount, GL_UNSIGNED_INT, 0);
}

- (void)update {
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0f, 0.0f, -2.0f);
    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, self.mDegreeX);
    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, self.mDegreeY);
    modelViewMatrix = GLKMatrix4RotateZ(modelViewMatrix, self.mDegreeZ);
    self.glBaseEffect.transform.modelviewMatrix = modelViewMatrix;
}

@end
