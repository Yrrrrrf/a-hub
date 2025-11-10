<script lang="ts">
	import {
		MagnifyingGlass,
		BookOpen,
		BookmarkSimple,
		Star,
		TrendUp,
		MapPin,
	} from 'phosphor-svelte';

	import { libraryStore } from '$lib/stores/library.svelte';

	// Access store data using runes
	let newArrivals = $derived(libraryStore.getNewArrivals());
	let categories = $derived(libraryStore.getCategories());
	let libraryStats = $derived(libraryStore.getLibraryStats());
	let services = $derived(libraryStore.getServices());
	let searchQuery = $state('');
</script>

<div class="min-h-screen bg-base-100">
	<section class="hero min-h-[60vh] bg-base-200 relative overflow-hidden">
		<div class="hero-content text-center">
			<div class="max-w-3xl z-10">
				<h1 class="text-5xl font-bold mb-4">University Library</h1>
				<p class="text-xl mb-8">
					Your gateway to knowledge and academic excellence
				</p>
				<div class="form-control">
					<div class="input-group flex justify-center">
						<input
							type="text"
							placeholder="Search books, journals, articles..."
							class="input input-bordered w-full max-w-xl"
							bind:value={searchQuery}
						/>
						<button class="btn btn-primary">
							<MagnifyingGlass class="h-5 w-5" />
						</button>
					</div>
				</div>
			</div>
		</div>
		<div class="absolute inset-0 opacity-10">
			<div class="grid grid-cols-6 gap-4 p-4 h-full">
				{#each Array(24) as _}
					<BookOpen class="w-full h-full text-current transform" style="rotate: {Math.random() * 360}deg" />
				{/each}
			</div>
		</div>
	</section>

	<section class="py-12 bg-primary text-primary-content">
		<div class="container mx-auto px-4">
			<div class="grid grid-cols-2 md:grid-cols-4 gap-8">
				{#each libraryStats as stat}
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
				<TrendUp class="text-primary" />
				New Arrivals
			</span>
		</h2>
		<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
			{#each newArrivals as book}
				<div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-all">
					<figure class="px-4 pt-4">
						<img
							src={book.cover || '/placeholder.jpg'}
							alt={book.title}
							class="rounded-xl h-[200px] w-full object-cover"
						/>
					</figure>
					<div class="card-body">
						<h3 class="card-title text-lg">{book.title}</h3>
						<p class="text-base-content/70">{book.author}</p>
						<div class="flex justify-between items-center mt-2">
							<span class="badge badge-primary">{book.category}</span>
							<div class="flex items-center gap-1">
								<Star class="w-4 h-4 text-yellow-500 fill-current" />
								<span>{book.rating}</span>
							</div>
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
					<MapPin class="text-primary" />
					Library Services
				</span>
			</h2>
			<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
				{#each services as service}
					<div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-all">
						<div class="card-body items-center text-center">
							<service.icon class="w-12 h-12 text-primary mb-4" />
							<h3 class="card-title">{service.title}</h3>
							<p class="text-base-content/70">{service.description}</p>
						</div>
					</div>
				{/each}
			</div>
		</div>
	</section>

	<section class="py-16 container mx-auto px-4">
		<h2 class="text-3xl font-bold text-center mb-12">
			<span class="flex items-center justify-center gap-2">
				<BookmarkSimple class="text-primary" />
				Popular Categories
			</span>
		</h2>
		<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
			{#each categories as category}
				<div class="stat bg-base-200 rounded-box shadow-lg hover:shadow-xl transition-all">
					<div class="stat-title text-lg font-medium">
						{category.name}
					</div>
					<div class="stat-value text-primary">
						{category.count.toLocaleString()}
					</div>
					<div class="stat-desc">Available Resources</div>
				</div>
			{/each}
		</div>
	</section>

	<footer class="footer p-10 bg-neutral text-neutral-content">
		<div class="container mx-auto grid grid-cols-1 md:grid-cols-3 gap-8">
			<div>
				<span class="footer-title">Library Hours</span>
				<p>Monday - Friday: 8:00 AM - 10:00 PM</p>
				<p>Saturday: 9:00 AM - 6:00 PM</p>
				<p>Sunday: 12:00 PM - 8:00 PM</p>
			</div>
			<div>
				<span class="footer-title">Quick Links</span>
				<a href="/" class="link link-hover">Book Catalog</a>
				<a href="/" class="link link-hover">E-Resources</a>
				<a href="/" class="link link-hover">Research Guides</a>
				<a href="/" class="link link-hover">Reserve Study Room</a>
			</div>
			<div>
				<span class="footer-title">Contact</span>
				<p>Email: library@academichub.edu</p>
				<p>Phone: (555) 123-4567</p>
				<p>Location: Main Campus, Building A</p>
			</div>
		</div>
	</footer>
</div>
