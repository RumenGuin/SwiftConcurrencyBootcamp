//
//  SwiftConcurrencyBootcampApp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by RUMEN GUIN on 30/04/22.
//

import SwiftUI

@main
struct SwiftConcurrencyBootcampApp: App {
    var body: some Scene {
        WindowGroup {
            DownloadImageAsync()
        }
    }
}
