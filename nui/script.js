const {createApp} = Vue
const {createVuetify} = Vuetify

const vuetify = createVuetify()

createApp({
    data() {
        return {
            isAuditOpen: false,
            siteName: 'Financial Transaction Audit',
            searchData: '',
            startDate: new Date(new Date().setDate(new Date().getDate() - 30)).toISOString().split('T')[0],
            endDate: new Date().toISOString().split('T')[0],
            results: [],
            noSearchResults: false,
            cidName: 'SSN',
            idName: 'ID Number',
            search: '',
            menu: false,
            dates: {start: null, end: null},
            dateRangeText: '',
            searchGrid: '',
            // Table headers
            headers: [{
                    title: 'Citizen ID',
                    value: 'citizenid',
                    sortable: true
                },
                {
                    title: 'Account Name',
                    value: 'account_name',
                    sortable: true
                },
                {
                    title: 'Amount',
                    value: 'amount',
                    sortable: true
                },
                {
                    title: 'Reason',
                    value: 'reason',
                    sortable: true
                },
                {
                    title: 'Statement Type',
                    value: 'statement_type',
                    sortable: true
                },
                {
                    title: 'Date',
                    value: 'date',
                    sortable: true
                }
            ],
            selectedOption: 'SSN',
            pasteeAPIKey: '',
            pasteeResponse: [],
            pasteeError: []
        }
    },
    computed: {
        // Check if the export button should be disabled
        isExportDisabled() {
            return this.results.length === 0
        }
    },
    methods: {
        // Open the audit window
        openAudit() {
            this.isAuditOpen = true
        },
        // Send a request to the server to search for transactions
        async clickSearch() {
            try {
                this.pasteeError = []
                this.pasteeResponse = []

                if (this.selectedOption === this.cidName) {
                    const response = await axios.post(`https://${GetParentResourceName()}/search`, {
                        searchData: this.searchData,
                        startDate: this.startDate,
                        endDate: this.endDate,
                        selectedOption: this.selectedOption
                    })
                } else if (this.selectedOption === this.idName) {
                    const response = await axios.post(`https://${GetParentResourceName()}/search`, {
                        searchData: this.searchData,
                        startDate: this.startDate,
                        endDate: this.endDate,
                        selectedOption: this.selectedOption
                    })
                } else {
                    console.error('Invalid search option selected.')
                }
                // Handle response if needed
            } catch (error) {
                console.error('Error during search request:', error.message)
                console.error('Full error object:', error)
            }
        },
        // Custom filter for the search bar to handle searching with or without commas
        customFilter(value, search, item) {
            if (typeof value === 'number') {
              // Remove commas from the search string and the value
              const normalizedSearch = search.replace(/,/g, '')
              const normalizedValue = value.toString().replace(/,/g, '')
              return normalizedValue.includes(normalizedSearch)
            }
            // Default behavior for non-number fields
            return value.toString().toLowerCase().includes(search.toLowerCase())
          },
        // Export the results to a CSV file using Pastee API
        async clickExport() {
            // console.log('Exporting...')
            // upload the data in results to Pastee api
            const results = this.results.map(result => {

                return {
                    'Citizen ID': result.citizenid,
                    'Account Name': result.account_name,
                    'Amount': result.amount,
                    'Reason': result.reason,
                    'Statement Type': result.statement_type,
                    'Date': new Date(result.date).toISOString().replace('T', ' ').substring(0, 19)
                }

            })

            // Use PapaParse to convert the data to CSV format
            const csv = Papa.unparse(results, {
                quotes: true, // Enclose all fields in quotes
                quoteChar: '"', // Character used to quote fields
                escapeChar: '"', // Character used to escape quotes within fields
                delimiter: ",", // Delimiter between fields
                header: true, // Include headers in the CSV
            })

            // Pastee API data
            const pasteData = {
                description: `Audit Results ${this.selectedOption} ${this.searchData}`,
                sections: [{
                    name: 'Audit Results ' + this.selectedOption + ' ' + this.searchData,
                    syntax: 'text',
                    contents: csv
                }]
            }

            try {
                const response = await axios.post('https://api.paste.ee/v1/pastes', pasteData, {
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Auth-Token': this.pasteeAPIKey
                    }
                })

                this.pasteeResponse = response.data

                // console.log('Pastee response:', response.data)
            } catch (error) {
                console.error('Error uploading to Pastee:', error.message)
                console.log('Pastee response:', error.response.data.errors[0].message)

                this.pasteeError[0] = error.message
                this.pasteeError[1] = error.response.data.errors[0].message
            }

            // This is used if having the LUA server handle the export

            // try {
            //     await axios.post(`https://${GetParentResourceName()}/export`, {})
            // } catch (error) {
            //     console.error('Error during export request:', error.message)
            //     console.error('Full error object:', error)
            // }
        },
        // Handle messages from the server
        handleMessage(event) {
            const action = event.data.action
            const statements = event.data.statements
            const cidName = event.data.citizenidName
            const siteName = event.data.siteName
            const idName = event.data.idName
            const pasteeAPIKey = event.data.pasteeAPIKey

            if (action === "openAudit") {
                this.openAudit()
            } else if (action === "updateResults") {
                this.displayResults(statements)
            } else if (action === "initVariables") {
                this.siteName = siteName
                this.cidName = cidName
                this.selectedOption = cidName
                this.idName = idName
                this.pasteeAPIKey = pasteeAPIKey
            }
        },
        // Close the audit window, reset variables, and send a request to the server to close the audit
        async closeAudit() {
            this.isAuditOpen = false
            this.results = []
            this.noSearchResults = false
            this.searchData = ''
            this.pasteeResponse = [],
                this.pasteeError = []

            try {
                await axios.post(`https://${GetParentResourceName()}/closeAudit`, {})
            } catch (error) {
                console.error('Error during closeAudit request:', error.message)
                console.error('Full error object:', error)
            }
        },
        // Close Audit if escape key is pressed
        handleKeydown(event) {
            if (event.key === "Escape") {
                this.closeAudit()
            }
        },
        // If results are found, display them. Otherwise, display no results message
        displayResults(statements) {
            if (statements.length > 0) {
                this.results = statements
                this.noSearchResults = false
            } else {
                this.noResults()
            }
        },
        // Reset variable if no results found
        noResults() {
            this.noSearchResults = true
            this.results = []
        },
        formatDate(timestamp) {
            const date = new Date(timestamp)
            return date.toLocaleDateString() + ' ' + date.toLocaleTimeString()
        },
        formatCurrency(value) {
            if (typeof value !== "number") {
                return value
            }
            return new Intl.NumberFormat('en-US', {
                style: 'currency',
                currency: 'USD',
                minimumFractionDigits: 0,
                maximumFractionDigits: 0
            }).format(value)
        }
    },
    mounted() {
        // Add event listeners
        document.addEventListener("keydown", this.handleKeydown)
        window.addEventListener("message", this.handleMessage)
    },
    beforeUnmount() {
        // Remove event listeners
        document.removeEventListener("keydown", this.handleKeydown)
    }
}).use(vuetify).mount('#app')