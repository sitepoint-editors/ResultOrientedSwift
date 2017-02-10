import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// Computing square of the number, asynchronously:

func square(ofNumber number: Int, completion: @escaping (Int) -> Void) {

    OperationQueue().addOperation {
        let squared = number * number
        OperationQueue.main.addOperation {
            completion(squared)
        }
    }
}

print("squaring")

square(ofNumber: 5) { squared in
    print(squared)
}

print("no longer squaring")



//: Result<T> example with division

enum Result<T> {
    case success(T)
    case error(Error)
}

enum MathError: Error {
    case divisionWithZero
}

/// Divides two numbers
///
/// - Parameters:
///   - first: First number
///   - second: Second number
/// - Returns: `Result<Double>`
func divide(_ first: Double, with second: Double) -> Result<Double> {
    // Check if second number is zero
    // If it is, return error result
    if second == 0 { return .error(MathError.divisionWithZero) }
    
    // Return successful result if second number
    // is not zero
    return .success(first / second)
}

let divisionResult = divide(5, with: 0)
switch divisionResult {
case let .success(value):
    print("Result of division is \(value)")
case let .error(error):
    print("error: \(error)")
}
