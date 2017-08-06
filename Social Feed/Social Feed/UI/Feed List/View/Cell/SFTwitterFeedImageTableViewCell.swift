//
//  SFTwitterFeedImageTableViewCell.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 05/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

//__ Haneke
import Haneke

class SFTwitterFeedImageTableViewCell: UITableViewCell {
    //__ IBOutlets
    @IBOutlet weak private var itemFeedUserImageView: UIImageView?
    @IBOutlet weak private var itemFeedUsernameLabel: UILabel?
    @IBOutlet weak private var itemFeedTextLabel: UILabel?
    @IBOutlet weak private var itemFeedImageView: UIImageView?
    @IBOutlet weak private var itemFeedTextHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak private var itemFeedCreatedAtLabel : UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViewCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.itemFeedUserImageView?.image = nil
        self.itemFeedTextLabel?.text = ""
        self.itemFeedImageView?.image = nil
        self.itemFeedTextHeightConstraint?.constant = 18.0
        self.itemFeedCreatedAtLabel?.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupViewCell() {
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    func heightForItem(text: String, font: UIFont) -> CGFloat {
        return (font.sizeOfString(string: text, constrainedToWidth: Double(self.frame.size.width - 64.0)).height)
    }
    
    //__ DVATableViewModelProtocol method
    func bind(withModel viewModel: DVATableViewModelProtocol!) {
        //__ Get the view model for cell
        let model : SFFeedViewObject = (viewModel as? SFFeedViewObject)!
        //__ Configure outlets
        self.itemFeedUserImageView?.contentMode = UIViewContentMode.scaleAspectFill
        self.itemFeedUserImageView?.clipsToBounds = true
        self.itemFeedUserImageView?.layer.cornerRadius = (self.itemFeedUserImageView?.frame.size.height)! / 2.0
        itemFeedUserImageView?.hnk_setImageFromURL((model.itemUserImageURL?.absoluteURL)!)
        
        self.itemFeedUsernameLabel?.text = model.itemUsername
        
        self.itemFeedCreatedAtLabel?.text = model.itemCreatedAt
        
        self.itemFeedTextLabel?.font = model.itemTextFont
        self.itemFeedTextLabel?.text = model.itemText
        self.itemFeedTextLabel?.numberOfLines = 0
        self.itemFeedTextHeightConstraint?.constant = 10.0 + heightForItem(text: model.itemText, font: model.itemTextFont)
        
        if (model.itemImageURL != nil) {
            self.itemFeedImageView?.contentMode = UIViewContentMode.scaleAspectFill
            self.itemFeedImageView?.clipsToBounds = true
            itemFeedImageView?.hnk_setImageFromURL(model.itemImageURL!)
            itemFeedImageView?.isHidden = false
        }
    }
}
