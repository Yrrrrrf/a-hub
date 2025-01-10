<!-- src/routes/academic/+page.svelte -->
<script lang="ts">
    import { CheckCircle } from 'phosphor-svelte';
    import { academicStore } from '$lib/stores/academic.svelte';

    // Get data from store using derived values
    let programs = $derived(academicStore.programs);
    let features = $derived(academicStore.features);
    let stats = $derived(academicStore.stats);
    let stories = $derived(academicStore.successStories);
</script>

<div class="min-h-screen bg-base-200">
    <!-- Hero Section -->
    <section class="hero min-h-[20vh] relative bg-gradient-to-br from-primary/10 to-base-200">
        <div class="hero-content text-center">
            <div class="max-w-4xl">
                <h1 class="text-6xl font-bold mb-6">Academic Excellence</h1>
                <p class="text-2xl mb-8 max-w-2xl mx-auto">
                    Empowering the next generation of innovators, leaders, and problem-solvers through 
                    cutting-edge education and research.
                </p>
            </div>
        </div>
    </section>

    <!-- Programs Section -->
    <section class="py-20 container mx-auto px-4">
        <div class="text-center mb-16 space-y-4">
            <h2 class="text-4xl font-bold">Our Programs</h2>
            <p class="text-xl opacity-80 max-w-2xl mx-auto">
                Discover our comprehensive range of academic programs designed to prepare you 
                for success in your chosen field.
            </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {#each programs as program}
                <div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-all">
                    <div class="card-body">
                        <div class="flex justify-between items-start mb-4">
                            <program.icon class="w-12 h-12 text-primary" />
                            <span class="badge badge-primary">{program.code}</span>
                        </div>
                        <h3 class="card-title text-2xl mb-2">{program.name}</h3>
                        <p class="text-base-content/80 mb-4">{program.description}</p>
                        <ul class="space-y-2 mb-6">
                            {#each program.details as detail}
                                <li class="flex items-center gap-2">
                                    <CheckCircle weight="fill" class="w-5 h-5 text-success" />
                                    {detail}
                                </li>
                            {/each}
                        </ul>
                        <div class="card-actions justify-between items-center mt-auto">
                            <span class="text-sm opacity-75">Duration: {program.duration}</span>
                            <button class="btn btn-primary">Learn More</button>
                        </div>
                    </div>
                </div>
            {/each}
        </div>
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
                    <div class="card bg-base-200 hover:bg-base-300 transition-colors">
                        <div class="card-body items-center text-center">
                            <feature.icon class="w-16 h-16 text-primary mb-4" />
                            <h3 class="card-title text-xl mb-2">{feature.title}</h3>
                            <p class="text-base-content/70">{feature.description}</p>
                        </div>
                    </div>
                {/each}
            </div>
        </div>
    </section>

    <!-- Statistics Section -->
    <section class="py-20 bg-primary text-primary-content">
        <div class="container mx-auto px-4">
            <div class="grid grid-cols-2 md:grid-cols-4 gap-8 text-center">
                {#each stats as stat}
                    <div class="stat p-4 transform hover:scale-105 transition-transform">
                        <div class="stat-value text-5xl font-bold mb-4">
                            {stat.value}
                        </div>
                        <div class="stat-label text-xl opacity-90">
                            {stat.label}
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
                    <button class="btn btn-outline btn-lg">Contact Us</button>
                </div>
            </div>
        </div>
    </section>
</div>
