//
//  ViewController.swift
//  FadeToBW
//
//  Created by Dave Dombrowski on 3/17/17.
//  Copyright © 2017 justDFD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Core Image
    
    var imgOriginal:CIImage!
    let imageView = ImageViewGLK()
    var ciKernel:CIColorKernel!
    var fadeFactor = UISlider()
    
    // Images
    
    let imageSegments = UISegmentedControl (items: ["Autumn","Baloons","Sunset"])
    let imgAutumn = CIImage(image: UIImage(named: "autumn.jpeg")!)
    let imgBaloons = CIImage(image: UIImage(named: "hot_air_balloons.jpeg")!)
    let imgSunset = CIImage(image: UIImage(named: "sunset.jpeg")!)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add subviews and constraints
        
        view.addSubview(imageView)
        view.addSubview(imageSegments)
        view.addSubview(fadeFactor)
        setConstraints()
        
        // Load FadeToBW kernel

        ciKernel = CIColorKernel(string: openKernelFile("FadeToBW"))

        // Initially show "Autumn" image in full color
        
        imageSegments.selectedSegmentIndex = 0
        imageSegments.addTarget(self, action: #selector(changeImageView), for: .valueChanged)
        changeImageView()
        fadeFactor.minimumValue = 0
        fadeFactor.maximumValue = 1
        fadeFactor.value = 0
        fadeFactor.addTarget(self, action: #selector(sliderChanged), for: UIControlEvents.valueChanged)
        updateImage()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController {
    
    func setConstraints() {
        
        // When setting constraints in code, always remember to turn off autoresizing mask!
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageSegments.translatesAutoresizingMaskIntoConstraints = false
        fadeFactor.translatesAutoresizingMaskIntoConstraints = false

        // The GLKView is square-sized, remaining constraints are set top to bottom
        
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageSegments.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15).isActive = true
        imageSegments.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageSegments.widthAnchor.constraint(equalToConstant: 250).isActive = true
        imageSegments.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fadeFactor.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        fadeFactor.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        fadeFactor.topAnchor.constraint(equalTo: imageSegments.bottomAnchor, constant: 30).isActive = true
        
    }
    
    func openKernelFile(_ name:String) -> String {
        let filePath = Bundle.main.path(forResource: name, ofType: ".cikernel")
        do {
            return try String(contentsOfFile: filePath!)
        }
        catch let error as NSError {
            return error.description
        }
    }
    
    func changeImageView() {
        
        switch imageSegments.selectedSegmentIndex {
        case 0:
            imgOriginal = imgAutumn
        case 1:
            imgOriginal = imgBaloons
        case 2:
            imgOriginal = imgSunset
        default:
            break
        }
        imageView.image = imgOriginal
        updateImage()
        
    }
    
    func sliderChanged(_ sender: UISlider) {
        updateImage()
    }
    
    func updateImage() {
        
        // Apply FadeToBW slider value to image and render
        
        let outputImage = ciKernel?.apply(withExtent: imgOriginal.extent, arguments: [imgOriginal, fadeFactor.value])
        imageView.image = outputImage
        imageView.setNeedsDisplay()
        
    }
    
    func clamp(_ x:Float, _ minVal:Float, _ maxVal:Float) -> Float {
        return min(max(x, minVal), maxVal)
    }
    
}

