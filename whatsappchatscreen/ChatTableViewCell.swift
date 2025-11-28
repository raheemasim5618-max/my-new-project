//
//  ChatTableViewCell.swift
//  whatsappchatscreen
//
//  Created by Developer on 12/11/2025.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImgV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var muteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImgV.layer.cornerRadius = profileImgV.frame.size.width / 2
        profileImgV.clipsToBounds = true
        profileImgV.contentMode = .scaleAspectFill
    }
    
    func configure(with chat: Chat) {
        nameLbl.text = chat.name
        msgLbl.text = chat.lastMessage
        timeLbl.text = chat.time
        profileImgV.image = chat.profileImage
        muteImageView.image = chat.icontype
        muteImageView.isHidden = (chat.icontype == nil)
        
    }
}
