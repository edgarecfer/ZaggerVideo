//
//  celdaPrincipal.swift
//  zaggerEjemplo
//
//  Created by Edgar Cruz on 09/05/24.
//

import UIKit
import SDWebImage

protocol celdaPrincipalDelegate:AnyObject {
    func presentarImgVideo(url: String, esVideo: Bool)
}

class celdaPrincipal: UICollectionViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imagenUsuario: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var conteoItemsVista: UIView!
    @IBOutlet weak var conteItems: UILabel!
    @IBOutlet weak var vistaContenedoraImgVideo: UIView!
    @IBOutlet weak var contenedorImgVideo: UICollectionView!
    @IBOutlet weak var tituloZag: UILabel!
    @IBOutlet weak var descripción: UILabel!
    
    var files: ZagParent?
    weak var delegate: celdaPrincipalDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
        calculateWidthCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setup() {
        viewMain.layer.cornerRadius = 20
        imagenUsuario.layer.cornerRadius = 12
        configuracionColeccion()
    }
    
    private func configuracionColeccion() {
        contenedorImgVideo.register(UINib(nibName: "CeldaImgVideo", bundle: nil), forCellWithReuseIdentifier: "CeldaImgVideo")
        contenedorImgVideo.delegate = self
        contenedorImgVideo.dataSource = self
        contenedorImgVideo.layer.cornerRadius = 30
    }
    
    func configItem(nombre: String, imgUsuario: String, titulo: String,descripcion: String, filesDatos: ZagParent) {
        self.nombre.text = nombre
        self.imagenUsuario.sd_setImage(with: URL(string: imgUsuario), placeholderImage: UIImage(systemName: "photo.fill"))
        self.tituloZag.text = titulo
        self.descripción.text = descripcion
        self.files = filesDatos
        self.contenedorImgVideo.reloadData()
        
        configNumeracionItems()
    }
    
    func ocultarColeccion(ocultar: Bool) {
        if ocultar {
            vistaContenedoraImgVideo.isHidden = true
        } else {
            vistaContenedoraImgVideo.isHidden = false
        }
    }
    
    private func configNumeracionItems() {
        conteoItemsVista.layer.cornerRadius = 10
    }
    
    private func actualizarContador(numero: Int) {
        conteItems.text = "\(numero)/\(files?.files?.count ?? 0)"
    }
    
    private func calculateWidthCell() {
        viewMain.translatesAutoresizingMaskIntoConstraints = false
        viewMain.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
    }
    
    func checkVisibilityOfCell(cell: CeldaImgVideo,indexPath: IndexPath) {
        if let cellRect = (contenedorImgVideo.layoutAttributesForItem(at: indexPath)?.frame) {
            let completelyVisible = contenedorImgVideo.bounds.contains(cellRect)
            if completelyVisible{
                cell.videoPlay()
            } else {
                cell.stopVideo()
            }
        }
    }

}
extension celdaPrincipal: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return files?.files?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CeldaImgVideo", for: indexPath) as! CeldaImgVideo
        
        let esVideo = (files?.files?[indexPath.row].file_url ?? "ND").contains(".mp4")
        cell.configImagen(url: files?.files?[indexPath.row].file_url ?? "ND", esVideo: esVideo)
        cell.delegate = self
        actualizarContador(numero: indexPath.row+1)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeScreen = contenedorImgVideo.bounds
        let widthScreen = sizeScreen.width
        let heightScreen = sizeScreen.height
        
        return CGSize(width: widthScreen, height: heightScreen)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCell = self.contenedorImgVideo.indexPathsForVisibleItems.sorted { top, bottom -> Bool in
            return top.section < bottom.section || top.row < bottom.row
        }.compactMap { indexPath -> UICollectionViewCell? in
            return self.contenedorImgVideo.cellForItem(at: indexPath)
        }
        
        let indexPaths = self.contenedorImgVideo.indexPathsForVisibleItems.sorted()
        let cellCount = visibleCell.count
        guard let firstCell = visibleCell.first as? CeldaImgVideo, let firstIndex = indexPaths.first else {return}
        checkVisibilityOfCell(cell: firstCell, indexPath: firstIndex)
        if cellCount == 1 {return}
        guard let lastCell = visibleCell.last as? CeldaImgVideo, let lastIndex = indexPaths.last else {return}
        checkVisibilityOfCell(cell: lastCell, indexPath: lastIndex)
    }

}

extension celdaPrincipal: CeldaImgVideoDelgate {
    func verImgVideo(url: String, esVideo: Bool) {
        delegate?.presentarImgVideo(url: url, esVideo: esVideo)
    }
}
