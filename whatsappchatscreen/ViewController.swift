//
//  ViewController.swift
//  whatsappchatscreen
//
//  Created by Abdul-Raheem on 12/11/2025.
//

import UIKit
struct Chat {
    
    let name: String
    var lastMessage: String
    let profileImage: UIImage?
    let time: String
    let icontype: UIImage?
}
struct APIChat: Codable {
    let id: Int
    let name: String
    let email: String
}
struct NewChatRequest: Codable {
    let name: String
    let email: String
}
struct NewChatResponse: Codable {
    let id: Int?
    let name: String?
    let email: String?
}
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var chats: [Chat] = [
        Chat(name: "Ali", lastMessage: "Hello!", profileImage: UIImage(named: "image"), time: "10:30 AM", icontype: UIImage(systemName: "bell.fill")),
        Chat(name: "Ahmad", lastMessage: "How are you?", profileImage: UIImage(named: "image1"), time: "11:15AM",icontype: UIImage(systemName: "archivebox.fill")),
        Chat(name: "nouman", lastMessage: "See you soon", profileImage: UIImage(named: "image2"), time: "11:45AM",icontype: nil),
        Chat(name: "sufyan", lastMessage: "See you soon", profileImage: UIImage(named: "image3"), time: "12:00PM",icontype: UIImage(systemName: "bell.slash.fill")),
        Chat(name: "suleman", lastMessage: "See you soon", profileImage: UIImage(named: "image4"), time: "1:00PM",icontype: UIImage(systemName: "pin.slash.fill")),
        Chat(name: "abu bakar", lastMessage: "you are good", profileImage: UIImage(named: "image5"), time: "3:30PM",icontype: UIImage(systemName:"square.and.arrow.down.fill" )),
        Chat(name: "ahmad", lastMessage: "give it to me", profileImage: UIImage(named: "image6"), time: "4:00PM",icontype: nil),
        Chat(name: "Ali", lastMessage: "Hello!", profileImage: UIImage(named: "image"), time: "10:30 AM", icontype: UIImage(systemName: "bell.fill")),
        Chat(name: "Ahmad", lastMessage: "How are you?", profileImage: UIImage(named: "image1"), time: "11:15AM",icontype: UIImage(systemName: "archivebox.fill")),
        Chat(name: "nouman", lastMessage: "See you soon", profileImage: UIImage(named: "image2"), time: "11:45AM",icontype: nil),
        Chat(name: "sufyan", lastMessage: "See you soon", profileImage: UIImage(named: "image3"), time: "12:00PM",icontype: UIImage(systemName: "bell.slash.fill")),
        Chat(name: "suleman", lastMessage: "See you soon", profileImage: UIImage(named: "image4"), time: "1:00PM",icontype: UIImage(systemName: "pin.slash.fill")),
        Chat(name: "abu bakar", lastMessage: "you are good", profileImage: UIImage(named: "image5"), time: "3:30PM",icontype: UIImage(systemName:"square.and.arrow.down.fill" )),
        Chat(name: "ahmad", lastMessage: "give it to me", profileImage: UIImage(named: "image6"), time: "4:00PM",icontype: nil)
    ]
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        let titleLabel = UILabel()
        titleLabel.text = "WhatsApp"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        titleLabel.textColor = .black
        let leftItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = leftItem
        let cameraButton = UIBarButtonItem(image: UIImage(systemName: "camera.fill"), style: .plain, target: self,action: #selector(cameraTapped))
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self,action: #selector(menuTapped))
        navigationItem.rightBarButtonItems = [menuButton, cameraButton]
        navigationController?.navigationBar.tintColor = .black
        addSearchField()
        setupFloatingActionButton()
        setupTableHeader()
        fetchChats()
        postNewChat()
        updateChat()
        deleteChat(id: 1)
    }
    
    func deleteChat(id: Int) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(id)") else {
            print("Bad URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("DELETE Error:", error)
                return
            }
            if let httpResp = response as? HTTPURLResponse {
                print("DELETE Status Code:", httpResp.statusCode)
            }
            DispatchQueue.main.async {
                if let index = self.chats.firstIndex(where: { $0.name.lowercased() == "updated name" }) {
                    self.chats.remove(at: index)
                    self.tableview.reloadData()
                }
            }
            print("Chat deleted successfully")
        }.resume()
    }
    
    func updateChat() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users/1") else {
            print("Bad URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let updatedChat = NewChatRequest(name: "Updated Name", email: "updated@example.com")
        do {
            let jsonData = try JSONEncoder().encode(updatedChat)
            request.httpBody = jsonData
        } catch {
            print("Encoding error:", error)
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("UPDATE Error:", error)
                return
            }
            if let httpResp = response as? HTTPURLResponse {
                print("UPDATE Status code:", httpResp.statusCode)
            }
            guard let data = data else {
                print("No data in UPDATE response")
                return
            }
            do {
                let resp = try JSONDecoder().decode(NewChatResponse.self, from: data)
                print("Updated Response:", resp)
                DispatchQueue.main.async {
                    if let index = self.chats.firstIndex(where: { $0.name.lowercased() == "updated name" }) {
                        self.chats[index].lastMessage = resp.email ?? "Updated"
                        self.tableview.reloadData()
                    }
                }
            } catch {
                print("Decoding UPDATE error:", error)
                if let s = String(data: data, encoding: .utf8) {
                    print("Raw update response:", s)
                }
            }
        }.resume()
    }
    
