//
//  StickersGalleryView.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI
import Combine
import Lottie
import SDWebImageSwiftUI
import Gzip

struct StickersGalleryView: View {
    @State var image: UIImage?
    @State var update = UUID()
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: StickerSet.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \StickerSet.date, ascending: true)])
    var stickerSets: FetchedResults<StickerSet>
    var groupedSets: [Date: [FetchedResults<StickerSet>.Element]] {
        Dictionary(grouping: stickerSets) { stickerSet in
            guard let date = stickerSet.date else {
                return Date()
            }
            return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: date)) ?? Date()
        }
    }
    
    func convertSticker(_ stickers: [Sticker]) -> [String: Data] {
        var data: [String: Data] = [:]
        for sticker in stickers {
            if let emotion = sticker.emotion, let animation = sticker.animation {
                data[emotion] = animation
            }
        }
        return data
    }
    
    var gridColumns: [GridItem] {
        let count = UIDevice.current.userInterfaceIdiom == .pad ? 4 : 3
        return (1...count).map { _ in GridItem() }
    }
    
    static func buildFormatter(relative: Bool = false, dateFormat: String? = nil, timeStyle: DateFormatter.Style = .none, dateStyle: DateFormatter.Style = .long) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = timeStyle
        formatter.dateStyle = dateStyle
        
        if let dateFormat = dateFormat {
            formatter.dateFormat = dateFormat
        }
        
        formatter.doesRelativeDateFormatting = relative
        formatter.locale = .current
        return formatter
    }
    
    static let dateFormatter = buildFormatter()
    static let timeFormatter = buildFormatter(timeStyle: .short, dateStyle: .none)
    static let relativeDateFormatter = buildFormatter(relative: true)
    static let shortDateFormatter = buildFormatter(dateFormat: "dd MMMM")
    
    static func formatDate(_ date: Date) -> String {
        let relative = relativeDateFormatter.string(for: date)
        let normal = dateFormatter.string(from: date)
        
        if relative == normal {
            if Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year) {
                return shortDateFormatter.string(from: date)
            } else {
                return normal
            }
        } else {
            return relative ?? normal
        }
    }
    
    @State private var isActivityPresented = false
    @State private var shareFiles: [Any] = []
    @State private var isSettingsOpen = false
    @AppStorage("useAnimations") var useAnimations: Bool = true
    
    @State var currentDeletionSet: StickerSet?
    @State var isPresented: Bool = false
    
    @State var animation: Animation?
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
        
    @State var cancellables = Set<AnyCancellable>()
    @State var purchased: Bool = false
        
    @State var viewStickers: [Date: Bool] = [:]
     
    var body: some View {
        Group {
            if image == nil {
                VStack(spacing: 0) {
                    if stickerSets.isEmpty {
                        empty
                    } else {
                        ZStack {
                            ScrollView {
                                LazyVGrid(columns: gridColumns, spacing: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 2, pinnedViews: [.sectionHeaders]) {
                                    ForEach(Array(groupedSets.sorted { $0.key > $1.key }.enumerated()), id: \.offset) { index, day in
                                        if day.value.reduce(0, { sum, set in set.stickers?.count ?? 0 }) != 0 {
                                            Section(header:
                                                Header(date: day.key, index: index)
                                            ) {
                                                ForEach(day.value.sorted { $0.date ?? Date() > $1.date ?? Date() }, id: \.date) { set in
                                                    if let id = set.date, let source = set.source ?? "telegram",
                                                        let stickers = set.stickers?.allObjects as? [Sticker], !stickers.isEmpty,
                                                        let first = stickers.randomElement(),
                                                       let data = first.animation {
                                                        
                                                        let isTelegram: Bool = source == "telegram"
                                                        
                                                        let count = min(stickers.count, 12)
                                                        let width = min(UIScreen.main.bounds.width - 80, 320)
                                                        let columns = max(3, min(4, Int(ceil(width / 108))))
                                                        let rows = ceil(CGFloat(count) / CGFloat(columns))
                                                        let height = min(CGFloat(rows) * 100 + 64, 480)
                                                        let size = CGSize(width: width, height: height)
                                                        
                                                        NavigationLink(destination: NavigationLazyView(ExportView(isTelegram: isTelegram, isGallery: true, animatedData: convertSticker(stickers), image: $image))) {
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .aspectRatio(1.0, contentMode: .fit)
                                                                .foregroundColor(.clear)
                                                                .overlay(
                                                                    RoundedRectangle(cornerRadius: 8)
                                                                        .stroke(lineWidth: UIDevice.current.userInterfaceIdiom == .pad ? 6 : 3)
                                                                        .foregroundColor(Color.night)
                                                                        .overlay(
                                                                            Group {
                                                                                if isTelegram {
                                                                                    LazyLottieView(data: data)
                                                                                        .mask(RoundedRectangle(cornerRadius: 6))
                                                                                        .padding(1.5)
                                                                                        .aspectRatio(1.0, contentMode: .fit)
                                                                                        .id(update) // It fixes lottie non-reloading bug
                                                                                } else {
                                                                                    AnimatedImage(data: data, isAnimating: .constant(viewStickers[id] ?? true))
                                                                                        .resizable()
                                                                                        .mask(RoundedRectangle(cornerRadius: 6))
                                                                                        .padding(1.5)
                                                                                        .aspectRatio(1.0, contentMode: .fit)
                                                                                        .onDisappear {
                                                                                            viewStickers[id] = false
                                                                                        }
                                                                                        .onAppear {
                                                                                            // It fixes animation stops while out of device screen
                                                                                            if viewStickers[id] == false {
                                                                                                viewStickers[id] = true
                                                                                            }
                                                                                        }
                                                                                }
                                                                            }
                                                                        )
                                                                )
                                                                .contentShape(RoundedRectangle(cornerRadius: 8))
                                                                .contextMenu(
                                                                    PreviewContextMenu(
                                                                        destination: NavigationLazyView(ExportView(isTelegram: isTelegram, isGallery: true, animatedData: convertSticker(stickers), image: $image
                                                                            )),
                                                                        preview: NavigationLazyView(StickersContextMenuPreview(id: id, size: size, columns: columns, stickers: Array(stickers.prefix(12)), isTelegram: isTelegram)),
                                                                        size: size,

                                                                        actionProvider: { _ in
                                                                            var items: [UIMenuElement] = [
                                                                                UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                                                                                    self.currentDeletionSet = set
                                                                                    self.isPresented = true
                                                                                }
                                                                            ]
                                                                            
                                                                            if isTelegram {
                                                                                let shareMenu = UIMenu(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), children: [
                                                                                       UIAction(title: "Telegram - TGS") { _ in
                                                                                           var files: [Any] = []
                                                                                           DispatchQueue.global().async {
                                                                                        let stickersData = convertSticker(stickers)
                                                                                        for (index, (_, data)) in stickersData.enumerated() {
                                                                                            if let compressed = try? data.gzipped(level: .bestCompression), let url = compressed.file(named: "\(index + 1).tgs") {
                                                                                                files.append(url)
                                                                                            }
                                                                                        }
                                                                                           DispatchQueue.main.async {
                                                                                               self.shareFiles = files
                                                                                               self.isActivityPresented = true
                                                                                           }
                                                                                           }
                                                                                       },
                                                                                       UIAction(title: "Lottie - JSON") { _ in
                                                                                           var files: [Any] = []
                                                                                           DispatchQueue.global().async {
                                                                                        let stickersData = convertSticker(stickers)
                                                                                        for (index, (_, data)) in stickersData.enumerated() {
                                                                                            if let url = data.file(named: "\(index + 1).json") {
                                                                                                files.append(url)
                                                                                            }
                                                                                        }
                                                                                           DispatchQueue.main.async {
                                                                                            self.shareFiles = files
                                                                                            self.isActivityPresented = true
                                                                                           }
                                                                                           }
                                                                                       }
                                                                                   ])
                                                                                items.insert(shareMenu, at: 0)
                                                                            } else {
                                                                                let shareMenu = UIMenu(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), children: [
                                                                                       UIAction(title: "Animated WebP") { _ in
                                                                                           var files: [Any] = []
                                                                                           DispatchQueue.global().async {
                                                                                            let stickersData = convertSticker(stickers)
                                                                                            for (index, (_, data)) in stickersData.enumerated() {
                                                                                                if let url = data.file(named: "\(index + 1).webp") {
                                                                                                    files.append(url)
                                                                                                }
                                                                                            }
                                                                                           DispatchQueue.main.async {
                                                                                            self.shareFiles = files
                                                                                            self.isActivityPresented = true
                                                                                           }
                                                                                           }
                                                                                       }
                                                                                   ])
                                                                                items.insert(shareMenu, at: 0)
                                                                            }
                                                                            
                                                                            return UIMenu(title: "\(isTelegram ? "Telegram" : "WhatsApp") - \(StickersGalleryView.formatDate(id)) \(Self.timeFormatter.string(from: id))", children: items)
                                                                        }
                                                                        
                                                                    )
                                                                )
                                                            
                                                                .background(NavigationLazyView(ActivityView(isPresented: $isActivityPresented, items: $shareFiles)))
                                                        }
                                                        .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 4 : 0)
                                                        .padding(.bottom, 12)
                                                        .padding(.top, 8)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding(.bottom, -8)
                                }
                                .animation(animation)
                                .padding(.leading)
                                .padding(.trailing)
                                .padding(.bottom)
                                
                                Spacer().frame(height: 70)
                            }
                            .alert(isPresented: $isPresented) {
                                let set = self.currentDeletionSet
                                let source = (set?.source ?? "telegram").capitalizingFirstLetter()
                                let count = set?.stickers?.allObjects.count ?? 0
                                let title = "Delete \(count == 0 ? "all" : String(count)) \(source) \(count == 1 ? "sticker" : "stickers")?"
                                
                                return Alert(title: Text(title), message: Text("deletionDescription"),
                                      primaryButton: .default(Text("cancel"), action: {
                                        self.currentDeletionSet = nil
                                      }),
                                      secondaryButton: .destructive(Text("delete"), action: {
                                        withAnimation {
                                            if let set = set {
                                               managedObjectContext.delete(set)
                                               try? managedObjectContext.save()
                                            }
                                            self.currentDeletionSet = nil
                                        }
                                    })
                                  )
                            }
                            
                            VStack {
                                Spacer()
                                NavigationLink(destination: NavigationLazyView(CameraView(image: $image))) { }
                                    .buttonStyle(AddButtonStyle())
                            }
                        }
                    }
                }
                .background(
                    LinearGradient(gradient: Gradient(colors: [.grass, .sea]), startPoint: .bottomLeading, endPoint: .topTrailing)
                        .edgesIgnoringSafeArea(.all))
                .onAppear {
                    self.update = UUID()
                }
                .onReceive(timer) { _ in
                    withAnimation {
                        timer.upstream.connect().cancel()
                        animation = .spring()
                    }
                }
            } else {
                RecognitionView(image: $image)
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    var empty: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        isSettingsOpen.toggle()
                    } label: {
                        Color.night
                            .mask (
                                Label("settings", systemImage: "ellipsis")
                                    .labelStyle(IconOnlyLabelStyle())
                                    .font(Font.system(size: 28).weight(.bold))
                                    .foregroundColor(.love)
                                    .rotationEffect(.degrees(-90))
                                )
                            .padding()
                            .frame(width: 64, height: 64)
                    }
                    .padding(.trailing, 8)
                    .sheet(isPresented: $isSettingsOpen) {
                        SettingsView().preferredColorScheme(.dark)
                    }
                }
                Spacer()
            }
            
            VStack {
                Spacer()
                Text("empty")
                    .font(Font.system(size: 36).weight(.heavy))
                    .foregroundColor(Color.night)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 240)
                
                Image("person")
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .padding(.leading, 100)
                    .padding(.trailing, 100)

                Spacer()
                
                NavigationLink(destination: NavigationLazyView(CameraView(image: $image))) { }
                    .buttonStyle(AddButtonStyle())
            }
        }
    }
}

struct StickersGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StickersGalleryView()
            
            #if DEBUG
            StickersGalleryView()
                .environment(\.managedObjectContext, PersistenceController.mock.container.viewContext)
            #endif
        }
    }
}
