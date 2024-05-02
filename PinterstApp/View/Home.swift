//
//  Home.swift
//  PinterstApp
//
//  Created by Vladimir Pisarenko on 02.05.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct Home: View {
    //getting window size
    var window = NSScreen.main?.visibleFrame
    @State var search = ""
    
    var columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 4)
    
    @StateObject var imageData = ImageViewModel()
    
    var body: some View {
        HStack {
            Sidebar()
            
            VStack {
                
                HStack(spacing: 12) {
                    //Search bar
                    
                    HStack(spacing: 15) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color.gray)
                        
                        TextField("Search", text: $search)
                            .textFieldStyle(PlainTextFieldStyle())
                        
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(BlurWindow())
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "slider.vertical.3")
                            .foregroundStyle(Color.black)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                    })
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.white)
                            .padding(10)
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    })
                    .buttonStyle(PlainButtonStyle())
                }
                
                //ScrollView with images...
                
                GeometryReader { geometry in
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 15, content: {
                            
                            //Getting images...
                            
                            ForEach(imageData.images.indices, id: \.self) { index in
                                ZStack {
                                    WebImage(url: URL(string: imageData.images[index].download_url)!) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: (geometry.frame(in: .global).width - 45) / 4, height: 150 )
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    Color.black.opacity(imageData.images[index].onHover ?? false ? 0.2 : 0)
                                    
                                    VStack {
                                        
                                        HStack {
                                            
                                            Spacer(minLength: 0)
                                            
                                            Button(action: {
//                                                saveImage(index: index)
                                            }, label: {
                                                
                                                Image(systemName: "hand.thumbsup.fill")
                                                    .foregroundStyle(Color.yellow)
                                                    .padding(8)
                                                    .background(Color.white)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                            })
                                            .buttonStyle(PlainButtonStyle())
                                            
                                            Button(action: {
                                                saveImage(index: index)
                                            }, label: {
                                                
                                                Image(systemName: "folder.fill")
                                                    .foregroundStyle(Color.blue)
                                                    .padding(8)
                                                    .background(Color.white)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                            })
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                        .padding(10)
                                        
                                        Spacer()
                                    }
                                    .opacity(imageData.images[index].onHover ?? false ? 1 : 0)
                                }
                                .onHover(perform: { hovering in
                                    withAnimation {
                                        imageData.images[index].onHover = hovering
                                    }
                                })
                            }
                        })
                        .padding(.vertical)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .ignoresSafeArea(.all, edges: .all)
        .frame(minWidth: window!.width / 1.5, minHeight: window!.height - 40)
        .background(Color.white.opacity(0.6))
        .background(BlurWindow())
    }
    
    func saveImage(index: Int) {
        
        let manager = SDWebImageDownloader(config: .default)
        
        manager.downloadImage(with: URL(string: imageData.images[index].download_url)!) { (image, _, _, _) in
            guard let originalImage = image else { return }
            let data = originalImage.sd_imageData(as: .JPEG)
            
             
            let panel = NSSavePanel()
            panel.canCreateDirectories = true
            panel.nameFieldStringValue = "\(imageData.images[index].id)"
            
            panel.begin { response in
                if response.rawValue == NSApplication.ModalResponse.OK.rawValue {
                    do {
                        try data?.write(to: panel.url!, options: .atomic)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        

    }
}

#Preview {
    Home()
}

struct Sidebar: View {
    @State var selected = "Home"
    @Namespace var animation
    
    var body: some View {
        HStack(spacing: 0) {
            
            VStack(spacing: 22) {
                
                Group {
                    
                    HStack {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 45)
                        
                        Text("Pinterest")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.black)
                        
                        Spacer(minLength: 0 )
                    }
                    .padding(.top, 35)
                    .padding(.leading, 10)
                    //tab button
                    
                    TabButton(image: "house.fill", title: "Home", selected: $selected, animation: animation)
                    TabButton(image: "clock.fill", title: "Recent", selected: $selected, animation: animation)
                    TabButton(image: "person.2.fill", title: "Following", selected: $selected, animation: animation)
                    
                    HStack {
                        
                        Text("Insights")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.gray)
                        Spacer()
                    }
                    .padding()
                    
                    TabButton(image: "message.fill", title: "Messages", selected: $selected, animation: animation)
                    TabButton(image: "bell.fill", title: "Notifications", selected: $selected, animation: animation)
                }
                
                Spacer(minLength: 0)
                
                VStack(spacing: 5) {
                    
                    Image("business")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Business Tools")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.blue)
                    })
                    .buttonStyle(PlainButtonStyle())
                    Text("Hurry! Up now you can unlock our new business tools at your convinence")
                        .foregroundStyle(Color.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                    
                    Spacer(minLength: 0)
                    
                }
                
                Spacer(minLength: 0)
                
                //Profile view...
                
                HStack(spacing: 10) {
                    Image("profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 8, content: {
                        Text("iJustine")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.gray)
                        
                        Text("Last Login 06/12/20")
                            .font(.caption2)
                            .foregroundStyle(Color.gray)
                    })
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.gray)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            
            Divider()
                .offset(x: -2)
        }
        //side bar default size
        .frame(width: 240)
    }
}

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get {.none}
        set {}
    }
}
