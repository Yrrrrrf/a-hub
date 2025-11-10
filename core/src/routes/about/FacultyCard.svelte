<!-- src/lib/components/FacultyCard.svelte -->
<script lang="ts">
    import { Star } from 'phosphor-svelte';
    import { goto } from '$app/navigation';
    import type { Faculty } from '$lib/stores/about.svelte';

    // Props using runes
    let { faculty } = $props<{
        faculty: Faculty;
    }>();

    // Local state
    let isHovered = $state(false);

    // Navigation functions
    function navigateToFaculty() {
        goto(`/faculties/${faculty.id.toLowerCase()}`);
    }

    function navigateToProgram(program: string) {
        goto(`/faculties/${faculty.id.toLowerCase()}/${program.toLowerCase().replace(/ /g, '-')}`);
    }
</script>

<article 
    class="card bg-base-100 shadow-xl transition-all duration-300 group"
    class:shadow-primary={isHovered}
    class:hover:translate-y-[-4px]={!isHovered}
>
    <div 
        class="card-body relative overflow-hidden"
        role="region"
        aria-label="Faculty information"
        onmouseenter={() => isHovered = true}
        onmouseleave={() => isHovered = false}
    >
        <!-- Background Pattern -->
        <div 
            onclick={() => navigateToFaculty()}
            class="absolute inset-0 bg-gradient-to-br from-primary/5 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500"
            aria-hidden="true"
        ></div>

        <!-- Header -->
        <div class="flex justify-between items-start mb-4 relative">
            <faculty.icon 
                weight={isHovered ? "fill" : "duotone"} 
                class="w-12 h-12 text-primary transition-all duration-300
                       group-hover:scale-110 group-hover:rotate-12" 
            />
            <div class="badge badge-primary group-hover:scale-105 transition-transform">
                {faculty.stats.programs} Programs
            </div>
        </div>

        <!-- Title with Link -->
        <button
            class="card-title text-2xl mb-2 w-full text-left hover:text-primary transition-colors duration-300 inline-flex items-center gap-2"
        >
            {faculty.name}
        </button>

        <p class="text-base-content/80 mb-4">{faculty.description}</p>
        
        <!-- Featured Programs -->
        <div class="space-y-2 mb-6 relative">
            <h4 class="font-semibold flex items-center gap-2">
                <Star 
                    weight="fill" 
                    class="w-5 h-5 text-primary group-hover:rotate-180 transition-transform duration-700" 
                />
                Featured Programs
            </h4>
            <ul class="space-y-1">
                {#each faculty.featuredPrograms as program}
                    <a
                        href="/faculties/{faculty.id.toLowerCase()}/{program.toLowerCase().replace(/ /g, '-')}"
                        class="w-full flex items-center gap-2 pl-2 hover:bg-base-200 rounded-lg p-2 
                               transition-all duration-300 hover:translate-x-1 focus:outline-none
                               focus:ring-2 focus:ring-primary/20 group/item"
                    >
                        <div class="w-1.5 h-1.5 rounded-full bg-primary transition-transform duration-300
                                  group-hover/item:scale-150"></div>
                        <span class="text-left group-hover/item:text-primary transition-colors">
                            {program}
                        </span>
                    </a>
                {/each}
            </ul>
        </div>

        <!-- Stats -->
        <div class="stats bg-base-200 text-base-content transition-colors duration-300 group-hover:bg-base-300 relative overflow-hidden">
            <div 
                class="absolute inset-0 bg-primary/5 scale-x-0 group-hover:scale-x-100 transition-transform duration-700 origin-left"
                aria-hidden="true"
            ></div>
            <div class="stat p-2 relative">
                <div class="stat-title group-hover:text-primary transition-colors">Students</div>
                <div class="stat-value text-lg">
                    {faculty.stats.students.toLocaleString()}
                </div>
            </div>
            <div class="stat p-2 relative">
                <div class="stat-title group-hover:text-primary transition-colors">Faculty</div>
                <div class="stat-value text-lg">
                    {faculty.stats.faculty.toLocaleString()}
                </div>
            </div>
        </div>
    </div>
</article>