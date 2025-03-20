//
//  NetworkManger.swift
//  MyNewsApp
//
//  Created by mhaashim on 20/03/25.
//

import Network
import SwiftUI

class NetworkManager: ObservableObject {
    @Published var isConnected: Bool = true
    private let monitor = NWPathMonitor()

    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = (path.status == .satisfied)
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
