//
//  MRTComponent.swift
//  NC3Trial
//
//  Created by Kezia Gloria on 20/07/23.
//

import SwiftUI
import PolyKit


struct Platform: View {
    
    var body: some View {
        
        HStack {
            Polygon(count: 3, cornerRadius: 5)
                .fill(Color("Grey"))
                .frame(width: 205, height: 205)
                .offset(x: 114, y: 23.7)
            RoundedRectangle(cornerRadius: 5)
                .fill(Color("Grey"))
                .frame(width: 850, height: 150)
                
            Polygon(count: 3, cornerRadius: 5)
                .fill(Color("Grey"))
                .frame(width: 205, height: 205)
                .offset(x: -114, y: 23.7)
        }
    }
}

struct Peron: View{
    @State var label = 1
    @Binding var isAvailable : Bool
    let customFont24 = Font.custom("HelveticaNeue.ttc", size:24)
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(isAvailable ? Color("BlueStatus") : Color("RedStatus"))
                .frame(width: 130, height: 70)
            Image(isAvailable ? "Diagonal" : "Vertical")
                    .resizable()
                    .opacity(0.2)
                    .frame(width: 130, height: 70)
                    .cornerRadius(10)
            Text("\(label)")
                .font(customFont24)
                .foregroundColor(.black)
        }
    }
}

struct MRTComponent: View {
    @Binding var changeView: Bool
    @Binding var colorPeron: [Bool]
    @Binding var currPeron: Int
    var body: some View {
        ZStack{
            Platform()
            HStack{
                ForEach(0..<6, id: \.self) { index in
                    Peron(label: 6 - index, isAvailable: $colorPeron[5 - index])
                        .onTapGesture {
                            currPeron = 5 - index
                            changeView = true
                        }
                }
            }.offset(y: 75)
        }
    }
}

struct MRTComponent_Previews: PreviewProvider {
    static var previews: some View {
        MRTComponent(changeView: .constant(false), colorPeron: .constant([false, true, true, false, true, true]), currPeron: .constant(0))
    }
}
