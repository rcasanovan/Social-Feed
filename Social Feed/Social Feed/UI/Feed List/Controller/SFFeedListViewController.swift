//
//  SFFeedListViewController.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

//__ TwitterKit
import TwitterKit

class SFFeedListViewController: SFBaseViewController, SFFeedListViewDelegate {
    //__ Private section
    private var instagramProvider: SFInstagramProvider!
    private var twitterProvider: SFTwitterProvider!
    private var feedListView : SFFeedListView {
        get {
            //__ Use get property in order to set the view controller's view to SFFeedListView object
            return (self.view as? SFFeedListView)!;
        }
    }
    private var instagramModelItemsList : [SFItemFeed] = []
    private var twitterModelItemsList : [SFItemFeed] = []
    private var isShowingInstagramFeed: Bool!
    private var isShowingTwitterFeed: Bool!
    private var isShowingAllFeed: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //__ Configure initial view controller's properties
        self.isShowingInstagramFeed = true
        self.isShowingTwitterFeed = false
        self.isShowingAllFeed = false
        self.instagramProvider = SFInstagramProvider()
        self.twitterProvider = SFTwitterProvider()
        //__ Configure view's delegate to get all user interaction
        self.feedListView.delegate = self
        //__ Init the view model
        viewModel()
        
        //__ Add observer to get instagram session chenged notification
        NotificationCenter.default.addObserver(self, selector: #selector(instagramSessionChanged), name: NSNotification.Name.InstagramKitUserAuthenticationChanged, object: nil)
        //__ Validate is user is logged into instagram
        validateInstragramLogged()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //__ Configure navigation bar
        configureNavigationBar()
        //__ if I'm showing twitter feed -> validate twitter logged
        if isShowingTwitterFeed {
            validateTwitterLogged()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //__ Method to configure the navigation bar
    private func configureNavigationBar() {
        //__ If user ios logged into instagram or twitter -> show the session button
        if (self.instagramProvider.instagramProviderIsSessionValid() ||
            self.twitterProvider.twitterProviderIsSessionValid()) {
            //__ Configure session button
            let logoutButton = UIButton(type: .custom)
            logoutButton.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 30.0)
            logoutButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            logoutButton.setTitle(NSLocalizedString("log out session", comment: "session title"), for: UIControlState.normal)
            logoutButton.addTarget(self, action: #selector(showLogoutOptions), for: .touchUpInside)
            let logoutItem = UIBarButtonItem(customView: logoutButton)
            
            self.navigationItem.setRightBarButton(logoutItem, animated: true)
        }
        //__ Remove the button from navigation bar
        else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    //__ Method to configure the initial view model injection
    private func viewModel() {
        let viewModel = SFFeedListViewModel()
        viewModel.items = []
        viewModel.showInstagramFeed = true
        viewModel.showTwitterFeed = false
        viewModel.instagramLogged = self.instagramProvider.instagramProviderIsSessionValid()
        viewModel.twitterLogged = self.twitterProvider.twitterProviderIsSessionValid()
        viewModel.noLoginMessage = NSLocalizedString("log in message", comment: "login message")
        self.feedListView.viewModel = viewModel;
    }
    
    //__ Method to show the actionsheet for logout
    @objc private func showLogoutOptions() {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: UIAlertControllerStyle.actionSheet)
        
        //__ Configure logout instagram action
        let logoutInstagramAction = UIAlertAction(title: NSLocalizedString("log out instagram", comment: "logout instagram action"),
                                                  style: .default, handler: { (actionSheetController) -> Void in
                                                    self.logoutInstragram()
        })
        
        //__ Configure logout twitter action
        let logoutTwitterAction = UIAlertAction(title: NSLocalizedString("log out twitter", comment: "logout twitter action"),
                                                style: .default, handler: { (actionSheetController) -> Void in
                                                    self.logoutTwitter()
        })
        
        //__ Configure cancel action
        let cancelAction = UIAlertAction(title: NSLocalizedString("log in cancel", comment: "logout cancel action"),
                                         style: .cancel, handler: nil)
        
        //__ User is logged into instagram? -> add actio item
        if self.instagramProvider.instagramProviderIsSessionValid() {
            alert.addAction(logoutInstagramAction)
        }
        //__ User is logged into twitter? -> add actio item
        if self.twitterProvider.twitterProviderIsSessionValid() {
            alert.addAction(logoutTwitterAction)
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //__ Method to logout from instagram
    private func logoutInstragram() {
        //__ Execute the log out process
        self.instagramProvider.instagramProviderLogout()
        //__ Configure navigation bar (in order to remove "log out from twitter" from the actionsheet)
        configureNavigationBar()
        //__ Clear instagram model list
        self.instagramModelItemsList = []
        //__ Re inject the info into the view
        let viewModel : SFFeedListViewModel = self.feedListView.viewModel!
        viewModel.instagramLogged = self.instagramProvider.instagramProviderIsSessionValid()
        viewModel.twitterLogged = self.twitterProvider.twitterProviderIsSessionValid()
        if self.isShowingInstagramFeed {
            viewModel.items = SFFeedViewObject.generateItemObjects(itemObjects: self.instagramModelItemsList)
        }
        self.feedListView.viewModel = viewModel
    }
    
    //__ Method to logout from twitter
    private func logoutTwitter() {
        //__ Execute the log out process
        self.twitterProvider.twitterProviderLogout()
        //__ Configure navigation bar (in order to remove "log out from twitter" from the actionsheet)
        configureNavigationBar()
        //__ Clear twitter model list
        self.twitterModelItemsList = []
        //__ Re inject the info into the view
        let viewModel : SFFeedListViewModel = self.feedListView.viewModel!
        viewModel.instagramLogged = self.instagramProvider.instagramProviderIsSessionValid()
        viewModel.twitterLogged = self.twitterProvider.twitterProviderIsSessionValid()
        if self.isShowingTwitterFeed {
            viewModel.items = SFFeedViewObject.generateItemObjects(itemObjects: self.twitterModelItemsList)
        }
        self.feedListView.viewModel = viewModel
    }
    
    //__ Method to validate if instagram session changed (log in or log out)
    @objc private func instagramSessionChanged() {
        loadInstragramFeed()
    }
    
    //__ Method to validate instagram session
    private func validateInstagramSession() {
        if (!self.instagramProvider.instagramProviderIsSessionValid()) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showInstagramLogin"), object: nil, userInfo: nil)
        }
        else {
            loadInstragramFeed()
        }
    }
    
    //__ Method to validate if the user is logged into instagram
    private func validateInstragramLogged() {
        if self.instagramProvider.instagramProviderIsSessionValid() {
            loadInstragramFeed()
        }
    }
    
    //__ Method to validate if the user is logged into twitter
    @objc private func validateTwitterLogged() {
        if self.twitterProvider.twitterProviderIsSessionValid() {
            loadTwitterFeed(showResultsFromBegining: true)
        }
    }
    
    //__ Show instagram feed list
    private func showInstagramFeed() {
        let viewModel : SFFeedListViewModel = self.feedListView.viewModel!
        viewModel.showInstagramFeed = true
        viewModel.showTwitterFeed = false
        viewModel.showAllFeed = false
        viewModel.instagramLogged = self.instagramProvider.instagramProviderIsSessionValid()
        viewModel.twitterLogged = self.twitterProvider.twitterProviderIsSessionValid()
        viewModel.items = SFFeedViewObject.generateItemObjects(itemObjects: self.instagramModelItemsList)
        viewModel.showResultsFromBegining = true
        self.feedListView.viewModel = viewModel
    }
    
    //__ Show twitter feed list
    private func showTwitterFeed() {
        loadTwitterFeed(showResultsFromBegining: true)
    }
    
    //__ Show all feed list
    private func showAllFeed() {
        let viewModel : SFFeedListViewModel = self.feedListView.viewModel!
        //__ Add instagram list + twitter list
        let allFeed = self.instagramModelItemsList + self.twitterModelItemsList
        //__ Generate model items and sort the list by createdDate property
        viewModel.items = SFFeedViewObject.generateItemObjects(itemObjects: allFeed.sorted(by: {$0.createdDate! > $1.createdDate!}))
        viewModel.allowLoadMoreItems = true
        viewModel.showInstagramFeed = false
        viewModel.showTwitterFeed = false
        viewModel.showAllFeed = true
        viewModel.instagramLogged = self.instagramProvider.instagramProviderIsSessionValid()
        viewModel.twitterLogged = self.twitterProvider.twitterProviderIsSessionValid()
        viewModel.showResultsFromBegining = true
        self.feedListView.viewModel = viewModel
    }
    
    private func loadInstragramFeed() {
        //__ Load instagram feed list
        self.instagramProvider.instagramProviderSelfFeedOn(completion: { (modelItems: [SFItemFeed], error: ProviderErrorCode) in
            if (error != ProviderErrorCode.everythingOKCode) {
                return
            }
            
            self.instagramModelItemsList = self.instagramModelItemsList + modelItems
            let viewModel : SFFeedListViewModel = self.feedListView.viewModel!
            viewModel.items = SFFeedViewObject.generateItemObjects(itemObjects: self.instagramModelItemsList)
            viewModel.allowLoadMoreItems = true
            viewModel.showInstagramFeed = true
            viewModel.showTwitterFeed = false
            viewModel.instagramLogged = self.instagramProvider.instagramProviderIsSessionValid()
            viewModel.twitterLogged = self.twitterProvider.twitterProviderIsSessionValid()
            self.feedListView.viewModel = viewModel
        })
    }
    
    //__ Method to load Twitter feed
    public func loadTwitterFeed(showResultsFromBegining: Bool) {
        //__ User is not logged? -> Clear list for Twitter feed
        if !self.twitterProvider.twitterProviderIsSessionValid() {
            let viewModel : SFFeedListViewModel = self.feedListView.viewModel!
            viewModel.items = SFFeedViewObject.generateItemObjects(itemObjects: self.twitterModelItemsList)
            viewModel.allowLoadMoreItems = true
            viewModel.showInstagramFeed = false
            viewModel.showTwitterFeed = true
            viewModel.showAllFeed = false
            viewModel.instagramLogged = self.instagramProvider.instagramProviderIsSessionValid()
            viewModel.twitterLogged = self.twitterProvider.twitterProviderIsSessionValid()
            viewModel.showResultsFromBegining = showResultsFromBegining
            self.feedListView.viewModel = viewModel
            return
        }
        
        //__ Load twitter feed list
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
            viewModel.showAllFeed = false
            viewModel.instagramLogged = self.instagramProvider.instagramProviderIsSessionValid()
            viewModel.twitterLogged = self.twitterProvider.twitterProviderIsSessionValid()
            self.feedListView.viewModel = viewModel
        }
    }
    
    //__ Delegate methods
    
    //__ Method to capture Instagran login event
    func feedListViewDelegateInstagramLogin() {
        validateInstagramSession()
    }
    
    //__ Method to capture load more items event
    func feedListViewDelegateLoadMoreItems() {
        loadTwitterFeed(showResultsFromBegining: false)
    }
    
    //__ Method to capture social network selection (Instagram, Twitter, All)
    func feedListViewDelegateSocialNetworkSelected(socialNetwork: FeedSociaNetwork) {
        switch socialNetwork {
        case FeedSociaNetwork.instagramSocialNetwork:
            isShowingInstagramFeed = true
            isShowingTwitterFeed = false
            isShowingAllFeed = false
            showInstagramFeed()
        case FeedSociaNetwork.twitterSocialNetwork:
            isShowingInstagramFeed = false
            isShowingTwitterFeed = true
            isShowingAllFeed = false
            showTwitterFeed()
        default:
            isShowingInstagramFeed = false
            isShowingTwitterFeed = false
            isShowingAllFeed = true
            showAllFeed()
        }
    }
}
