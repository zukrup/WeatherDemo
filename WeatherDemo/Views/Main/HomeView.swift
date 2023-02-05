//
//  HomeView.swift
//  WeatherDemo
//
//  Created by musa fedakar on 4.02.2023.
//

import SwiftUI
import BottomSheet

enum BottomSheetPosition: CGFloat, CaseIterable {
    case top = 0.83
    case middle = 0.385
}

struct HomeView: View {
    @State var bottomSheetPosition : BottomSheetPosition = .middle
    @State var bottomSheetTranslation : CGFloat = BottomSheetPosition.middle.rawValue
    @State var hasDragged: Bool = false
    
    var bottomSheetTranslationProrated : CGFloat {
        (bottomSheetTranslation - BottomSheetPosition.middle.rawValue) / (BottomSheetPosition.top.rawValue - BottomSheetPosition.middle.rawValue)
    }
    
    var body: some View {
        
        NavigationView {
            GeometryReader { geometry in
                let screenHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
                let imageOffset = screenHeight + 36
                ZStack {
                        // MARK: Background Color
                        Color.background.ignoresSafeArea()
                        
                        // MARK: Background Image
                    Image("Background").resizable().ignoresSafeArea().offset(y: -bottomSheetTranslationProrated * imageOffset)
                       
                        Image("House").frame(maxHeight: .infinity, alignment: .top).padding(.top, 257).offset(y: -bottomSheetTranslationProrated * imageOffset)
                        
                        VStack(spacing: -10 * (1 - bottomSheetTranslationProrated)) {
                            Text("Montreal").font(.largeTitle)
                            VStack {
                                /*
                                Text("19°").font(.system(size: 96, weight: .thin)).foregroundColor(.primary)
                                +
                                Text("\n ")
                                +
                                Text("Mostly Clear").font(.title3.weight(.semibold)).foregroundColor(.secondary)
                                */
                                Text(attributedString)
                                // MARK: current weather
                                Text("H: 25° L: 18°").font(.title3.weight(.semibold)).opacity(1 - bottomSheetTranslationProrated)
                            }
                            Spacer()
                        }
                        .padding(.top, 51)
                        .offset(y: -bottomSheetTranslationProrated * 46)
                        // MARK: bottom sheet
                        BottomSheetView(position: $bottomSheetPosition) {
                            // Text(bottomSheetTranslationProrated.formatted())
                        } content: {
                            ForecastView(bottomSheetTranslationProrated: bottomSheetTranslationProrated)
                        }
                        .onBottomSheetDrag { translation in
                            bottomSheetTranslation = translation / screenHeight
                            
                            withAnimation(.easeInOut) {
                                if bottomSheetPosition == BottomSheetPosition.top {
                                    self.hasDragged = true
                                }
                                else {
                                    self.hasDragged = false
                                }
                            }
                            
                        }
                        // MARK: tab bar
                        TabBar(action: {
                            bottomSheetPosition = .top
                        })
                        .offset(y: bottomSheetTranslationProrated * 115)
                }
            }
        }
    }
    private var attributedString: AttributedString {
        var string = AttributedString("19°" + (hasDragged ? " | " : "\n ") + "Mostly Clear")
        if let temp = string.range(of: "19°") {
            string[temp].font = .systemFont(ofSize: (96 - (bottomSheetTranslationProrated * (96-20))), weight: hasDragged ?  .semibold : .thin)
            string[temp].foregroundColor = hasDragged ? .secondary : .primary
        }
        if let pipe = string.range(of: " | ") {
            string[pipe].font = .title3.weight(.semibold)
            string[pipe].foregroundColor =  .secondary.opacity(bottomSheetTranslationProrated)
        }
        if let weather = string.range(of: "Mostly Clear") {
            string[weather].font = .title3.weight(.semibold)
            string[weather].foregroundColor = .primary
        }
        
        return string
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().preferredColorScheme(.dark)
    }
}
