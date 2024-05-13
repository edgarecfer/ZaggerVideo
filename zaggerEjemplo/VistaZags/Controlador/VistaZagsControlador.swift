//
//  VistaZagsControlador.swift
//  zaggerEjemplo
//
//  Created by Edgar Cruz on 09/05/24.
//

import Foundation
import UIKit
import AVKit

class VistaZagsControlador: UIViewController {
    
    @IBOutlet weak var contenedorPrincipal: UICollectionView!
    
    var apiZagger = ApiZaggerPrincipal()
    var modeloDatos: ModeloPrincipal?
    var streamController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupServicios()
    }
    
    private func setup() {
        configuracionColeccion()
    }
    
    private func configuracionColeccion() {
        contenedorPrincipal.register(UINib(nibName: "celdaPrincipal", bundle: nil), forCellWithReuseIdentifier: "celdaPrincipal")
        contenedorPrincipal.delegate = self
        contenedorPrincipal.dataSource = self
        
        if let collectionViewLayout = contenedorPrincipal.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    private func setupServicios() {
        apiZagger.obtenerDatos() { result in
            self.modeloDatos = result
            self.contenedorPrincipal.reloadData()
        } onFailure: { error in
            print("Error aqui: \(error.localizedDescription)")
        }
    }
    
}
extension VistaZagsControlador: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modeloDatos?.zags?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celdaPrincipal", for: indexPath) as! celdaPrincipal
        
        let nombreUsuario = modeloDatos?.zags?[indexPath.row].user?.name ?? ""
        let imagenUsuario = modeloDatos?.zags?[indexPath.row].user?.profile_picture_url ?? ""
        let titulo = modeloDatos?.zags?[indexPath.row].zag ?? ""
        let descripción = modeloDatos?.zags?[indexPath.row].caption ?? ""
        let datos = modeloDatos?.zags?[indexPath.row].zag_parent ?? ZagParent()
        let ocultarColeccion = (modeloDatos?.zags?[indexPath.row].zag_parent == nil) ? true : false
        
        cell.delegate = self
        cell.configItem(nombre: nombreUsuario, imgUsuario: imagenUsuario, titulo: titulo, descripcion: descripción, filesDatos: datos)
        cell.ocultarColeccion(ocultar: ocultarColeccion)
        return cell
    }

}

extension VistaZagsControlador: celdaPrincipalDelegate {
    func presentarImgVideo(url: String, esVideo: Bool) {
        let url = url
        if esVideo {
            let streamplayer = AVPlayer(url: URL(string: url)!)
            streamController.player = streamplayer
            self.present(self.streamController, animated: true, completion: {
                self.streamController.player?.play()
            })
        } else {
            let vc = VistaImagenZoom(nibName: "VistaImagenZoom", bundle: nil)
            vc.imagenUrl = url
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
}
