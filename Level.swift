//
//  Level.swift
//  project1
//
//  Created by Elaine Zhai on 5/8/18.
//  Copyright � 2018 csproject. All rights reserved.
//

import Foundation
import UIKit

let numRows: Int = 4
let numCols: Int = 4
let numLevels = 1

class Level
{
    var boxes = Array2D<Box>(rows: numRows, cols: numCols)
    var tiles = Array2D<Tile>(rows: numRows, cols: numCols)
    var possibleAdds: Set<Add> = []
    
    var timeLimit: Int
    let targetNumber: Int
    
    /**
     * Constructor for objects of class Level.
     *
     * @param filename      the file that contains the level data
     */
    init(filename: String)
    {
        timeLimit = 60
        targetNumber = 10 + (Int(arc4random_uniform(6)))
        
        guard let levelData = LevelData.loadFrom(file: filename) else { return }
        let tilesArray = levelData.tiles
        for (row, rowArray) in tilesArray.enumerated()
        {
            let tileRow = numRows - row - 1
            for (col, value) in rowArray.enumerated()
            {
                if value == 1
                {
                    tiles[col, tileRow] = Tile()
                }
            }
        }
    }
    
    /**
     * Retrieves the Box at [row][atCol] in level
     *
     * @precondition col >= 0 && col < numCols
     * @precondition row >= 0 && row < numRows
     *
     * @param row       the row to retrieve the Box from
     * @param col       the col to retrieve the Box from
     */
    func box(row: Int, atCol col: Int) -> Box?
    {
        precondition(col >= 0 && col < numCols)
        precondition(row >= 0 && row < numRows)
        return boxes[row, col]
    }
    
    /**
     * Retrieves the Tile at [row][col]
     *
     * @precondition col >= 0 && col < numCols
     * @precondition row >= 0 && row < numRows
     *
     * @param row       the row to retrieve the Tile from
     * @param col       the col to retrieve the Tile from
     */
    func tileAt(row: Int, col: Int) -> Box?
    {
        precondition(col >= 0 && col < numCols)
        precondition(row >= 0 && row < numRows)
        return boxes[row, col]
    }
    
    /**
     * Retrieves the image for a given number.
     *
     * @param value       the number to find the image for
     */
    func getImage(value: Int) -> UIImage
    {
        if value == 0
        {
            return #imageLiteral(resourceName: "0")
        }
        else if value == 1
        {
            return #imageLiteral(resourceName: "1")
        }
        else if value == 2
        {
            return #imageLiteral(resourceName: "2")
        }
        else if value == 3
        {
            return #imageLiteral(resourceName: "3")
        }
        else if value == 4
        {
            return #imageLiteral(resourceName: "4")
        }
        else if value == 5
        {
            return #imageLiteral(resourceName: "5")
        }
        else if value == 6
        {
            return #imageLiteral(resourceName: "6")
        }
        else if value == 7
        {
            return #imageLiteral(resourceName: "7")
        }
        else if value == 8
        {
            return #imageLiteral(resourceName: "8")
        }
        else
        {
            return #imageLiteral(resourceName: "9")
        }
    }
    
    /**
     * Shuffles the boxes in the grid
     *
     * @return      the 2d array of boxes that is created
     */
    func shuffle() -> Set<Box> {
        var set: Set<Box>
        repeat
        {
            set = createInitialBoxes()
            detectPossibleAdds()
            print("possible adds: \(possibleAdds)")
        } while possibleAdds.count == 0
        
        return set
    }
    
    /**
     * Creates the initial boxes of the 2d array.
     *
     * @return      the 2d array of boxes that is created
     */
    private func createInitialBoxes() -> Set<Box>
    {
        var set: Set<Box> = []
        
        for row in 0..<numRows
        {
            for col in 0..<numCols
            {
                var boxType: BoxType
                repeat
                {
                    boxType = BoxType.getRandomType()
                } while (row < 2 || row >= 2 &&
                    boxes[row-1, col]?.boxType == boxType &&
                    boxes[row-2, col]?.boxType == boxType)
                    || (col >= 2 &&
                        boxes[row, col-1]?.boxType == boxType &&
                        boxes[row, col-2]?.boxType == boxType)
                
                let box = Box(row: row, col: col, boxType: boxType)
                boxes[row, col] = box
                
                set.insert(box)
                
            }
        }
        return set
    }
    
    /**
     * Checks if there are two numbers next to each other
     * that add to the target number.
     *
     * @return      true if the tile at (row, col)
     *              adds to the target number
     *              (with an adjacent tile)
     */
    
