import * as index from './tests/index'

for (let test in index) {
    // call each test function from index tests
    index[test]()
}
