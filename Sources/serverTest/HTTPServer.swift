//
//  File 3.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/14/19.
//

import Foundation
import NIO
import NIOHTTP1


class Server<E: HTTPEnviroment> {

	let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
	let threadPool = NIOThreadPool(numberOfThreads: 6)


	static func childChannelInitializer(channel: Channel) -> EventLoopFuture<Void> {
		return channel.pipeline.configureHTTPServerPipeline(withErrorHandling: true).flatMap {
			channel.pipeline.addHandler(HTTPHandler())
		}
	}


	init(host: String, port: Int = 8080) {
		threadPool.start()

		let socketBootstrap = ServerBootstrap(group: group)
			// Specify backlog and enable SO_REUSEADDR for the server itself
			.serverChannelOption(ChannelOptions.backlog, value: 256)
			.serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)

			// Set the handlers that are applied to the accepted Channels
			.childChannelInitializer(Self.childChannelInitializer(channel:))

			// Enable SO_REUSEADDR for the accepted Channels
			.childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
			.childChannelOption(ChannelOptions.maxMessagesPerRead, value: 1)
			.childChannelOption(ChannelOptions.allowRemoteHalfClosure, value: false)



		self.channel = try! socketBootstrap.bind(host: "127.0.0.1", port: 8888).wait()
	}

	var channel: Channel

	deinit {
		try! group.syncShutdownGracefully()
		try! threadPool.syncShutdownGracefully()
	}

	func serve() {
		try! channel.closeFuture.wait()
		print("Stop!")
	}


	func configure(_ points: () -> ()) {
		print("Start Endpoint Config")
		points()
		print("End Config!")
	}

	var endPoints: EnviromentRouter<E> = .init()
}


class ServerHandler<E: HTTPEnviroment> {

}

class EnviromentRouter<E: HTTPEnviroment> {

	//	static var shared: EnviromentRouter = .init()

	var tracker: [String] = []

	func add(path: String, method: String) {
		print("Registered path: \(path), \(method)")
	}

	func add(type: String) {
		print("Registered In Type: \(type)")
	}

	func add(middle name: String) {
		print("Middle Operation registered: \(name)")
	}


	func add(returns type: String, point: AnyPoint<E>) {
		print("Return Type: \(type)")
	}

	var routes: [String: AnyPoint<E>] = [:]

	init() {

	}
}
