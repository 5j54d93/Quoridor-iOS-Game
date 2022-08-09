//
//  AdModViewModel.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/8/7.
//

import Foundation
import GoogleMobileAds

class AdModViewModel: ObservableObject {
    
    @Published var ad: GADRewardedAd?
    
    func loadAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: request) {ad, error in
            if error != nil {
                self.loadAd()
            }
            self.ad = ad
        }
    }
    
    func showAd(completion: @escaping (String) -> Void) {
        if let ad = ad, let controller = UIViewController.getLastPresentedViewController() {
            ad.present(fromRootViewController: controller) {
                completion("success")
            }
        } else {
            completion("Video hasn't ready")
        }
    }
}
