//
//  RemoteImageView.swift
//  SiriusYoungCon
//
//  Created by Владимир Мацнев on 03.04.2025.
//

import SwiftUI

struct RemoteImageView: View {
    @State private var image: Image?
    @State private var isLoading = false
    @State private var error: Error?
    
    let url: URL
    let networkService: NetworkService
    var isFlipped: Binding<Bool>?
    var useFlipEffect: Bool
    
    init(url: URL, networkService: NetworkService = NetworkService(), isFlipped: Binding<Bool>? = nil) {
        self.url = url
        self.networkService = networkService
        self.isFlipped = isFlipped
        self.useFlipEffect = isFlipped != nil
    }
    
    init(_ photoUrl: URL, networkService: NetworkService = NetworkService(), isFlipped: Binding<Bool>? = nil) {
        self.url = photoUrl
        self.networkService = networkService
        self.isFlipped = isFlipped
        self.useFlipEffect = isFlipped != nil
    }
    
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: useFlipEffect ? .fill : .fit)
                    .modifier(FlipEffectModifier(isFlipped: isFlipped, useFlipEffect: useFlipEffect))
            } else if isLoading {
                ProgressView()
            } else if error != nil {
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            } else {
                Color.gray.opacity(0.3)
            }
        }
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let uiimage = try await networkService.downloadImage(from: url)
            image = Image(uiImage: uiimage)
        } catch {
            self.error = error
            print("Ошибка загрузки изображения: \(error)")
        }
    }
}

struct FlipEffectModifier: ViewModifier {
    var isFlipped: Binding<Bool>?
    var useFlipEffect: Bool
    
    func body(content: Content) -> some View {
        if useFlipEffect, let isFlipped = isFlipped {
            content
                .padding()
                .rotation3DEffect(
                    .degrees(isFlipped.wrappedValue ? -180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
                .opacity(isFlipped.wrappedValue ? 0 : 1)
        } else {
            content
        }
    }
}
