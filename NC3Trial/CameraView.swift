//
//  CameraView.swift
//  NC3Trial
//
//  Created by Kezia Gloria on 21/07/23.
//

import SwiftUI

struct CameraView: View {
    @Binding var changeView: Bool
    @Binding var colorPeron: [Bool]
    @Binding var currPeron: Int
    @StateObject private var viewModel = CameraViewModel()
    @State var status = "Unknown"

    var body: some View {
        VStack {
            Text("Crowd Control")
                .foregroundColor(.black)
                .font(.system(size: 18))
                .fontWeight(.semibold)
            Text("Lebak Bulus")
                .foregroundColor(.gray)
                .font(.system(size: 12))
            
            if let image = viewModel.previewImage {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
            } else {
                Image("photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
            }
            HStack {
                Text("Nomor Peron :")
                    .foregroundColor(.black)
                    .font(.system(size: 12))
                Text("\(currPeron+1)")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }
            
            HStack {
                Text("Status Peron :")
                    .foregroundColor(.black)
                    .font(.system(size: 12))
                Text("\(viewModel.crowdSizeLabel ?? "Unknown")")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }
            
            VStack {
                HStack {
                    Button {
                        viewModel.captureImage()
                    } label: {
                        Text("Capture Photo")
                            .foregroundColor(.black)
                    }
                    
                    Button {
                        viewModel.selectImage()
                    } label: {
                        Text("Select Image")
                            .foregroundColor(.white)
                    }.buttonStyle(.borderedProminent)
                    .tint(Color("BlueButton"))
                }
                
                Button {
                    colorPeron[currPeron] = viewModel.crowdSizeLabel == "Tersedia" ? true : false
                    changeView = false
                } label: {
                    Text("Close")
                        .foregroundColor(.black)
                }
            }
        }
        .padding()
        .background(.white)
        .onAppear {
            viewModel.checkForPermissions()
        }
    }
}


struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(changeView: .constant(false), colorPeron: .constant([false, true, true, false, true, true]), currPeron: .constant(0))
    }
}
