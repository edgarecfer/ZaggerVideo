//
//  CeldaImgVideo.swift
//  zaggerEjemplo
//
//  Created by Edgar Cruz on 11/05/24.
//

import UIKit
import SDWebImage

class CeldaImgVideo: UICollectionViewCell {
    
    @IBOutlet weak var imagen: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        self.imagen.image = UIImage(systemName: "photo.fill")
        super.prepareForReuse()
    }
    
    func configImagen(url: String) {
        self.imagen.sd_setImage(with: URL(string: url), placeholderImage: UIImage(systemName: "photo.fill"))
    }

}
