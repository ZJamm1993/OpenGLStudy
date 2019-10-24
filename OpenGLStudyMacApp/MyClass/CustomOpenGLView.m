//
//  CustomOpenGLView.m
//  OpenGLStudyMacApp
//
//  Created by zjj on 2019/10/21.
//  Copyright © 2019 zjj. All rights reserved.
//

#import "CustomOpenGLView.h"
#include <OpenGL/gl.h>

@implementation CustomOpenGLView

+ (NSOpenGLPixelFormat *)defaultPixelFormat {
    NSOpenGLPixelFormat *pix = [[NSOpenGLPixelFormat alloc] init];
    return pix;
}


- (id)initWithFrame:(NSRect)frameRect pixelFormat:(NSOpenGLPixelFormat*)format
{
    self = [super initWithFrame:frameRect];
    if (self != nil) {
        _pixelFormat = format;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_surfaceNeedsUpdate:) name:NSViewGlobalFrameDidChangeNotification object:self];
    }
    return self;
}
 
- (void) _surfaceNeedsUpdate:(NSNotification*)notification
{
   [self update];
}

- (void)clearGLContext {
    [self.openGLContext clearDrawable];
}

- (void)prepareOpenGL {
    
}

- (void)lockFocus {
    NSOpenGLContext *context = self.openGLContext;
    [super lockFocus];
    if (context.view != self) {
        [context setView:self];
    }
    [context makeCurrentContext];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSOpenGLContext *context = self.openGLContext;
    [context makeCurrentContext];
    
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
    
    [context flushBuffer];
}

- (void)viewDidMoveToWindow {
    [super viewDidMoveToWindow];
    if (self.window == nil) {
        [self.openGLContext clearDrawable];
    }
}

@end
