//
//  ControladorVP.swift
//  zaggerEjemplo
//
//  Created by Edgar Cruz on 07/05/24.
//

import Foundation
import UIKit

class ControladorVP: UIViewController {
    
    @IBOutlet weak var contenedorPrincipal: UICollectionView!
    
    var apiZagger = ApiZaggerPrincipal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupServicios()
    }
    
    private func setup() {
//        configuracionColeccion()
    }
    
//    private func configuracionColeccion() {
//        contenedorPrincipal.register(UINib(nibName: "celdaPrincipal", bundle: nil), forCellWithReuseIdentifier: "celdaPrincipal")
//        contenedorPrincipal.delegate = self
//        contenedorPrincipal.dataSource = self
//    }
    
    private func setupServicios() {
        apiZagger.obtenerDatos() { result in
            for i in result.zags! {
                print("Usuario: \(i.user?.name ?? "ND")")
            }
        } onFailure: { error in
            print("Error aqui: \(error.localizedDescription)")
        }
    }
    
}
//extension ControladorVP: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celdaPrincipal", for: indexPath) as! celdaPrincipal
//        return cell
//    }
//    
//}
