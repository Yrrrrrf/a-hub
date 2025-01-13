<!-- src/routes/+layout.svelte -->
<script lang="ts">
    import '../app.css';
    let { children } = $props();
    import { onMount } from 'svelte';
    import { appData, forge, apiStore, Kyntharil, gen_types, Altharun, UIShowcase } from 'rune-lab';
    import { themeStore } from 'rune-lab';
    // import {  UIShowcase, databaseStore, } from 'rune-lab';
    import { Footer, UrlDisplay, NavBar } from 'rune-lab';
    
    import { authStore } from 'rune-lab';
    import { profileStore } from '$lib/stores/profile.svelte';

    import { initFooter } from '$lib/stores/footer.svelte';
	// import { requestsStore } from '$lib/stores/requests.svelte';

    initFooter();  // Initialize footer data

    onMount(() => {  // Initialize main app data
        // requestsStore.getRequestTypes(); // No need to call other get methods, they are just getters.

        appData.init({  // Initialize app data
            name: 'A-Hub',
            version: 'v0.2.0',
            description: 'A-Hub is a web that means to be a better academic hub for students and teachers.',
            author: 'Yrrrrrf <fer.rezac@outlook.com>'
        });

        apiStore.init({  // Initialize API configuration
            URL: 'http://localhost:8000',
            VERSION: 'v1',
            TIMEOUT: 30000
        });

        // databaseStore.init();

        authStore.setProfile({
            id: 'a4444444-4444-4444-4444-444444444444', // Student ID from DB
            username: 'student',
            email: 'student@academichub.edu',
            fullName: 'John Student',
            status: 'active',
            roles: [{ id: '44444444-4444-4444-4444-444444444444', name: 'student', permissions: {} }],
            createdAt: new Date().toISOString(),
            updatedAt: new Date().toISOString()
        });

        // authStore.setProfile({
        //     id: '1',
        //     username: 'yrrrrrf',
        //     email: 'some@mail.com',
        //     fullName: 'Fer Reza C',
        //     status: 'active',
        //     roles: [{ id: '1', name: 'user', permissions: {} }],
        //     createdAt: new Date().toISOString(),
        //     updatedAt: new Date().toISOString()
        // });
        // authStore.clearAuth();

        // console.log('Profile:', profileStore.profile);
    });

    // Meta tags derived from app data
    const metaTags = $derived([
        { name: 'application-name', content: appData.name },
        { name: 'author', content: appData.author },
        { name: 'description', content: appData.description },
    ]);
</script>

<svelte:head>
    <title>{appData.name}</title>
    {#each metaTags as meta}
        <meta name={meta.name} content={meta.content} />
    {/each}
</svelte:head>

<!-- <UIShowcase /> -->

<NavBar />


<!-- From the rune of change... -->
<!-- <Kyntharil /> -->

<!-- From the rune of knowledge... -->
<!-- <Altharun /> -->


<div class="min-h-screen flex flex-col">
    <main class="flex-grow">
        {@render children()}
    </main>

    <Footer />
</div>

<UrlDisplay />

<style>
    :global(body) {
        font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    @keyframes gradientAnimation {
        0% { background-position: 0% 50%; }
        50% { background-position: 100% 50%; }
        100% { background-position: 0% 50%; }
    }

    :global(.bg-gradient-animated) {
        background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
        background-size: 400% 400%;
        animation: gradientAnimation 15s ease infinite;
    }
</style>
