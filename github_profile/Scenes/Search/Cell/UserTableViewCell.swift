//
//  UserTableViewCell.swift
//  github_profile
//
//  Created by dang.chi.truong on 10/5/26.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var usernameText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private var imageTask: URLSessionDataTask?

    func configCell(with user: User) {
        usernameText.text = user.login
        avatarImage.image = nil
        imageTask?.cancel()
        guard let url = URL(string: user.avatarUrl) else { return }
        imageTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.avatarImage.image = UIImage(data: data)
            }
        }
        imageTask?.resume()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        avatarImage.image = nil
    }
}
