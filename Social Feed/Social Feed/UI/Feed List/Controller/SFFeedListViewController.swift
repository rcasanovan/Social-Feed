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
    private var isShowingInstagramFeed: Bool!
    private var isShowingTwitterFeed: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShowingInstagramFeed = true
        self.instagramProvider = SFInstagramProvider()
        self.twitterProvider = SFTwitterProvider()
        //__ Configure the view model
        self.feedListView.delegate = self
        viewModel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(instagramSessionChanged), name: NSNotification.Name.InstagramKitUserAuthenticationChanged, object: nil)
        
        validateInstragramLogged()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureNavigationBar() {
        if (self.instagramProvider.instagramProviderIsSessionValid() ||
            self.twitterProvider.twitterProviderIsSessionValid()) {
        let logoutButton = UIButton(type: .custom)
        logoutButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        logoutButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        logoutButton.setTitle("bt1", for: UIControlState.normal)
        logoutButton.addTarget(self, action: #selector(showLogoutOptions), for: .touchUpInside)
        let logoutItem = UIBarButtonItem(customView: logoutButton)
        
        self.navigationItem.setRightBarButton(logoutItem, animated: true)
        }
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
    
    @objc private func showLogoutOptions() {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let logoutInstagramAction = UIAlertAction(title: "log out Instagram",
                                                  style: .default, handler: { (actionSheetController) -> Void in
                                                    self.logoutInstragram()
        })
        
        let logoutTwitterAction = UIAlertAction(title: "log out Twitter",
                                                style: .default, handler: { (actionSheetController) -> Void in
                                                    self.logoutTwitter()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel, handler: nil)
        
        alert.addAction(logoutInstagramAction)
        alert.addAction(logoutTwitterAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func logoutInstragram() {
        self.instagramProvider.instagramProviderLogout()
        self.modelItemsList = []
        let viewModel : SFFeedListViewModel = self.feedListView.viewModel!
        viewModel.instagramLogged = self.instagramProvider.instagramProviderIsSessionValid()
        viewModel.twitterLogged = self.twitterProvider.twitterProviderIsSessionValid()
        if self.isShowingInstagramFeed {
            viewModel.items = SFFeedViewObject.generateItemObjects(itemObjects: self.modelItemsList)
        }
        self.feedListView.viewModel = viewModel
    }
    
    private func logoutTwitter() {
        self.twitterProvider.twitterProviderLogout()
        self.twitterModelItemsList = []
        let viewModel : SFFeedListViewModel = self.feedListView.viewModel!
        viewModel.instagramLogged = self.instagramProvider.instagramProviderIsSessionValid()
        viewModel.twitterLogged = self.twitterProvider.twitterProviderIsSessionValid()
        if self.isShowingTwitterFeed {
            viewModel.items = SFFeedViewObject.generateItemObjects(itemObjects: self.twitterModelItemsList)
        }
        self.feedListView.viewModel = viewModel
    }
    
    @objc private func instagramSessionChanged() {
        loadInstragramFeed()
    }
    
    private func validateInstagramSession() {
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
    
    private func showAllFeed() {
        let viewModel : SFFeedListViewModel = self.feedListView.viewModel!
        let allFeed = self.modelItemsList + self.twitterModelItemsList
        viewModel.items = SFFeedViewObject.generateItemObjects(itemObjects: allFeed.sorted(by: {$0.createdDate! > $1.createdDate!}))
        viewModel.allowLoadMoreItems = true
        viewModel.showInstagramFeed = true
        viewModel.showTwitterFeed = false
        viewModel.instagramLogged = self.instagramProvider.instagramProviderIsSessionValid()
        viewModel.twitterLogged = self.twitterProvider.twitterProviderIsSessionValid()
        self.feedListView.viewModel = viewModel
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
        if !self.twitterProvider.twitterProviderIsSessionValid() {
            let viewModel : SFFeedListViewModel = self.feedListView.viewModel!
            viewModel.items = SFFeedViewObject.generateItemObjects(itemObjects: self.twitterModelItemsList)
            viewModel.allowLoadMoreItems = true
            viewModel.showInstagramFeed = false
            viewModel.showTwitterFeed = true
            viewModel.instagramLogged = self.instagramProvider.instagramProviderIsSessionValid()
            viewModel.twitterLogged = self.twitterProvider.twitterProviderIsSessionValid()
            self.feedListView.viewModel = viewModel
            return
        }
        
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
        loadTwitterFeed()
    }
    
    func feedListViewDelegateSocialNetworkSelected(socialNetwork: FeedSociaNetwork) {
        switch socialNetwork {
        case FeedSociaNetwork.instagramSocialNetwork:
            isShowingInstagramFeed = true
            isShowingTwitterFeed = false
            showInstagramFeed()
        case FeedSociaNetwork.twitterSocialNetwork:
            isShowingInstagramFeed = false
            isShowingTwitterFeed = true
            showTwitterFeed()
        default:
            showAllFeed()
        }
    }
}
