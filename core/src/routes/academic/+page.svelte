<!-- src/routes/academic/+page.svelte -->
<script lang="ts">
    import { fade, fly } from 'svelte/transition';
    import { 
        GraduationCap, Book, ChartLine, Trophy,
        Star, Student, Buildings, Users
    } from 'phosphor-svelte';
    import { academicStore } from '$lib/stores/academic.svelte';
    import ProgramCard from './ProgramCard.svelte';
    import { goto } from '$app/navigation';

    // Get data from store using derived values
    let programs = $derived(academicStore.programs);
    let features = $derived(academicStore.features);
    let stats = $derived(academicStore.stats);
    let stories = $derived(academicStore.successStories);

    // Filter state
    let searchQuery = $state('');
    let selectedType = $state('all');
    let activeTab = $state('featured');

    // Derived values
    let filteredPrograms = $derived(
        programs.filter(program => {
            const matchesSearch = program.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                                program.description.toLowerCase().includes(searchQuery.toLowerCase());
            const matchesType = selectedType === 'all' || program.code.startsWith(selectedType);
            return matchesSearch && matchesType;
        })
    );
</script>

<div class="min-h-screen bg-base-200">
    <!-- Hero Section -->
    <section 
        class="hero min-h-[60vh] relative bg-gradient-to-br from-primary/10 to-base-200 overflow-hidden"
        in:fade={{ duration: 1000 }}
    >
        <div class="absolute inset-0 grid grid-cols-6 gap-4 p-4 opacity-5">
            {#each Array(24) as _}
                <GraduationCap 
                    class="w-full h-full transform rotate-12 text-current" 
                    style="rotate: {Math.random() * 360}deg"
                />
            {/each}
        </div>

        <div class="hero-content text-center relative z-10">
            <div class="max-w-4xl space-y-8">
                <div in:fly={{ y: -50, duration: 1000 }}>
                    <h1 class="text-6xl font-bold mb-6">Academic Excellence</h1>
                    <p class="text-2xl mb-8 max-w-2xl mx-auto">
                        Empowering the next generation of innovators, leaders, and problem-solvers through 
                        cutting-edge education and research.
                    </p>
                </div>

                <!-- Quick Stats -->
                <div 
                    class="stats bg-base-100 shadow-lg"
                    in:fly={{ y: 50, duration: 1000, delay: 200 }}
                >
                    {#each stats as stat}
                        <div class="stat text-center p-4">
                            <stat.icon class="w-8 h-8 mx-auto mb-2 text-primary" />
                            <div class="stat-value">{stat.value}</div>
                            <div class="stat-title">{stat.label}</div>
                            {#if stat.trend}
                                <div class="stat-desc text-success">
                                    ↗︎ {stat.trend.value} ({stat.trend.direction})
                                </div>
                            {/if}
                        </div>
                    {/each}
                </div>
            </div>
        </div>
    </section>

    <!-- Programs Section -->
    <section class="py-20 container mx-auto px-4">
        <div class="text-center mb-16 space-y-4">
            <h2 class="text-4xl font-bold">Academic Programs</h2>
            <p class="text-xl opacity-80 max-w-2xl mx-auto">
                Discover our comprehensive range of programs designed to prepare you 
                for success in your chosen field.
            </p>
        </div>

        <!-- Filters -->
        <div class="flex flex-col sm:flex-row gap-4 mb-8 justify-between items-center">
            <!-- Empty div just to make the next section appear at right side -->
            <div></div>

            <div class="join">
                <input
                    type="text"
                    placeholder="Search programs..."
                    class="input input-bordered join-item w-full"
                    bind:value={searchQuery}
                />
                <button class="btn join-item">
                    <Book class="w-5 h-5" />
                </button>
            </div>
        </div>

        <!-- Programs Carousel -->
        <div class="w-full overflow-x-auto hide-scrollbar">
            <!-- <div class="flex gap-8 min-w-min p-4"> -->
            <!-- <div class="flex gap-8 min-w-min p-4"> -->
            <!-- <div class="flex gap-8 min-w-min p-4"> -->
            <!-- <div class="flex gap-8 min-w-min p-4"> -->
            <!-- <div class="flex gap-8 min-w-min p-4"> -->
            <!-- TODO: ADD SOME GAP TO THE WIDTH -->
            <div class="flex gap-8 min-w-min p-4">
                {#each filteredPrograms as program (program.id)}
                    <div 
                        class="w-[600px] snap-center"
                        in:fade={{ duration: 300 }}
                    >
                        <ProgramCard {program} />
                    </div>
                {/each}
            </div>
        </div>

        <style>
            /* Hide scrollbar but maintain functionality */
            .hide-scrollbar {
                scrollbar-width: none;  /* Firefox */
                -ms-overflow-style: none;  /* IE and Edge */
                scroll-behavior: smooth;
            }
            .hide-scrollbar::-webkit-scrollbar {
                display: none;  /* Chrome, Safari, Opera */
            }
        </style>
    </section>

    <!-- Features Section -->
    <section class="py-20 bg-base-100">
        <div class="container mx-auto px-4">
            <div class="text-center mb-16">
                <h2 class="text-4xl font-bold mb-4">Why Choose Us</h2>
                <p class="text-xl opacity-80 max-w-2xl mx-auto">
                    Experience education that goes beyond the classroom, preparing you for real-world success.
                </p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
                {#each features as feature}
                    <div class="card bg-base-200 hover:bg-base-300 transition-all duration-300 hover:-translate-y-2">
                        <div class="card-body items-center text-center relative overflow-hidden">
                            <!-- Background Circle -->
                            <div 
                                class="absolute w-32 h-32 rounded-full bg-primary/5 -top-16 -right-16 
                                       transition-transform duration-500 group-hover:scale-150"
                                aria-hidden="true"
                            ></div>

                            <feature.icon 
                                weight="duotone"
                                class="w-16 h-16 text-primary mb-4 relative z-10 transition-transform 
                                       duration-300 hover:scale-110" 
                            />
                            <h3 class="card-title text-xl mb-2 relative z-10">{feature.title}</h3>
                            <p class="text-base-content/70 relative z-10">{feature.description}</p>
                        </div>
                    </div>
                {/each}
            </div>
        </div>
    </section>

    <!-- Success Stories -->
    <section class="py-20 container mx-auto px-4">
        <div class="text-center mb-16">
            <h2 class="text-4xl font-bold mb-4">Student Success Stories</h2>
            <p class="text-xl opacity-80 max-w-2xl mx-auto">
                Meet some of our outstanding alumni and their achievements.
            </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            {#each stories as story}
                <div class="card lg:card-side bg-base-100 shadow-xl hover:shadow-2xl transition-all">
                    <figure class="lg:w-1/3">
                        <img src={story.image} 
                             alt={story.name}
                             class="h-full w-full object-cover" />
                    </figure>
                    <div class="card-body lg:w-2/3">
                        <h3 class="card-title text-2xl">{story.name}</h3>
                        <div class="space-y-2 mb-4">
                            <p class="text-primary font-semibold">{story.program}, Class of {story.year}</p>
                            <p class="font-medium">{story.achievement}</p>
                        </div>
                        <blockquote class="text-base-content/80 italic">
                            "{story.quote}"
                        </blockquote>
                    </div>
                </div>
            {/each}
        </div>
    </section>

    <!-- Call to Action -->
    <section class="py-20 bg-base-300">
        <div class="container mx-auto px-4 text-center">
            <div class="max-w-3xl mx-auto space-y-6">
                <h2 class="text-4xl font-bold">Start Your Journey With Us</h2>
                <p class="text-xl opacity-80">
                    Take the first step towards your future. Apply now or contact us to learn more 
                    about our programs and opportunities.
                </p>
                <div class="flex gap-4 justify-center">
                    <button class="btn btn-primary btn-lg">Apply Now</button>
                    <button 
                        class="btn btn-outline btn-lg"
                        onclick={() => goto('/contact')}    
                    >Contact Us</button>
                </div>
            </div>
        </div>
    </section>
</div>
