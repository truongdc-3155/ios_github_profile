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
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDetail()
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
