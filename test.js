const retry = require("async-retry")
const axios = require("axios")
const assert = require("assert")
const setUpBail = require("./common")
const bail = { shouldBail: false }

describe(" Test HTTP Call", () => {
    setUpBail(bail)

    before(async () =>{
        console.log("Before Each")
    })

    it("Test Axios call", async () =>{
        return retry(
            async () => {
                const result = await axios({
                    url: 'https://dog.ceo/api/breeds/list/all',
                    method: 'get',
                    data: {
                      foo: 'bar'
                    }
                  })
                  console.log(result.status)
                  assert.equal(result.status, 201)
            },
            {
                retries: 2,
                onRetry: (err) => {
                    console.log(`Retrying on error: ${err}`)
                }
            }
        )
    })
})