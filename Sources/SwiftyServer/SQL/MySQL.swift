//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation
import SwiftKueryMySQL
import SwiftKuery

//class MySwiftyConnection {
//
//	static var SQLLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1)
//
//
//	func configure() {
//
//	}
//}

public struct SwiftyMySQLDatabase: DatabaseConnection {
	public func perform<T>(action: T, callback: () throws -> ()) throws where T : SQLAction {
		let statement = T.SQLString.generateStatement(from: action)


	}

	public func get<T>(view: T, callback: (T.Result) throws -> ()) throws where T : SQLView {
//		let statement = T.SQLString.generateStatement(from: action)


	}

	public func get<T, E>(all: T, callback: (T.Result) throws -> ()) throws where T : SQLView, E : Decodable, T.Result == Array<E> {
//		let statement = T.SQLString.generateStatement(from: action)


		
	}

	public func perform<T, O>(action: T, output: O.Type) throws where T : SQLAction, O : Decodable {
		
	}


	enum ConError: Error {
		case requestError
	}






	public var isAvailable: Bool {
		self.connection.isConnected
	}

	public var hostname: String
	public var database: String


	private var connection: MySQLConnection

	public init(hostname: String, database: String) {
		self.hostname = hostname
		self.database = database

		self.connection = MySQLConnection(host: self.hostname, user: "doadmin", password: "gqzdtaw8zp69lgbj", database: "defaultdb", port: 25060, characterSet: "utf8", reconnect: true)
		
//		self.connection = MySQLConnection(host: self.hostname, user: "", password: "", database: "", port: 25060, characterSet: "utf8", reconnect: true)



		print("Connecting to mysql \(hostname)!")

		self.connection.connect { res in
			print("MYSQL Result!")
			print(res)
		}



		print("")



	}


}
