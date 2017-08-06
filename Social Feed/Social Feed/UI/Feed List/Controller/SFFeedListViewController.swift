//
//  SFFeedListViewController.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

import TwitterKit

class SFFeedListViewController: SFBaseViewController, SFFeedListViewDelegate {
    private var instagramProvider: SFInstagramProvider!
    private var twitterProvider: SFTwitterProvider!
    //__ Private section
    private var feedListView : SFFeedListView {
        get {
            return (self.view as? SFFeedListView)!;
        }
    }
    private var modelItemsList : [SFItemFeed] = []
    private var twitterModelItemsList : [SFItemFeed] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.instagramProvider = SFInstagramProvider()
        self.twitterProvider = SFTwitterProvider()
        //__ Configure the view model
        self.feedListView.delegate = self
        viewModel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.validateInstagramSession), name: NSNotification.Name.InstagramKitUserAuthenticationChanged, object: nil)
        
        validateInstragramLogged()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //validateInstagramSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func viewModel() {
        let viewModel = SFFeedListViewModel()
        viewModel.items = []
        viewModel.showInstagramFeed = true
        viewModel.showTwitterFeed = false
        viewModel.instagramLogged = self.instagramProvider.instagramProviderIsSessionValid()
        viewModel.twitterLogged = self.twitterProvider.twitterProviderIsSessionValid()
        self.feedListView.viewModel = viewModel;
    }
    
    @objc private func validateInstagramSession() {
        if (!self.instagramProvider.instagramProviderIsSessionValid()) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showInstagramLogin"), object: nil, userInfo: nil)
        }
        else {
            loadInstragramFeed()
        }
    }
    
    private func validateInstragramLogged() {
        if (self.instagramProvider.instagramProviderIsSessionValid()) {
            loadInstragramFeed()
        }
    }
    
    private func showInstagramFeed() {
        let viewModel : SFFeedListViewModel = self.feedListView.viewModel!
        viewModel.showInstagramFeed = true
        viewModel.showTwitterFeed = false
        viewModel.instagramLogged = self.instagramProvider.instagramProviderIsSessionValid()
        viewModel.twitterLogged = self.twitterProvider.twitterProviderIsSessionValid()
        viewModel.items = SFFeedViewObject.generateItemObjects(itemObjects: self.modelItemsList)
        self.feedListView.viewModel = viewModel
    }
    
    private func showTwitterFeed() {
        loadTwitterFeed()
    }
    
    private func loadInstragramFeed() {
        self.instagramProvider.instagramProviderSelfFeedOn(completion: { (modelItems: [SFItemFeed], error: ProviderErrorCode) in
            if (error != ProviderErrorCode.everythingOKCode) {
                return
            }
            
            self.modelItemsList = self.modelItemsList + modelItems
            let viewModel : SFFeedListViewModel = self.feedListView.viewModel!
            viewModel.items = SFFeedViewObject.generateItemObjects(itemObjects: self.modelItemsList)
            viewModel.allowLoadMoreItems = true
            viewModel.showInstagramFeed = true
            viewModel.showTwitterFeed = false
            viewModel.instagramLogged = self.instagramProvider.instagramProviderIsSessionValid()
            viewModel.twitterLogged = self.twitterProvider.twitterProviderIsSessionValid()
            self.feedListView.viewModel = viewModel
        })
    }
    
    public func loadTwitterFeed() {
        self.twitterProvider.twitterProviderSelfFeedOn { (modelItems: [SFItemFeed]?, error: ProviderErrorCode) in
            if (error != ProviderErrorCode.everythingOKCode) {
                return
            }
            
            self.twitterModelItemsList = self.twitterModelItemsList + modelItems!
            let viewModel : SFFeedListViewModel = self.feedListView.viewModel!
            viewModel.items = SFFeedViewObject.generateItemObjects(itemObjects: self.twitterModelItemsList)
            viewModel.allowLoadMoreItems = true
            viewModel.showInstagramFeed = false
            viewModel.showTwitterFeed = true
            viewModel.instagramLogged = self.instagramProvider.instagramProviderIsSessionValid()
            viewModel.twitterLogged = self.twitterProvider.twitterProviderIsSessionValid()
            self.feedListView.viewModel = viewModel
        }
    }
    
    //__ SFFeedListViewDelegate
    func feedListViewDelegateInstagramLogin() {
        validateInstagramSession()
    }
    
    func feedListViewDelegateLoadMoreItems() {
        loadInstragramFeed()
    }
    
    func feedListViewDelegateSocialNetworkSelected(socialNetwork: FeedSociaNetwork) {
        switch socialNetwork {
        case FeedSociaNetwork.instagramSocialNetwork:
            showInstagramFeed()
        case FeedSociaNetwork.twitterSocialNetwork:
            showTwitterFeed()
        default:
            print("all")
        }
    }
}
