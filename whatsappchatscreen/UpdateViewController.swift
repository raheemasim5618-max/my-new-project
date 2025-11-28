//
//  UpdateViewController.swift
//  whatsappchatscreen
//
//  Created by Developer on 19/11/2025.
//

import UIKit

struct updateData {
    let name: String
    let createdAt: String
    let image: UIImage?
}
struct APIUpdate: Codable {
    let name: String
    let username: String
    let email: String
}
class UpdateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var allUpdates: [updateData] = [
        updateData(name: "Ali", createdAt: "1 minute ago",image: UIImage(named: "image1")),
        updateData(name: "Ahmad", createdAt: "20 minute ago", image: UIImage(named: "image2")),
        updateData(name: "Usman", createdAt: "30 minute ago", image: UIImage(named: "image3")),
        updateData(name: "Abu bakar", createdAt: "40 minute ago", image:UIImage(named:"image4")),
        updateData(name: "Hamza", createdAt: "50 minute ago", image: UIImage(named: "image5")),
        updateData(name: "ali", createdAt: "1 hour ago",image: UIImage(named: "image6")),
        updateData(name: "Ahamd", createdAt: "2 hours ago", image: UIImage(named: "image3")),
        updateData(name: "Usman", createdAt: "2 hours 30 minutes ago",image:UIImage(named:"image1")),
        updateData(name: "Abu bakar", createdAt: "3 hours ago", image: UIImage(named: "image4")),
        updateData(name: "Hamza", createdAt: "3hours 40 minute ago", image: UIImage(named: "image2"))
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
       let titleLabel = UILabel()
            titleLabel.text = "UPDATES"
            titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
            titleLabel.textColor = .black
        let leftItem = UIBarButtonItem(customView: titleLabel)
            navigationItem.leftBarButtonItem = leftItem
        let cameraButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(cameraTapped))
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(menuTapped))
       navigationItem.rightBarButtonItems = [menuButton, cameraButton]
       navigationController?.navigationBar.tintColor = .black
        tableView.register(UINib(nibName: "MyStatusCellTableViewCell", bundle: nil), forCellReuseIdentifier: "MyStatusCellTableViewCell")
        setupFloatingActionButton()
        fetchUpdates()
    
}
    
    
    func fetchUpdates() {
        let urlString = "https://jsonplaceholder.typicode.com/users" 
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                print("API Error:", error)
                return
            }
            guard let data = data else { return }

            do {
                let apiData = try JSONDecoder().decode([APIUpdate].self, from: data)
                let newUpdates = apiData.map { api in
                    updateData(
                        name: api.name,
                        createdAt: "Just now",
                        image: UIImage(named: "image1")
                    )
                }
                DispatchQueue.main.async {
                    self.allUpdates = newUpdates
                    self.tableView.reloadData()
                }

            } catch {
                print("Decoding Error:", error)
            }
        }.resume()
    }
    
    func setupFloatingActionButton() {
            let fab = UIButton(type: .custom)
            let whatsappGreen = UIColor(red: 0.14, green: 0.77, blue: 0.28, alpha: 1.0)
            fab.backgroundColor = whatsappGreen
            fab.layer.cornerRadius = 30
            fab.layer.shadowRadius = 5
            fab.layer.shadowOpacity = 0.3
            let icon = UIImage(systemName: "camera", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
            fab.setImage(icon, for: .normal)
            fab.tintColor = .white
            fab.addTarget(self, action: #selector(addstatus), for: .touchUpInside)
            fab.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(fab)
            NSLayoutConstraint.activate([
                fab.heightAnchor.constraint(equalToConstant: 60),
                fab.widthAnchor.constraint(equalToConstant: 60),
                fab.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                fab.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            ])
        
}
    @objc func addstatus() {
        print("New Call button tapped!")
    }
    @objc func cameraTapped() {
        print("Camera tapped")
    }

   @objc func menuTapped() {
        print("Menu tapped")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return allUpdates.count
        }
}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyStatusCellTableViewCell", for: indexPath) as? MyStatusCellTableViewCell else {
                fatalError("Could not dequeue MyStatusCellTableViewCell. Check Identifier/Class in XIB.")
}
        if indexPath.section == 0 {
                    cell.configure(name: "My Status", time: "Tap to add status update", image: UIImage(named:"image6"), isViewed: true, showUnseenRing: false)
        }else{
            let update = allUpdates[indexPath.row]
            cell.configure(name: update.name,
                           time: update.createdAt,
                           image: update.image,
                           isViewed: true,
                           showUnseenRing: true)
}
                return cell
        
}
    
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if section == 1 && !allUpdates.isEmpty {

                let headerView = UIView()
                headerView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)

                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
                label.textColor = .gray
                label.text = "VIEWED UPDATES"
                label.translatesAutoresizingMaskIntoConstraints = false
                headerView.addSubview(label)
                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
                    label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5)
                ])
                return headerView
            }
            return nil
}
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            if section == 1 && !allUpdates.isEmpty {
                return 35
            }
            return 0
}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}
    

