//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation

public struct MySQLDatabase: DatabaseConnection {
	public var hostname: String
	public var database: String

	public init(hostname: String, database: String) {
		self.hostname = hostname
		self.database = database
	}
}
