//
//  MyBaseGLKViewController.m
//  OpenGLStudy
//
//  Created by zjj on 2019/10/24.
//  Copyright © 2019 zjj. All rights reserved.
//

#import "MyBaseGLKViewController.h"

@interface MyBaseGLKViewController ()

@end

@implementation MyBaseGLKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.glView.context = self.glContext;
    self.glView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    self.glView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:self.glContext];
    
    glEnable(GL_DEPTH_TEST);
    
    self.glBaseEffect = [[GLKBaseEffect alloc] init];
    
    glClearColor(0, 0, 0, 1);
}

- (GLKView *)glView {
    return (GLKView *)self.view;
}

@end
