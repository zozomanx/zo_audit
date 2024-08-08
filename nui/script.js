const app = Vue.createApp({
    data() {
        return {
            isAuditOpen: false,
            siteName: 'Financial Transaction Audit',
            searchData: ''
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
            if (action === "openAudit") {
                this.openAudit()
            }
        },
        closeAudit() {
            this.isAuditOpen = false
        
            axios.post(`https://${GetParentResourceName()}/closeAudit`, {});
        },
        handleKeydown(event) {
            if (event.key === "Escape") {
                this.closeAudit();
            }
        },

    },
    
    mounted() {
        document.addEventListener("keydown", this.handleKeydown)
        window.addEventListener("message", this.handleMessage)
        console.log('mounted')
    },
    beforeUnmount() {
        document.removeEventListener("keydown", this.handleKeydown)
    },
}).mount('#app')