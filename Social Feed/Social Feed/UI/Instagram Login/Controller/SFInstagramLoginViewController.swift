//
//  SFInstagramLoginViewController.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

class SFInstagramLoginViewController: SFBaseViewController, SFInstagramLoginViewDelegate {
    //__ Private section
    private var instagramProvider: SFInstagramProvider!
    private var instagramLoginView : SFInstagramLoginView {
        get {
            //__ Use get property in order to set the view controller's view to SFInstagramLoginView object
            return (self.view as? SFInstagramLoginView)!;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //__ Configure view's delegate to get all user interaction
        self.instagramLoginView.delegate = self
        //__ Init the provider
        self.instagramProvider = SFInstagramProvider()
        //__ init the view model
        viewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //__ Method to inject information to the view
    private func viewModel() {
        let viewModel = SFInstagramLoginViewModel()
        viewModel.instagramAuthUrl = self.instagramProvider.instagramProviderAuthorizationURL()
        self.instagramLoginView.viewModel = viewModel;
    }
    
    //__ Delegate methods
    
    //__ Method to get the authentication success for instagram
    func instagramLoginViewDelegateAuthenticationSuccess(url: NSURL) {
        if (self.instagramProvider.instagramProviderReceivedValidAccessTokenFromURL(url: url)) {
            self.dismiss(animated: true, completion: {
            })
        }
    }
    
    //__ Method to get the cancel event
    func instagramLoginViewDelegateCancel() {
        self.dismiss(animated: true, completion: {
        })
    }
}