    private func hasMatch(row: Int, atColumn col: Int) -> Bool {
        let value = boxes[row, col]!.boxType.getValue()
        
        // Horizontal
        
        // Left
        let c1 = col-1
        if c1 >= 0 &&
            (boxes[row, c1]?.boxType.getValue())! + value == targetNumber
        {
            return true
        }
        
        // Right
        let c2 = col + 1
        if c2 < numCols &&
            (boxes[row, c2]?.boxType.getValue())! + value == targetNumber
        {
            return true
        }
        
        // Vertical
        
        // Down
        let r1 = row - 1
        if r1 >= 0 &&
            (boxes[r1, col]?.boxType.getValue())! + value == targetNumber
        {
            return true
        }
        
        // Up
        let r2 = row + 1
        if r2 < numRows &&
            (boxes[r2, col]?.boxType.getValue())! + value == targetNumber
        {
            return true
        }
        
        return false
    }
    
    /**
     * Detects possible swaps
     * and sets the possibleAdds set
     * to its result.
     */
    func detectPossibleAdds()
    {
        var set: Set<Add> = []
        
        for row in 0..<numRows
        {
            for col in 0..<numCols
            {
                if col < numCols - 1,
                    let box = boxes[row, col]
                {
                    if let other = boxes[col + 1, row]
                    {
                        boxes[col, row] = other
                        boxes[row, col + 1] = box
                        
                        if hasMatch(row: row, atColumn: col + 1) ||
                            hasMatch(row: row, atColumn: col)
                        {
                            set.insert(Add(boxA: box, boxB: other))
                        }
                        
                        boxes[row, col] = box
                        boxes[row, col + 1] = other
                    }
                    
                    if row < numRows - 1,
                        let other = boxes[col, row + 1]
                    {
                        boxes[col, row] = other
                        boxes[col, row + 1] = box
                        
                        if hasMatch(row: row + 1, atColumn: col) ||
                            hasMatch(row: row, atColumn: col)
                        {
                            set.insert(Add(boxA: box, boxB: other))
                        }
                        
                        boxes[row, col] = box
                        boxes[row + 1, col] = other
                    }
                }
            }
        }
        
        possibleAdds = set
    }
    
    /**
     * Swaps the two boxes.
     *
     * @param add     the Add object that contains
     *                the two boxes that will be added
     *                and need to be swapped
     */
    func swapBoxes(_ add: Add)
    {
        let boxA = add.boxA
        let boxB = add.boxB
        let rowA = boxA.row
        let colA = boxA.col
        let rowB = boxB.row
        let colB = boxB.col
        
        //swaps the two boxes
        boxes[rowA, colA] = boxB
        boxB.row = rowA
        boxB.col = colA
        
        boxes[rowB, colB] = boxA
        boxA.row = rowB
        boxA.col = colB
    }
    
    /**
     * Checks if the add is possible.
     *
     * @param add     the Add object that contains
     *                the two boxes that will be added
     */
    func isPossibleAdd(_ add: Add) -> Bool
    {
        return (add.boxA.value + add.boxB.value == targetNumber) &&
            possibleAdds.contains(add)
    }
    
    /**
     * Removes the match.
     *
     * @param add     the Add object that contains
     *                the two boxes that will be added
     */
    func removeMatch(add: Add)
    {
        boxes[add.boxA.row, add.boxA.col] = nil
        boxes[add.boxB.row, add.boxB.col] = nil
    }
    
    /**
     * Fills the "holes" that are there after
     * the previous boxes are removed.
     *
     * @return an array of the new boxes
     */
    func fillHoles(add: Add)
    {
        var arr: [Box] = [add.boxA, add.boxB]
        
        var boxType: BoxType = .unknown
        for i in 0..<2
        {
            let curr = arr[i]
            var newBoxType: BoxType
            repeat
            {
                newBoxType = BoxType.getRandomType()
            } while newBoxType == boxType
            boxType = newBoxType
            let box = Box(row: curr.row, col: curr.col, boxType: boxType)
            boxes[curr.row, curr.col] = box
            arr[i] = box
            
        }
    }
    
    /**
     * Gets the next Box. The next Box is random if
     * alreadyMatches() returns true. The next Box
     * is calculated to find a match to target if
     * alreadyMatches() returns false.
     *
     * @return          the next Box
     */
    func getNextBox(r: Int, c: Int) -> Box
    {
        var boxType: BoxType
        repeat
        {
            boxType = BoxType.getRandomType()
        } while (r >= 2 &&
            boxes[r, c - 1]?.boxType == boxType &&
            boxes[r, c - 2]?.boxType == boxType)
            || (c >= 2 &&
                boxes[r - 1, c]?.boxType == boxType &&
                boxes[r - 2, c]?.boxType == boxType)
        
        let box = Box(row: r, col: c, boxType: boxType)
        boxes[r, c] = box
        return boxes[r,c]!
    }
}

