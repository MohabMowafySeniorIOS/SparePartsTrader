import SwiftUI

struct FavouriteImageButton: View {
    
    @Binding var isFavourite: Bool
    
    var body: some View {
            Image(isFavourite == true ? "favouriteBtn" : "unFavouriteIcon")
    }
}

#Preview {
    FavouriteImageButton(isFavourite: .constant(false))
}
