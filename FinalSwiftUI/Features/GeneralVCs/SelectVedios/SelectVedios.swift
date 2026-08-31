//
//  SelectVedios.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 19/12/2024.
//

import SwiftUI
import AVKit
import SwiftUI
import UIKit

struct VideoPickerView: View {
    @State private var showImagePicker = false
    @State private var selectedVideoURL: URL? = nil
    @State private var player: AVPlayer? = nil
    
    var body: some View {
        VStack {
            Button(action: {
                self.showImagePicker = true
            }) {
                Text("Select Video")
            }
            .sheet(isPresented: $showImagePicker) {
                VedioPicker(isPresented: self.$showImagePicker, selectedVideoURL: self.$selectedVideoURL)
            }
            
            if let url = selectedVideoURL {
                VideoPlayerView(videoURL: url)
                    .frame(width: 300, height: 200)
            }
        }
    }
}

struct VedioPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var selectedVideoURL: URL?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.mediaTypes = ["public.movie"]
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: VedioPicker
        
        init(parent: VedioPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let url = info[.mediaURL] as? URL {
                parent.selectedVideoURL = url
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}

struct VideoPlayerView: View {
    var videoURL: URL
    
    var body: some View {
        AVPlayerView(player: AVPlayer(url: videoURL))
            .onAppear() {
                let player = AVPlayer(url: videoURL)
                player.play()
            }
    }
}

struct AVPlayerView: View {
    var player: AVPlayer
    
    var body: some View {
        VideoPlayer(player: player)
            .onDisappear() {
                player.pause()
            }
    }
}
#Preview {
    VideoPickerView()
}
