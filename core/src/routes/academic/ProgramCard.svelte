<!-- src/lib/components/ProgramCard.svelte -->
<script lang="ts">
    import { CheckCircle, ArrowRight, Users, Clock, Book } from 'phosphor-svelte';
    import { goto } from '$app/navigation';
    import type { AcademicProgram } from '$lib/stores/academic.svelte';

    // Props using runes
    let { program } = $props<{
        program: AcademicProgram;
    }>();

    // Local state
    let isHovered = $state(false);

    function navigateToProgram() {
        goto(`/academic/programs/${program.id.toLowerCase()}`);
    }
</script>

<article 
    class="card bg-base-100 shadow-xl transition-all duration-300 group relative overflow-hidden"
    class:shadow-primary={isHovered}
>
    <div 
        class="card-body relative"
        role="region"
        aria-label="Program information"
        onmouseenter={() => isHovered = true}
        onmouseleave={() => isHovered = false}
    >
        <!-- Decorative Background Pattern -->
        <div 
            class="absolute inset-0 bg-gradient-to-br from-primary/5 to-transparent opacity-0 
                   group-hover:opacity-100 transition-all duration-500"
            aria-hidden="true"
        ></div>

        <!-- Header -->
        <div class="flex justify-between items-start mb-6 relative">
            <div class="flex flex-col gap-2">
                <program.icon 
                    weight={isHovered ? "fill" : "duotone"}
                    class="w-12 h-12 text-primary transition-all duration-300
                           group-hover:scale-110 group-hover:rotate-12"
                />
                <span class="badge badge-primary">{program.code}</span>
            </div>
            <div class="flex flex-col gap-2 items-end">
                <div class="flex items-center gap-2 text-sm opacity-75">
                    <Clock weight="duotone" class="w-4 h-4" />
                    {program.duration}
                </div>
                {#if program.coordinator}
                    <div class="flex items-center gap-2 text-sm opacity-75">
                        <Users weight="duotone" class="w-4 h-4" />
                        {program.coordinator}
                    </div>
                {/if}
            </div>
        </div>

        <!-- Content -->
        <button
            onclick={navigateToProgram}
            class="text-left group/title cursor-pointer focus:outline-none w-full"
        >
            <h3 class="card-title text-2xl mb-3 flex items-center gap-2 group-hover/title:text-primary transition-colors">
                {program.name}
                <ArrowRight 
                    weight="bold"
                    class="w-5 h-5 opacity-0 group-hover/title:opacity-100 group-hover/title:translate-x-1 
                           transition-all duration-300"
                />
            </h3>
            <p class="text-base-content/80 mb-6">{program.description}</p>
        </button>

        <!-- Details List -->
        <div class="space-y-3 mb-6">
            <div class="flex items-center gap-2 text-primary font-medium">
                <Book weight="fill" class="w-5 h-5" />
                Program Details
            </div>
            <ul class="grid gap-2">
                {#each program.details as detail}
                    <li 
                        class="flex items-center gap-2 pl-2 hover:bg-base-200 rounded-lg p-2 
                               transition-all duration-300 group-hover:translate-x-1"
                    >
                        <CheckCircle 
                            weight="fill" 
                            class="w-5 h-5 text-success shrink-0" 
                        />
                        <span>{detail}</span>
                    </li>
                {/each}
            </ul>
        </div>

        <!-- Career Options -->
        {#if program.career_options}
            <div class="mt-auto">
                <div class="divider text-base-content/50 text-sm">Career Opportunities</div>
                <div class="flex flex-wrap gap-2">
                    {#each program.career_options as career}
                        <span class="badge badge-outline hover:badge-primary transition-colors duration-300">
                            {career}
                        </span>
                    {/each}
                </div>
            </div>
        {/if}

        {#if program.credits}
            <div class="absolute top-4 right-4 w-12 h-12 flex items-center justify-center">
                <div class="radial-progress text-primary" style="--value:100; --size:3rem;">
                    <span class="text-xs font-bold">{program.credits}</span>
                </div>
                <span class="absolute -bottom-4 text-xs opacity-75">credits</span>
            </div>
        {/if}
    </div>
</article>
