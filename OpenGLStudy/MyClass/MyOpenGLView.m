//
//  MyOpenGLView.m
//  OpenGLStudy
//
//  Created by zjj on 2019/10/18.
//  Copyright © 2019 zjj. All rights reserved.
//

#import "MyOpenGLView.h"
#import <OpenGLES/EAGL.h>

@implementation MyOpenGLView

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    glGenRend
}

@end
