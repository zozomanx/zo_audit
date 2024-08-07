new Vue({
    el: '#app',
    data: {
        isAppVisible: true,
        citizenid: '',
        startDate: '',
        endDate: '',
        transactions: [],
        accounts: []
    },
    created() {
        window.addEventListener('message', this.handleMessage);
    },
    methods: {
        handleMessage(event) {
            const item = event.data;
            if (item.type === "ui") {
                this.isAppVisible = item.status;
            }
        },
        async searchTransactions() {
            if (!this.citizenid || !this.startDate || !this.endDate) {
                alert("Please enter all search fields.");
                return;
            }

            try {
                const transactionsResponse = await fetch(`/api/transactions?citizenid=${this.citizenid}&startDate=${this.startDate}&endDate=${this.endDate}`);
                this.transactions = await transactionsResponse.json();

                const accountsResponse = await fetch(`/api/accounts?citizenid=${this.citizenid}`);
                this.accounts = await accountsResponse.json();
            } catch (error) {
                console.error("Error fetching data:", error);
            }
        }
    }
});


// Watch for "ui" event to enable the Penal Code to open
window.addEventListener('message', function(event) {
    var item = event.data;
    if (item.type === "ui") {
        OpenWindow(item.status);
    }
});


/* // Ensure the iframeContainer is initially hidden
CloseWindow()

// Add event listener for the Esc key
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        CloseWindow();
    }
});

// Function to close the iframeContainer
function CloseWindow() {
    document.getElementById('container').style.display = 'none';

    $.post('https://zo_audit/close', JSON.stringify({})); // Send to LUA to release NUI focus
}

// Close button functionality
document.getElementById('closeButton').addEventListener('click', function() {
    CloseWindow();
});

// Watch for "ui" event to enable the Penal Code to open
window.addEventListener('message', function(event) {
    var item = event.data;
    if (item.type === "ui") {
        OpenWindow(item.status);
    }
});
 */