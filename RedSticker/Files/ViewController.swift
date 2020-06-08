//
//  ViewController.swift
//  RedSticker
//
//  Created by Liam Mizrahi on 17/03/2020.
//  Copyright © 2020 Liam Mizrahi. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {
    
    @IBOutlet var littleImage: UIImageView!
    var ChosenImage: UIImage!
    var bannerView: GADBannerView!
    @IBOutlet var toptitle: UILabelX!
    var thetext : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toptitle.text = thetext
        littleImage.image = ChosenImage
        setUpBannerView()
    }
    
    
    @IBAction func tiktok(_ sender: Any) {
        guard let url = URL(string: "https://www.tiktok.com/@liammizrahi20") else { return }
        UIApplication.shared.open(url)
    }
    
    func setUpBannerView() {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        addBannerViewToView(bannerView)
        
        bannerView.delegate = self
        
        bannerView.adUnitID = "ca-app-pub-1705309407614919/7822884932"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
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
}
extension ViewController : GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("adViewDidReceiveAd")
    }

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
}

