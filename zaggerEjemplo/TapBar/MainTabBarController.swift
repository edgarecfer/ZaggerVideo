//
//  MainTabBarController.swift
//  zaggerEjemplo
//
//  Created by Edgar Cruz on 09/05/24.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    private func setup() {
        configureTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rounderBordesTopMenu()
    }
    
    //MARK: Methods
    private func configureTabBar() {
        let vistaZags = VistaZagsControlador()
        let vistaZagsControlador = UINavigationController(rootViewController: vistaZags)
        hiddenNavigation(view: vistaZagsControlador)
        vistaZagsControlador.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: 1)
        
        let vistaPrincipal = ControladorVP()
        let vistaPrincipalControlador = UINavigationController(rootViewController: vistaPrincipal)
        hiddenNavigation(view: vistaPrincipalControlador)
        vistaPrincipalControlador.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "snowflake"), tag: 2)
        
        let vistaMuro = MuroControlador()
        let vistaMuroControlador = UINavigationController(rootViewController: vistaMuro)
        hiddenNavigation(view: vistaMuroControlador)
        vistaMuroControlador.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), tag: 3)
        
        setViewControllers([vistaZagsControlador, vistaPrincipalControlador, vistaMuroControlador], animated: true)
    }
    
    private func rounderBordesTopMenu() {
        tabBar.layer.backgroundColor = UIColor.white.cgColor
        tabBar.tintColor = UIColor.black
        tabBar.clipsToBounds = true
        tabBar.layer.cornerRadius = 16
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        tabBar.itemPositioning = .centered
    }
    
    private func hiddenNavigation(view: UINavigationController) {
        view.navigationBar.isHidden = true
    }
}
