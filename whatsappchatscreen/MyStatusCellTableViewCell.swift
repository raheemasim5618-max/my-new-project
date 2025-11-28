//
//  MyStatusCellTableViewCell.swift
//  whatsappchatscreen
//
//  Created by Developer on 19/11/2025.
//

import UIKit

class MyStatusCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ringContainerView: UIView!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var Namelabel: UILabel!
    @IBOutlet weak var Lbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        ProfileImage.layer.cornerRadius = ProfileImage.frame.size.width / 2
        ProfileImage.clipsToBounds = true
        ProfileImage.contentMode = .scaleAspectFill
}
    
    func configure(name: String, time: String, image: UIImage?, isViewed: Bool, showUnseenRing: Bool) {
        Namelabel.text = name
        Lbl.text = time
        ProfileImage.image = image
        
        func drawStatusRing(color: UIColor) {
            ringContainerView.layer.sublayers?.filter { $0.name == "statusRing" }.forEach { $0.removeFromSuperlayer() }
            let circlePath = UIBezierPath(ovalIn: ringContainerView.bounds.insetBy(dx: 1.5, dy: 1.5))
            let ringLayer = CAShapeLayer()
            ringLayer.name = "statusRing"
            ringLayer.path = circlePath.cgPath
            ringLayer.fillColor = UIColor.clear.cgColor
            ringLayer.strokeColor = color.cgColor
            ringLayer.lineWidth = 2.0
            ringContainerView.layer.addSublayer(ringLayer)
        }
        
    }
    
}
