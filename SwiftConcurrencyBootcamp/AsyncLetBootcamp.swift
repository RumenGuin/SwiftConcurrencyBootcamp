//
//  AsyncLetBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by RUMEN GUIN on 10/05/22.
//

import SwiftUI
//(for executing multiple asynchronous func at once and then awaiting the result of all those func at the same time -> we use async let)
//async let is letting us perform multiple methods at the same time and then wait for the result of all of those methods together
struct AsyncLetBootcamp: View {
    @State private var images: [UIImage] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/300")!
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Async Let 🥳")
            .onAppear {
                Task {
                    do {
                        //all images load at the same time
                        async let fetchImage1 = fetchImage()
//                        async let fetchImage2 = fetchImage()
//                        async let fetchImage3 = fetchImage()
//                        async let fetchImage4 = fetchImage()
                        async let fetchTitle1 = fetchTitle()
                        
                        //fetchTitle does not throw error so we dont need to add 'try'
                        let (image, title) = await (try fetchImage1, fetchTitle1)
                        
//                        let (image1, image2, image3, image4) = await (try fetchImage1,try fetchImage2,try fetchImage3,try fetchImage4)
//                        self.images.append(contentsOf: [image1,image2,image3,image4])
                        
                        
                        //all images at different time
//                        let image1 = try await fetchImage()
//                        self.images.append(image1)
//
//                        let image2 = try await fetchImage()
//                        self.images.append(image2)
//
//                        let image3 = try await fetchImage()
//                        self.images.append(image3)
//
//                        let image4 = try await fetchImage()
//                        self.images.append(image4)
                    }catch {
                        
                    }
                }
            }
        }
    }
    
    func fetchTitle() async -> String {
        return "New title"
    }
    
    func fetchImage() async throws -> UIImage {
        do {
            let (data, _) = try await URLSession.shared.data(from: url,delegate: nil)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

struct AsyncLetBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLetBootcamp()
    }
}
