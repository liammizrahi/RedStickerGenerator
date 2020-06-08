//
//  MainVC.swift
//  RedSticker
//
//  Created by Liam Mizrahi on 18/03/2020.
//  Copyright © 2020 Liam Mizrahi. All rights reserved.
//

import UIKit
import CoreImage
import ALCameraViewController
import Toucan
import GoogleMobileAds
import ImageDetect

class MainVC: UIViewController, GADBannerViewDelegate {
    
    var bannerView: GADBannerView!

    @IBOutlet var preview: UIImageView!
    @IBOutlet var continueButton: UIButton!
    var minimumSize: CGSize = CGSize(width: 60, height: 60)
    var ChosenImage: UIImage!
    var croppingParameters: CroppingParameters {
        return CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: minimumSize)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-1705309407614919/7822884932"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
     bannerView.translatesAutoresizingMaskIntoConstraints = false
     view.addSubview(bannerView)
     view.addConstraints(
       [NSLayoutConstraint(item: bannerView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: bottomLayoutGuide,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0),
        NSLayoutConstraint(item: bannerView,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0)
       ])
    }
    
    @IBAction func openCamera(_ sender: Any) {
        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: true) { [weak self] image, asset in
            self!.proccessImage(image: image!)
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    @IBAction func openLibrary(_ sender: Any) {
        let libraryViewController = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { [weak self] image, asset in
            self!.proccessImage(image: image!)
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(libraryViewController, animated: true, completion: nil)
    }
    
    func proccessImage(image: UIImage) {
        preview.image = image
        var h = CIImage(image: image, options: [CIImageOption.colorSpace: NSNull()])!

        var facedImage: UIImage!
        DispatchQueue.global().async {
            image.detector.crop(type: .face) { result in
                DispatchQueue.main.async { [weak self] in
                    switch result {
                    case .success(let croppedImages):
                        // When the `Vision` successfully find type of object you set and successfuly crops it.
                        facedImage = croppedImages[0]
                        print("Detect Face")
                        h = CIImage(image: facedImage, options: [CIImageOption.colorSpace: NSNull()])!
                        self!.preview.image = facedImage
                    case .notFound:
                        // When the image doesn't contain any type of object you did set, `result` will be `.notFound`.
                        print("Face Not Found")
                    case .failure(let error):
                        // When the any error occured, `result` will be `failure`.
                        facedImage = image
                        print(error.localizedDescription)
                    }
                }
            }
            
            let filter = ThresholdFilter()
            filter.inputImage = h
            let final = filter.outputImage

            let blackImage = UIImage(ciImage: final!)
            
            // UIColor(red: 238/255, green: 46/255, blue: 36/255, alpha: 1.0)
            //ChosenImage = Toucan(image: blackImage.blend(withTint: UIColor(red: 238/255, green: 46/255, blue: 36/255, alpha: 1.0), blendAlpha: 0.1, blendMode: .colorDodge)).maskWithEllipse().image
            self.ChosenImage = blackImage.blend(withTint: UIColor(red: 238/255, green: 46/255, blue: 36/255, alpha: 1.0), blendAlpha: 0.1, blendMode: .colorDodge)
        }
        self.continueButton.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "give_name"
        {
            let destination = segue.destination as! CreateVC

            destination.ChosenImage = ChosenImage
        }
    }
    

    @IBAction func coninue(_ sender: Any) {
        self.performSegue(withIdentifier: "give_name", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      // Add banner to view and add constraints as above.
      addBannerViewToView(bannerView)
    }

}
