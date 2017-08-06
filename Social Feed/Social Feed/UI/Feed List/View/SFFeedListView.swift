//
//  SFFeedListView.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

import TwitterKit

enum FeedSociaNetwork: Int {
    case instagramSocialNetwork
    case twitterSocialNetwork
    case allSocialNetwork
}

class SFFeedListView: SFBaseView, DVATableViewModelDatasourceDelegate, UITableViewDelegate {
    //__ IBOutlets
    @IBOutlet weak fileprivate var itemsTableView: UITableView?
    @IBOutlet weak fileprivate var instagramLoginButton: UIButton?
    //__ Private section
    private var twitterLoginButton: TWTRLogInButton?
    private var datasource : DVAProtocolDataSourceForTableView?;
    internal var viewModel:SFFeedListViewModel? {
        didSet {
            if viewModel?.reloadItems == true {
                configureItemListWith(viewModel: viewModel!)
                configureInstagramLoginWith(viewModel: viewModel!)
                configureTwitterLoginFeedWith(viewModel: viewModel!)
            }
        }
    }
    private let threshold = 50.0 // threshold from bottom of tableView
    private var isLoadingMore = false // flag
    internal var delegate:SFFeedListViewDelegate?
    
    private func configureInstagramLoginWith(viewModel: SFFeedListViewModel) {
//        if (!viewModel.showInstagramFeed) {
//            instagramLoginButton?.isHidden = true
//            return
//        }
        instagramLoginButton?.isHidden = viewModel.instagramLogged || viewModel.showTwitterFeed
    }
    
    private func configureTwitterLoginFeedWith(viewModel: SFFeedListViewModel) {
//        if (!viewModel.showTwitterFeed) {
//            twitterLoginButton?.isHidden = true
//            return
//        }
        twitterLoginButton?.isHidden = viewModel.twitterLogged || viewModel.showInstagramFeed
    }
    
    private func configureItemListWith(viewModel: SFFeedListViewModel) {
        self.itemsTableView?.isHidden = !viewModel.showInstagramFeed && !viewModel.showTwitterFeed
        self.isLoadingMore = !viewModel.allowLoadMoreItems
        if viewModel.reloadItems == true {
            self.datasource?.viewModelDataSource = viewModel.items as DVATableViewModelDatasource
            self.itemsTableView?.isHidden = viewModel.items.count == 0;
            DispatchQueue.main.async {
                self.itemsTableView?.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //__ Configure view
        setupLoginButtons()
        setupView()
    }
    
    private func setupView() {
        //__ Configure UI
        self.backgroundColor = UIColor.white
        //__ Setup the data source
        setupDataSource()
    }
    
    private func setupLoginButtons() {
        instagramLoginButton?.clipsToBounds = true
        instagramLoginButton?.layer.cornerRadius = 4.0
        instagramLoginButton?.backgroundColor = UIColor.orange
        instagramLoginButton?.setTitle("Login con Instgram", for: UIControlState.normal)
        
        if (twitterLoginButton == nil) {
            twitterLoginButton = TWTRLogInButton(logInCompletion: { session, error in
                if (session != nil) {
                    print("signed in as \(String(describing: session?.userName))");
                } else {
                    print("error: \(String(describing: error?.localizedDescription))");
                }
            })
            twitterLoginButton?.center = self.center
            self.addSubview(twitterLoginButton!)
            twitterLoginButton?.isHidden = true
        }
    }
    
    private func setupDataSource() {
        //__ The delegate is self
        self.itemsTableView?.delegate = self
        //__ Register the cell
        self.itemsTableView?.register(UINib(nibName: "SFInstagramFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "SFInstagramFeedTableViewCell")
        self.itemsTableView?.register(UINib(nibName: "SFTwitterFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "SFTwitterFeedTableViewCell")
        self.itemsTableView?.register(UINib(nibName: "SFTwitterFeedImageTableViewCell", bundle: nil), forCellReuseIdentifier: "SFTwitterFeedImageTableViewCell")
        //__ Remove empty separator lines
        let tableView =  UIView(frame: CGRect.zero)
        self.itemsTableView!.tableFooterView = tableView
        self.itemsTableView!.tableFooterView!.isHidden = true
        //__ Init the data source
        self.datasource = DVAProtocolDataSourceForTableView()
        self.datasource?.delegate = self
        //__ Assign the data source
        self.itemsTableView?.dataSource = self.datasource
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.viewModel?.items[indexPath.row]
        if (item != nil) {
            if item?.itemType == ItemFeedType.instagramFeedType {
                return 500.0
            }
            if item?.itemType == ItemFeedType.twitterFeedType && item?.itemImageURL != nil {
                return 43.0 + 272.0 + (item?.itemTextFont.sizeOfString(string: item!.itemText!, constrainedToWidth: Double(self.frame.size.width - 64.0)).height)!
            }
            return 51.0 + (item?.itemTextFont.sizeOfString(string: item!.itemText!, constrainedToWidth: Double(self.frame.size.width - 64.0)).height)!
        }
        return 500.0
    }
    
    //__ Use this function in order to determinate the moment to load more items
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if !isLoadingMore && (maximumOffset - contentOffset <= CGFloat(threshold)) {
            delegate?.feedListViewDelegateLoadMoreItems()
            self.isLoadingMore = true
        }
    }
    
    @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
        delegate?.feedListViewDelegateSocialNetworkSelected(socialNetwork: FeedSociaNetwork(rawValue: (sender.selectedSegmentIndex))!)
    }
    
    @IBAction func instagramLoginButtonPressed(_ sender: UIButton) {
        delegate?.feedListViewDelegateInstagramLogin()
    }
}

//__ View model class
class SFFeedListViewModel: NSObject {
    var items:[SFFeedViewObject] = [] //__ items
    var reloadItems:Bool = true //__ reload or not the tableview
    var allowLoadMoreItems: Bool = true
    var instagramLogged: Bool = false
    var twitterLogged: Bool = false
    var showInstagramFeed: Bool = false
    var showTwitterFeed: Bool = false
}

//__ Delegate method class
protocol SFFeedListViewDelegate {
    func feedListViewDelegateInstagramLogin()
    func feedListViewDelegateLoadMoreItems()
    func feedListViewDelegateSocialNetworkSelected(socialNetwork: FeedSociaNetwork)
}
