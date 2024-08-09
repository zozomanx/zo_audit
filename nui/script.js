const { createApp } = Vue;
const { createVuetify } = Vuetify;

const vuetify = createVuetify();

createApp({
    data() {
        return {
            isAuditOpen: true,
            siteName: 'Financial Transaction Audit',
            searchData: '',
            results: [],
            noSearchResults: false,
            cidName: 'SSN',
            idName: 'ID Number',
            search: '',
            searchGrid: '',
            headers: [
                { title: 'Citizen ID', value: 'citizenid' },
                { title: 'Account Name', value: 'account_name' },
                { title: 'Amount', value: 'amount' },
                { title: 'Reason', value: 'reason' },
                { title: 'Statement Type', value: 'statement_type' },
                { title: 'Date', value: 'date' }
            ],
            selectedOption: 'SSN',
        };
    },
    methods: {
        openAudit() {
            this.isAuditOpen = true;
        },
        async clickSearch() {
            try {
                if (this.selectedOption === this.cidName) {   
                    const response = await axios.post(`https://${GetParentResourceName()}/search`, {
                        searchData: this.searchData,
                        selectedOption: this.selectedOption
                    });
                } else if (this.selectedOption === this.idName) {
                    const response = await axios.post(`https://${GetParentResourceName()}/search`, {
                        searchData: this.searchData,
                        selectedOption: this.selectedOption
                    });
                } else { console.error('Invalid search option selected.'); }
                // Handle response if needed
            } catch (error) {
                console.error('Error during search request:', error.message);
                console.error('Full error object:', error);
            }
        },
        async clickExport() {
            console.log('Exporting...');
            try {
                await axios.post(`https://${GetParentResourceName()}/export`, {});
            } catch (error) {
                console.error('Error during export request:', error.message);
                console.error('Full error object:', error);
            }
        },
        handleMessage(event) {
            const action = event.data.action;
            const statements = event.data.statements;
            const cidName = event.data.citizenidName;
            const siteName = event.data.siteName;
            const idName = event.data.idName;

            if (action === "openAudit") {
                this.openAudit();
            } else if (action === "updateResults") {
                this.displayResults(statements);
            } else if (action === "initVariables") {
                this.siteName = siteName;
                this.cidName = cidName;
                this.selectedOption = cidName;
                this.idName = idName;
            }
        },
        async closeAudit() {
            this.isAuditOpen = false;
            this.results = [];
            this.noSearchResults = false;
            this.searchData = '';

            try {
                await axios.post(`https://${GetParentResourceName()}/closeAudit`, {});
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
            if (statements.length > 0) {
                this.results = statements;
                this.noSearchResults = false;
            } else {
                this.noResults();
            }
        },
        noResults() {
            this.noSearchResults = true;
            this.results = [];
        },
        formatDate(timestamp) {
            const date = new Date(timestamp);
            return date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
        }
    },
    mounted() {
        document.addEventListener("keydown", this.handleKeydown);
        window.addEventListener("message", this.handleMessage);
    },
    beforeUnmount() {
        document.removeEventListener("keydown", this.handleKeydown);
    }
}).use(vuetify).mount('#app');
