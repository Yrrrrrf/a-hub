<!-- src/routes/news/+page.svelte -->
<script lang="ts">
    import { 
        MagnifyingGlass, FunnelSimple, Newspaper, CalendarCheck, Tag, Clock, 
        BookOpen, Bell, CaretRight, ArrowSquareOut, CalendarPlus, MapPin,
    } from 'phosphor-svelte';
    
    import { newsStore } from '$lib/stores/news.svelte';

    let searchInput = $state('');

    function handleSearch() {
        newsStore.setSearchQuery(searchInput);
    }

    function getPriorityColor(priority: string): string {
        switch(priority) {
            case 'High': return 'badge-error';
            case 'Medium': return 'badge-warning';
            case 'Normal': return 'badge-info';
            default: return 'badge-ghost';
        }
    }
</script>

<div class="min-h-screen bg-base-200">
    <!-- Hero Header -->
    <div class="bg-gradient-to-br from-primary/10 via-base-100 to-base-200 py-12">
        <div class="container mx-auto px-4">
            <div class="flex flex-col md:flex-row justify-between items-center gap-6">
                <div class="space-y-4">
                    <h1 class="text-5xl font-bold flex items-center gap-3">
                        <Newspaper weight="duotone" class="text-primary w-12 h-12" />
                        Campus News & Events
                    </h1>
                    <p class="text-xl opacity-80 max-w-xl">
                        Stay updated with the latest news, events, and announcements from our academic community.
                    </p>
                </div>
                
                <!-- Search and Filter -->
                <div class="flex gap-3">
                    <div class="join">
                        <input type="text" 
                               placeholder="Search news..." 
                               class="input input-bordered join-item"
                               bind:value={searchInput}
                               onkeyup={(e) => e.key === 'Enter' && handleSearch()} />
                        <button class="btn btn-primary join-item" onclick={handleSearch}>
                            <MagnifyingGlass weight="bold" class="w-5 h-5" />
                        </button>
                    </div>
                    <div class="dropdown dropdown-end">
                        <button class="btn btn-ghost">
                            <FunnelSimple weight="bold" class="w-5 h-5" />
                            Filter
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container mx-auto px-4 py-12">
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Main News Feed -->
            <div class="lg:col-span-2 space-y-10">
                <!-- Featured Article -->
                <div class="card bg-base-100 shadow-xl image-full overflow-hidden transform hover:scale-[1.01] transition-all">
                    <figure>
                        <img src={newsStore.featuredArticle.image} 
                             alt={newsStore.featuredArticle.title}
                             class="w-full h-[400px] object-cover" />
                    </figure>
                    <div class="card-body bg-gradient-to-t from-base-100 via-base-100/80 to-transparent">
                        <div class="flex items-center gap-3 mb-3">
                            <span class="badge badge-primary">{newsStore.featuredArticle.category}</span>
                            <span class="flex items-center gap-2 text-sm opacity-75">
                                <CalendarCheck weight="fill" class="w-4 h-4" />
                                {newsStore.featuredArticle.date}
                            </span>
                        </div>
                        <h2 class="card-title text-4xl mb-4">{newsStore.featuredArticle.title}</h2>
                        <p class="text-lg mb-6">{newsStore.featuredArticle.excerpt}</p>
                        <div class="card-actions justify-between items-center">
                            <div class="flex items-center gap-3">
                                <div class="avatar placeholder">
                                    <div class="bg-primary text-primary-content rounded-full w-10">
                                        <span>{newsStore.featuredArticle.author[0]}</span>
                                    </div>
                                </div>
                                <div class="flex flex-col">
                                    <span class="font-bold">{newsStore.featuredArticle.author}</span>
                                    <span class="text-sm opacity-75">{newsStore.featuredArticle.readTime}</span>
                                </div>
                            </div>
                            <button class="btn btn-primary">
                                Read Article
                                <ArrowSquareOut weight="bold" class="w-5 h-5" />
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Latest News Grid -->
                <div class="space-y-8">
                    <h2 class="text-3xl font-bold flex items-center gap-3">
                        <BookOpen weight="duotone" class="text-primary" />
                        Latest News
                    </h2>
                    <div class="grid gap-6">
                        {#each newsStore.filteredNews as article (article.id)}
                            <div class="card lg:card-side bg-base-100 shadow-xl hover:shadow-2xl transition-all">
                                <figure class="lg:w-2/5">
                                    <img src={article.image} 
                                         alt={article.title}
                                         class="h-full w-full object-cover" />
                                </figure>
                                <div class="card-body lg:w-3/5">
                                    <div class="flex items-center gap-3 mb-2">
                                        <span class="badge badge-primary">{article.category}</span>
                                        <span class="flex items-center gap-2 text-sm opacity-75">
                                            <CalendarCheck weight="fill" class="w-4 h-4" />
                                            {article.date}
                                        </span>
                                    </div>
                                    <h3 class="card-title text-2xl">{article.title}</h3>
                                    <p class="text-base-content/80">{article.excerpt}</p>
                                    <div class="flex flex-wrap gap-2 mt-3">
                                        {#each article.tags || [] as tag}
                                            <span class="badge badge-ghost">{tag}</span>
                                        {/each}
                                    </div>
                                    <div class="card-actions justify-between items-center mt-4">
                                        <div class="flex items-center gap-2 text-sm opacity-75">
                                            <Clock weight="fill" class="w-4 h-4" />
                                            {article.readTime}
                                        </div>
                                        <button class="btn btn-primary btn-sm group">
                                            Read More
                                            <CaretRight weight="bold" 
                                                       class="w-4 h-4 transition-transform group-hover:translate-x-1" />
                                        </button>
                                    </div>
                                </div>
                            </div>
                        {/each}
                    </div>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="space-y-8">
                <!-- Categories -->
                <div class="card bg-base-100 shadow-xl">
                    <div class="card-body">
                        <h3 class="card-title text-xl flex items-center gap-2 mb-4">
                            <Tag weight="duotone" class="text-primary" />
                            Browse Categories
                        </h3>
                        <div class="space-y-2">
                            {#each newsStore.categories as category (category.id)}
                                <button class="btn btn-ghost w-full justify-between hover:bg-primary/10"
                                        onclick={() => newsStore.setCategory(category.name)}>
                                    {category.name}
                                    <span class="badge badge-primary">{category.count}</span>
                                </button>
                            {/each}
                        </div>
                    </div>
                </div>

                <!-- Upcoming Events -->
                <div class="card bg-base-100 shadow-xl">
                    <div class="card-body">
                        <h3 class="card-title text-xl flex items-center gap-2 mb-4">
                            <CalendarPlus weight="duotone" class="text-primary" />
                            Upcoming Events
                        </h3>
                        <div class="space-y-4">
                            {#each newsStore.upcomingEvents as event (event.id)}
                                <div class="bg-base-200 rounded-lg p-4 hover:bg-base-300 transition-colors">
                                    <h4 class="font-bold text-lg mb-3">{event.title}</h4>
                                    <div class="space-y-2 text-sm">
                                        <div class="flex items-center gap-2">
                                            <CalendarCheck weight="fill" class="w-4 h-4 text-primary" />
                                            {event.date}
                                        </div>
                                        <div class="flex items-center gap-2">
                                            <Clock weight="fill" class="w-4 h-4 text-primary" />
                                            {event.time}
                                        </div>
                                        <div class="flex items-center gap-2">
                                            <MapPin weight="fill" class="w-4 h-4 text-primary" />
                                            {event.location}
                                        </div>
                                    </div>
                                    <div class="mt-3">
                                        <span class="badge badge-secondary">{event.type}</span>
                                    </div>
                                </div>
                            {/each}
                        </div>
                    </div>
                </div>

                <!-- Important Announcements -->
                <div class="card bg-base-100 shadow-xl">
                    <div class="card-body">
                        <h3 class="card-title text-xl flex items-center gap-2 mb-4">
                            <Bell weight="duotone" class="text-primary" />
                            Important Announcements
                        </h3>
                        <div class="space-y-4">
                            {#each newsStore.announcements as announcement (announcement.id)}
                                <div class="flex items-start gap-4 p-4 bg-base-200 rounded-lg hover:bg-base-300 transition-colors">
                                    <div class="mt-1">
                                        <!-- <svelte:component 
                                            this={getPriorityIcon(announcement.priority)}
                                            weight="fill"
                                            class="w-5 h-5"
                                        /> -->
                                    </div>
                                    <div class="flex-1">
                                        <div class="font-semibold mb-1">{announcement.title}</div>
                                        <div class="text-sm flex justify-between items-center">
                                            <span class="opacity-70">{announcement.department}</span>
                                            <span class={`badge ${getPriorityColor(announcement.priority)}`}>
                                                {announcement.priority}
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            {/each}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>