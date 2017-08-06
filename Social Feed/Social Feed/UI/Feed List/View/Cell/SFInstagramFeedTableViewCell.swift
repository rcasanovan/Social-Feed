//
//  SFInstagramFeedTableViewCell.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 03/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import UIKit

//__ Haneke
import Haneke

class SFInstagramFeedTableViewCell: UITableViewCell {
    //__ IBOutlets
    @IBOutlet weak private var itemFeedImageView : UIImageView?
    @IBOutlet weak private var itemFeedUserImageView : UIImageView?
    @IBOutlet weak private var itemFeedUsernameLabel : UILabel?
    @IBOutlet weak private var itemFeedTextLabel : UILabel?
    @IBOutlet weak private var itemFeedLocationLabel : UILabel?
    @IBOutlet weak private var itemFeedCreatedAtLabel : UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViewCell()
    }
    
    override func prepareForReuse() {
        self.itemFeedUserImageView?.image = nil
        self.itemFeedUsernameLabel?.text = ""
        self.itemFeedImageView?.image = nil
        self.itemFeedTextLabel?.text = ""
        self.itemFeedLocationLabel?.text = ""
        self.itemFeedCreatedAtLabel?.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupViewCell() {
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    //__ DVATableViewModelProtocol method
    func bind(withModel viewModel: DVATableViewModelProtocol!) {
        //__ Get the view model for cell
        let model : SFFeedViewObject = (viewModel as? SFFeedViewObject)!
        //__ Configure outlets
        self.itemFeedUserImageView?.contentMode = UIViewContentMode.scaleAspectFill
        self.itemFeedUserImageView?.clipsToBounds = true
        self.itemFeedUserImageView?.layer.cornerRadius = (self.itemFeedUserImageView?.frame.size.height)! / 2.0
        itemFeedUserImageView?.hnk_setImageFromURL(model.itemUserImageURL!)
        
        self.itemFeedUsernameLabel?.text = model.itemUsername
        
        self.itemFeedCreatedAtLabel?.text = model.itemCreatedAt
        
        self.itemFeedLocationLabel?.text = model.itemLocationName
        
        self.itemFeedImageView?.contentMode = UIViewContentMode.scaleAspectFill
        self.itemFeedImageView?.clipsToBounds = true
        itemFeedImageView?.hnk_setImageFromURL(model.itemImageURL!)
        
        self.itemFeedTextLabel?.text = model.itemText
    }
}
