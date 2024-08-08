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
        clickSearch(){
            console.log('Searching...')
            console.log(this.searchData)
            axios.post(`https://${GetParentResourceName()}/search`, {
                searchData: this.searchData
            });
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
                console.log('updateResults triggered via handlemessage')
                this.displayResults(statements)
            } else {
                console.log('nothing')
            }
        },
        closeAudit() {
            this.isAuditOpen = false
        
            axios.post(`https://${GetParentResourceName()}/closeAudit`, {})
        },
        handleKeydown(event) {
            if (event.key === "Escape") {
                this.closeAudit();
            }
        },
        displayResults(statements) {
            console.log('displayResults called')
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