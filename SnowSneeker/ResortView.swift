//
//  ResortView.swift
//  SnowSneeker
//
//  Created by Danjuma Nasiru on 27/03/2023.
//

import SwiftUI

struct ResortView: View {
    let resort : Resort
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.dynamicTypeSize) var typeSize
    @EnvironmentObject() var favorites : Favorites
    
    @State private var selectedFacility: Facility?
    @State private var showingFacility = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomTrailing){
                    Image(decorative: resort.id)
                        .resizable()
                        .scaledToFit()
                        .opacity(0.7)
                    
                        Text("Photo Credit: \(resort.imageCredit)")
                        .padding(10)
                        .background(.white)
                }
                HStack{
                    if sizeClass == .compact && typeSize > .large{
                        VStack(spacing: 10){
                            ResortDetailsView(resort: resort)
                        }
                        VStack(spacing: 10){
                            SkiDetailsView(resort: resort)
                        }
                    }else{
                        ResortDetailsView(resort: resort)
                        SkiDetailsView(resort: resort)
                    }
                    
                }
                .padding(.vertical)
                .background(Color.primary.opacity(0.1))
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                
                Group {
                    Text(resort.description)
                        .padding(.vertical)
                    
                    Text("Facilities")
                        .font(.headline)
                    
                    //                            Text(resort.facilities.joined(separator: ", "))
                    //                                .padding(.vertical)
                    
//                    Text(resort.facilities, format: .list(type: .and))
//                        .padding(.vertical)
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack( spacing: 20) {
                            ForEach(resort.facilityTypes) { facility in
                                Button {
                                        selectedFacility = facility
                                        showingFacility = true
                                    } label: {
                                        HStack{
                                            facility.icon
                                                .font(.title)
                                            Text(facility.name)
                                        }
                                    }
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
                        if favorites.contains(resort) {
                            favorites.remove(resort)
                        } else {
                            favorites.add(resort)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .navigationBarTitleDisplayMode(.inline)
        .alert(selectedFacility?.name ?? "More Information", isPresented: $showingFacility, presenting: selectedFacility){_ in
            
        } message: { facility in
            Text(facility.description)
        }
    }
}

struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ResortView(resort: Resort.alternativeExample)
        }
        .environmentObject(Favorites())
    }
}
