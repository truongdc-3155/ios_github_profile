//
//  FavoriteViewController.swift
//  github_profile
//
//  Created by dang.chi.truong on 11/5/26.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var users: [UserEntity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        users = CoreDataManager.shared.fetchUsers()
        tableView.reloadData()
    }
}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        let entity = users[indexPath.row]
        cell.usernameText.text = entity.login
        if let avatarUrl = entity.avatarUrl {
            cell.loadAvatar(urlString: avatarUrl)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let entity = users[indexPath.row]
        CoreDataManager.shared.deleteUser(id: Int(entity.id))
        users.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
