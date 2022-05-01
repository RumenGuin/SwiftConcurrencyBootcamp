//
//  DoCatchTryThrowBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by RUMEN GUIN on 30/04/22.
//

import SwiftUI

//do-catch
//try
//throws

class DoCatchTryThrowBootcampDataManager {
    let isActive: Bool = true
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("New Text", nil)
        }else {
            return (nil, URLError(.badURL))
        }
    }
    
    //Generic type-> Result<Success, Failure>
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("New Text")
        }else {
            return.failure(URLError(.appTransportSecurityRequiresSecureConnection))
        }
    }
    
    func getTitle3() throws -> String {
        if isActive {
            return "New text"
        }else {
            throw URLError(.badServerResponse)
        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "Final text"
        }else {
            throw URLError(.badServerResponse)
        }
    }
}

class DoCatchTryThrowBootcampViewModel: ObservableObject {
    @Published var text: String = "Starting text."
    let manager = DoCatchTryThrowBootcampDataManager()
    
    func fetchTitle() {
        
        /*
        let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            self.text = newTitle
        }else if let error = returnedValue.error {
            self.text = error.localizedDescription
        }
         */
        /*
        let result = manager.getTitle2()
        
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
        */
        
//        let newTitle = try? manager.getTitle3()
//        if let newTitle = newTitle {
//            self.text = newTitle
//        }
        //try? -> means you dont care about the error/ you want to show error to the user
        
        do {
            let newTitle = try manager.getTitle3()
            self.text = newTitle
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
        } catch let error {
            self.text = error.localizedDescription
        }
    }
}

struct DoCatchTryThrowBootcamp: View {
    @StateObject private var viewModel = DoCatchTryThrowBootcampViewModel()
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

struct DoCatchTryThrowBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DoCatchTryThrowBootcamp()
    }
}
