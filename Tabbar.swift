import SwiftUI

struct MainTabView: View {
    
    @AppStorage("userChatid") private var userChatid: String = ""
    @StateObject private var vm = CometChatViewModel()
    var body: some View {
        TabView {
            
            NewHomeScreen()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
         
                
                RootsView()
                    .tabItem {
                        Image(systemName: "message.fill")
                        Text("Chats")
                    }
                    .navigationTitle("Chats")
            
         

            CombinedAddProductFlow()
                        .tabItem {
                    Image(systemName: "plus")
                    Text("Add")
                }
            RentyMyAdsExactView()
                .tabItem {
                    Image(systemName: "doc.plaintext")
                    Text("My Ads")
                }
            
            ProfileSettingsView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(.purple)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
