//
//  GLKViewDFD.swift
//  FadeToBW
//
//  Created by Dave Dombrowski on 8/6/16.
//  Copyright © 2017 justDFD. All rights reserved.
//


import CoreImage
import GLKit

open class GLKViewDFD: GLKView {
    
    var renderContext: CIContext
    
    open var image: CIImage! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public init() {
        let eaglContext = EAGLContext(api: .openGLES2)
        renderContext = CIContext(eaglContext: eaglContext!)
        super.init(frame: CGRect.zero)
        context = eaglContext!
    }
    
    override public init(frame: CGRect, context: EAGLContext) {
        renderContext = CIContext(eaglContext: context)
        super.init(frame: frame, context: context)
        enableSetNeedsDisplay = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        let eaglContext = EAGLContext(api: .openGLES2)
        renderContext = CIContext(eaglContext: eaglContext!)
        super.init(coder: aDecoder)
        context = eaglContext!
        enableSetNeedsDisplay = true
    }
    
    override open func draw(_ rect: CGRect) {
        if let image = image {
            
            // Set drawFrame for AspectFit mode
            
            let imageSize = image.extent.size
            var drawFrame = CGRect(x: 0, y: 0, width: CGFloat(drawableWidth), height: CGFloat(drawableHeight))
            let imageAR = imageSize.width / imageSize.height
            let viewAR = drawFrame.width / drawFrame.height
            if imageAR > viewAR {
                drawFrame.origin.y += (drawFrame.height - drawFrame.width / imageAR) / 2.0
                drawFrame.size.height = drawFrame.width / imageAR
            } else {
                drawFrame.origin.x += (drawFrame.width - drawFrame.height * imageAR) / 2.0
                drawFrame.size.width = drawFrame.height * imageAR
            }
            
            // Set "unfilled" background to white
            
            let myClearColor = UIColor.white
            let rgb = myClearColor.rgb()
            glClearColor(Float(rgb.0!)/256.0, Float(rgb.1!)/256.0, Float(rgb.2!)/256.0, 0.0);
            
            
            glClear(0x00004000)
            glEnable(0x0BE2);
            glBlendFunc(1, 0x0303);
            renderContext.draw(image, in: drawFrame, from: image.extent)
        }
    }
    
}
