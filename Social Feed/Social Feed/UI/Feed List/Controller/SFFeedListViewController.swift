//
//  SFFeedListViewController.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

class SFFeedListViewController: SFBaseViewController {
    private var instagramProvider: SFInstagramProvider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.instagramProvider.instagramProviderPopularMedia()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.instagramProvider = SFInstagramProvider()
        self.validateSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func validateSession() {
        if (!self.instagramProvider.instagramProviderIsSessionValid()) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showInstagramLogin"), object: nil, userInfo: nil)
        }
        else {
            self.instagramProvider.instagramProviderSelfFeed()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
