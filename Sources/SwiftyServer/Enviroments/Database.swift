//
//  File 4.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation


public protocol DatabaseConnection {
	// General Database Connection Stuff!

	var isAvailable: Bool { get }

	func perform<T>(action: T) throws where T : SQLAction

	func get<T>(view: T) throws where T : SQLView

	func get<T: SQLView, E>(all: T) throws where T.Result == Array<E>


}


public protocol DatabaseEnviroment: RequestEnviroment {
	associatedtype Database: DatabaseConnection

	static var connection: Database { get }
}
