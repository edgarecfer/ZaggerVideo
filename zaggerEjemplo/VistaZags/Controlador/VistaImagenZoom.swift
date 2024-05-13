//
//  VistaImagenZoom.swift
//  zaggerEjemplo
//
//  Created by Edgar Cruz on 12/05/24.
//

import Foundation
import UIKit
import SDWebImage

class VistaImagenZoom: UIViewController {
    
    @IBOutlet weak var imagenContenido: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cerrarIcono: UIButton!
    
    var imagenUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScrollView()
        configIconos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cargarImagen()
    }
    
    private func configIconos() {
        cerrarIcono.tintColor = .white
        imagenContenido.tintColor = .white
    }
    
    private func cargarImagen() {
        imagenContenido.sd_setImage(with: URL(string: imagenUrl ?? "ND"), placeholderImage: UIImage(systemName: "photo.fill"))
    }
    
    private func setUpScrollView() {
        scrollView.delegate = self
    }
    
    @IBAction func tapCerrar(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension VistaImagenZoom: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imagenContenido
    }
    
}
