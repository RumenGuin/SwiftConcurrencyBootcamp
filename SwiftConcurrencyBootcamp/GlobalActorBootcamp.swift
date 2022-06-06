//
//  GlobalActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by RUMEN GUIN on 06/06/22.
//

import SwiftUI
 //final class -> no other class can inherit from this class
@globalActor final class MyFirstGlobalActor {
    static var shared = MyNewDataManager()
}

actor MyNewDataManager {
    
    func getDataFromDatabase() -> [String] {
        return ["One", "Two", "Three", "Four", "Five", "Six"]
    }
    
}

class GlobalActorBootcampViewModel: ObservableObject {
    @MainActor @Published var dataArray: [String] = [] //update in main thread ONLY
    let manager = MyFirstGlobalActor.shared
    @MyFirstGlobalActor
    func getData() {
        Task {
            let data = await manager.getDataFromDatabase()
            await MainActor.run {
                self.dataArray = data //update in main thread ONLY
            }
            
        }
    }
}

struct GlobalActorBootcamp: View {
    @StateObject private var viewModel = GlobalActorBootcampViewModel()
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.getData()
        }
    }
}

struct GlobalActorBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        GlobalActorBootcamp()
    }
}
