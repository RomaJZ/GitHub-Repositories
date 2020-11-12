//
//  GitRepoCell.swift
//  GitHub Repos
//
//  Created by Roma Filipenko on 12.11.2020.
//

import UIKit

class GitRepoCell: UITableViewCell {
    
    @IBOutlet private weak var gitRepoLabel: UILabel!
    @IBOutlet private weak var gitRepoStarsCountLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var gitRepoCellViewModel: GitRepoCellViewModelProtocol? {
        willSet(newRepo) {
            gitRepoLabel.text = newRepo?.name
            gitRepoStarsCountLabel.text = newRepo?.starsCount
        }
    }
    
    override var isHighlighted: Bool {
        willSet(highlited) {
            let scale: CGFloat = highlited ? 0.9 : 1
            
            UIView.animate(withDuration: 0.3) {
                self.contentView.transform = CGAffineTransform(scaleX: scale, y: scale)
                self.contentView.layoutIfNeeded()
            }
        }
    }
}
