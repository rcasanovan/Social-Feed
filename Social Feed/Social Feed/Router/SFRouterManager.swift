//
//  SFRouterManager.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

class SFRouterManager: NSObject {
    static let shared = SFRouterManager()
    
    public func initRouterNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showLoginView), name: NSNotification.Name(rawValue: "showInstagramLogin"), object: nil)
    }
    
    @objc private func showLoginView() {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SFInstagramLoginViewController") as! SFInstagramLoginViewController
        let main = UIApplication.shared.windows.first?.rootViewController
        main?.present(vc, animated: true, completion: nil)
    }
}
