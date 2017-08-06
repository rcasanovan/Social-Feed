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
            if ((viewModel?.instagramAuthUrl) != nil) {
                configureLoginWebViewWith(viewModel: viewModel!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        cancelButton?.backgroundColor = UIColor.red
        cancelButton?.setTitle(NSLocalizedString("log in cancel", comment: "login cancel action"), for: UIControlState.normal)
        
        self.loginWebView?.delegate = self
        self.loginWebView?.scrollView.bounces = false
    }
    
    public func configureLoginWebViewWith(viewModel: SFInstagramLoginViewModel) {
        self.loginWebView?.loadRequest(NSURLRequest(url: viewModel.instagramAuthUrl! as URL) as URLRequest)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        delegate?.instagramLoginViewDelegateAuthenticationSuccess(url: request.url! as NSURL)
        return true
    }
    
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

