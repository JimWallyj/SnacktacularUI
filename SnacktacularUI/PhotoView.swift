//
//  PhotoView.swift
//  SnacktacularUI
//
//  Created by JIM WALEJKO on 6/22/26.
//

import SwiftUI
import PhotosUI

struct PhotoView: View {
    @State var spot: Spot  //  passed in from SpotDetailView
    @State private var photo = Photo()
    @State private var data = Data()  //  We need to take image & convert it to data to save it
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var pickerIsPresented = true
    @State private var selectedImage = Image(systemName: "photo")
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        NavigationStack{
            Spacer()
            
          selectedImage
                .resizable()
                .scaledToFit()
            
            Spacer()
            
            Text("by: \(photo.reviewer), on: \(photo.postedOn.formatted(date: .numeric, time: .omitted))")
            
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel"){
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save"){
                            Task{
                                await PhotoViewModel.saveImage(spot: spot, photo: photo, data: data)
                                dismiss()
                            }
                        }
                    }
                }
                .photosPicker(isPresented: $pickerIsPresented, selection: $selectedPhoto)
                .onChange(of: selectedPhoto){
                    //  turn selectedPhoto into a usable Image View
                    Task{
                        do{
                            if let image = try await selectedPhoto?.loadTransferable(type: Image.self){
                                selectedImage = image
                            }
                            //  Get raw data from image so we can save it to Firebase Storage
                            guard let transferredData = try await selectedPhoto?.loadTransferable(type: Data.self) else{
                                print("😡 ERROR: Could not convert data from selectedPhoto.")
                                return
                            }
                            data = transferredData
                        }catch{
                            print("😡 ERROR: Could not create Image from selectedPhoto. \(error.localizedDescription)")
                        }
                    }
                   
                }
        }
        .padding()
    }
}

#Preview {
    PhotoView(spot: Spot(), )
}
