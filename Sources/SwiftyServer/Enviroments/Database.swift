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

	func perform<T: SQLAction>(action: T, callback: () throws -> ()) throws
	func get<T: SQLView>(view: T, callback: (T.Result) throws -> ()) throws
	func get<T: SQLView, E>(all: T, callback: (T.Result) throws -> ()) throws where T.Result == Array<E>
}

public protocol DatabaseEnviroment: RequestEnviroment {
	associatedtype Database: DatabaseConnection
	static var connection: Database { get }
}
