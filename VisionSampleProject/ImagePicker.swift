//
//  ImagePicker.swift
//  VisionSampleProject
//
//  Created by James Rochabrun on 2/1/21.
//

import SwiftUI

struct ImagePicker {
        
    private(set) var selectedImage: UIImage?
    private(set) var cameraSource: Bool
    private let completion: (UIImage?) -> Void
    
    init(camera: Bool = false, completion: @escaping (UIImage?) -> Void) {
        self.cameraSource = camera
        self.completion = completion
    }
    
    public func makeCoordinator() -> ImagePicker.Coordinator {
        let coordinator = Coordinator(self)
        coordinator.completion = self.completion
        return coordinator
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        var completion: ((UIImage?) -> Void)?
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            print("imagePicker complete")
            let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            picker.dismiss(animated: true)
            completion?(selectedImage)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            print("imagePicker cancelled")
            picker.dismiss(animated: true)
            completion?(nil)
        }
    }
}

extension ImagePicker: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = cameraSource ? .camera : .photoLibrary
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker(camera: true, completion: { _ in })
    }
}
