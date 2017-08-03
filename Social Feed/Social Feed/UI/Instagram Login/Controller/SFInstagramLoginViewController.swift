//
//  SFInstagramLoginViewController.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

class SFInstagramLoginViewController: SFBaseViewController, SFInstagramLoginViewDelegate {
    private var instagramProvider: SFInstagramProvider!
    //__ Private section
    fileprivate var instagramLoginView : SFInstagramLoginView {
        get {
            return (self.view as? SFInstagramLoginView)!;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.instagramLoginView.delegate = self
        self.instagramProvider = SFInstagramProvider()
        viewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func viewModel() {
        let viewModel = SFInstagramLoginViewModel()
        viewModel.instagramAuthUrl = self.instagramProvider.instagramProviderAuthorizationURL()
        self.instagramLoginView.viewModel = viewModel;
    }
    
    func instagramLoginViewDelegateAuthenticationSuccess(url: NSURL) {
        if (self.instagramProvider.instagramProviderReceivedValidAccessTokenFromURL(url: url)) {
            self.dismiss(animated: true, completion: {
            })
        }
    }
}
