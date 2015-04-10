//
//  FMOsc.swift
//  Bubli
//
//  Created by Nathan  Pahucki on 4/2/15.
//  Copyright (c) 2015 Nathan Pahucki. All rights reserved.
//

import UIKit

class FMOscillator : AKInstrument {


    let frequency : AKInstrumentProperty = AKInstrumentProperty(value:220.0, minimum:1.0 , maximum:440.0)
    let carrierMultiplier : AKInstrumentProperty = AKInstrumentProperty(value:1.0, minimum:0.0, maximum:2.0)
    let modulatingMultiplier : AKInstrumentProperty = AKInstrumentProperty(value:1.0, minimum:0.0, maximum:2.0)
    let modulationIndex : AKInstrumentProperty = AKInstrumentProperty(value:1,  minimum:15,   maximum:30)
    let amplitude : AKInstrumentProperty = AKInstrumentProperty(value:0.0, minimum:0,   maximum:0.2)
    
    override init() {
        super.init()
        addProperty(frequency)
        addProperty(carrierMultiplier)
        addProperty(modulatingMultiplier)
        addProperty(modulationIndex)
        addProperty(amplitude)

        let osc = AKFMOscillator(waveform: AKTable.standardSquareWave(),
            baseFrequency: frequency,
            carrierMultiplier: carrierMultiplier,
            modulatingMultiplier: modulatingMultiplier,
            modulationIndex: modulationIndex,
            amplitude: amplitude)
        setAudioOutput(osc)
    }
    
    func reset() {
        frequency.value = frequency.initialValue
        carrierMultiplier.value = carrierMultiplier.initialValue
        modulatingMultiplier.value = modulatingMultiplier.initialValue
        modulationIndex.value = modulationIndex.value
        amplitude.value = amplitude.initialValue
    }
}
