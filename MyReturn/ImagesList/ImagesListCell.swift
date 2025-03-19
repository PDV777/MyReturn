//КЛАСС для управления ячейками в таблице
import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIndifier = "ImagesListCell"
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var cellImage: UIImageView!
 
}



