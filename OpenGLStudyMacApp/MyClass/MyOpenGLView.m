//
//  MyOpenGLView.m
//  OpenGLStudyMacApp
//
//  Created by zjj on 2019/10/18.
//  Copyright © 2019 zjj. All rights reserved.
//

#import "MyOpenGLView.h"
#include <OpenGL/gl.h>

@implementation MyOpenGLView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setWantsBestResolutionOpenGLSurface:YES];
}

- (void)drawRect:(NSRect)dirtyRect {

    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(1, 0.85, 0.35);
    glBegin(GL_TRIANGLES);
    {
        glVertex3f(0, 0.6, 0);
        glVertex3f(-0.2, -0.3, 0);
        glVertex3f(0.2, -0.3, 0);
    }
    glEnd();
    
    glFlush();
}

@end
