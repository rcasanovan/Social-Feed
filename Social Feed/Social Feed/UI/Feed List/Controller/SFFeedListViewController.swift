//
//  SFFeedListViewController.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

class SFFeedListViewController: SFBaseViewController, SFFeedListViewDelegate {
    private var instagramProvider: SFInstagramProvider!
    //__ Private section
    private var feedListView : SFFeedListView {
        get {
            return (self.view as? SFFeedListView)!;
        }
    }
    private var modelItemsList : [SFItemFeed] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.instagramProvider.instagramProviderPopularMedia()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //__ Configure the view model
        self.feedListView.delegate = self
        viewModel()
        self.instagramProvider = SFInstagramProvider()
        self.validateSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func viewModel() {
        let viewModel = SFFeedListViewModel()
        viewModel.items = []
        self.feedListView.viewModel = viewModel;
    }
    
    private func validateSession() {
        if (!self.instagramProvider.instagramProviderIsSessionValid()) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showInstagramLogin"), object: nil, userInfo: nil)
        }
        else {
            loadInstragramFeed()
        }
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
            self.feedListView.viewModel = viewModel
        })
    }
    
    //__ SFFeedListViewDelegate
    func feedListViewDelegateLoadMoreItems() {
        loadInstragramFeed()
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
