//
//  AsyncPublisherBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by RUMEN GUIN on 06/06/22.
//

import SwiftUI
import Combine

class AsyncPublishedDataManager {
    @Published var myData: [String] = []
    
    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Lichuda")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Aamda")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Lebuda")
        
    }
    
}

class AsyncPublisherBootcampViewModel: ObservableObject {
    @MainActor @Published var dataArray: [String] = [] //telling we want to always update on the main thread
    let manager = AsyncPublishedDataManager()
    var cancellables = Set<AnyCancellable>()
    init() {
        addSubscriber()
    }
    
    private func addSubscriber() {
        
        Task {
            
            
//            await MainActor.run(body: {
//                self.dataArray =  ["One"]
//            })
            
            
            for await value in manager.$myData.values {
                await MainActor.run(body: {
                    self.dataArray = value //updates in main thread
                })
            }
            
            
//            await MainActor.run(body: {
//                self.dataArray =  ["two"]
//            })
            
        }
        
        
//        manager.$myData
//            .receive(on: DispatchQueue.main, options: nil)
//            .sink { dataArray in
//                self.dataArray = dataArray
//            }
//            .store(in: &cancellables)
    }
    
    func start() async {
        await manager.addData()
    }

}

struct AsyncPublisherBootcamp: View {
    @StateObject private var viewModel = AsyncPublisherBootcampViewModel()
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
            await viewModel.start()
        }
    }
}

struct AsyncPublisherBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncPublisherBootcamp()
    }
}
