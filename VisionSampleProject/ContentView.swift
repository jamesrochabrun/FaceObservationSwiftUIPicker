//
//  ContentView.swift
//  VisionSampleProject
//
//  Created by James Rochabrun on 2/1/21.
//

import SwiftUI
import Vision

struct ContentView: View {
    
    @State private var imagePickerOpen: Bool = false
    @State private var cameraOpen: Bool = false
    @State private var image: UIImage? = nil
    @State private var faces: [VNFaceObservation]? = nil
    
    private var faceCount: Int { faces?.count ?? 0 }
    private let placeHolderImage = UIImage(systemName: "photo")!
    private var cameraEnabled: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    private var detectionEnabled: Bool { image != nil }
        
    var body: some View {
        if imagePickerOpen { imagePickerView }
        if cameraOpen { cameraView }
        if !imagePickerOpen && !cameraOpen {
            mainView
        }
    }
    
    @ViewBuilder var imagePickerView: some View {
        ImagePicker { result in
            image = result
            cameraOpen = false
        }
    }
    
    @ViewBuilder var cameraView: some View {
        ImagePicker(camera: true) { result in
            image = result
            cameraOpen = false
        }
    }
    
    private func getFaces() {
        print("getting faces...")
        faces = []
        image?.detectFaces {
            faces = $0
            if let image = self.image,
               let annotatedImage = $0?.drawOn(image) {
                self.image = annotatedImage
            }
        }
    }
    
    private func summonImagePicker() {
        print("summoning ImagePicker...")
        imagePickerOpen = true
    }
    
    private func summonCamera() {
        print("summoning camera...")
        cameraOpen = true
    }
    
}

extension ContentView {
    
    @ViewBuilder var mainView: some View {
        NavigationView {
            MainView(image: image ?? placeHolderImage,
                     text: "\(faceCount) face\(faceCount == 1 ? "" : "s")") {
                TwoStateButton(text: "Detect Faces", disabled: !detectionEnabled, action: getFaces)
            }
            .padding()
            .navigationBarTitle(Text("FDDemo"), displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: summonImagePicker) {
                                        Text("Select")
                                    },
                                trailing:
                                    Button(action: summonCamera) {
                                        Text("Camera")
                                    }
                                    .disabled(!cameraEnabled)
            )
        }
    }
}

struct MainView: View {
    
    private let image: UIImage
    private let text: String
    private let button: TwoStateButton
    
    init(image: UIImage,
         text: String,
         button: () -> TwoStateButton) {
        self.image = image
        self.text = text
        self.button = button()
    }
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
            Text(text)
                .font(.title)
                .bold()
            Spacer()
            self.button
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