func postNewChat() {
           guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
               print("Bad URL")
               return
           }
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
           let newChat = NewChatRequest(name: "John Appleseed", email: "john@example.com")
           do {
               let jsonData = try JSONEncoder().encode(newChat)
               request.httpBody = jsonData
           } catch {
               print("Encoding Error:", error)
               return
           }
           URLSession.shared.dataTask(with: request) { data, response, error in
               if let error = error {
               print("POST Error:", error)
                   return
               }
               if let httpResp = response as? HTTPURLResponse {
               print("POST Status code:", httpResp.statusCode)
               }
               guard let data = data else {
                   print("No data in POST response")
                   return
               }
               do {
                   let resp = try JSONDecoder().decode(NewChatResponse.self, from: data)
                   print("Response JSON:", resp)
                   if let name = resp.name, let email = resp.email {
                       let created = Chat(
                           name: name,
                           lastMessage: email,
                           profileImage: UIImage(named: "image1"),
                           time: "Now",
                           icontype: UIImage(systemName: "circle.fill")
                       )
                       DispatchQueue.main.async {
                           self.chats.insert(created, at: 0)
                           self.tableview.reloadData()
                       }
                   }
               } catch {
                   print("Decoding POST response error:", error)
                   if let s = String(data: data, encoding: .utf8) {
                       print("Raw response:", s)
            }
        }
    }.resume()
}
   
      func fetchChats() {
          let urlString = "https://jsonplaceholder.typicode.com/users"
          guard let url = URL(string: urlString) else { return }
          URLSession.shared.dataTask(with: url) { data, response, error in
              if let error = error {
                  print("API Error:", error)
                  return
              }
                  guard let data = data else { return }
                  do {
                  let apiData = try JSONDecoder().decode([APIChat].self, from: data)
                  let newChats = apiData.map { api in
                  Chat(
                          name: api.name,
                          lastMessage: api.email,
                          profileImage: UIImage(named: "image1"),
                          time: "Now",
                          icontype: UIImage(systemName: "circle.fill")
                      )
                  }
                  DispatchQueue.main.async {
                      self.chats = newChats
                      self.tableview.reloadData()
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
            let icon = UIImage(systemName: "plus.app.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
            fab.setImage(icon, for: .normal)
            fab.tintColor = .white
            fab.addTarget(self, action: #selector(morecontacts), for: .touchUpInside)
            fab.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(fab)
            NSLayoutConstraint.activate([
                fab.heightAnchor.constraint(equalToConstant: 60),
                fab.widthAnchor.constraint(equalToConstant: 60),
                fab.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                fab.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            ])
}
    @objc func morecontacts() {
        print("New Call button tapped!")
  }
    func addSearchField() {
        let searchField = UITextField()
        searchField.placeholder = "Ask Meta AI or Search"
        searchField.backgroundColor = UIColor(white: 0.85, alpha: 1)
        searchField.layer.cornerRadius = 20
        searchField.translatesAutoresizingMaskIntoConstraints = false
        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconView.tintColor = .gray
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        let leftContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        leftContainer.addSubview(iconView)
        iconView.center = leftContainer.center
        searchField.leftView = leftContainer
        searchField.leftViewMode = .always
        view.addSubview(searchField)
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor,constant: 5),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func cameraTapped() {
        print("Camera tapped")
    }
    
    @objc func menuTapped() {
        print("Menu tapped")
    }
    
    func setupTableHeader() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10),
            stack.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10)
        ])
        let titles = ["All", "Unread 30", "Favourite", "Groups 9", "+"]
        for title in titles {
            let btn = UIButton(type: .system)
            btn.setTitle(title, for: .normal)
            btn.backgroundColor = UIColor(white: 0.85, alpha: 1)
            btn.layer.cornerRadius = 17
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            stack.addArrangedSubview(btn)
        }
        tableview.tableHeaderView = headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatcell", for: indexPath) as! ChatTableViewCell
        cell.configure(with: chats[indexPath.row])
        return cell
    }
    
}
    

