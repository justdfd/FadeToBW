//
//  ViewController.swift
//  FadeToBW
//
//  Created by Dave Dombrowski on 3/17/17.
//  Copyright © 2017 justDFD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let imageView = GLKViewDFD()
    var ciImage:CIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        setConstraints()
        ciImage = CIImage(image: UIImage(named: "sunset.jpeg")!)
        let ciKernel = CIColorKernel(string: openKernelFile("FadeToBW"))
        let extent = ciImage.extent
        let inputColorFade:Float = 1
        let arguments = [ciImage, inputColorFade] as [Any]
        let outputImage = ciKernel?.apply(withExtent: extent, arguments: arguments)
        imageView.image = outputImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func openKernelFile(_ name:String) -> String {
        let filePath = Bundle.main.path(forResource: name, ofType: ".cikernel")
        do {
            return try String(contentsOfFile: filePath!)
        }
        catch let error as NSError {
            return error.description
        }
    }

}

extension ViewController {
    func setConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
    }
}

