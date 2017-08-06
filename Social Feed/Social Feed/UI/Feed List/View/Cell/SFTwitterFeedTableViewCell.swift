//
//  SFTwitterFeedTableViewCell.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 04/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

//__ Haneke
import Haneke

class SFTwitterFeedTableViewCell: UITableViewCell {
    //__ IBOutlets
    @IBOutlet weak private var itemFeedUserImageView: UIImageView?
    @IBOutlet weak private var itemFeedUsernameLabel: UILabel?
    @IBOutlet weak private var itemFeedTextLabel: UILabel?
    @IBOutlet weak private var itemFeedTextHeightConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.itemFeedUserImageView?.image = nil
        self.itemFeedTextLabel?.text = ""
        self.itemFeedTextHeightConstraint?.constant = 18.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
        
        self.itemFeedTextLabel?.font = model.itemTextFont
        self.itemFeedTextLabel?.text = model.itemText
        self.itemFeedTextLabel?.numberOfLines = 0
        self.itemFeedTextHeightConstraint?.constant = 10.0 + heightForItem(text: model.itemText, font: model.itemTextFont)
    }
}