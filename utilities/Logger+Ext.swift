//
//  Logger+Ext.swift
//  RickAndMorty
//
//  Created by Friss, Shay (206845153) on 12/18/25.
//

import os
import Foundation

extension Logger {
    static let network = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "network")
    static let swiftData = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "swiftData")
}
