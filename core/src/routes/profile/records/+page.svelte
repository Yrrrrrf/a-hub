<!-- src/routes/profile/records/+page.svelte -->
<script lang="ts">
    import { 
        ChartLine, Calculator, Printer, ArrowCounterClockwise,
        GraduationCap, MagnifyingGlass, Download,
    } from 'phosphor-svelte';
    
    import SemesterCard from './SemesterCard.svelte';
    import { academicRecords } from '$lib/stores/records.svelte';
    import { profileStore } from '$lib/stores/profile.svelte';
    
    // State management with runes
    let loading = $state(false);

    // todo: Fix the search term
    // todo: Fix the search behavior in the component itself...
    let searchTerm = $state('');
    
    // Derived values
    let semesters = $derived(academicRecords.semesters);
    let academic = $derived(profileStore.academicInfo);
    
    // Filtered semesters
    let filteredSemesters = $derived(
        searchTerm === ''
            ? semesters
            : semesters.filter(semester => 
                semester.semester.toLowerCase().includes(searchTerm.toLowerCase()) ||
                semester.year.toString().includes(searchTerm) ||
                semester.courses.some(course => 
                    course.code.toLowerCase().includes(searchTerm.toLowerCase()) ||
                    course.name.toLowerCase().includes(searchTerm.toLowerCase())
                )
            )
    );

    // Actions
    function handlePrint() {
        window.print();
    }

    function handleReset() {
        academicRecords.reset();
    }

    function handleSearch(e: Event) {
        const input = e.target as HTMLInputElement;
        searchTerm = input.value;
    }
</script>

<div class="min-h-screen space-y-8">
    <!-- Header Section -->
    <div class="bg-gradient-to-br from-primary/10 via-base-100 to-base-200 py-12">
        <div class="container mx-auto px-4">
            <div class="flex flex-col md:flex-row justify-between items-start gap-8">
                <!-- Title and Description -->
                <div class="space-y-4">
                    <h1 class="text-4xl font-bold flex items-center gap-3">
                        <GraduationCap weight="duotone" class="text-primary w-10 h-10" />
                        Academic Records
                    </h1>
                    <p class="text-xl opacity-80 max-w-xl">
                        View and track your academic progress through all semesters.
                    </p>
                </div>

                <!-- Overall Stats -->
                <div class="stats bg-base-200 shadow">
                    <div class="stat">
                        <div class="stat-figure text-primary">
                            <ChartLine weight="duotone" class="w-8 h-8" />
                        </div>
                        <div class="stat-title">Overall GPA</div>
                        <div class="stat-value">{academic.gpa}</div>
                        <div class="stat-desc">Current Standing</div>
                    </div>
                    
                    <div class="stat">
                        <div class="stat-figure text-secondary">
                            <Calculator weight="duotone" class="w-8 h-8" />
                        </div>
                        <div class="stat-title">Credits</div>
                        <div class="stat-value text-secondary">{academic.creditsCompleted}</div>
                        <div class="stat-desc">of {academic.creditsRequired} Required</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container mx-auto px-4">
        <!-- Search and Actions -->
        <div class="flex flex-col sm:flex-row justify-between items-center gap-4 mb-8">
            <!-- Search -->
            <div class="join w-full sm:w-auto">
                <input
                    type="text"
                    value={searchTerm}
                    oninput={handleSearch}
                    placeholder="Search courses..."
                    class="input input-bordered join-item flex-1"
                />
                <button class="btn btn-primary join-item" aria-label="Search">
                    <MagnifyingGlass size={20} />
                </button>
            </div>

            <!-- Action Buttons -->
            <div class="flex gap-2">
                <button 
                    class="btn btn-ghost btn-sm" 
                    onclick={handleReset}
                >
                    <ArrowCounterClockwise weight="duotone" class="w-4 h-4" />
                    Reset
                </button>
                <button 
                    class="btn btn-ghost btn-sm"
                    onclick={handlePrint}
                >
                    <Printer weight="duotone" class="w-4 h-4" />
                    Print
                </button>
                <button class="btn btn-primary btn-sm">
                    <Download weight="duotone" class="w-4 h-4" />
                    Export
                </button>
            </div>
        </div>

        <!-- Loading State -->
        {#if loading}
            <div class="flex justify-center py-12">
                <span class="loading loading-spinner loading-lg"></span>
            </div>
        {:else}
            <!-- Semester Cards -->
            <div class="space-y-8">
                {#each filteredSemesters as semester (semester.id)}
                    <SemesterCard {semester} />
                {/each}
            </div>
        {/if}
    </div>
</div>

<style>
    @media print {
        .btn, input, .join, .stats {
            display: none;
        }
    }
</style>