const reportDirectory = '/tmp/'
const reportName = 'test-result'

module.exports = {
    exit: true,
    extension: ["js"],
    package: "./package.json",
    spec: ["test.js"],
    reporter: "mochawesome",
    "reporter=option": [`reportDir=${reportDirectory}`, "overwrite=true", "inline=true", `reportFilename=${reportName}`],
    timeout: "100000"
}