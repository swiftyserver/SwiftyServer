//
//  File 4.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation


public protocol DatabaseConnection {
	// General Database Connection Stuff!
}


public protocol DatabaseEnviroment: RequestEnviroment {
	associatedtype Database: DatabaseConnection

	static var connection: Database { get }
}
