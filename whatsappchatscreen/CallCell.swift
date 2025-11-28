

import UIKit

class CallCell: UITableViewCell {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var calltimeLabel: UILabel!
    @IBOutlet weak var photoIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
}
    
        override func layoutSubviews() {
        super.layoutSubviews()
        if let img = profileImg {
            img.layer.cornerRadius = img.frame .width/2
            img.clipsToBounds = true
            img.contentMode = .scaleAspectFill
        }
    }
    
    func configure(with call: Call) {
            nameLabel.text = call.name
            calltimeLabel.text = call.callTime
            nameLabel.textColor = call.isMissed ? .systemRed : .black
            if let imageName = call.profileImageName {
                profileImg.image = UIImage(named: imageName)
            } else {
                profileImg.image = UIImage(systemName: "person.circle.fill")
            }
            photoIcon.image = UIImage(systemName: call.isVideo ? "video.fill" : "phone.fill")
            photoIcon.tintColor = .gray
        }
    }
   

