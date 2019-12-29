//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation


public protocol RequestEnviroment {

}


@_functionBuilder
struct EnviromentBuilder<E: RequestEnviroment> {
	static func buildBlock(_ items: AnyPoint<E>...) -> () {
		return ()
    }
}
