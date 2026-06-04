import SwiftUI

struct DotsAndBoxesView: View {
    
    // MARK: - Stored properties
    
    @State private var game: DotsAndBoxesGame = DotsAndBoxesGame()
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack {
                Text("Dots and Boxes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                HStack(spacing: 40) {
                    VStack {
                        Text("Player A")
                            .font(.headline)
                        Text("\(game.playerOneScore)")
                            .font(.title)
                    }
                    .foregroundColor(game.currentPlayer == "Player A" ? .blue : .primary)
                    
                    VStack {
                        Text("Player B")
                            .font(.headline)
                        Text("\(game.playerTwoScore)")
                            .font(.title)
                    }
                    .foregroundColor(game.currentPlayer == "Player B" ? .red : .primary)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
            }
            
            Text(game.isGameOver ? "Game Over!" : "Turn: \(game.currentPlayer)")
                .font(.headline)
                .padding(.top)
            
            // Grid
            VStack(spacing: 0) {
                ForEach(0..<4) { row in
                    // Horizontal lines row
                    HStack(spacing: 0) {
                        ForEach(0..<3) { column in
                            DotView()
                            
                            LineView(
                                isClaimed: game.horizontalLines[row][column],
                                direction: .horizontal
                            ) {
                                game.claimLine(direction: .horizontal, row: row, column: column)
                            }
                        }
                        DotView()
                    }
                    
                    // Vertical lines and boxes row
                    if row < 3 {
                        HStack(spacing: 0) {
                            ForEach(0..<4) { column in
                                LineView(
                                    isClaimed: game.verticalLines[row][column],
                                    direction: .vertical
                                ) {
                                    game.claimLine(direction: .vertical, row: row, column: column)
                                }
                                
                                if column < 3 {
                                    BoxView(owner: game.boxOwners[row][column])
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 5)
            
            // Reset Button
            Button(action: {
                game.resetGame()
            }) {
                Text("Reset Game")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
        }
        .padding()
        .alert("Game Over", isPresented: $game.isGameOver) {
            Button("New Game") {
                game.resetGame()
            }
        } message: {
            if let winner = game.winner {
                if winner == "Draw" {
                    Text("The game ended in a draw!")
                } else {
                    Text("\(winner) wins!")
                }
            } else {
                Text("Game Over!")
            }
        }
    }
}

// MARK: - Subviews

struct DotView: View {
    var body: some View {
        Circle()
            .fill(Color.black)
            .frame(width: 10, height: 10)
    }
}

struct LineView: View {
    let isClaimed: Bool
    let direction: LineDirection
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Rectangle()
                .fill(isClaimed ? Color.primary : Color.gray.opacity(0.2))
                .frame(
                    width: direction == .horizontal ? 60 : 10,
                    height: direction == .horizontal ? 10 : 60
                )
        }
        .buttonStyle(.plain)
    }
}

struct BoxView: View {
    let owner: String?
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(owner == nil ? Color.clear : (owner == "Player A" ? Color.blue.opacity(0.2) : Color.red.opacity(0.2)))
                .frame(width: 60, height: 60)
            
            if let owner = owner {
                Text(owner == "Player A" ? "A" : "B")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(owner == "Player A" ? .blue : .red)
            }
        }
    }
}

#Preview {
    DotsAndBoxesView()
}
