//
//  ChannelTableViewCell.swift
//  Mobile News Reader
//
//  Created by Vladimir Gorbunov on 12.04.2021.
//

import UIKit
import RealmSwift

class ChannelTableViewCell: UITableViewCell {

   
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var channelDescription: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    //Для реализации checkbox и добавления в избранное, используем кнопку с изменением фонового изображения
    let checkedImage = UIImage(named: "icons-star-fill")
    let uncheckedImage = UIImage(named: "icons-star")
    var isFavorite: Bool = false {
        didSet {
            if isFavorite {
                favoriteButton.setImage (checkedImage, for: .normal)
            } else {
                favoriteButton.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    @IBAction func isFavoriteButton(_ sender: UIButton) {
        isFavorite = !isFavorite
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
