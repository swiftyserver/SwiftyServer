//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 2/14/20.
//

import Foundation
import CMySQL

open class SwiftyMysql {

	let mysql: UnsafeMutablePointer<MYSQL>



	public init() {
		mysql_server_init(0, nil, nil)

		let host = "127.0.0.1"
		let user = "root"
		let password = "qwerty1234"
		let database = "powerbank"
		let port = 3306

		 mysql = mysql_init(nil)

		var reconnect: Int8 = 1
		withUnsafePointer(to: &reconnect) { ptr in
			if mysql_options(mysql, MYSQL_OPT_RECONNECT, ptr) != 0 {
				print("WARNING: Error setting MYSQL_OPT_RECONNECT")
			}
		}

		if (mysql_real_connect(mysql, host, user, password, database, UInt32(port), nil, 0) != nil) {

			print("Connected!")
			mysql_set_character_set(mysql, "utf8")

			let query = "SHOW TABLES"
			exec(query)
		}

		print("MYSQL INIT!!")
	}

	struct MysqlStatement {
		let pointer: UnsafeMutablePointer<MYSQL_STMT>
	}

	func prepare(_ raw: String) -> MysqlStatement? {
		mysql_thread_init()

		guard let statement = mysql_stmt_init(mysql) else {
			printError()
			mysql_thread_end()
			return nil

		}

		guard mysql_stmt_prepare(statement, raw, UInt(raw.utf8.count)) == 0 else {
			let error = "ERROR \(mysql_stmt_errno(statement)): " + String(cString: mysql_stmt_error(statement))
			mysql_stmt_close(statement)
			mysql_thread_end()
			return nil
		}

		return MysqlStatement(pointer: statement)
	}

	func printError() {
		print(String(cString: mysql_error(mysql)))
	}

	func exec(_ query: String) {
		guard let statement = self.prepare(query) else { return }

		guard let resultMetadata = mysql_stmt_result_metadata(statement.pointer) else {
			print("No Result!");
			return
		}

		guard let fields = mysql_fetch_fields(resultMetadata) else {
			printError();
			print("Init Error")
			return;
		}

//		let numFields = Int(mysql_num_fields(resultMetadata))
//		var binds = [MYSQL_BIND]()
//		var fieldNames = [String]()
//		var charsetnr = [UInt32]()
//
//		for i in 0 ..< numFields {
//			let field = fields[i]
//			binds.append(MySQLResultFetcher.getOutputBind(field))
//			fieldNames.append(String(cString: field.name))
//			charsetnr.append(field.charsetnr)
//		}
//
//		let bindPtr = UnsafeMutablePointer<MYSQL_BIND>.allocate(capacity: binds.count)
//		for i in 0 ..< binds.count {
//			bindPtr[i] = binds[i]
//		}
//
//
//		guard mysql_stmt_bind_result(statement.pointer, bindPtr) == mysql_false() else {
//			printError();
//			print("Init Error")
//			return;
//		}

		guard mysql_stmt_execute(statement.pointer) == 0 else {
			printError();
			print("Init Error")
			return;
        }

		print("We have result!")

	}


}
