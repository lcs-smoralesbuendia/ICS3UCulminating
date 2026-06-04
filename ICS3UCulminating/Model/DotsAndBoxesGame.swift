import Foundation
import Observation

enum LineDirection: String, CaseIterable {
    case horizontal
    case vertical
}

@Observable
class DotsAndBoxesGame {
    
    // MARK: - Stored properties
    
    var horizontalLines: [[Bool]] = []
    var verticalLines: [[Bool]] = []
    var boxOwners: [[String?]] = []
    
    var playerOneScore: Int = 0
    var playerTwoScore: Int = 0
    var currentPlayer: String = "Player A"
    var isGameOver: Bool = false
    var winner: String? = nil
    
    // MARK: - Initializer
    
    init() {
        self.resetGame()
    }
    
    // MARK: - Functions
    
    func resetGame() {
        // 4 rows of 3 horizontal lines each
        var hLines: [[Bool]] = []
        for _ in 0..<4 {
            var row: [Bool] = []
            for _ in 0..<3 {
                row.append(false)
            }
            hLines.append(row)
        }
        self.horizontalLines = hLines
        
        // 3 rows of 4 vertical lines each
        var vLines: [[Bool]] = []
        for _ in 0..<3 {
            var row: [Bool] = []
            for _ in 0..<4 {
                row.append(false)
            }
            vLines.append(row)
        }
        self.verticalLines = vLines
        
        // 3x3 grid of box owners
        var owners: [[String?]] = []
        for _ in 0..<3 {
            var row: [String?] = []
            for _ in 0..<3 {
                row.append(nil)
            }
            owners.append(row)
        }
        self.boxOwners = owners
        
        self.playerOneScore = 0
        self.playerTwoScore = 0
        self.currentPlayer = "Player A"
        self.isGameOver = false
        self.winner = nil
    }
    
    func claimLine(direction: LineDirection, row: Int, column: Int) {
        if self.isGameOver {
            return
        }
        
        var lineAlreadyClaimed: Bool = false
        
        if direction == .horizontal {
            if row >= 0 && row < 4 && column >= 0 && column < 3 {
                if !self.horizontalLines[row][column] {
                    self.horizontalLines[row][column] = true
                } else {
                    lineAlreadyClaimed = true
                }
            }
        } else {
            if row >= 0 && row < 3 && column >= 0 && column < 4 {
                if !self.verticalLines[row][column] {
                    self.verticalLines[row][column] = true
                } else {
                    lineAlreadyClaimed = true
                }
            }
        }
        
        if lineAlreadyClaimed {
            return
        }
        
        let boxCaptured: Bool = self.checkBoxes()
        
        if !boxCaptured {
            self.switchPlayer()
        }
        
        self.checkGameOver()
    }
    
    private func checkBoxes() -> Bool {
        var capturedAnyBox: Bool = false
        
        for row in 0..<3 {
            for column in 0..<3 {
                // If the box is not yet owned, check if it's now completed
                if self.boxOwners[row][column] == nil {
                    let top: Bool = self.horizontalLines[row][column]
                    let bottom: Bool = self.horizontalLines[row + 1][column]
                    let left: Bool = self.verticalLines[row][column]
                    let right: Bool = self.verticalLines[row][column + 1]
                    
                    if top && bottom && left && right {
                        self.boxOwners[row][column] = self.currentPlayer
                        capturedAnyBox = true
                        
                        if self.currentPlayer == "Player A" {
                            self.playerOneScore += 1
                        } else {
                            self.playerTwoScore += 1
                        }
                    }
                }
            }
        }
        
        return capturedAnyBox
    }
    
    private func switchPlayer() {
        if self.currentPlayer == "Player A" {
            self.currentPlayer = "Player B"
        } else {
            self.currentPlayer = "Player A"
        }
    }
    
    private func checkGameOver() {
        var allBoxesFilled: Bool = true
        for row in 0..<3 {
            for column in 0..<3 {
                if self.boxOwners[row][column] == nil {
                    allBoxesFilled = false
                }
            }
        }
        
        if allBoxesFilled {
            self.isGameOver = true
            if self.playerOneScore > self.playerTwoScore {
                self.winner = "Player A"
            } else if self.playerTwoScore > self.playerOneScore {
                self.winner = "Player B"
            } else {
                self.winner = "Draw"
            }
        }
    }
}
