//
//  NetworkReachbility.swift
//  Upstox
//
//  Created by Pushkar Dubey on 14/06/24.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    private var monitor: NWPathMonitor?
    private let queue = DispatchQueue.global(qos: .background)
    
    var isConnected: Bool = false
    
    private init() {
    }
    
    func startMonitor() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            print("Network status changed: \(self.isConnected ? "Connected" : "Disconnected")")
        }
        monitor?.start(queue: queue)
    }
}
