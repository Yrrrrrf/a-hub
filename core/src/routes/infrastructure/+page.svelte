<script lang="ts">
	import { Buildings, MapPin, Info, Bookmark } from 'phosphor-svelte';
	import { infrastructureStore } from '$lib/stores/infrastructure.svelte';
    import { fade } from 'svelte/transition';
    import { aboutStore } from '$lib/stores/about.svelte';

	
	// Access store data using runes
	let locations = $derived(infrastructureStore.getAllCampuses());
	let facilityTypes = $derived(infrastructureStore.getFacilityTypes());
	let campusStats = $derived(infrastructureStore.getCampusStats());
	let latestUpdates = $derived(infrastructureStore.getLatestUpdates());
	
	let searchQuery = $state('');
	let highlights = $derived(aboutStore.campusHighlights);
	
	// Filtered buildings based on search query
	let filteredBuildings = $derived(
		searchQuery
			? locations.filter((loc) =>
					loc.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
					loc.address.toLowerCase().includes(searchQuery.toLowerCase()) ||
					loc.facilities?.some((f) => f.toLowerCase().includes(searchQuery.toLowerCase()))
			)
			: locations
	);
</script>

<div class="min-h-screen bg-base-100">
	<section class="hero min-h-[50vh] bg-base-200">
		<div class="hero-content text-center">
			<div class="max-w-3xl">
				<h1 class="text-5xl font-bold mb-4">Campus Infrastructure</h1>
				<p class="text-xl mb-8">
					Explore our modern facilities designed to support academic excellence
				</p>
				<div class="form-control">
					<div class="input-group flex justify-center">
						<input
							type="text"
							placeholder="Search buildings, rooms, facilities..."
							class="input input-bordered w-full max-w-xl"
							bind:value={searchQuery}
						/>
						<!-- <button class="btn btn-primary" on:click={() => (filteredBuildings = filteredBuildings)}>
							<MagnifyingGlass class="h-5 w-5" />
						</button> -->
					</div>
				</div>
			</div>
		</div>
	</section>

	<section class="py-12 bg-primary text-primary-content">
		<div class="container mx-auto px-4">
			<div class="grid grid-cols-2 md:grid-cols-4 gap-8">
				{#each campusStats as stat}
					<div class="stat text-center">
						<div class="stat-figure text-primary-content">
                            <stat.icon class="w-8 h-8" />
						</div>
						<div class="stat-value text-3xl font-bold">
							{stat.value}
						</div>
						<div class="stat-label text-lg">
							{stat.label}
						</div>
					</div>
				{/each}
			</div>
		</div>
	</section>

	<section class="py-16 container mx-auto px-4">
		<h2 class="text-3xl font-bold text-center mb-12">
			<span class="flex items-center justify-center gap-2">
				<Buildings class="text-primary" />
				Campus Buildings
			</span>
		</h2>
		<div class="grid grid-cols-1 md:grid-cols-2 gap-8">
			{#each filteredBuildings as building}
				<div class="card lg:card-side bg-base-100 shadow-xl hover:shadow-2xl transition-all">
					<figure class="lg:w-1/2">
						<img
							src={building.image || '/https://picsum.photos/200/300'}
							alt={building.name}
							class="h-full w-full object-cover"
						/>
					</figure>
					<div class="card-body lg:w-1/2">
						<h3 class="card-title">
							{building.name}
							{#if building.accessibility}
								<div class="badge badge-success gap-2">
									<Bookmark class="h-4 w-4" />
									Accessible
								</div>
							{/if}
						</h3>
						<p class="text-base-content/70">{building.description}</p>
						<div class="flex items-center gap-2 text-sm">
							<MapPin class="w-4 h-4" />
							{building.address}
						</div>
						<div class="flex flex-wrap gap-2 mt-2">
							{#each building.facilities || [] as facility}
								<span class="badge badge-primary">{facility}</span>
							{/each}
						</div>
						<div class="card-actions justify-end mt-4">
							<button class="btn btn-primary btn-sm">
								View Details
							</button>
						</div>
					</div>
				</div>
			{/each}
		</div>
	</section>

	<section class="py-16 bg-base-200">
		<div class="container mx-auto px-4">
			<h2 class="text-3xl font-bold text-center mb-12">
				<span class="flex items-center justify-center gap-2">
					<Buildings class="text-primary" />
					Campus Facilities
				</span>
			</h2>
			<div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-6">
				{#each facilityTypes as facility}
					<div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-all">
						<div class="card-body items-center text-center">
							<facility.icon class="w-12 h-12 text-primary mb-4" />
							<h3 class="card-title text-lg">{facility.name}</h3>
							<p class="text-2xl font-bold text-primary">
								{facility.count}
							</p>
						</div>
					</div>
				{/each}
			</div>
		</div>
	</section>


    <!-- Campus Highlights -->
    <section class="py-20 bg-base-100">
        <div class="container mx-auto px-4">
            <div class="text-center mb-16">
                <h2 class="text-4xl font-bold mb-4">Campus Highlights</h2>
                <p class="text-xl opacity-80 max-w-2xl mx-auto">
                    Experience our world-class facilities and vibrant campus life.
                </p>
            </div>

            <div class="space-y-12">
                {#each highlights as highlight, i}
                    <div class="card lg:card-side bg-base-200 shadow-xl overflow-hidden" 
                         class:flex-row-reverse={i % 2 === 1}
                         transition:fade>
                        <figure class="lg:w-1/2">
                            <img src={highlight.image} 
                                 alt={highlight.title}
                                 class="w-full h-full object-cover" />
                        </figure>
                        <div class="card-body lg:w-1/2">
                            <h3 class="card-title text-2xl">{highlight.title}</h3>
                            <p class="text-base-content/80 mb-6">{highlight.description}</p>
                            
                            {#if highlight.stats}
                                <div class="stats stats-vertical lg:stats-horizontal shadow bg-base-100">
                                    {#each highlight.stats as stat}
                                        <div class="stat">
                                            <div class="stat-title">{stat.label}</div>
                                            <div class="stat-value text-primary">{stat.value}</div>
                                        </div>
                                    {/each}
                                </div>
                            {/if}
                        </div>
                    </div>
                {/each}
            </div>
        </div>
    </section>




	<section class="py-16 container mx-auto px-4">
		<h2 class="text-3xl font-bold text-center mb-12">
			<span class="flex items-center justify-center gap-2">
				<Info class="text-primary" />
				Recent Updates
			</span>
		</h2>
		<div class="max-w-3xl mx-auto">
			{#each latestUpdates as update}
				<div
					class="flex items-center gap-4 p-4 bg-base-200 rounded-lg hover:bg-base-300 transition-colors mb-4"
				>
					<div class="mr-4 shrink-0">
						{#if update.icon}
							<update.icon class="w-6 h-6 text-primary" />
						{/if}
					</div>
					<div class="flex-1">
						<div class="text-lg font-medium">{update.facility}</div>
						<div class="text-sm opacity-70">{update.update}</div>
					</div>
					<div class="text-sm opacity-70 font-mono">{update.date}</div>
				</div>
			{/each}
		</div>
	</section>
</div>
