//
//  SpotDetailView.swift
//  SnacktacularUI
//
//  Created by JIM WALEJKO on 6/18/26.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import MapKit

struct SpotDetailView: View {
    @FirestoreQuery(collectionPath: "spots") var fsPhotos: [Photo]
    @State var spot: Spot  //  pass in value from ListView
    @State private var photoSheetIsPresented = false
    @State private var showingAlert = false  //  Alert user if they need to save Spot before adding a Photo
    @State private var alertMessage = "Cannot add a Photo until you save the Spot."
    @Environment(\.dismiss) private var dismiss
    private var photos: [Photo] {
        //  If running in Preview then show mock data
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return [Photo.preview, Photo.preview, Photo.preview, Photo.preview, Photo.preview, Photo.preview]
        }
        //  Else show Firebase Data
        return fsPhotos
    }
    
//    private var mapCameraPosition: MapCameraPosition{
//        let coordinate = CLLocationCoordinate2D(latitude: $spot.latitude, longitude: $spot.longitude)
//        return .region(MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
//    }
    
    
    
    var body: some View {
        VStack{
            Group{
                TextField("name", text: $spot.name)
                    .font(.title2)
                    .autocorrectionDisabled()
                
                TextField("address", text: $spot.address)
                    .font(.title2)
                    .autocorrectionDisabled()
            }
            .textFieldStyle(.roundedBorder)
            .overlay{
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            
            Text("Lat: \(spot.latitude), Long: \(spot.longitude)")

//            Map(position: .constant(MapCameraPosition)) {
//                Marker(spot.name, coordinate: CLLocationCoordinate2D(latitude: spot.lat, longitude: <#T##CLLocationDegrees#>))
//            }
            
            Button {  //  Photo Button
                if spot.id == nil{  //  Ask if you want to save
                    showingAlert.toggle()
                }else{  //  Go right to PhotoView
                    photoSheetIsPresented.toggle()
                }
            } label: {
                Image(systemName: "camera.fill")
                Text("Photo")
            }
            .bold()
            .buttonStyle(.borderedProminent)
            .tint(.snack)
            
            ScrollView(.horizontal){
                HStack{
                    ForEach(photos) { photo in
                        let url = URL(string: photo.imageURLString)
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
            }
            .frame(height: 80)
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .task{
            guard let id = spot.id else{
                print("New record - has no id")
                return
            }
            $fsPhotos.path = "spots/\(id)/photos"
        }
        
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel"){
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save"){
                    saveSpot()
                    dismiss()
                }
            }
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Save"){
                //  We want to return spot.id after saving a new Spot. Right now it is nil
                Task{
                    guard let id = await SpotViewModel.saveSpot(spot: spot) else{
                        print("😡 ERROR: Saving spot in alert returned nil")
                        return
                    }
                    spot.id = id
                    print("spot.id: \(id)")
                    $fsPhotos.path = "spots/\(id)/photos"  //  Now that we've saved the spot, we have an id, so we can get the photos
                    photoSheetIsPresented.toggle()  //Now open sheet & move to PhotoView
                }
            }
        }
        .fullScreenCover(isPresented: $photoSheetIsPresented){
            PhotoView(spot: spot)
        }
    } //body
    
    func saveSpot(){
        Task{
            guard let id = await SpotViewModel.saveSpot(spot: spot) else{
                print("😡 ERROR: Saving spot from Save button")
                return
            }
            print("spot.id: \(id)")
            print("😎 Nice Spot save!")
        }
    }
}

#Preview {
    NavigationStack{
        SpotDetailView(spot: Spot.preview)
    }
}
