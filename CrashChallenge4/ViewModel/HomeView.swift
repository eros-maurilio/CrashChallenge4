//
//  HomeView.swift
//  CrashChallenge4
//
//  Created by Eros Maurilio on 09/10/21.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var substances = ["2C-T-X", "2C-X", "5-MeO-xxT", "Alcohol", "Amphetamines", "Benzodiazepines", "Caffeine", "Cannabis", "Cocaine", "DMT", "DOx", "DXM", "GHB/GBL", "Ketamine", "LSD", "MAOIs", "MDMA", "MXE", "Mescaline", "Mushrooms", "NBOMes", "Nitrous", "Opioids", "SSRIs", "Tramadol"]
    @Published var spacing: CGFloat = 20
    @Published var padding: CGFloat = 30
    @Published var alignmentIndex = 0
    
    let alignments: [HorizontalAlignment] = [.leading, .center, .trailing]

    var alignment: HorizontalAlignment {
      alignments[alignmentIndex]
    }
}


struct HomeView: View {
    @ObservedObject var model = ContentViewModel()
    @State var isSelected = false
    @State var isSelected2 = true
    private var gradient = [Color.gradientHomeTop, Color.gradientHomeBot]
    @State var opacityStyle: CGFloat = 0
    @State var substances = [String]()
    @State var isShowing = false
    @State var bottomColor: Color = .gradientHomeBot
    @State var topColor: Color = .gradientHomeTop
    @Namespace var botID

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color.deepBlue), NSAttributedString.Key.font: UIFont(name: PublicSans.medium.rawValue, size: 17)!]
        
        UINavigationBar.appearance().barStyle = .default
    }

    var body: some View {
        ScrollView {
            ScrollViewReader { value in
                VStack(alignment: .leading, spacing: 0){
                    Text("Harm Reduction for all")
                        .scaledFont(name: PublicSans.bold.rawValue, size: 36)
                        .foregroundColor(.deepBlue)
                        .padding(.top, -50)
                    HStack {
                        Spacer()
                    }
                    
                    Text("Select two substances to see how they interact")
                        .scaledFont(name: PublicSans.medium.rawValue, size: 17)
                        .padding(.top, 25)
                    
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                
                FlexibleView(data: model.substances, spacing: model.spacing, alignment: model.alignment) { item in
                Button {
                    substanceSelection(name: item)
                    withAnimation {
                        if substances.count == 2 {
                            isShowing = true
                        } else {
                            isShowing = false
                        }
                    }

                    } label: {
                        TagView(substance: item, isSelected: substances.contains(item) ? $isSelected2 : $isSelected)
                    }

                }
                .padding(.horizontal, model.padding)
                
                if isShowing {
                CombinationButtonView(substances: $substances)
                    .frame(height: UIScreen.main.bounds.size.height / 16)
                    .id(botID)
                    .padding(30)
                    .onAppear {
                        withAnimation {
                            value.scrollTo(botID, anchor: .bottom)
                        }
                    }
                }
            }
        }
        .background(LinearGradient(colors: gradient, startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        .overlay(
            VStack {
                Spacer()
                Rectangle()
                    .fill(LinearGradient(colors: [topColor.opacity(0.01), bottomColor], startPoint: .top, endPoint: .bottom))
                    .frame(width: UIScreen.main.bounds.size.width, height: 60, alignment: .bottom)
            }
                .edgesIgnoringSafeArea(.all))

    .navigationTitle("Harm Reduction for all")
    }
    
    func substanceSelection(name: String) {
        if substances.contains(name) {
            substances = substances.filter {$0 != name}
            withAnimation {
                opacityStyle = 0
            }
            return
        }
        
        if substances.count == 2 {
            substances.remove(at: 0)
            print(substances)
        }
        
        if substances.count < 2 {
            substances.append(name)
            print(substances)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
    }
}