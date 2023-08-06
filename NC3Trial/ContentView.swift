//
//  ContentView.swift
//  NC3Trial
//
//  Created by Kezia Gloria on 18/07/23.
//

import SwiftUI

struct ContentView: View {
    let fontName = "HelveticaNeue.ttc"
    @State var changeView = false
    @State var colorPeron = [false, true, true, true, false, true]
    @State var currPeron = 0
    let customFont36 = Font.custom("HelveticaNeue.ttc", size:36)
    let customFont16 = Font.custom("HelveticaNeue.ttc", size:16)
    let customFont18 = Font.custom("HelveticaNeue.ttc", size:18)
    
    var body: some View {
        VStack {
                HStack{
                    Text("10:24")
                        .foregroundColor(.black)
                        .fontWeight(.medium)
                        .font(customFont36)
                    Divider()
                        .foregroundColor(.black)
                    VStack(alignment: .leading){
                        Text("Selasa, 17 Juli")
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                            .font(customFont16)
                        Text("2023")
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                            .font(customFont16)
                    }
                    Spacer()
                    Image("MRT")
                        .resizable()
                        .frame(width: 125, height: 46)
                }.frame(height: 50)
                
                VStack{
                    TrainTrackOCC()
                }.padding(.vertical, 50)
                
                VStack{
                    MRTComponent(changeView: $changeView, colorPeron: $colorPeron, currPeron: $currPeron)
                }
                
                HStack{
                    HStack(spacing: 200){
                        Text("Ratangga 0805")
                            .fontWeight(.medium)
                            .font(.custom(fontName, size: 30))
                            .foregroundColor(.black)
                            .kerning(5)
                        
                        HStack{
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color("BlueStatus"))
                                    .frame(width: 40, height: 40)
                                Image("Diagonal")
                                    .resizable()
                                    .opacity(0.2)
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(5)
                            }
                            .padding(.trailing, 10)
                            Text("Tersedia")
                                .font(customFont18)
                                .foregroundColor(.black)
                                .padding(.trailing, 50)
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color("RedStatus"))
                                    .frame(width: 40, height: 40)
                                Image("Vertical")
                                    .resizable()
                                    .opacity(0.2)
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(5)
                            }
                            .padding(.trailing, 10)
                            Text("Penuh")
                                .font(customFont18)
                                .foregroundColor(.black)
                        }
                    }
                }
                .sheet(isPresented: $changeView, content: {
                    CameraView(changeView: $changeView, colorPeron: $colorPeron, currPeron: $currPeron)
                })
                .padding(.top, 50)
                .padding(.bottom, 100)
        }
        .frame(minWidth: 1400, minHeight: 900)
        .padding()
        .background(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
