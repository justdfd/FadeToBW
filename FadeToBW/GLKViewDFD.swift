//
//  GLKView.swift
//  Stained Glass
//
//  Created by Dave Dombrowski on 8/6/16.
//  Copyright © 2016 justDFD. All rights reserved.
//
// Version 1.0
//


import CoreImage
import GLKit

open class GLKViewDFD: GLKView {
    
    var renderContext: CIContext
    var myClearColor:UIColor!
    var rgb:(Int?,Int?,Int?)!
    
    open var image: CIImage! {
        didSet {
            setNeedsDisplay()
        }
    }
    public var clearColor: UIColor! {
        didSet {
            myClearColor = clearColor
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
            
            myClearColor = UIColor.white
            rgb = myClearColor.rgb()
            glClearColor(Float(rgb.0!)/256.0, Float(rgb.1!)/256.0, Float(rgb.2!)/256.0, 0.0);
            glClear(0x00004000)
            // set the blend mode to "source over" so that CI will use that
            glEnable(0x0BE2);
            glBlendFunc(1, 0x0303);
            renderContext.draw(image, in: drawFrame, from: image.extent)
        }
    }
    
}
extension UIColor {
    func rgb() -> (Int?, Int?, Int?) {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            return (iRed, iGreen, iBlue)
        } else {
            // Could not extract RGBA components:
            return (nil,nil,nil)
        }
    }
}
