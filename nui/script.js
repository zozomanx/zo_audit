const app = Vue.createApp({
    data() {
        return {
            siteName: 'Financial Transaction Audit',
        }
    },
    methods: {
        clickSearch(){
            console.log('Searching...');
        },
        clickExport(){
            console.log('Exporting...');
        },
    },
})


app.mount('#app')