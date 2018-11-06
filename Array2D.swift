//
//  2DArray.swift
//  project1
//
//  Created by Julia Biswas on 5/11/18.
//  Copyright © 2018 csproject. All rights reserved.
//

import Foundation
import UIKit

struct Array2D<T>
{
    let rows: Int
    let cols: Int
    
    var array: [T?]
    
    /**
     * Constructor for objects of class Array2D.
     *
     * @param rows      number of rows in the 2d array
     * @param cols      numbers of coloumns in the 2d array
     * @param arr       the array of type T in the array
     */
    init(rows: Int, cols: Int)
    {
        self.rows = rows
        self.cols = cols
        array = Array<T?>(repeating: nil, count: rows*cols)
    }
    
    /**
     * Gets and sets the elements in the 2d array.
     *
     * @param r      the row in the 2d array
     * @param c      the column in the 2d array
     *
     * @return the element at [r][c]
     */
    subscript(r: Int, c: Int) -> T? {
        get
        {
            return array[(r * cols) + c]
        }
        set {
            array[r * cols + c] = newValue
        }
    }
}

