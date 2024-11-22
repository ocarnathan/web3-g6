interface PageContent {
    title: string;
    content: string;
}

const pages: Record<string, PageContent> = {
    home: {
        title: 'Welcome to Voting dApp',
        content: `
            <h1>Welcome to Voting dApp</h1>
            <button id="connectButton">Connect Wallet</button>
            <p>A decentralized voting platform for transparent elections</p>
        `
    },
    register: {
        title: 'Register to Vote',
        content: `
            <h1>Register to Vote</h1>
            <p>Registration page coming soon...</p>
        `
    },
    vote: {
        title: 'Cast Your Vote',
        content: `
            <h1>Cast Your Vote</h1>
            <p>Voting page coming soon...</p>
        `
    },
    dashboard: {
        title: 'Voting Dashboard',
        content: `
            <h1>Voting Dashboard</h1>
            <p>Dashboard coming soon...</p>
        `
    }
};

function updateContent(pageId: string): void {
    const contentDiv = document.getElementById('content');
    const page = pages[pageId] || pages.home;
    
    if (contentDiv) {
        contentDiv.innerHTML = page.content;
    }
    
    document.title = `Voting dApp - ${page.title}`;
    
    // Reattach event listeners
    if (pageId === 'home') {
        const connectButton = document.getElementById('connectButton');
        if (connectButton) {
            connectButton.addEventListener('click', connectWallet);
        }
    }
}

async function connectWallet(): Promise<void> {
    console.log('Connecting wallet...');
    // Wallet connection logic will go here
}

function handleNavigation(): void {
    const pageId = window.location.hash.slice(1) || 'home';
    updateContent(pageId);
}

// Event listeners
window.addEventListener('hashchange', handleNavigation);
window.addEventListener('DOMContentLoaded', handleNavigation); 