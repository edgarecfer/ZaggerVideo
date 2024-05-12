//
//  ApiZaggerPrincipal.swift
//  zaggerEjemplo
//
//  Created by Edgar Cruz on 07/05/24.
//

import Foundation

final class ApiZaggerPrincipal {
    
    func obtenerDatos(onSuccess: @escaping(_ infoReel: ModeloPrincipal) -> Void, onFailure: @escaping(_ error: Error) -> Void) {
        do {
            if let bundlePath = Bundle.main.path(forResource: "Zags", ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                
                let zagList = try JSONDecoder().decode(ModeloPrincipal.self, from: jsonData)
                debugPrint(zagList, "RESPONSE MODELOPRINCIPAL")
                onSuccess(zagList)
            }
        }
        catch {
            print("Error al decodificar")
            print(error)
            onFailure(error)
        }
    }
    
}
