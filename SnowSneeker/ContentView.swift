//
//  ContentView.swift
//  SnowSneeker
//
//  Created by Danjuma Nasiru on 27/03/2023.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to SnowSeeker!")
                .font(.largeTitle)
            
            Text("Please select a resort from the left-hand menu; swipe from the left edge to show it.")
                .foregroundColor(.secondary)
        }
    }
}


extension View {
    @ViewBuilder func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}


struct ContentView: View {
    @State private var resorts = Bundle.main.decode("resorts.json") as [Resort]
    @State private var searchText = ""
    @StateObject var favorites = Favorites()
    @State private var showSortingOptions = false
    
    var body: some View {
        NavigationView{
            
            List(filteredResults){resort in
                NavigationLink{
                    ResortView(resort: resort)
                } label: {
                    HStack{
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 1))
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                            .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "look for resort")
            .toolbar{
                Button("Sort"){
                    showSortingOptions = true
                }
            }
            .confirmationDialog("Sort", isPresented: $showSortingOptions){
                Button("By Name"){
                   resorts = resorts.sorted{
                        $0.name < $1.name
                    }
                }
                
                Button("By Country"){
                   resorts = resorts.sorted{
                        $0.country < $1.country
                    }
                }
                
                Button("Default"){
                    resorts = Bundle.main.decode("resorts.json")
                }
            } message: {
                Text("How would you like the resorts to be arranged")
            }
            
            WelcomeView()
        }
        .phoneOnlyStackNavigationView()
        .environmentObject(favorites)
        
    }
    
    var filteredResults : [Resort]{
        if searchText.isEmpty{
            return resorts
        }else{
            return resorts.filter{ $0.name.localizedCaseInsensitiveContains(searchText)}
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
