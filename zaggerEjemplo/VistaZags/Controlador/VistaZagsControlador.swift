//
//  VistaZagsControlador.swift
//  zaggerEjemplo
//
//  Created by Edgar Cruz on 09/05/24.
//

import Foundation
import UIKit

class VistaZagsControlador: UIViewController {
    
    @IBOutlet weak var contenedorPrincipal: UICollectionView!
    
    var apiZagger = ApiZaggerPrincipal()
    var modeloDatos: ModeloPrincipal?
    
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
        
        cell.configItem(nombre: nombreUsuario, imgUsuario: imagenUsuario, titulo: titulo, descripcion: descripción, filesDatos: datos)
        cell.ocultarColeccion(ocultar: ocultarColeccion)
        return cell
    }

}
