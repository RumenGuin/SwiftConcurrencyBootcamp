//
//  ActorsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by RUMEN GUIN on 04/06/22.
//

import SwiftUI

// 1. What is the problem that actors is solving?
// 2. How was this problem solved prior to actors?
// 3. Actors can solve the problem!


class MyDataManager {
    static let instance = MyDataManager()
    private init() { }
    
    var data: [String] = []
    private let lock = DispatchQueue(label: "com.MyApp.MyDataManager")
    
    func getRandomData(completionHandler: @escaping (_ title: String?) -> ()) {
        
        lock.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            
            completionHandler(self.data.randomElement())
        }
        
    }
    
}

// everything is async in actor
// if you dont want async, put nonisolated keyword
actor MyActorDataManager {
    static let instance = MyActorDataManager()
    private init() { }
    
    var data: [String] = []
    
    nonisolated let randomText = "asdfghjkloiu"
    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return self.data.randomElement()
    }
    
    //to make it not isolated to actor
    //meaning we dont have to await to get into actor in order to access this func
    nonisolated func getSavedData() -> String {
        return "New Data"
    }
    
}


struct HomeView: View {
    
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onAppear(perform: {
            //let newString = manager.randomText //as nonisolated
            Task {
                //await manager.getSavedData()
            }
        })
        .onReceive(timer) { _ in
            
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run(body: {
                        self.text = data
                    })
                }
            }
            
            
//            DispatchQueue.global(qos: .background).async {
//
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                    }
//                }
//            }
        }
    }
}

struct BrowseView: View {
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.01, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8).ignoresSafeArea()
            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
            
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run(body: {
                        self.text = data
                    })
                }
            }
            
            
//            DispatchQueue.global(qos: .default).async {
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                    }
//                }
//            }
        }
    }
}

struct ActorsBootcamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
    }
}

struct ActorsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ActorsBootcamp()
    }
}
