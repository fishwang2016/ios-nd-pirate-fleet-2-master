//
//  ControlCenter.swift
//  Pirate Fleet
//
//  Created by Jarrod Parkes on 9/2/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

struct GridLocation {
    let x: Int
    let y: Int
}

struct Ship {
    let length: Int
    let location: GridLocation
    let isVertical: Bool
    let isWooden: Bool
    

// TODO: Add the computed property, cells.
    var cells: [GridLocation] {
        get {
            // Hint: These two constants will come in handy
            let start = self.location
            let end: GridLocation = ShipEndLocation(self)
            
            // Hint: The cells getter should return an array of GridLocations.
            var occupiedCells = [GridLocation]()
            
            //print(" start: \(start) ")
           // print("end: \(end)")
            
            if start.x - end.x == 0 {
                
                for i in start.y...end.y{
                    
                    occupiedCells.append(GridLocation(x: start.x,y: i))
                }
            
            } else if start.y - end.y == 0 {
                
                for i in start.x...end.x{
                    
                    occupiedCells.append(GridLocation(x: i, y: start.y))
                }
            
            }
            //print("shipLocations:")
            //print(occupiedCells)
            return occupiedCells

        }
    }
    
    var hitTracker: HitTracker
    let hit = HitTracker()
// TODO: Add a getter for sunk. Calculate the value returned using hitTracker.cellsHit.
    var sunk: Bool {
        
        get {
        
            for (_, value) in hitTracker.cellsHit {
                
                if value == false{
                    
                    return false
                }
            
            }
            
         return true
        
        }
    }

// TODO: Add custom initializers
    init(length:Int, location: GridLocation, isVertical:Bool){
        
        self.length = length
        self.location = location
        self.isVertical = isVertical
        self.isWooden = false
        self.hitTracker = hit
        
    }
    
    init(length: Int, location: GridLocation, isVertical: Bool,isWooden:Bool){
        
        self.length = length
        self.location = location
        self.isVertical = isVertical
        self.isWooden = isWooden
        self.hitTracker = hit
    }

    
    init(length: Int, location:GridLocation,isVertical :Bool,isWooden:Bool, hitTracker:HitTracker) {
        self.length = length
        self.hitTracker = hitTracker
        self.isVertical = isVertical
        self.location  = location
        self.isWooden = isWooden
    }
}

// TODO: Change Cell protocol to PenaltyCell and add the desired properties
protocol PenaltyCell {
    var location: GridLocation {get}
    var guaranteesHit :Bool {get set}
    var penaltyText :String {get set }
}

// TODO: Adopt and implement the PenaltyCell protocol
struct Mine: PenaltyCell {
    let location: GridLocation
    
    var guaranteesHit :Bool
    var penaltyText :String
    
    init(location:GridLocation){
        
        self.location = location
        self.guaranteesHit = true
        self.penaltyText = "Hit Mine!! Careful!"
    
    }
    
    init(location:GridLocation, penalyText:String){
        
        self.location = location
        self.guaranteesHit = false
        self.penaltyText = penalyText
        
    }
    
    init(location:GridLocation, penalyText:String,guaranteesHit:Bool){
        
        self.location = location
        self.guaranteesHit = guaranteesHit
        self.penaltyText = penalyText
        
    }


    
}

// TODO: Adopt and implement the PenaltyCell protocol
struct SeaMonster: PenaltyCell {
    let location: GridLocation
    var guaranteesHit :Bool
    var penaltyText: String
    
    init(location:GridLocation){
        
        self.location = location
        self.guaranteesHit = true
        self.penaltyText = "test"
    }
}

class ControlCenter {
    
    func placeItemsOnGrid(human: Human) {
        
        let smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: true, isWooden: true, hitTracker: HitTracker())
        human.addShipToGrid(smallShip)
        
        let mediumShip1 = Ship(length: 3, location: GridLocation(x: 0, y: 0), isVertical: false, isWooden: true, hitTracker: HitTracker())
        human.addShipToGrid(mediumShip1)
        
        let mediumShip2 = Ship(length: 3, location: GridLocation(x: 3, y: 1), isVertical: false, isWooden: true, hitTracker: HitTracker())
        human.addShipToGrid(mediumShip2)
        
        let largeShip = Ship(length: 4, location: GridLocation(x: 6, y: 3), isVertical: true, isWooden: true, hitTracker: HitTracker())
        human.addShipToGrid(largeShip)
        
        let xLargeShip = Ship(length: 5, location: GridLocation(x: 7, y: 2), isVertical: true, isWooden: true, hitTracker: HitTracker())
        human.addShipToGrid(xLargeShip)
        
        let mine1 = Mine(location: GridLocation(x: 6, y: 0),penalyText:"hit!! Mine")
        human.addMineToGrid(mine1)
        let mine2 = Mine(location: GridLocation(x: 3, y: 3))
        human.addMineToGrid(mine2)



        
        let seamonster1 = SeaMonster(location: GridLocation(x: 5, y: 6))
        human.addSeamonsterToGrid(seamonster1)
        
        let seamonster2 = SeaMonster(location: GridLocation(x: 2, y: 2))
        human.addSeamonsterToGrid(seamonster2)
      //  print(smallShip.cells) // check location working?

    }
    
    func calculateFinalScore(gameStats: GameStats) -> Int {
        
        var finalScore: Int
        
        let sinkBonus = (5 - gameStats.enemyShipsRemaining) * gameStats.sinkBonus
        let shipBonus = (5 - gameStats.humanShipsSunk) * gameStats.shipBonus
        let guessPenalty = (gameStats.numberOfHitsOnEnemy + gameStats.numberOfMissesByHuman) * gameStats.guessPenalty
        
        finalScore = sinkBonus + shipBonus - guessPenalty
        
        return finalScore
    }
}