

import UIKit
struct Call {
    let name: String
    let callTime: String
    let profileImageName: String?
    let isVideo: Bool
    let isMissed: Bool
}
class CallViewContoller: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    let calls: [Call] = [
            Call(name: "Ali", callTime: "3 minutes ago", profileImageName: "image1", isVideo: false, isMissed: true),
            Call(name: "Ahmad", callTime: "10 minutes ago", profileImageName: "image2", isVideo: true, isMissed: false),
            Call(name: "Usman", callTime: "20 minutes ago", profileImageName: "image3", isVideo: false, isMissed: false),
            Call(name: "Hamza", callTime: "1 hour ago", profileImageName: "image4", isVideo: true, isMissed: true),
            Call(name: "Abu bakar", callTime: "Yesterday", profileImageName: "image5", isVideo: false, isMissed: false),
            Call(name: "Ali", callTime: "3 minutes ago", profileImageName: "image1", isVideo: false, isMissed: true),
            Call(name: "Ahmad", callTime: "10 minutes ago", profileImageName: "image2", isVideo: true, isMissed: false),
            Call(name: "Usman", callTime: "20 minutes ago", profileImageName: "image3", isVideo: false, isMissed: false),
            Call(name: "Hamza", callTime: "1 hour ago", profileImageName: "image4", isVideo: true, isMissed: true),
            Call(name: "Abu bakar", callTime: "Yesterday", profileImageName: "image5", isVideo: false, isMissed: false),
        ]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CallCell", bundle: nil),forCellReuseIdentifier: "CallCell")
        let titleLabel = UILabel()
             titleLabel.text = "CALLS"
             titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
             titleLabel.textColor = .black
         let leftItem = UIBarButtonItem(customView: titleLabel)
             navigationItem.leftBarButtonItem = leftItem
         let cameraButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(forsearch))
         let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(menuTapped))
        navigationItem.rightBarButtonItems = [menuButton, cameraButton]
        navigationController?.navigationBar.tintColor = .black
        setupFloatingActionButton()
}
    func setupFloatingActionButton() {
            let fab = UIButton(type: .custom)
            let whatsappGreen = UIColor(red: 0.14, green: 0.77, blue: 0.28, alpha: 1.0)
            fab.backgroundColor = whatsappGreen
            fab.layer.cornerRadius = 30
            fab.layer.shadowRadius = 5 
            fab.layer.shadowOpacity = 0.3
            let icon = UIImage(systemName: "phone.badge.plus.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
            fab.setImage(icon, for: .normal)
            fab.tintColor = .white
            fab.addTarget(self, action: #selector(newCallTapped), for: .touchUpInside)
            fab.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(fab)
            NSLayoutConstraint.activate([
                fab.heightAnchor.constraint(equalToConstant: 60),
                fab.widthAnchor.constraint(equalToConstant: 60),
                fab.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                fab.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            ])
}
         @objc func newCallTapped() {
                 print("New Call button tapped!")
           }
             @objc func forsearch() {
                 print("Camera tapped")
           }

             @objc func menuTapped() {
        print("Menu tapped")
                 
}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calls.count
          }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CallCell", for: indexPath) as? CallCell else {
                    return UITableViewCell()
          }
        let call = calls[indexPath.row]
                cell.configure(with: call)
                
                return cell
         }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected call: \(calls[indexPath.row].name)")
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
  
}
