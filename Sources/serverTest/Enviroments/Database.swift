//
//  File 4.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation


protocol DatabaseConnection {
	// General Database Connection Stuff!
}


protocol DatabaseEnviroment: RequestEnviroment {
	associatedtype Database: DatabaseConnection

	var connection: Database { get }

}
