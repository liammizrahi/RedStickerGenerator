//
//  CreateVC.swift
//  RedSticker
//
//  Created by Liam Mizrahi on 17/03/2020.
//  Copyright © 2020 Liam Mizrahi. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SCLAlertView

class CreateVC: UIViewController, GADBannerViewDelegate {

    var ChosenImage: UIImage!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var textField: UITextField!
    var bannerView: GADBannerView!
    var rewardBasedAd: GADRewardBasedVideoAd!
    private var rewardCreditSuccess: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        createButton.isEnabled = false
        rewardBasedAd = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedAd.delegate = self
        rewardBasedAd.load(GADRequest(), withAdUnitID: "ca-app-pub-1705309407614919/1816999348")
        setUpBannerView()
    }
    
    @IBAction func createClicked(_ sender: Any) {
        if(textField.text!.count > 1) {
            if(textField.text!.count < 14) {
                createButton.isEnabled = false
                if rewardBasedAd.isReady {
                    rewardCreditSuccess = false
                    rewardBasedAd.present(fromRootViewController: self)
                }
                else {
                    createSticker()
                }
            }
            else {
                SCLAlertView().showError("שימו לב", subTitle: "השתמשתם ביותר מידי תווים. כמה אתם חושבים שאפשר להכניס בסטיקר?!")
            }
        }
        else {
            SCLAlertView().showWarning("שימו לב", subTitle: "צריך להכניס לפחות 2 אותיות")
        }
    }
    func createSticker() {
        if(textField.text!.count > 1) {
            if(textField.text!.count < 14) {
                self.performSegue(withIdentifier: "create_sticker", sender: self)
            }
            else {
                SCLAlertView().showError("שימו לב", subTitle: "השתמשתם ביותר מידי תווים. כמה אתם חושבים שאפשר להכניס בסטיקר?!")
            }
        }
        else {
            SCLAlertView().showWarning("שימו לב", subTitle: "צריך להכניס לפחות 2 אותיות")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "create_sticker"
        {
            let destination = segue.destination as! ViewController

            destination.thetext = textField.text!
            destination.ChosenImage = ChosenImage
        }
    }

    func setUpBannerView() {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        addBannerViewToView(bannerView)
                
        bannerView.adUnitID = "ca-app-pub-1705309407614919/7822884932"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CreateVC : GADRewardBasedVideoAdDelegate {
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
        didRewardUserWith reward: GADAdReward) {
      self.rewardCreditSuccess = true
    }

    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
        createButton.isEnabled = true
    }

    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      print("Opened reward based video ad.")
    }

    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      print("Reward based video ad started playing.")
    }

    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      print("Reward based video ad has completed.")
    }

    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
        if rewardCreditSuccess {
            createSticker()
        }
        rewardBasedAd.load(GADRequest(), withAdUnitID: "ca-app-pub-1705309407614919/1816999348")
    }

    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      print("Reward based video ad will leave application.")
    }

    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
        didFailToLoadWithError error: Error) {
      print("Reward based video ad failed to load.")
        createButton.isEnabled = true
    }
}
/*
extension CreateVC : GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerViewToView(bannerView)
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
*/
