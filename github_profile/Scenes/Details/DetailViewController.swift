//
//  DetailViewController.swift
//  github_profile
//
//  Created by dang.chi.truong on 10/5/26.
//


import UIKit

final class DetailViewController : UIViewController  {
    
   
    @IBOutlet weak var avatarUserImage: UIImageView!
    
    
    @IBOutlet weak var userNameText: UILabel!
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!

    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDetail()
        updateFavoriteButton()
    }

    private func updateFavoriteButton() {
        let isFav = CoreDataManager.shared.isFavorite(id: user.id)
        favoriteButton.image = UIImage(systemName: isFav ? "heart.fill" : "heart")
    }

    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        if CoreDataManager.shared.isFavorite(id: user.id) {
            CoreDataManager.shared.deleteUser(id: user.id)
        } else {
            CoreDataManager.shared.saveUser(user)
        }
        updateFavoriteButton()
    }

    private func fetchDetail() {
        Task {
            do {
                let detail = try await APIService.shared.getUserDetail(username: user.login)
                await MainActor.run {
                    userNameText.text = detail.login
                    loadAvatar(urlString: detail.avatarUrl)
                }
            } catch {
                print(error)
            }
        }
    }

    private func loadAvatar(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.avatarUserImage.image = UIImage(data: data)
            }
        }.resume()
    }
}
