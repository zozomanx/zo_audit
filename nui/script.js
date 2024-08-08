const app = Vue.createApp({
    data() {
        return {
            isAuditOpen: false,
            siteName: 'Financial Transaction Audit',
            searchData: 'UDT96695',
            results: []
        }
    },
    methods: {
        openAudit(){
            this.isAuditOpen = true
        },
        async clickSearch(){
            try {
                // console.log('Searching...')
                // console.log(this.searchData)
                axios.post(`https://${GetParentResourceName()}/search`, {
                    searchData: this.searchData
                });
            } catch (error) {
                console.error('Error during search request:', error.message);
                console.error('Full error object:', error, error.response);
            }
        },
        clickExport(){
            console.log('Exporting...')
        },
        handleMessage(event) {
            const action = event.data.action
            const statements = event.data.statements

            if (action === "openAudit") {
                this.openAudit()
            } else if (action === "updateResults") {
                // console.log('updateResults triggered via handlemessage')
                this.displayResults(statements)
            } else {
                // console.log('nothing')
            }
        },
        async closeAudit() {
            this.isAuditOpen = false
            try {
                await axios.post(`https://${GetParentResourceName()}/closeAudit`, {})
            } catch (error) {
                console.error('Error during closeAudit request:', error.message);
                console.error('Full error object:', error);
            }
        },
        handleKeydown(event) {
            if (event.key === "Escape") {
                this.closeAudit();
            }
        },
        displayResults(statements) {
            // console.log('displayResults called')
            this.results = statements
        },
        formatDate(timestamp) {
            const date = new Date(timestamp);
            return date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
        },
    },
    mounted() {
        document.addEventListener("keydown", this.handleKeydown)
        window.addEventListener("message", this.handleMessage)
        window.addEventListener("message", this.handleMessage)
        console.log('mounted')
    },
    beforeUnmount() {
        document.removeEventListener("keydown", this.handleKeydown)
    },
}).mount('#app')
