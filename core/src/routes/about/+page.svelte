<!-- src/routes/about/+page.svelte -->
<script lang="ts">

    import { 
        ArrowRight, CalendarCheck, Trophy,
        Clock, MapPin, Buildings, Star
    } from 'phosphor-svelte';
    import { aboutStore } from '$lib/stores/about.svelte';
    import { goto } from '$app/navigation';
    import FacultyCard from './FacultyCard.svelte';
    
    // Get data from store using derived values
    let quickStats = $derived(aboutStore.quickStats);
    let faculties = $derived(aboutStore.faculties);
    let activities = $derived(aboutStore.recentActivities);

    // Additional derived values
    let totalStudents = $derived(aboutStore.totalStudents);
    let totalFaculty = $derived(aboutStore.totalFaculty);
    let totalPrograms = $derived(aboutStore.totalPrograms);
</script>

<div class="min-h-screen bg-base-200">
    <!-- Hero Section -->
    <section class="hero min-h-[60vh] relative bg-gradient-to-br from-primary/10 to-base-200">
        <div class="hero-content text-center">
            <div class="max-w-4xl space-y-6">
                <h1 class="text-6xl font-bold mb-6">Shaping Tomorrow's Leaders</h1>
                <p class="text-2xl mb-8 max-w-2xl mx-auto">
                    {aboutStore.mission}
                </p>
                <div class="stats bg-base-100 shadow">
                    {#each quickStats as stat}
                        <div class="stat p-4">
                            <div class="stat-figure text-primary">
                                <stat.icon weight="duotone" class="w-8 h-8" />
                            </div>
                            <div class="stat-title">{stat.label}</div>
                            <div class="stat-value">{stat.value}</div>
                        </div>
                    {/each}
                </div>
            </div>
        </div>
    </section>

    <!-- Faculties Section -->
    <section class="py-20 container mx-auto px-4">
        <div class="text-center mb-16 space-y-4">
            <h2 class="text-4xl font-bold">Our Faculties</h2>
            <p class="text-xl opacity-80 max-w-2xl mx-auto">
                Discover our diverse range of faculties, each dedicated to excellence in 
                teaching, research, and innovation.
            </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {#each faculties as faculty (faculty.id)}
                <FacultyCard {faculty} />
            {/each}
        </div>
    </section>

    <!-- Recent Activities -->
    <section class="py-20 container mx-auto px-4">
        <div class="text-center mb-16">
            <h2 class="text-4xl font-bold mb-4">Recent Activities</h2>
            <p class="text-xl opacity-80 max-w-2xl mx-auto">
                Stay updated with the latest happenings across our campus.
            </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            {#each activities as activity}
                <div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-all">
                    <figure>
                        <img src={activity.image} 
                             alt={activity.title}
                             class="h-48 w-full object-cover" />
                    </figure>
                    <div class="card-body">
                        <div class="flex justify-between items-start mb-2">
                            <span class="badge badge-primary">{activity.category}</span>
                            <div class="flex items-center gap-2 text-sm opacity-70">
                                <CalendarCheck weight="fill" class="w-4 h-4" />
                                <span>{activity.date}</span>
                            </div>
                        </div>
                        <h3 class="card-title text-xl">{activity.title}</h3>
                        <p class="text-base-content/80">{activity.description}</p>
                        
                        {#if activity.link}
                            <div class="card-actions justify-end mt-4">
                                <a href={activity.link} class="btn btn-primary btn-sm group">
                                    Read More
                                    <ArrowRight class="w-4 h-4 transition-transform group-hover:translate-x-1" />
                                </a>
                            </div>
                        {/if}
                    </div>
                </div>
            {/each}
        </div>
    </section>

    <!-- Call to Action -->
    <section class="py-20 bg-primary text-primary-content">
        <div class="container mx-auto px-4 text-center">
            <div class="max-w-3xl mx-auto space-y-8">
                <h2 class="text-4xl font-bold">Begin Your Journey With Us</h2>
                <p class="text-xl opacity-90">
                    Join our community of innovators, researchers, and future leaders. 
                    Discover the opportunities that await you at our institution.
                </p>
                <div class="stats bg-primary-content/10 backdrop-blur-sm text-primary-content">
                    <div class="stat">
                        <div class="stat-title opacity-80">Total Students</div>
                        <div class="stat-value">{totalStudents}</div>
                    </div>
                    <div class="stat">
                        <div class="stat-title opacity-80">Faculty Members</div>
                        <div class="stat-value">{totalFaculty}</div>
                    </div>
                    <div class="stat">
                        <div class="stat-title opacity-80">Academic Programs</div>
                        <div class="stat-value">{totalPrograms}</div>
                    </div>
                </div>
                <div class="flex gap-4 justify-center">
                    <!-- //href=/academic -->
                    <button 
                        class="btn btn-secondary btn-lg"
                        onclick={() => goto('/academic')}>Explore Programs</button>
                </div>
            </div>
        </div>
    </section>

    <!-- Additional Info -->
    <section class="py-20 bg-base-200">
        <div class="container mx-auto px-4">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <!-- Visit Us -->
                <div class="card bg-base-100 shadow-xl">
                    <div class="card-body">
                        <h3 class="card-title flex items-center gap-2">
                            <MapPin weight="duotone" class="text-primary" />
                            Visit Us
                        </h3>
                        <p class="text-base-content/80">
                            Experience our campus firsthand. Schedule a tour and meet our community.
                        </p>
                        <div class="card-actions justify-end mt-4">
                            <button class="btn btn-primary btn-sm">Book a Tour</button>
                        </div>
                    </div>
                </div>

                <!-- Research Opportunities -->
                <div class="card bg-base-100 shadow-xl">
                    <div class="card-body">
                        <h3 class="card-title flex items-center gap-2">
                            <Trophy weight="duotone" class="text-primary" />
                            Research
                        </h3>
                        <p class="text-base-content/80">
                            Discover our research initiatives and collaboration opportunities.
                        </p>
                        <div class="card-actions justify-end mt-4">
                            <button class="btn btn-primary btn-sm">Learn More</button>
                        </div>
                    </div>
                </div>

                <!-- Connect -->
                <div class="card bg-base-100 shadow-xl">
                    <div class="card-body">
                        <h3 class="card-title flex items-center gap-2">
                            <Buildings weight="duotone" class="text-primary" />
                            Connect
                        </h3>
                        <p class="text-base-content/80">
                            Stay connected with our community and latest developments.
                        </p>
                        <div class="card-actions justify-end mt-4">
                            <button class="btn btn-primary btn-sm">Get in Touch</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>