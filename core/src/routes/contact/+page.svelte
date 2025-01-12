<!-- src/routes/contact/+page.svelte -->
<script lang="ts">
    import { fade, fly } from 'svelte/transition';
    import {
        MagnifyingGlass,
        Phone,
        EnvelopeSimple,
        Buildings
    } from 'phosphor-svelte';
    import { contactStore } from '$lib/stores/contact.svelte';

    // Local state
    let searchQuery = $state('');
    let selectedDepartment = $state('all');

    // Get data from store
    let departments = $derived(contactStore.departments);
    let mainInfo = $derived(contactStore.mainInfo);
    let director = $derived(contactStore.director);
    let quickContacts = $derived(contactStore.quickContacts);

    // Filtered contacts based on search
    let filteredContacts = $derived(
        searchQuery ? contactStore.searchContacts(searchQuery) :
        selectedDepartment === 'all' ? 
            departments.flatMap(d => d.contacts) :
            contactStore.getDepartmentContacts(selectedDepartment)
    );
</script>

<div class="min-h-screen bg-base-200">
    <!-- Hero Section -->
    <section class="hero min-h-[40vh] bg-gradient-to-br from-primary/10 to-base-200">
        <div class="hero-content text-center">
            <div class="max-w-2xl" in:fly={{ y: -20, duration: 1000 }}>
                <h1 class="text-5xl font-bold mb-4">Contacto</h1>
                <p class="text-xl opacity-80">
                    Estamos aquí para ayudarte. Encuentra la información de contacto 
                    de nuestro personal académico y administrativo.
                </p>
            </div>
        </div>
    </section>

    <!-- Quick Contact Cards -->
    <section class="py-8 container mx-auto px-4">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            {#each quickContacts as contact}
                <a 
                    href={contact.action}
                    class="card bg-base-100 shadow-xl hover:shadow-2xl transition-all duration-300
                           hover:-translate-y-1 group"
                >
                    <div class="card-body flex flex-row items-center gap-4">
                        <div 
                            class="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center
                                   group-hover:bg-primary/20 transition-colors"
                        >
                            <contact.icon
                                weight="duotone"
                                class="w-6 h-6 text-primary"
                            />
                        </div>
                        <div>
                            <h3 class="font-bold">{contact.label}</h3>
                            <p class="text-sm opacity-70">{contact.value}</p>
                        </div>
                    </div>
                </a>
            {/each}
        </div>
    </section>

    <!-- Director Card -->
    <section class="py-8 container mx-auto px-4">
        <div class="card lg:card-side bg-base-100 shadow-xl max-w-3xl mx-auto overflow-hidden">
            <figure class="lg:w-1/3 relative">
                {#if director.image}
                    <img 
                        src={director.image} 
                        alt={director.name}
                        class="w-full h-full object-cover"
                    />
                {:else}
                    <div class="w-full h-full bg-primary/10 flex items-center justify-center">
                        <Buildings weight="duotone" class="w-20 h-20 text-primary/50" />
                    </div>
                {/if}
                <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/50 to-transparent p-4">
                    <div class="text-white flex items-center gap-2">
                        <Phone class="w-4 h-4" />
                        <span>Ext. {director.extension}</span>
                    </div>
                </div>
            </figure>
            <div class="card-body lg:w-2/3">
                <h2 class="card-title text-2xl">{director.name}</h2>
                <div class="text-xl text-primary font-semibold">{director.title}</div>
                <div class="space-y-2 mt-4">
                    <div class="flex items-center gap-2">
                        <Phone weight="duotone" class="w-5 h-5 text-primary" />
                        <span>{director.phone}</span>
                    </div>
                    {#if director.email}
                        <div class="flex items-center gap-2">
                            <EnvelopeSimple weight="duotone" class="w-5 h-5 text-primary" />
                            <span>{director.email}</span>
                        </div>
                    {/if}
                </div>
            </div>
        </div>
    </section>

    <!-- Contact Directory -->
    <section class="py-8 container mx-auto px-4">
        <div class="flex flex-col md:flex-row gap-4 mb-8">
            <!-- Department Filter -->
            <select 
                class="select select-bordered w-full md:w-64"
                bind:value={selectedDepartment}
            >
                <option value="all">Todos los departamentos</option>
                {#each departments as dep}
                    <option value={dep.id}>{dep.name}</option>
                {/each}
            </select>

            <!-- Search -->
            <div class="join w-full md:w-auto">
                <input
                    type="text"
                    placeholder="Buscar contacto..."
                    class="input input-bordered join-item w-full"
                    bind:value={searchQuery}
                />
                <button class="btn join-item">
                    <MagnifyingGlass weight="bold" class="w-5 h-5" />
                </button>
            </div>
        </div>

        <!-- Contacts Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {#each filteredContacts as contact}
                <div 
                    class="card bg-base-100 shadow-xl hover:shadow-2xl transition-all duration-300
                           hover:-translate-y-1"
                    in:fade
                >
                    <div class="card-body">
                        <h3 class="card-title text-lg">{contact.name}</h3>
                        <p class="text-primary font-medium">{contact.title}</p>
                        <p class="text-sm opacity-70">{contact.department}</p>
                        <div class="divider my-2"></div>
                        <div class="space-y-2">
                            <a 
                                href="tel:{contact.phone}"
                                class="flex items-center gap-2 hover:text-primary transition-colors"
                            >
                                <Phone weight="duotone" class="w-4 h-4" />
                                <span>Ext. {contact.extension}</span>
                            </a>
                            {#if contact.email}
                                <a 
                                    href="mailto:{contact.email}"
                                    class="flex items-center gap-2 hover:text-primary transition-colors"
                                >
                                    <EnvelopeSimple weight="duotone" class="w-4 h-4" />
                                    <span>{contact.email}</span>
                                </a>
                            {/if}
                        </div>
                    </div>
                </div>
            {/each}
        </div>
    </section>
</div>