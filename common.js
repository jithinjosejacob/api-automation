// This will allow mocha to return non zero exit codes.
module.exports = function(bail) {
    function onUncaught(err){
        console.log(err)
        process.exit(1)
    }

    process.on("unhandledRejection", onUncaught)
    process.on("uncaughtException", onUncaught)
    process.setMaxListeners(20)

    beforeEach(function () {
        if(bail.shouldBail){
            this.skip()
        }
    })

    afterEach(function () {
        if(this.currentTest.state === 'failed'){
            bail.shouldBail = true
        }
    })
}