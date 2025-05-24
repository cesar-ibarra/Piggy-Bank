//
//  BannerAd.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 5/24/25.
//

import SwiftUI
import GoogleMobileAds

struct BannerAd: UIViewRepresentable {
    let unitID: String
    
    func makeCoordinator() -> Coordinator {
        //For Implementing Delegates...
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> BannerView{
        let adView = BannerView(adSize: AdSizeBanner)
        
        adView.adUnitID = unitID
        adView.rootViewController = UIApplication.shared.getRootViewController()
        adView.delegate = context.coordinator
        adView.load(Request())
        
        return adView
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        
    }
    
    class Coordinator: NSObject,BannerViewDelegate {
        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
          print("bannerViewDidReceiveAd")
        }

        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
          print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        }

        func bannerViewDidRecordImpression(_ bannerView: BannerView) {
          print("bannerViewDidRecordImpression")
        }

        func bannerViewWillPresentScreen(_ bannerView: BannerView) {
          print("bannerViewWillPresentScreen")
        }

        func bannerViewWillDismissScreen(_ bannerView: BannerView) {
          print("bannerViewWillDIsmissScreen")
        }

        func bannerViewDidDismissScreen(_ bannerView: BannerView) {
          print("bannerViewDidDismissScreen")
        }
    }
}

//Extending Application to get RootView...
extension UIApplication {
    func getRootViewController()->UIViewController {
        
        guard let screen = self.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
            
            guard let root = screen.windows.first?.rootViewController else {
                return .init()
            }
            
            return root
    }
}
