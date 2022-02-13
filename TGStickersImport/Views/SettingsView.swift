//
//  SettingsView.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI
import Combine

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isWhatsApp") var isWhatsApp: Bool = false
    @AppStorage("iCloudSync") var iCloud: Bool = false
    @AppStorage("useAnimations") var useAnimations: Bool = true
    
    @State var isPresented: Bool = false
   
    var body: some View {
        ZStack {
            Color.night
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                    if #available(iOS 15, *), UIScreen.main.bounds.height < 730 {
                        Text("settings")
                            .font(Font.system(size: 38).weight(.heavy))
                            .multilineTextAlignment(.center)
                            .gradientForeground(colors:[.fire, .love])
                            .padding(.horizontal)
                            .padding(.top, 12)
                            .padding(.bottom, -2)
                    } else {
                        Text("settings")
                            .font(Font.system(size: 38).weight(.heavy))
                            .multilineTextAlignment(.center)
                            .gradientForeground(colors:[.fire, .love])
                            .padding(.horizontal)
                            .padding(.top)
                            .padding(.top, UIScreen.main.bounds.height >= 800 ? 20 : 0)
                    }
                
                Divider().padding(.horizontal).gradientForeground(colors: [.fire, .love])
                    .padding(.top, 6)
                
                HStack {
                    Text("preferredMessenger")
                    .gradientForeground(colors:[.fire, .love])
                        .padding(.horizontal, 32)
                    Spacer()
                }
                .padding(.top, 8)
                
                Toggle("", isOn: $isWhatsApp)
                    .toggleStyle(TGWAToggleStyle())
                    .padding(.top, 8)
                    .padding(.bottom, 10)
                
                Divider().padding(.horizontal).gradientForeground(colors: [.fire, .love])

                Toggle("icloud", isOn: $iCloud)
                    .toggleStyle(iCloudToggleStyle())
                    .padding(.horizontal, 32)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    .onChange(of: iCloud) { state in
                        isPresented = true
                    }
                    .alert(isPresented: $isPresented) {
                        Alert(title: Text("warning"), message: Text("restart"), dismissButton: .default(Text("ok"), action: { }))
                    }
                
                /*Toggle("animations", isOn: $useAnimations)
                    .toggleStyle(SwitchToggleStyle(tint: .main))
                    .foregroundColor(.main)
                    .padding(.horizontal)
                    .padding()*/
                }
                
                Divider().padding(.horizontal).gradientForeground(colors: [.fire, .love])
                
                HStack(spacing: 24) {
                    Link("privacy", destination: URL(string: "https://facemotion.herokuapp.com/privacy")!)
                    Link("terms", destination: URL(string: "https://facemotion.herokuapp.com/terms")!)
                }
                .font(Font.system(size: 14))
                .foregroundColor(.white.opacity(0.25))
                .padding(.horizontal)
                .padding(.top, UIScreen.main.bounds.height < 680 ? 2 : 4)
                
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(LinearGradient(gradient: Gradient(colors: [.fire, .love]), startPoint: .bottomLeading, endPoint: .topTrailing), lineWidth: 2)
                        .frame(width: 260, height: 48)
                        .overlay(
                            Text("dismiss")
                                .font(.system(size: 20).weight(.bold))
                                .gradientForeground(colors: [.fire, .love])
                        )
                        .padding(.bottom, UIScreen.main.bounds.height < 680 ? 16 : 24)
                }

            }
            .font(.system(size: 24).weight(.bold))
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView()
        }
    }
}
