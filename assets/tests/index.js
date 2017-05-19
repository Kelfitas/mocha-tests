import 'assert'

export function exampleTestCase() {
    describe('Array', () => {
        describe('#indexOf()', () => {
            it('should return -1 when the value is not present', () => {
                assert.equal(-1, [1,2,3].indexOf(4))
            })
        })
    })
}
export function anotherExampleTestCase() {
    describe('Array', () => {
        describe('#indexOf()', () => {
            it('should return -1 when the value is not present', () => {
                assert.equal(-1, [1, 2, 3, 4].indexOf(4))
            })
        })
    })
}
