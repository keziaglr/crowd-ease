//
//  TrainTrackOCC.swift
//  CrowdCountUI
//
//  Created by Azella Mutyara on 20/07/23.
//

import SwiftUI

struct TrainTrackOCC: View {
    var primaryColor = Color("TrainTrackBlue")
    var secondaryColor = Color("TrainTrackGreen")
    
    let customFont24 = Font.custom("HelveticaNeue.ttc", size:24)
    let customFont18 = Font.custom("HelveticaNeue.ttc", size:18)
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) { // Add ScrollView with horizontal scrolling
                HStack(spacing: -3) {
                    
                    ForEach(0..<13) { index in
                        
                        let color: Color = index > 0 ? secondaryColor : primaryColor
                        let circleWidth: CGFloat = index==0 || index==5 || index==11 ? 55 : 35
                        let innerCircleWidth: CGFloat = index==0 || index==5 || index==11 ? 31 : 16
                        let top: Bool = index%2 == 0 ? true : false
                        
                        HStack {
                            
                            VStack {
                                if top {
                                    Text(stationList[index].station)
                                        .foregroundColor(.black)
                                        .font(customFont24)
                                        .fixedSize(horizontal: true, vertical: true)
                                    if stationList[index].sponsor != nil {
                                        Text(stationList[index].sponsor ?? "-")
                                            .foregroundColor(.black)
                                            .font(customFont18)
                                            .fixedSize(horizontal: true, vertical: false)
                                    }
                                }
                                
                                ZStack {
                                    Circle()
                                        .fill(color)
                                        .frame(width: circleWidth)
                                    
                                    Circle()
                                        .fill(.white)
                                        .frame(width: innerCircleWidth)
                                }
                                
                                if !top {
                                    
                                    Text(stationList[index].station)
                                        .foregroundColor(.black)
                                        .font(customFont24)
                                        .fixedSize(horizontal: true, vertical: true)
                                    if stationList[index].sponsor != nil {
                                        Text(stationList[index].sponsor ?? "-")
                                            .foregroundColor(.black)
                                            .font(customFont18)
                                            .fixedSize(horizontal: true, vertical: false)
                                    }
                                }
                            }
                            .frame(width: circleWidth)
                            .offset(y: CGFloat(offsetY[index]))
                        }
                        
                        if index == 0 {
                            ZStack{
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .fill(color)
                                        .frame(width: 65, height: 19)
                                    Rectangle()
                                        .fill(secondaryColor)
                                        .frame(width: 50, height: 19)
                                }
                                
                                Rectangle()
                                    .fill(.white)
                                    .frame(width: 19.81, height: 4.65)
                                    .rotationEffect(.degrees(42))
                                    .offset(x: 7, y: -5.5)
                                Rectangle()
                                    .fill(.white)
                                    .frame(width: 19.81, height: 4.65)
                                    .rotationEffect(.degrees(-48))
                                    .offset(x: 7, y: 5.5)
                            }
                        }
                        else if index < 12 {
                            ZStack{
                                Rectangle()
                                    .fill(color)
                                    .frame(width: 120, height: 19)
                                
                            }
                        }
                    }
                }
                .frame(height: 184)
                .padding(.leading, 40)
                .padding(.trailing, 50)
                .background(.white)
            }
            .frame(width: 1376, height: 184)
            .background(.white)
        }.frame(height: 184)
    }
}

struct TrainTrackOCC_Previews: PreviewProvider {
    static var previews: some View {
        TrainTrackOCC()
    }
}
