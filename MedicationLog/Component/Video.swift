//
//  SwiftUIView.swift
//  
//
//  Created by Lee Jinhee on 2/21/24.
//

import AVKit
import PhotosUI
import SwiftUI

struct Movie: Transferable {
    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { received in
            let copy = URL.documentsDirectory.appending(path: "movie_\(received.file.lastPathComponent).mp4")
            
            if FileManager.default.fileExists(atPath: copy.path()) {
                try FileManager.default.removeItem(at: copy)
            }

            try FileManager.default.copyItem(at: received.file, to: copy)
            return Self.init(url: copy)
        }
    }
}

struct VideoPickerView: View {
        
    enum LoadState {
        case unknown, loading, loaded(Movie), failed
    }

    @State private var loadState = LoadState.unknown
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        PhotosPicker(selection: $selectedItem, matching: .videos, photoLibrary: .shared()) {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 180, height: 180)
                .foregroundStyle(Color.white.opacity(0.4))
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color.GrayAF.opacity(0.1))
                )
                .overlay {
                    switch loadState {
                    case .unknown, .failed, .loaded:
                        Image(systemName: "plus")
                            .font(.button2B)
                            .foregroundStyle(Color.ML_Primary)
                    case .loading:
                        ProgressView()
                    }
                }
        }
        .onChange(of: selectedItem) {
            guard let selectedItem = selectedItem else{ return}
            Task {
                do {
                    loadState = .loading
                    
                    if let movie = try await selectedItem.loadTransferable(type: Movie.self) {
                        RecordService.shared.appendVideoUrlToTodayRecord(url: movie.url)
                        loadState = .loaded(movie)
                    } else {
                        loadState = .failed
                    }
                } catch {
                    loadState = .failed
                }
            }
        }
    }
}

// TODO: 비디오 삭제 기능 구현
struct VideoView: View {
    let movieUrl: URL
    
    var body: some View {
        VideoPlayer(player: AVPlayer(url: movieUrl))
            .scaledToFill()
            .frame(width: 180, height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
