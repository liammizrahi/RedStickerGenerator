//
//  TestVC.swift
//  RedSticker
//
//  Created by Liam Mizrahi on 18/03/2020.
//  Copyright © 2020 Liam Mizrahi. All rights reserved.
//

import UIKit
import FlexibleImage
import CoreImage
import ALCameraViewController
import Toucan

class TestVC: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var minimumSize: CGSize = CGSize(width: 60, height: 60)

    var croppingParameters: CroppingParameters {
        return CroppingParameters(isEnabled: true, allowResizing: false, allowMoving: true, minimumSize: minimumSize)
    }
    
    @IBAction func Choose(_ sender: Any) {
        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: true) { [weak self] image, asset in
            self!.proccessImage(image: image!)
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    func proccessImage(image: UIImage) {
        let h = CIImage(image: image, options: [CIImageOption.colorSpace: NSNull()])!

        let filter = ThresholdFilter()
        filter.inputImage = h
        let final = filter.outputImage

        let blackImage = UIImage(ciImage: final!)
        
        // UIColor(red: 238/255, green: 46/255, blue: 36/255, alpha: 1.0)
        imageView.image = Toucan(image: blackImage.blend(withTint: UIColor(red: 238/255, green: 46/255, blue: 36/255, alpha: 1.0), blendAlpha: 0.1, blendMode: .colorDodge)).maskWithEllipse().image
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = CIImage(image: UIImage(named: "testImage")!, options: [CIImageOption.colorSpace: NSNull()])!

        let filter = ThresholdFilter()
        filter.inputImage = image
        let final = filter.outputImage

        let blackImage = UIImage(ciImage: final!)
        
        // UIColor(red: 238/255, green: 46/255, blue: 36/255, alpha: 1.0)
        imageView.image = blackImage.blend(withTint: UIColor(red: 238/255, green: 46/255, blue: 36/255, alpha: 1.0), blendAlpha: 0.1, blendMode: .colorDodge)
        
    }
    func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    func filledImage(source: UIImage, fillColor: UIColor) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(source.size, false, UIScreen.main.scale)

        let context = UIGraphicsGetCurrentContext()
        fillColor.setFill()

        context!.translateBy(x: 0, y: source.size.height)
        context!.scaleBy(x: 1.0, y: -1.0)

        context!.setBlendMode(CGBlendMode.colorBurn)
        let rect = CGRect(x: 0, y: 0, width: source.size.width, height: source.size.height)
        context!.draw(source.cgImage ?? CGImage.self as! CGImage, in: rect)

        context!.setBlendMode(CGBlendMode.sourceIn)
        context!.addRect(rect)
        context!.drawPath(using: CGPathDrawingMode.fill)

        let coloredImg : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return coloredImg
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIImage {
    
    open func blend(withTint color:UIColor, blendAlpha alpha:CGFloat, blendMode mode:CGBlendMode) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        let bounds = CGRect(origin: .zero, size: size)
        UIRectFill(bounds)
        draw(in: bounds, blendMode: mode, alpha: alpha)
        let tinted = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tinted!
    }
    
}
public extension UIImage {
    func filledImage(fillColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)

        let context = UIGraphicsGetCurrentContext()!
        fillColor.setFill()

        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        context.setBlendMode(CGBlendMode.colorBurn)

        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.draw(self.cgImage!, in: rect)

        context.setBlendMode(CGBlendMode.sourceIn)
        context.addRect(rect)
        context.drawPath(using: CGPathDrawingMode.fill)

        let coloredImg : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return coloredImg
    }
}
