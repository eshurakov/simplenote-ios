import XCTest
@testable import Simplenote

// MARK: - SPSnappingSliderTests
//
class SPSnappingSliderTests: XCTestCase {

    /// Slider
    ///
    private lazy var slider: SPSnappingSlider = {
        let slider = SPSnappingSlider()
        slider.step = 1.0
        slider.minimumValue = 0.0
        slider.maximumValue = 10.0
        return slider
    }()

    /// Test that values are snapped according to "step"
    ///
    func testSnapping() throws {
        var receivedValues: [Float] = []
        slider.onSnappedValueChange = { value in
            receivedValues.append(value)
        }

        slider.value = 0.9
        slider.value = 2.1
        slider.value = 3.49
        slider.value = 3.5

        XCTAssertEqual(receivedValues, [1.0, 2.0, 3.0, 4.0])
    }

    /// Test that for the same snapped value we get only one callback
    ///
    func testCallbackIsCalledOnlyOnceForTheSameValue() throws {
        var receivedValues: [Float] = []
        slider.onSnappedValueChange = { value in
            receivedValues.append(value)
        }

        slider.value = 0.9
        slider.value = 1.0
        slider.value = 1.1

        XCTAssertEqual(receivedValues, [1.0])
    }
}
