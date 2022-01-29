//
//  ContentView.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isFirstRun") var isFirstRun: Bool = true
            
    // init() {
    // Reset state
    // UserDefaults.standard.setValue(true, forKey: "isFirstRun")
    // }
    
    var body: some View {
        NavigationView {
            Group {
                if isFirstRun {
                    #if DEBUG
                    StickersGalleryView()
                    #else
                    IntroView()
                    #endif
                } else {
                    StickersGalleryView()
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.mock.container.viewContext)
    }
}
#endif
