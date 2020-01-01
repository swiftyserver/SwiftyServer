//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation
import NIOTLS
import NIOSSL
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

	enum ConError: Error {
		case requestError
	}

	public func perform<T>(action: T) throws where T : SQLAction {


		print("MYSQL Action requested!")

		let statement = T.SQLString.generateStatement(from: action)
		print("Generated statement: ", statement)


		let sem = DispatchSemaphore(value: 0)

		var deneme = false
		var error: Error?

		self.connection.execute(statement.sql, parameters: statement.values) { (result) in
			print("Result \(result)")
			deneme = result.asError == nil
			error = result.asError
			sem.signal()
		}

		sem.wait()


		print("Waited!")

		if let err = error {
			print("MyError: \(err)")
			throw err
		}
		if !deneme {

			throw ConError.requestError
		}

//Insert(into: infos, values: "firstname", "surname", Parameter())
		
//		return deneme
	}

	public func get<T>(view: T) throws where T : SQLView {

	}

	public func get<T, E>(all: T) throws where T : SQLView, E : Decodable, T.Result == Array<E> {

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

		
//		self.connection = MySQLConnection(host: self.hostname, user: "", password: "", database: "", port: 25060, characterSet: "utf8", reconnect: true)



		print("Connecting to mysql \(hostname)!")

		self.connection.connect { [self] res in

			print("MYSQL Result!")
			print(res)
		}



		print("")



	}


}
