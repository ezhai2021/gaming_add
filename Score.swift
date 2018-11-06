//
//  Score.swift
//  project1
//
//  Created by Elaine Zhai on 5/17/18.
//  Copyright © 2018 LearnAppMaking. All rights reserved.
//

import Foundation
import UIKit

//need to keep track of score here
//also do the highest score stuff
//make it an instance variable of either viewcontroller or gamescene idk
//^^have the uilabel as one of its instance variables

struct Score
{
    var score: Int
    init()
    {
        score = 0
    }
    mutating func add()->Int
    {
        self.score+=1
        return score
    }
}

