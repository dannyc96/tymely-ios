import SwiftUI

struct NavigationBarView: View {
    @Binding var isMenuOpen: Bool
    
    var body: some View {
        HStack {
            Spacer()
            
            Image("NavIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .cornerRadius(8)
            
            Spacer()
        }
        .foregroundColor(.primaryText)
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.appBackground)
        .shadow(color: Color.accent.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct NavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarView(isMenuOpen: .constant(false))
            .background(Color.appBackground)
            .preferredColorScheme(.dark)
    }
} 