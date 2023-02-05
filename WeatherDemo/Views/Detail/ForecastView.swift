//
//  ForecastView.swift
//  WeatherDemo
//
//  Created by musa fedakar on 4.02.2023.
//

import SwiftUI

struct ForecastView: View {
    var bottomSheetTranslationProrated: CGFloat = 1
    @State private var selection = 0
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: Segmented Control
                SegmentedControl(selection: $selection)
                
                // MARK: Forecast Cards
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        if selection == 0 {
                            ForEach(Forecast.hourly) { forecast in
                                ForecastCard(forecast: forecast, forecastPeriod: .hourly)
                            }
                            .transition(.offset(x: -430))
                        }
                        else {
                            ForEach(Forecast.daily) { forecast in
                                ForecastCard(forecast: forecast, forecastPeriod: .weekly)
                            }
                            .transition(.offset(x: 430))
                        }
                    }
                    .padding(.vertical, 20)
                }
                .padding(.horizontal, 20)
                
                // MARK: Forecast Widgets
                Image("Forecast Widgets").opacity(bottomSheetTranslationProrated)
            }
        }
        //.background(.ultraThinMaterial)
        .backgroundBlur(radius: 25, opaque: false)
        .background(Color.bottomSheetBackground)
        .clipShape(RoundedRectangle(cornerRadius: 44))
        .innerShadow(shape: RoundedRectangle(cornerRadius: 44), color: Color.bottomSheetBorderMiddle, lineWidth: 1, offsetX: 0, offsetY: 1, blur: 0, blendMode: .overlay, opacity: 1 - bottomSheetTranslationProrated)
        .overlay(content: {
            // MARK: bottom sheet seperator
            Divider().background(Color.bottomSheetBorderTop)
                .blendMode(.overlay)
                .frame(maxHeight: .infinity, alignment: .top)
                .clipShape(RoundedRectangle(cornerRadius: 44))
        })
        .overlay(content: {
            // MARK: drag indicator
            RoundedRectangle(cornerRadius: 10).fill(.black.opacity(0.3)).frame(width: 48, height: 5)
                .frame(height: 20)
                .frame(maxHeight: .infinity, alignment: .top)
        })
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView().background(Color.background).preferredColorScheme(.dark)
    }
}
