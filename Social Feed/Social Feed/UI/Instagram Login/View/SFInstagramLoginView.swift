//
//  SFInstagramLoginView.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

class SFInstagramLoginView: SFBaseView, UIWebViewDelegate {
    //__ IBOutlets
    @IBOutlet weak var loginWebView : UIWebView?
    @IBOutlet weak var cancelButton : UIButton?
    //__ Internal section
    internal var delegate:SFInstagramLoginViewDelegate?
    internal var viewModel:SFInstagramLoginViewModel? {
        didSet {
            //__ View model injection
            //__ Use this code in order to inject all information to the view from view model
            if ((viewModel?.instagramAuthUrl) != nil) {
                configureLoginWebViewWith(viewModel: viewModel!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //__ Configure view
        setupView()
    }
    
    //__ Method to setup the view
    private func setupView() {
        //__ Configure cancel button
        cancelButton?.backgroundColor = UIColor.red
        cancelButton?.setTitle(NSLocalizedString("log in cancel", comment: "login cancel action"), for: UIControlState.normal)
        
        //__ Configure login web view
        self.loginWebView?.delegate = self
        self.loginWebView?.scrollView.bounces = false
    }
    
    //__ Method to start load request
    public func configureLoginWebViewWith(viewModel: SFInstagramLoginViewModel) {
        self.loginWebView?.loadRequest(NSURLRequest(url: viewModel.instagramAuthUrl! as URL) as URLRequest)
    }
    
    //__ Method to get the response from instagram login process
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        delegate?.instagramLoginViewDelegateAuthenticationSuccess(url: request.url! as NSURL)
        return true
    }
    
    //__ User actions
    
    //__ Method to cancel login process
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        delegate?.instagramLoginViewDelegateCancel()
    }
}

//__ View model class
class SFInstagramLoginViewModel: NSObject {
    var instagramAuthUrl:NSURL? = nil
}

//__ Delegate method class
protocol SFInstagramLoginViewDelegate {
    func instagramLoginViewDelegateCancel()
    func instagramLoginViewDelegateAuthenticationSuccess(url: NSURL)
}

